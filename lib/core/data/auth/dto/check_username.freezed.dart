// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_username.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsernameAvailability {

 bool get available; UsernameReason? get reason;
/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsernameAvailabilityCopyWith<UsernameAvailability> get copyWith => _$UsernameAvailabilityCopyWithImpl<UsernameAvailability>(this as UsernameAvailability, _$identity);

  /// Serializes this UsernameAvailability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsernameAvailability&&(identical(other.available, available) || other.available == available)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available,reason);

@override
String toString() {
  return 'UsernameAvailability(available: $available, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $UsernameAvailabilityCopyWith<$Res>  {
  factory $UsernameAvailabilityCopyWith(UsernameAvailability value, $Res Function(UsernameAvailability) _then) = _$UsernameAvailabilityCopyWithImpl;
@useResult
$Res call({
 bool available, UsernameReason? reason
});




}
/// @nodoc
class _$UsernameAvailabilityCopyWithImpl<$Res>
    implements $UsernameAvailabilityCopyWith<$Res> {
  _$UsernameAvailabilityCopyWithImpl(this._self, this._then);

  final UsernameAvailability _self;
  final $Res Function(UsernameAvailability) _then;

/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as UsernameReason?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsernameAvailability].
extension UsernameAvailabilityPatterns on UsernameAvailability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsernameAvailability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsernameAvailability value)  $default,){
final _that = this;
switch (_that) {
case _UsernameAvailability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsernameAvailability value)?  $default,){
final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool available,  UsernameReason? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
return $default(_that.available,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool available,  UsernameReason? reason)  $default,) {final _that = this;
switch (_that) {
case _UsernameAvailability():
return $default(_that.available,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool available,  UsernameReason? reason)?  $default,) {final _that = this;
switch (_that) {
case _UsernameAvailability() when $default != null:
return $default(_that.available,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsernameAvailability implements UsernameAvailability {
  const _UsernameAvailability({required this.available, this.reason});
  factory _UsernameAvailability.fromJson(Map<String, dynamic> json) => _$UsernameAvailabilityFromJson(json);

@override final  bool available;
@override final  UsernameReason? reason;

/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsernameAvailabilityCopyWith<_UsernameAvailability> get copyWith => __$UsernameAvailabilityCopyWithImpl<_UsernameAvailability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsernameAvailabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsernameAvailability&&(identical(other.available, available) || other.available == available)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available,reason);

@override
String toString() {
  return 'UsernameAvailability(available: $available, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$UsernameAvailabilityCopyWith<$Res> implements $UsernameAvailabilityCopyWith<$Res> {
  factory _$UsernameAvailabilityCopyWith(_UsernameAvailability value, $Res Function(_UsernameAvailability) _then) = __$UsernameAvailabilityCopyWithImpl;
@override @useResult
$Res call({
 bool available, UsernameReason? reason
});




}
/// @nodoc
class __$UsernameAvailabilityCopyWithImpl<$Res>
    implements _$UsernameAvailabilityCopyWith<$Res> {
  __$UsernameAvailabilityCopyWithImpl(this._self, this._then);

  final _UsernameAvailability _self;
  final $Res Function(_UsernameAvailability) _then;

/// Create a copy of UsernameAvailability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? reason = freezed,}) {
  return _then(_UsernameAvailability(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as UsernameReason?,
  ));
}


}

// dart format on
