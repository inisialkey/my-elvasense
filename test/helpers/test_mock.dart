import 'package:flutter/cupertino.dart';
import 'package:mockito/annotations.dart';
import 'package:myelvasense/features/features.dart';
import 'package:myelvasense/utils/utils.dart';

@GenerateMocks([
  AuthRepository,
  AuthRemoteDatasource,
  UsersRepository,
  UsersRemoteDatasource,
  AuthTokenService,
  PermissionService,
])
@GenerateNiceMocks([MockSpec<BuildContext>()])
void main() {}
