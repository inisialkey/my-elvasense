import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myelvasense/features/auth/auth.dart';
import 'package:myelvasense/features/general/general.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'diagnostic') Diagnostic? diagnostic,
    @JsonKey(name: 'data') DataLogin? data,
  }) = _LoginResponse;

  const LoginResponse._();

  Login toEntity() => Login(token: '${data?.tokenType} ${data?.token}');

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
sealed class DataLogin with _$DataLogin {
  const factory DataLogin({
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'tokenType') String? tokenType,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _DataLogin;

  factory DataLogin.fromJson(Map<String, dynamic> json) =>
      _$DataLoginFromJson(json);
}
