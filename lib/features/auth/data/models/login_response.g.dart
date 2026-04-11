// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      data: json['data'] == null
          ? null
          : DataLogin.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{'data': instance.data?.toJson()};

_DataLogin _$DataLoginFromJson(Map<String, dynamic> json) => _DataLogin(
  accessToken: json['access_token'] as String?,
  refreshToken: json['refresh_token'] as String?,
);

Map<String, dynamic> _$DataLoginToJson(_DataLogin instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
