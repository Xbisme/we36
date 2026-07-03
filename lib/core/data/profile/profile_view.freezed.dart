// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileView {

 User get user; ViewerRelationship get relationship; bool get isMe; bool get gated;
/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileViewCopyWith<ProfileView> get copyWith => _$ProfileViewCopyWithImpl<ProfileView>(this as ProfileView, _$identity);

  /// Serializes this ProfileView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileView&&(identical(other.user, user) || other.user == user)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.gated, gated) || other.gated == gated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,relationship,isMe,gated);

@override
String toString() {
  return 'ProfileView(user: $user, relationship: $relationship, isMe: $isMe, gated: $gated)';
}


}

/// @nodoc
abstract mixin class $ProfileViewCopyWith<$Res>  {
  factory $ProfileViewCopyWith(ProfileView value, $Res Function(ProfileView) _then) = _$ProfileViewCopyWithImpl;
@useResult
$Res call({
 User user, ViewerRelationship relationship, bool isMe, bool gated
});


$UserCopyWith<$Res> get user;$ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class _$ProfileViewCopyWithImpl<$Res>
    implements $ProfileViewCopyWith<$Res> {
  _$ProfileViewCopyWithImpl(this._self, this._then);

  final ProfileView _self;
  final $Res Function(ProfileView) _then;

/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? relationship = null,Object? isMe = null,Object? gated = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,gated: null == gated ? _self.gated : gated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerRelationshipCopyWith<$Res> get relationship {
  
  return $ViewerRelationshipCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileView].
extension ProfileViewPatterns on ProfileView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileView value)  $default,){
final _that = this;
switch (_that) {
case _ProfileView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileView value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User user,  ViewerRelationship relationship,  bool isMe,  bool gated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileView() when $default != null:
return $default(_that.user,_that.relationship,_that.isMe,_that.gated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User user,  ViewerRelationship relationship,  bool isMe,  bool gated)  $default,) {final _that = this;
switch (_that) {
case _ProfileView():
return $default(_that.user,_that.relationship,_that.isMe,_that.gated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User user,  ViewerRelationship relationship,  bool isMe,  bool gated)?  $default,) {final _that = this;
switch (_that) {
case _ProfileView() when $default != null:
return $default(_that.user,_that.relationship,_that.isMe,_that.gated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileView extends ProfileView {
  const _ProfileView({required this.user, required this.relationship, this.isMe = false, this.gated = false}): super._();
  factory _ProfileView.fromJson(Map<String, dynamic> json) => _$ProfileViewFromJson(json);

@override final  User user;
@override final  ViewerRelationship relationship;
@override@JsonKey() final  bool isMe;
@override@JsonKey() final  bool gated;

/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileViewCopyWith<_ProfileView> get copyWith => __$ProfileViewCopyWithImpl<_ProfileView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileView&&(identical(other.user, user) || other.user == user)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.gated, gated) || other.gated == gated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,relationship,isMe,gated);

@override
String toString() {
  return 'ProfileView(user: $user, relationship: $relationship, isMe: $isMe, gated: $gated)';
}


}

/// @nodoc
abstract mixin class _$ProfileViewCopyWith<$Res> implements $ProfileViewCopyWith<$Res> {
  factory _$ProfileViewCopyWith(_ProfileView value, $Res Function(_ProfileView) _then) = __$ProfileViewCopyWithImpl;
@override @useResult
$Res call({
 User user, ViewerRelationship relationship, bool isMe, bool gated
});


@override $UserCopyWith<$Res> get user;@override $ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class __$ProfileViewCopyWithImpl<$Res>
    implements _$ProfileViewCopyWith<$Res> {
  __$ProfileViewCopyWithImpl(this._self, this._then);

  final _ProfileView _self;
  final $Res Function(_ProfileView) _then;

/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? relationship = null,Object? isMe = null,Object? gated = null,}) {
  return _then(_ProfileView(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,gated: null == gated ? _self.gated : gated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ProfileView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerRelationshipCopyWith<$Res> get relationship {
  
  return $ViewerRelationshipCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// @nodoc
mixin _$FollowResult {

 ViewerRelationship get relationship; int get followersCount;
/// Create a copy of FollowResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowResultCopyWith<FollowResult> get copyWith => _$FollowResultCopyWithImpl<FollowResult>(this as FollowResult, _$identity);

  /// Serializes this FollowResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowResult&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relationship,followersCount);

@override
String toString() {
  return 'FollowResult(relationship: $relationship, followersCount: $followersCount)';
}


}

/// @nodoc
abstract mixin class $FollowResultCopyWith<$Res>  {
  factory $FollowResultCopyWith(FollowResult value, $Res Function(FollowResult) _then) = _$FollowResultCopyWithImpl;
@useResult
$Res call({
 ViewerRelationship relationship, int followersCount
});


$ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class _$FollowResultCopyWithImpl<$Res>
    implements $FollowResultCopyWith<$Res> {
  _$FollowResultCopyWithImpl(this._self, this._then);

  final FollowResult _self;
  final $Res Function(FollowResult) _then;

/// Create a copy of FollowResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? relationship = null,Object? followersCount = null,}) {
  return _then(_self.copyWith(
relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of FollowResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerRelationshipCopyWith<$Res> get relationship {
  
  return $ViewerRelationshipCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// Adds pattern-matching-related methods to [FollowResult].
extension FollowResultPatterns on FollowResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowResult value)  $default,){
final _that = this;
switch (_that) {
case _FollowResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowResult value)?  $default,){
final _that = this;
switch (_that) {
case _FollowResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ViewerRelationship relationship,  int followersCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowResult() when $default != null:
return $default(_that.relationship,_that.followersCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ViewerRelationship relationship,  int followersCount)  $default,) {final _that = this;
switch (_that) {
case _FollowResult():
return $default(_that.relationship,_that.followersCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ViewerRelationship relationship,  int followersCount)?  $default,) {final _that = this;
switch (_that) {
case _FollowResult() when $default != null:
return $default(_that.relationship,_that.followersCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowResult implements FollowResult {
  const _FollowResult({required this.relationship, required this.followersCount});
  factory _FollowResult.fromJson(Map<String, dynamic> json) => _$FollowResultFromJson(json);

@override final  ViewerRelationship relationship;
@override final  int followersCount;

/// Create a copy of FollowResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowResultCopyWith<_FollowResult> get copyWith => __$FollowResultCopyWithImpl<_FollowResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowResult&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relationship,followersCount);

@override
String toString() {
  return 'FollowResult(relationship: $relationship, followersCount: $followersCount)';
}


}

/// @nodoc
abstract mixin class _$FollowResultCopyWith<$Res> implements $FollowResultCopyWith<$Res> {
  factory _$FollowResultCopyWith(_FollowResult value, $Res Function(_FollowResult) _then) = __$FollowResultCopyWithImpl;
@override @useResult
$Res call({
 ViewerRelationship relationship, int followersCount
});


@override $ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class __$FollowResultCopyWithImpl<$Res>
    implements _$FollowResultCopyWith<$Res> {
  __$FollowResultCopyWithImpl(this._self, this._then);

  final _FollowResult _self;
  final $Res Function(_FollowResult) _then;

/// Create a copy of FollowResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? relationship = null,Object? followersCount = null,}) {
  return _then(_FollowResult(
relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of FollowResult
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
