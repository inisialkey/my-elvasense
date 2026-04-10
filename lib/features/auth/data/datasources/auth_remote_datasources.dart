import 'package:dartz/dartz.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';

abstract class AuthRemoteDatasource {
  Future<Either<Failure, LoginResponse>> login(LoginParams params);

  Future<Either<Failure, DiagnosticResponse>> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _client;

  AuthRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginParams params) async {
    final response = await _client.postRequest(
      ListAPI.login,
      data: params.toJson(),
      converter: (response) =>
          LoginResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, DiagnosticResponse>> logout() async {
    final response = await _client.postRequest(
      ListAPI.logout,
      converter: (response) =>
          DiagnosticResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }
}
