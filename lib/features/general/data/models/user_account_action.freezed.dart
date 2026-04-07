// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_account_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserAccountAction {

 String? get userAccountId;
/// Create a copy of UserAccountAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountActionCopyWith<UserAccountAction> get copyWith => _$UserAccountActionCopyWithImpl<UserAccountAction>(this as UserAccountAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountAction&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId));
}


@override
int get hashCode => Object.hash(runtimeType,userAccountId);

@override
String toString() {
  return 'UserAccountAction(userAccountId: $userAccountId)';
}


}

/// @nodoc
abstract mixin class $UserAccountActionCopyWith<$Res>  {
  factory $UserAccountActionCopyWith(UserAccountAction value, $Res Function(UserAccountAction) _then) = _$UserAccountActionCopyWithImpl;
@useResult
$Res call({
 String? userAccountId
});




}
/// @nodoc
class _$UserAccountActionCopyWithImpl<$Res>
    implements $UserAccountActionCopyWith<$Res> {
  _$UserAccountActionCopyWithImpl(this._self, this._then);

  final UserAccountAction _self;
  final $Res Function(UserAccountAction) _then;

/// Create a copy of UserAccountAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userAccountId = freezed,}) {
  return _then(_self.copyWith(
userAccountId: freezed == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAccountAction].
extension UserAccountActionPatterns on UserAccountAction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountAction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountAction value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountAction():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountAction value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountAction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? userAccountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountAction() when $default != null:
return $default(_that.userAccountId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? userAccountId)  $default,) {final _that = this;
switch (_that) {
case _UserAccountAction():
return $default(_that.userAccountId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? userAccountId)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountAction() when $default != null:
return $default(_that.userAccountId);case _:
  return null;

}
}

}

/// @nodoc


class _UserAccountAction implements UserAccountAction {
  const _UserAccountAction({this.userAccountId});
  

@override final  String? userAccountId;

/// Create a copy of UserAccountAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountActionCopyWith<_UserAccountAction> get copyWith => __$UserAccountActionCopyWithImpl<_UserAccountAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountAction&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId));
}


@override
int get hashCode => Object.hash(runtimeType,userAccountId);

@override
String toString() {
  return 'UserAccountAction(userAccountId: $userAccountId)';
}


}

/// @nodoc
abstract mixin class _$UserAccountActionCopyWith<$Res> implements $UserAccountActionCopyWith<$Res> {
  factory _$UserAccountActionCopyWith(_UserAccountAction value, $Res Function(_UserAccountAction) _then) = __$UserAccountActionCopyWithImpl;
@override @useResult
$Res call({
 String? userAccountId
});




}
/// @nodoc
class __$UserAccountActionCopyWithImpl<$Res>
    implements _$UserAccountActionCopyWith<$Res> {
  __$UserAccountActionCopyWithImpl(this._self, this._then);

  final _UserAccountAction _self;
  final $Res Function(_UserAccountAction) _then;

/// Create a copy of UserAccountAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userAccountId = freezed,}) {
  return _then(_UserAccountAction(
userAccountId: freezed == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
