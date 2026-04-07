// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_account_action_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserAccountActionResponse {

@JsonKey(name: 'data') DataUserAccountAction? get data;
/// Create a copy of UserAccountActionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountActionResponseCopyWith<UserAccountActionResponse> get copyWith => _$UserAccountActionResponseCopyWithImpl<UserAccountActionResponse>(this as UserAccountActionResponse, _$identity);

  /// Serializes this UserAccountActionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountActionResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'UserAccountActionResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $UserAccountActionResponseCopyWith<$Res>  {
  factory $UserAccountActionResponseCopyWith(UserAccountActionResponse value, $Res Function(UserAccountActionResponse) _then) = _$UserAccountActionResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'data') DataUserAccountAction? data
});


$DataUserAccountActionCopyWith<$Res>? get data;

}
/// @nodoc
class _$UserAccountActionResponseCopyWithImpl<$Res>
    implements $UserAccountActionResponseCopyWith<$Res> {
  _$UserAccountActionResponseCopyWithImpl(this._self, this._then);

  final UserAccountActionResponse _self;
  final $Res Function(UserAccountActionResponse) _then;

/// Create a copy of UserAccountActionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DataUserAccountAction?,
  ));
}
/// Create a copy of UserAccountActionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataUserAccountActionCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DataUserAccountActionCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserAccountActionResponse].
extension UserAccountActionResponsePatterns on UserAccountActionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountActionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountActionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountActionResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountActionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountActionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountActionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'data')  DataUserAccountAction? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountActionResponse() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'data')  DataUserAccountAction? data)  $default,) {final _that = this;
switch (_that) {
case _UserAccountActionResponse():
return $default(_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'data')  DataUserAccountAction? data)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountActionResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAccountActionResponse extends UserAccountActionResponse {
  const _UserAccountActionResponse({@JsonKey(name: 'data') this.data}): super._();
  factory _UserAccountActionResponse.fromJson(Map<String, dynamic> json) => _$UserAccountActionResponseFromJson(json);

@override@JsonKey(name: 'data') final  DataUserAccountAction? data;

/// Create a copy of UserAccountActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountActionResponseCopyWith<_UserAccountActionResponse> get copyWith => __$UserAccountActionResponseCopyWithImpl<_UserAccountActionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAccountActionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountActionResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'UserAccountActionResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$UserAccountActionResponseCopyWith<$Res> implements $UserAccountActionResponseCopyWith<$Res> {
  factory _$UserAccountActionResponseCopyWith(_UserAccountActionResponse value, $Res Function(_UserAccountActionResponse) _then) = __$UserAccountActionResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'data') DataUserAccountAction? data
});


@override $DataUserAccountActionCopyWith<$Res>? get data;

}
/// @nodoc
class __$UserAccountActionResponseCopyWithImpl<$Res>
    implements _$UserAccountActionResponseCopyWith<$Res> {
  __$UserAccountActionResponseCopyWithImpl(this._self, this._then);

  final _UserAccountActionResponse _self;
  final $Res Function(_UserAccountActionResponse) _then;

/// Create a copy of UserAccountActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_UserAccountActionResponse(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DataUserAccountAction?,
  ));
}

/// Create a copy of UserAccountActionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataUserAccountActionCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DataUserAccountActionCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$DataUserAccountAction {

@JsonKey(name: 'userAccountId') String? get userAccountId;
/// Create a copy of DataUserAccountAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataUserAccountActionCopyWith<DataUserAccountAction> get copyWith => _$DataUserAccountActionCopyWithImpl<DataUserAccountAction>(this as DataUserAccountAction, _$identity);

  /// Serializes this DataUserAccountAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataUserAccountAction&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userAccountId);

@override
String toString() {
  return 'DataUserAccountAction(userAccountId: $userAccountId)';
}


}

/// @nodoc
abstract mixin class $DataUserAccountActionCopyWith<$Res>  {
  factory $DataUserAccountActionCopyWith(DataUserAccountAction value, $Res Function(DataUserAccountAction) _then) = _$DataUserAccountActionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userAccountId') String? userAccountId
});




}
/// @nodoc
class _$DataUserAccountActionCopyWithImpl<$Res>
    implements $DataUserAccountActionCopyWith<$Res> {
  _$DataUserAccountActionCopyWithImpl(this._self, this._then);

  final DataUserAccountAction _self;
  final $Res Function(DataUserAccountAction) _then;

/// Create a copy of DataUserAccountAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userAccountId = freezed,}) {
  return _then(_self.copyWith(
userAccountId: freezed == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DataUserAccountAction].
extension DataUserAccountActionPatterns on DataUserAccountAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataUserAccountAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataUserAccountAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataUserAccountAction value)  $default,){
final _that = this;
switch (_that) {
case _DataUserAccountAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataUserAccountAction value)?  $default,){
final _that = this;
switch (_that) {
case _DataUserAccountAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userAccountId')  String? userAccountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataUserAccountAction() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userAccountId')  String? userAccountId)  $default,) {final _that = this;
switch (_that) {
case _DataUserAccountAction():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userAccountId')  String? userAccountId)?  $default,) {final _that = this;
switch (_that) {
case _DataUserAccountAction() when $default != null:
return $default(_that.userAccountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DataUserAccountAction implements DataUserAccountAction {
  const _DataUserAccountAction({@JsonKey(name: 'userAccountId') this.userAccountId});
  factory _DataUserAccountAction.fromJson(Map<String, dynamic> json) => _$DataUserAccountActionFromJson(json);

@override@JsonKey(name: 'userAccountId') final  String? userAccountId;

/// Create a copy of DataUserAccountAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataUserAccountActionCopyWith<_DataUserAccountAction> get copyWith => __$DataUserAccountActionCopyWithImpl<_DataUserAccountAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataUserAccountActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataUserAccountAction&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userAccountId);

@override
String toString() {
  return 'DataUserAccountAction(userAccountId: $userAccountId)';
}


}

/// @nodoc
abstract mixin class _$DataUserAccountActionCopyWith<$Res> implements $DataUserAccountActionCopyWith<$Res> {
  factory _$DataUserAccountActionCopyWith(_DataUserAccountAction value, $Res Function(_DataUserAccountAction) _then) = __$DataUserAccountActionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userAccountId') String? userAccountId
});




}
/// @nodoc
class __$DataUserAccountActionCopyWithImpl<$Res>
    implements _$DataUserAccountActionCopyWith<$Res> {
  __$DataUserAccountActionCopyWithImpl(this._self, this._then);

  final _DataUserAccountAction _self;
  final $Res Function(_DataUserAccountAction) _then;

/// Create a copy of DataUserAccountAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userAccountId = freezed,}) {
  return _then(_DataUserAccountAction(
userAccountId: freezed == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
