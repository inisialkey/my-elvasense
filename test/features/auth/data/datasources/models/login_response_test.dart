import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myelvasense/features/features.dart';

import '../../../../../helpers/json_reader.dart';
import '../../../../../helpers/paths.dart';

void main() {
  const loginResponse = LoginResponse(
    data: DataLogin(
      accessToken:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX3Nlc3Npb25faWQiOiIxMjI1MmIyNC1lNjhhLTQxZjQtOTIzNy01NjY4Mjk2NDgxZGEiLCJ1c2VyX2FjY291bnRfaWQiOiI5M2YyZjgzOC0xMzEzLTQwNzItYjQ0Ny0zY2ZjNDM2MmI4NjEiLCJpYXQiOjE3NzU0Njc5NTksImV4cCI6MTc3NTQ3MTU1OX0.KtQv9-26EoXPr_BpMcVCiFyVy6A2IoABnT8kiW59zZQ',
      refreshToken:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX3Nlc3Npb25faWQiOiIxMjI1MmIyNC1lNjhhLTQxZjQtOTIzNy01NjY4Mjk2NDgxZGEiLCJ1c2VyX2FjY291bnRfaWQiOiI5M2YyZjgzOC0xMzEzLTQwNzItYjQ0Ny0zY2ZjNDM2MmI4NjEiLCJpYXQiOjE3NzU0Njc5NTksImV4cCI6MTgwNzAwMzk1OX0.XWHcydpH7A1rFnlK8uyLG2UFw6Da_skbUZqpXyGCnzI',
    ),
  );

  test('from json, should return a valid model from json', () {
    /// arrange
    final jsonMap = json.decode(jsonReader(pathLoginResponse200));

    /// act
    final result = LoginResponse.fromJson(jsonMap as Map<String, dynamic>);

    /// assert
    expect(result, equals(loginResponse));
  });

  test('to json, should return a json map containing proper data', () {
    /// act
    final result = loginResponse.toJson();

    /// arrange
    final exceptedJson = {
      'data': {
        'access_token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX3Nlc3Npb25faWQiOiIxMjI1MmIyNC1lNjhhLTQxZjQtOTIzNy01NjY4Mjk2NDgxZGEiLCJ1c2VyX2FjY291bnRfaWQiOiI5M2YyZjgzOC0xMzEzLTQwNzItYjQ0Ny0zY2ZjNDM2MmI4NjEiLCJpYXQiOjE3NzU0Njc5NTksImV4cCI6MTc3NTQ3MTU1OX0.KtQv9-26EoXPr_BpMcVCiFyVy6A2IoABnT8kiW59zZQ',
        'refresh_token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX3Nlc3Npb25faWQiOiIxMjI1MmIyNC1lNjhhLTQxZjQtOTIzNy01NjY4Mjk2NDgxZGEiLCJ1c2VyX2FjY291bnRfaWQiOiI5M2YyZjgzOC0xMzEzLTQwNzItYjQ0Ny0zY2ZjNDM2MmI4NjEiLCJpYXQiOjE3NzU0Njc5NTksImV4cCI6MTgwNzAwMzk1OX0.XWHcydpH7A1rFnlK8uyLG2UFw6Da_skbUZqpXyGCnzI',
      },
    };

    /// assert
    expect(result, equals(exceptedJson));
  });
}
