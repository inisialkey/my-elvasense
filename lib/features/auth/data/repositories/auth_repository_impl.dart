import 'package:dartz/dartz.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/auth/auth.dart';
import 'package:myelvasense/utils/services/hive/hive.dart';

class AuthRepositoryImpl implements AuthRepository {
  /// Data Source
  final AuthRemoteDatasource authRemoteDatasource;
  final MainBoxMixin mainBoxMixin;

  const AuthRepositoryImpl(this.authRemoteDatasource, this.mainBoxMixin);

  @override
  Future<Either<Failure, Login>> login(LoginParams params) async {
    final response = await authRemoteDatasource.login(params);

    return response.fold((failure) => Left(failure), (loginResponse) {
      mainBoxMixin.addData(MainBoxKeys.isLogin, true);
      mainBoxMixin.addData(
        MainBoxKeys.accessToken,
        loginResponse.data?.accessToken,
      );
      mainBoxMixin.addData(
        MainBoxKeys.refreshToken,
        loginResponse.data?.refreshToken,
      );

      return Right(loginResponse.toEntity());
    });
  }

  @override
  Future<Either<Failure, Register>> register(RegisterParams params) async {
    final response = await authRemoteDatasource.register(params);

    return response.fold(
      (failure) => Left(failure),
      (registerResponse) => Right(registerResponse.toEntity()),
    );
  }

  @override
  Future<Either<Failure, String>> logout() async {
    final response = await authRemoteDatasource.logout();

    return response.fold(
      (failure) => Left(failure),
      (loginResponse) => Right(loginResponse.diagnostic?.message ?? ''),
    );
  }
}
