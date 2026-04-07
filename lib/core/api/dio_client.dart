import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/utils/utils.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

class DioClient with MainBoxMixin, FirebaseCrashLogger {
  String baseUrl = const String.fromEnvironment('BASE_URL');

  String? _token;
  bool _isUnitTest = false;
  late Dio _dio;

  DioClient({bool isUnitTest = false}) {
    _isUnitTest = isUnitTest;

    try {
      _token = token();
    } catch (_) {}

    _dio = _createDio();

    if (!_isUnitTest) {
      _dio.interceptors.add(DioInterceptor());
    }
  }

  String token() => getData(MainBoxKeys.accessToken);

  Dio get dio {
    if (_isUnitTest) {
      /// Return static dio if is unit test
      return _dio;
    } else {
      /// We need to recreate dio to avoid token issue after login
      try {
        _token = token();
      } catch (_) {}

      final dio = _createDio();

      if (!_isUnitTest) {
        dio.interceptors.add(DioInterceptor());
      }

      return dio;
    }
  }

  Dio _createDio() => Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': const String.fromEnvironment('API_KEY'),
        if (_token != null) ...{'Authorization': 'Bearer $_token'},
      },
      receiveTimeout: const Duration(minutes: 1),
      connectTimeout: const Duration(minutes: 1),
      validateStatus: (int? status) => status! > 0,
    ),
  );

  Future<Either<Failure, T>> getRequest<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    bool isIsolate = true,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      if (e.type == DioExceptionType.connectionError) {
        return Left(ConnectionFailure(e.message ?? 'No internet connection'));
      }
      try {
        if (!_isUnitTest) {
          nonFatalError(error: e, stackTrace: stackTrace);
        }
        return Left(
          ServerFailure(
            e.response?.data['diagnostic']['message'] as String? ?? e.message,
          ),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, T>> postRequest<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? data,
    bool isIsolate = true,
  }) async {
    try {
      final response = await dio.post(url, data: data);
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      if (e.type == DioExceptionType.connectionError) {
        return Left(ConnectionFailure(e.message ?? 'No internet connection'));
      }
      try {
        if (!_isUnitTest) {
          nonFatalError(error: e, stackTrace: stackTrace);
        }
        return Left(
          ServerFailure(
            e.response?.data['diagnostic']['message'] as String? ?? e.message,
          ),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
