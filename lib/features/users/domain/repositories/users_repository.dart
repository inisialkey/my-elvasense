import 'package:dartz/dartz.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/users/users.dart';

abstract class UsersRepository {
  Future<Either<Failure, Users>> users(UsersParams usersParams);

  Future<Either<Failure, User>> user();
}
