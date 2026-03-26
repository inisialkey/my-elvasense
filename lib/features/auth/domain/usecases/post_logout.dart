import 'package:dartz/dartz.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';

class PostLogout extends UseCase<String, NoParams> {
  final AuthRepository _repo;

  // coverage:ignore-start
  PostLogout(this._repo);

  @override
  Future<Either<Failure, String>> call(NoParams _) => _repo.logout();
  // coverage:ignore-end
}
