// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FollowRequest {

 UserSummary get requester; DateTime get requestedAt;
/// Create a copy of FollowRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowRequestCopyWith<FollowRequest> get copyWith => _$FollowRequestCopyWithImpl<FollowRequest>(this as FollowRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowRequest&&(identical(other.requester, requester) || other.requester == requester)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt));
}


@override
int get hashCode => Object.hash(runtimeType,requester,requestedAt);

@override
String toString() {
  return 'FollowRequest(requester: $requester, requestedAt: $requestedAt)';
}


}

/// @nodoc
abstract mixin class $FollowRequestCopyWith<$Res>  {
  factory $FollowRequestCopyWith(FollowRequest value, $Res Function(FollowRequest) _then) = _$FollowRequestCopyWithImpl;
@useResult
$Res call({
 UserSummary requester, DateTime requestedAt
});


$UserSummaryCopyWith<$Res> get requester;

}
/// @nodoc
class _$FollowRequestCopyWithImpl<$Res>
    implements $FollowRequestCopyWith<$Res> {
  _$FollowRequestCopyWithImpl(this._self, this._then);

  final FollowRequest _self;
  final $Res Function(FollowRequest) _then;

/// Create a copy of FollowRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requester = null,Object? requestedAt = null,}) {
  return _then(_self.copyWith(
requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as UserSummary,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of FollowRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get requester {
  
  return $UserSummaryCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}
}


/// Adds pattern-matching-related methods to [FollowRequest].
extension FollowRequestPatterns on FollowRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowRequest value)  $default,){
final _that = this;
switch (_that) {
case _FollowRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FollowRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserSummary requester,  DateTime requestedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowRequest() when $default != null:
return $default(_that.requester,_that.requestedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserSummary requester,  DateTime requestedAt)  $default,) {final _that = this;
switch (_that) {
case _FollowRequest():
return $default(_that.requester,_that.requestedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserSummary requester,  DateTime requestedAt)?  $default,) {final _that = this;
switch (_that) {
case _FollowRequest() when $default != null:
return $default(_that.requester,_that.requestedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FollowRequest implements FollowRequest {
  const _FollowRequest({required this.requester, required this.requestedAt});
  

@override final  UserSummary requester;
@override final  DateTime requestedAt;

/// Create a copy of FollowRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowRequestCopyWith<_FollowRequest> get copyWith => __$FollowRequestCopyWithImpl<_FollowRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowRequest&&(identical(other.requester, requester) || other.requester == requester)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt));
}


@override
int get hashCode => Object.hash(runtimeType,requester,requestedAt);

@override
String toString() {
  return 'FollowRequest(requester: $requester, requestedAt: $requestedAt)';
}


}

/// @nodoc
abstract mixin class _$FollowRequestCopyWith<$Res> implements $FollowRequestCopyWith<$Res> {
  factory _$FollowRequestCopyWith(_FollowRequest value, $Res Function(_FollowRequest) _then) = __$FollowRequestCopyWithImpl;
@override @useResult
$Res call({
 UserSummary requester, DateTime requestedAt
});


@override $UserSummaryCopyWith<$Res> get requester;

}
/// @nodoc
class __$FollowRequestCopyWithImpl<$Res>
    implements _$FollowRequestCopyWith<$Res> {
  __$FollowRequestCopyWithImpl(this._self, this._then);

  final _FollowRequest _self;
  final $Res Function(_FollowRequest) _then;

/// Create a copy of FollowRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requester = null,Object? requestedAt = null,}) {
  return _then(_FollowRequest(
requester: null == requester ? _self.requester : requester // ignore: cast_nullable_to_non_nullable
as UserSummary,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of FollowRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get requester {
  
  return $UserSummaryCopyWith<$Res>(_self.requester, (value) {
    return _then(_self.copyWith(requester: value));
  });
}
}

// dart format on
