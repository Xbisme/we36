// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountRow {

 UserSummary get user; ViewerRelationship get relationship;
/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountRowCopyWith<AccountRow> get copyWith => _$AccountRowCopyWithImpl<AccountRow>(this as AccountRow, _$identity);

  /// Serializes this AccountRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountRow&&(identical(other.user, user) || other.user == user)&&(identical(other.relationship, relationship) || other.relationship == relationship));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,relationship);

@override
String toString() {
  return 'AccountRow(user: $user, relationship: $relationship)';
}


}

/// @nodoc
abstract mixin class $AccountRowCopyWith<$Res>  {
  factory $AccountRowCopyWith(AccountRow value, $Res Function(AccountRow) _then) = _$AccountRowCopyWithImpl;
@useResult
$Res call({
 UserSummary user, ViewerRelationship relationship
});


$UserSummaryCopyWith<$Res> get user;$ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class _$AccountRowCopyWithImpl<$Res>
    implements $AccountRowCopyWith<$Res> {
  _$AccountRowCopyWithImpl(this._self, this._then);

  final AccountRow _self;
  final $Res Function(AccountRow) _then;

/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? relationship = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserSummary,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,
  ));
}
/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get user {
  
  return $UserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerRelationshipCopyWith<$Res> get relationship {
  
  return $ViewerRelationshipCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountRow].
extension AccountRowPatterns on AccountRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountRow value)  $default,){
final _that = this;
switch (_that) {
case _AccountRow():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountRow value)?  $default,){
final _that = this;
switch (_that) {
case _AccountRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserSummary user,  ViewerRelationship relationship)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountRow() when $default != null:
return $default(_that.user,_that.relationship);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserSummary user,  ViewerRelationship relationship)  $default,) {final _that = this;
switch (_that) {
case _AccountRow():
return $default(_that.user,_that.relationship);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserSummary user,  ViewerRelationship relationship)?  $default,) {final _that = this;
switch (_that) {
case _AccountRow() when $default != null:
return $default(_that.user,_that.relationship);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountRow implements AccountRow {
  const _AccountRow({required this.user, required this.relationship});
  factory _AccountRow.fromJson(Map<String, dynamic> json) => _$AccountRowFromJson(json);

@override final  UserSummary user;
@override final  ViewerRelationship relationship;

/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountRowCopyWith<_AccountRow> get copyWith => __$AccountRowCopyWithImpl<_AccountRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountRow&&(identical(other.user, user) || other.user == user)&&(identical(other.relationship, relationship) || other.relationship == relationship));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,relationship);

@override
String toString() {
  return 'AccountRow(user: $user, relationship: $relationship)';
}


}

/// @nodoc
abstract mixin class _$AccountRowCopyWith<$Res> implements $AccountRowCopyWith<$Res> {
  factory _$AccountRowCopyWith(_AccountRow value, $Res Function(_AccountRow) _then) = __$AccountRowCopyWithImpl;
@override @useResult
$Res call({
 UserSummary user, ViewerRelationship relationship
});


@override $UserSummaryCopyWith<$Res> get user;@override $ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class __$AccountRowCopyWithImpl<$Res>
    implements _$AccountRowCopyWith<$Res> {
  __$AccountRowCopyWithImpl(this._self, this._then);

  final _AccountRow _self;
  final $Res Function(_AccountRow) _then;

/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? relationship = null,}) {
  return _then(_AccountRow(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserSummary,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,
  ));
}

/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get user {
  
  return $UserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AccountRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerRelationshipCopyWith<$Res> get relationship {
  
  return $ViewerRelationshipCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}

// dart format on
