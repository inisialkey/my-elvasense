import 'package:dartz/dartz.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/auth/auth.dart';

abstract class AuthRepository {
  Future<Either<Failure, Login>> login(LoginParams params);

  Future<Either<Failure, String>> logout();
}
