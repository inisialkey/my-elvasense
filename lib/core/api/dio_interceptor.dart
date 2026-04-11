import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/dependencies_injection.dart';
import 'package:myelvasense/features/auth/auth.dart';
import 'package:myelvasense/utils/utils.dart';

// coverage:ignore-start
class DioInterceptor extends Interceptor with FirebaseCrashLogger {
  /// Completer-based lock: only the first 401 triggers a refresh.
  /// Subsequent 401s await this Completer's future.
  static Completer<bool>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check connectivity before proceeding
    if (sl.isRegistered<ConnectivityService>() &&
        !sl<ConnectivityService>().isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection',
        ),
      );
    }

    final token = await sl<AuthTokenService>().getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    String headerMessage = '';
    options.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

    try {
      options.queryParameters.forEach((k, v) => debugPrint('► $k: $v'));
    } catch (_) {}
    try {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      final String prettyJson = encoder.convert(options.data);
      log.d(
        // ignore: unnecessary_null_comparison
        "REQUEST ► ︎ ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"${options.baseUrl}${options.path}"}\n\n"
        'Headers:\n'
        '$headerMessage\n'
        '❖ QueryParameters : \n'
        'Body: $prettyJson',
      );
    } catch (e, stackTrace) {
      log.e('Failed to extract json request $e');
      nonFatalError(error: e, stackTrace: stackTrace);
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException dioException,
    ErrorInterceptorHandler handler,
  ) async {
    log.e(
      "<-- ${dioException.message} ${dioException.response?.requestOptions != null ? (dioException.response!.requestOptions.baseUrl + dioException.response!.requestOptions.path) : 'URL'}\n\n"
      "${dioException.response != null ? dioException.response!.data : 'Unknown Error'}",
    );

    nonFatalError(error: dioException, stackTrace: dioException.stackTrace);

    // Only handle 401 with 'jwt error' message
    final responseData = dioException.response?.data;
    final isJwtError =
        responseData is Map<String, dynamic> &&
        responseData['message'] == 'jwt error';

    if (dioException.response?.statusCode != 401 || !isJwtError) {
      return handler.next(dioException);
    }

    final sessionExpiredException = DioException(
      requestOptions: dioException.requestOptions,
      message: 'SESSION_EXPIRED',
    );

    // No refresh token stored — session is invalid
    if (await sl<AuthTokenService>().getRefreshToken() == null) {
      await sl<MainBoxMixin>().logoutBox();
      await sl<AuthTokenService>().clearTokens();
      _showSessionExpiredDialog();
      return handler.reject(sessionExpiredException);
    }

    // Another request is already refreshing — wait for it
    if (_refreshCompleter != null) {
      final success = await _refreshCompleter!.future;
      if (success) {
        return handler.resolve(await _retry(dioException.requestOptions));
      }
      return handler.reject(sessionExpiredException);
    }

    // First 401 — take the lock and refresh
    _refreshCompleter = Completer<bool>();
    try {
      final success = await _refreshToken();
      _refreshCompleter!.complete(success);
      _refreshCompleter = null;

      if (success) {
        return handler.resolve(await _retry(dioException.requestOptions));
      }
      _showSessionExpiredDialog();
      return handler.reject(sessionExpiredException);
    } catch (e) {
      _refreshCompleter!.complete(false);
      _refreshCompleter = null;
      await sl<MainBoxMixin>().logoutBox();
      await sl<AuthTokenService>().clearTokens();
      _showSessionExpiredDialog();
      return handler.reject(sessionExpiredException);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final newToken = await sl<AuthTokenService>().getAccessToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (newToken != null) 'Authorization': 'Bearer $newToken',
      },
    );

    return sl<DioClient>().dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Calls the refresh token API using a raw Dio instance (no interceptors)
  /// to avoid recursive interceptor loops.
  /// Returns true on success, false on failure.
  Future<bool> _refreshToken() async {
    try {
      const baseUrl = String.fromEnvironment('BASE_URL');
      final currentRefreshToken =
          await sl<AuthTokenService>().getRefreshToken();
      final rawDio = Dio(
        BaseOptions(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-api-key': const String.fromEnvironment('API_KEY'),
            'Authorization': 'Bearer $currentRefreshToken',
          },
          receiveTimeout: const Duration(minutes: 1),
          connectTimeout: const Duration(minutes: 1),
          validateStatus: (status) => true,
        ),
      );

      final response = await rawDio.post('$baseUrl${ListAPI.refreshToken}');

      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        return false;
      }

      final loginResponse = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      final data = loginResponse.data;

      if (data?.accessToken == null || data?.refreshToken == null) {
        await sl<MainBoxMixin>().logoutBox();
        await sl<AuthTokenService>().clearTokens();
        return false;
      }

      await sl<AuthTokenService>().saveTokens(
        accessToken: data!.accessToken,
        refreshToken: data.refreshToken,
      );
      return true;
    } catch (_) {
      await sl<MainBoxMixin>().logoutBox();
      await sl<AuthTokenService>().clearTokens();
      return false;
    }
  }

  void _showSessionExpiredDialog() {
    final context = AppRoute.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Session Expired'),
          content: const Text('Your session has expired. Please log in again.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                sl<MainBoxMixin>().logoutBox();
                sl<AuthTokenService>().clearTokens();
                context.goNamed(Routes.root.name);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String headerMessage = '';
    response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyJson = encoder.convert(response.data);
    log.d(
      // ignore: unnecessary_null_comparison
      "◀ ︎RESPONSE ${response.statusCode} ${response.requestOptions != null ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL'}\n\n"
      'Headers:\n'
      '$headerMessage\n'
      '❖ Results : \n'
      'Response: $prettyJson',
    );
    super.onResponse(response, handler);
  }
}

// coverage:ignore-end
