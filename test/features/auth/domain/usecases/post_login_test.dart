import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myelvasense/features/features.dart';

import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';
import '../../../../helpers/test_mock.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late PostLogin postLogin;
  late Login login;
  const loginParams = LoginParams(
    email: 'produksi1@mail.com',
    password: '12345678',
  );

  setUp(() {
    login = LoginResponse.fromJson(
      json.decode(jsonReader(pathLoginResponse200)) as Map<String, dynamic>,
    ).toEntity();
    mockAuthRepository = MockAuthRepository();
    postLogin = PostLogin(mockAuthRepository);
  });

  test('should get login from the repository', () async {
    /// arrange
    when(
      mockAuthRepository.login(loginParams),
    ).thenAnswer((_) async => Right(login));

    /// act
    final result = await postLogin.call(loginParams);

    /// assert
    expect(result, equals(Right(login)));
  });

  test('parse LoginParams to json', () {
    /// act
    final result = loginParams.toJson();
    final expected = {'email': 'produksi1@mail.com', 'password': '12345678'};

    /// assert
    expect(result, equals(expected));
  });

  test('parse LoginParams from json', () {
    /// act
    final params = LoginParams.fromJson({
      'email': 'produksi1@mail.com',
      'password': '12345678',
    });

    /// assert
    expect(params, equals(loginParams));
  });
}
