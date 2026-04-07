import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_account_action.freezed.dart';

@freezed
sealed class UserAccountAction with _$UserAccountAction {
  const factory UserAccountAction({String? userAccountId}) = _UserAccountAction;
}
