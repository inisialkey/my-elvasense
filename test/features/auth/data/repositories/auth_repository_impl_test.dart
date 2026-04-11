import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/dependencies_injection.dart';
import 'package:myelvasense/features/features.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';
import '../../../../helpers/test_mock.mocks.dart';

void main() {
  late MockAuthRemoteDatasource mockAuthRemoteDatasource;
  late MockAuthTokenService mockAuthTokenService;
  late AuthRepositoryImpl authRepositoryImpl;
  late Login login;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    FlutterSecureStorage.setMockInitialValues({});
    await serviceLocator(
      isUnitTest: true,
      prefixBox: 'auth_repository_impl_test_',
    );
    mockAuthRemoteDatasource = MockAuthRemoteDatasource();
    mockAuthTokenService = MockAuthTokenService();
    authRepositoryImpl = AuthRepositoryImpl(
      mockAuthRemoteDatasource,
      sl(),
      mockAuthTokenService,
    );
    login = LoginResponse.fromJson(
      json.decode(jsonReader(pathLoginResponse200)) as Map<String, dynamic>,
    ).toEntity();
  });

  group('login', () {
    const loginParams = LoginParams(
      email: 'mudassir@lazycatlabs.com',
      password: 'pass123',
    );

    test('should return login and save tokens when call is successful',
        () async {
      // arrange
      when(mockAuthRemoteDatasource.login(loginParams)).thenAnswer(
        (_) async => Right(
          LoginResponse.fromJson(
            json.decode(jsonReader(pathLoginResponse200))
                as Map<String, dynamic>,
          ),
        ),
      );
      when(
        mockAuthTokenService.saveTokens(
          accessToken: anyNamed('accessToken'),
          refreshToken: anyNamed('refreshToken'),
        ),
      ).thenAnswer((_) async {});

      // act
      final result = await authRepositoryImpl.login(loginParams);

      // assert
      verify(mockAuthRemoteDatasource.login(loginParams));
      verify(
        mockAuthTokenService.saveTokens(
          accessToken: login.accessToken,
          refreshToken: login.refreshToken,
        ),
      );
      expect(result, Right(login));
    });

    test('should return server failure when call is unsuccessful', () async {
      // arrange
      when(
        mockAuthRemoteDatasource.login(loginParams),
      ).thenAnswer((_) async => const Left(ServerFailure('')));

      // act
      final result = await authRepositoryImpl.login(loginParams);

      // assert
      verify(mockAuthRemoteDatasource.login(loginParams));
      verifyNever(
        mockAuthTokenService.saveTokens(
          accessToken: anyNamed('accessToken'),
          refreshToken: anyNamed('refreshToken'),
        ),
      );
      expect(result, const Left(ServerFailure('')));
    });
  });
}
