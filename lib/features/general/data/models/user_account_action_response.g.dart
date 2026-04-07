// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAccountActionResponse _$UserAccountActionResponseFromJson(
  Map<String, dynamic> json,
) => _UserAccountActionResponse(
  data: json['data'] == null
      ? null
      : DataUserAccountAction.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserAccountActionResponseToJson(
  _UserAccountActionResponse instance,
) => <String, dynamic>{'data': instance.data};

_DataUserAccountAction _$DataUserAccountActionFromJson(
  Map<String, dynamic> json,
) => _DataUserAccountAction(userAccountId: json['userAccountId'] as String?);

Map<String, dynamic> _$DataUserAccountActionToJson(
  _DataUserAccountAction instance,
) => <String, dynamic>{'userAccountId': instance.userAccountId};
