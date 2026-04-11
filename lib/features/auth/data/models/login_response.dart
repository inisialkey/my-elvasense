import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myelvasense/features/auth/auth.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
sealed class LoginResponse with _$LoginResponse {
  @JsonSerializable(explicitToJson: true)
  const factory LoginResponse({@JsonKey(name: 'data') DataLogin? data}) =
      _LoginResponse;

  const LoginResponse._();

  Login toEntity() =>
      Login(accessToken: data?.accessToken, refreshToken: data?.refreshToken);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
sealed class DataLogin with _$DataLogin {
  const factory DataLogin({
    @JsonKey(name: 'access_token') String? accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
  }) = _DataLogin;

  factory DataLogin.fromJson(Map<String, dynamic> json) =>
      _$DataLoginFromJson(json);
}
