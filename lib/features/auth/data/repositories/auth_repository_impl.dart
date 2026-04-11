import 'package:dartz/dartz.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/auth/auth.dart';
import 'package:myelvasense/utils/services/hive/hive.dart';
import 'package:myelvasense/utils/services/secure_storage/secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final MainBoxMixin mainBoxMixin;
  final AuthTokenService authTokenService;

  const AuthRepositoryImpl(
    this.authRemoteDatasource,
    this.mainBoxMixin,
    this.authTokenService,
  );

  @override
  Future<Either<Failure, Login>> login(LoginParams params) async {
    final response = await authRemoteDatasource.login(params);

    return response.fold((failure) => Left(failure), (loginResponse) async {
      await mainBoxMixin.addData(MainBoxKeys.isLogin, true);
      await authTokenService.saveTokens(
        accessToken: loginResponse.data?.accessToken,
        refreshToken: loginResponse.data?.refreshToken,
      );

      return Right(loginResponse.toEntity());
    });
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
