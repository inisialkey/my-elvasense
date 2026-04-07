import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myelvasense/features/features.dart';

part 'user_account_action_response.freezed.dart';
part 'user_account_action_response.g.dart';

@freezed
sealed class UserAccountActionResponse with _$UserAccountActionResponse {
  const factory UserAccountActionResponse({
    @JsonKey(name: 'data') DataUserAccountAction? data,
  }) = _UserAccountActionResponse;

  const UserAccountActionResponse._();

  UserAccountAction toEntity() =>
      UserAccountAction(userAccountId: data?.userAccountId);

  factory UserAccountActionResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAccountActionResponseFromJson(json);
}

@freezed
sealed class DataUserAccountAction with _$DataUserAccountAction {
  const factory DataUserAccountAction({
    @JsonKey(name: 'userAccountId') String? userAccountId,
  }) = _DataUserAccountAction;

  factory DataUserAccountAction.fromJson(Map<String, dynamic> json) =>
      _$DataUserAccountActionFromJson(json);
}
