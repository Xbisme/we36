// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeProfile {

 String get id; String get email; bool get isPrivate; bool get isVerified; bool get profileCompleted; DateTime get createdAt; String? get username; String? get displayName; String? get avatarMediaId; String? get avatarUrl; String? get bio; String? get website; String? get pronouns;
/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeProfileCopyWith<MeProfile> get copyWith => _$MeProfileCopyWithImpl<MeProfile>(this as MeProfile, _$identity);

  /// Serializes this MeProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarMediaId, avatarMediaId) || other.avatarMediaId == avatarMediaId)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.website, website) || other.website == website)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,isPrivate,isVerified,profileCompleted,createdAt,username,displayName,avatarMediaId,avatarUrl,bio,website,pronouns);

@override
String toString() {
  return 'MeProfile(id: $id, email: $email, isPrivate: $isPrivate, isVerified: $isVerified, profileCompleted: $profileCompleted, createdAt: $createdAt, username: $username, displayName: $displayName, avatarMediaId: $avatarMediaId, avatarUrl: $avatarUrl, bio: $bio, website: $website, pronouns: $pronouns)';
}


}

/// @nodoc
abstract mixin class $MeProfileCopyWith<$Res>  {
  factory $MeProfileCopyWith(MeProfile value, $Res Function(MeProfile) _then) = _$MeProfileCopyWithImpl;
@useResult
$Res call({
 String id, String email, bool isPrivate, bool isVerified, bool profileCompleted, DateTime createdAt, String? username, String? displayName, String? avatarMediaId, String? avatarUrl, String? bio, String? website, String? pronouns
});




}
/// @nodoc
class _$MeProfileCopyWithImpl<$Res>
    implements $MeProfileCopyWith<$Res> {
  _$MeProfileCopyWithImpl(this._self, this._then);

  final MeProfile _self;
  final $Res Function(MeProfile) _then;

/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? isPrivate = null,Object? isVerified = null,Object? profileCompleted = null,Object? createdAt = null,Object? username = freezed,Object? displayName = freezed,Object? avatarMediaId = freezed,Object? avatarUrl = freezed,Object? bio = freezed,Object? website = freezed,Object? pronouns = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarMediaId: freezed == avatarMediaId ? _self.avatarMediaId : avatarMediaId // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,pronouns: freezed == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeProfile].
extension MeProfilePatterns on MeProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeProfile value)  $default,){
final _that = this;
switch (_that) {
case _MeProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeProfile value)?  $default,){
final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  bool isPrivate,  bool isVerified,  bool profileCompleted,  DateTime createdAt,  String? username,  String? displayName,  String? avatarMediaId,  String? avatarUrl,  String? bio,  String? website,  String? pronouns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
return $default(_that.id,_that.email,_that.isPrivate,_that.isVerified,_that.profileCompleted,_that.createdAt,_that.username,_that.displayName,_that.avatarMediaId,_that.avatarUrl,_that.bio,_that.website,_that.pronouns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  bool isPrivate,  bool isVerified,  bool profileCompleted,  DateTime createdAt,  String? username,  String? displayName,  String? avatarMediaId,  String? avatarUrl,  String? bio,  String? website,  String? pronouns)  $default,) {final _that = this;
switch (_that) {
case _MeProfile():
return $default(_that.id,_that.email,_that.isPrivate,_that.isVerified,_that.profileCompleted,_that.createdAt,_that.username,_that.displayName,_that.avatarMediaId,_that.avatarUrl,_that.bio,_that.website,_that.pronouns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  bool isPrivate,  bool isVerified,  bool profileCompleted,  DateTime createdAt,  String? username,  String? displayName,  String? avatarMediaId,  String? avatarUrl,  String? bio,  String? website,  String? pronouns)?  $default,) {final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
return $default(_that.id,_that.email,_that.isPrivate,_that.isVerified,_that.profileCompleted,_that.createdAt,_that.username,_that.displayName,_that.avatarMediaId,_that.avatarUrl,_that.bio,_that.website,_that.pronouns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeProfile implements MeProfile {
  const _MeProfile({required this.id, required this.email, required this.isPrivate, required this.isVerified, required this.profileCompleted, required this.createdAt, this.username, this.displayName, this.avatarMediaId, this.avatarUrl, this.bio, this.website, this.pronouns});
  factory _MeProfile.fromJson(Map<String, dynamic> json) => _$MeProfileFromJson(json);

@override final  String id;
@override final  String email;
@override final  bool isPrivate;
@override final  bool isVerified;
@override final  bool profileCompleted;
@override final  DateTime createdAt;
@override final  String? username;
@override final  String? displayName;
@override final  String? avatarMediaId;
@override final  String? avatarUrl;
@override final  String? bio;
@override final  String? website;
@override final  String? pronouns;

/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeProfileCopyWith<_MeProfile> get copyWith => __$MeProfileCopyWithImpl<_MeProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarMediaId, avatarMediaId) || other.avatarMediaId == avatarMediaId)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.website, website) || other.website == website)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,isPrivate,isVerified,profileCompleted,createdAt,username,displayName,avatarMediaId,avatarUrl,bio,website,pronouns);

@override
String toString() {
  return 'MeProfile(id: $id, email: $email, isPrivate: $isPrivate, isVerified: $isVerified, profileCompleted: $profileCompleted, createdAt: $createdAt, username: $username, displayName: $displayName, avatarMediaId: $avatarMediaId, avatarUrl: $avatarUrl, bio: $bio, website: $website, pronouns: $pronouns)';
}


}

/// @nodoc
abstract mixin class _$MeProfileCopyWith<$Res> implements $MeProfileCopyWith<$Res> {
  factory _$MeProfileCopyWith(_MeProfile value, $Res Function(_MeProfile) _then) = __$MeProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, bool isPrivate, bool isVerified, bool profileCompleted, DateTime createdAt, String? username, String? displayName, String? avatarMediaId, String? avatarUrl, String? bio, String? website, String? pronouns
});




}
/// @nodoc
class __$MeProfileCopyWithImpl<$Res>
    implements _$MeProfileCopyWith<$Res> {
  __$MeProfileCopyWithImpl(this._self, this._then);

  final _MeProfile _self;
  final $Res Function(_MeProfile) _then;

/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? isPrivate = null,Object? isVerified = null,Object? profileCompleted = null,Object? createdAt = null,Object? username = freezed,Object? displayName = freezed,Object? avatarMediaId = freezed,Object? avatarUrl = freezed,Object? bio = freezed,Object? website = freezed,Object? pronouns = freezed,}) {
  return _then(_MeProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarMediaId: freezed == avatarMediaId ? _self.avatarMediaId : avatarMediaId // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,pronouns: freezed == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
