// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewerRelationship {

 bool get following; bool get requested; bool get followsYou; bool get blocking;
/// Create a copy of ViewerRelationship
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewerRelationshipCopyWith<ViewerRelationship> get copyWith => _$ViewerRelationshipCopyWithImpl<ViewerRelationship>(this as ViewerRelationship, _$identity);

  /// Serializes this ViewerRelationship to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewerRelationship&&(identical(other.following, following) || other.following == following)&&(identical(other.requested, requested) || other.requested == requested)&&(identical(other.followsYou, followsYou) || other.followsYou == followsYou)&&(identical(other.blocking, blocking) || other.blocking == blocking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,following,requested,followsYou,blocking);

@override
String toString() {
  return 'ViewerRelationship(following: $following, requested: $requested, followsYou: $followsYou, blocking: $blocking)';
}


}

/// @nodoc
abstract mixin class $ViewerRelationshipCopyWith<$Res>  {
  factory $ViewerRelationshipCopyWith(ViewerRelationship value, $Res Function(ViewerRelationship) _then) = _$ViewerRelationshipCopyWithImpl;
@useResult
$Res call({
 bool following, bool requested, bool followsYou, bool blocking
});




}
/// @nodoc
class _$ViewerRelationshipCopyWithImpl<$Res>
    implements $ViewerRelationshipCopyWith<$Res> {
  _$ViewerRelationshipCopyWithImpl(this._self, this._then);

  final ViewerRelationship _self;
  final $Res Function(ViewerRelationship) _then;

/// Create a copy of ViewerRelationship
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? following = null,Object? requested = null,Object? followsYou = null,Object? blocking = null,}) {
  return _then(_self.copyWith(
following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as bool,requested: null == requested ? _self.requested : requested // ignore: cast_nullable_to_non_nullable
as bool,followsYou: null == followsYou ? _self.followsYou : followsYou // ignore: cast_nullable_to_non_nullable
as bool,blocking: null == blocking ? _self.blocking : blocking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ViewerRelationship].
extension ViewerRelationshipPatterns on ViewerRelationship {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewerRelationship value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewerRelationship() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewerRelationship value)  $default,){
final _that = this;
switch (_that) {
case _ViewerRelationship():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewerRelationship value)?  $default,){
final _that = this;
switch (_that) {
case _ViewerRelationship() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool following,  bool requested,  bool followsYou,  bool blocking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewerRelationship() when $default != null:
return $default(_that.following,_that.requested,_that.followsYou,_that.blocking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool following,  bool requested,  bool followsYou,  bool blocking)  $default,) {final _that = this;
switch (_that) {
case _ViewerRelationship():
return $default(_that.following,_that.requested,_that.followsYou,_that.blocking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool following,  bool requested,  bool followsYou,  bool blocking)?  $default,) {final _that = this;
switch (_that) {
case _ViewerRelationship() when $default != null:
return $default(_that.following,_that.requested,_that.followsYou,_that.blocking);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ViewerRelationship extends ViewerRelationship {
  const _ViewerRelationship({required this.following, required this.requested, required this.followsYou, required this.blocking}): super._();
  factory _ViewerRelationship.fromJson(Map<String, dynamic> json) => _$ViewerRelationshipFromJson(json);

@override final  bool following;
@override final  bool requested;
@override final  bool followsYou;
@override final  bool blocking;

/// Create a copy of ViewerRelationship
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewerRelationshipCopyWith<_ViewerRelationship> get copyWith => __$ViewerRelationshipCopyWithImpl<_ViewerRelationship>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViewerRelationshipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewerRelationship&&(identical(other.following, following) || other.following == following)&&(identical(other.requested, requested) || other.requested == requested)&&(identical(other.followsYou, followsYou) || other.followsYou == followsYou)&&(identical(other.blocking, blocking) || other.blocking == blocking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,following,requested,followsYou,blocking);

@override
String toString() {
  return 'ViewerRelationship(following: $following, requested: $requested, followsYou: $followsYou, blocking: $blocking)';
}


}

/// @nodoc
abstract mixin class _$ViewerRelationshipCopyWith<$Res> implements $ViewerRelationshipCopyWith<$Res> {
  factory _$ViewerRelationshipCopyWith(_ViewerRelationship value, $Res Function(_ViewerRelationship) _then) = __$ViewerRelationshipCopyWithImpl;
@override @useResult
$Res call({
 bool following, bool requested, bool followsYou, bool blocking
});




}
/// @nodoc
class __$ViewerRelationshipCopyWithImpl<$Res>
    implements _$ViewerRelationshipCopyWith<$Res> {
  __$ViewerRelationshipCopyWithImpl(this._self, this._then);

  final _ViewerRelationship _self;
  final $Res Function(_ViewerRelationship) _then;

/// Create a copy of ViewerRelationship
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? following = null,Object? requested = null,Object? followsYou = null,Object? blocking = null,}) {
  return _then(_ViewerRelationship(
following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as bool,requested: null == requested ? _self.requested : requested // ignore: cast_nullable_to_non_nullable
as bool,followsYou: null == followsYou ? _self.followsYou : followsYou // ignore: cast_nullable_to_non_nullable
as bool,blocking: null == blocking ? _self.blocking : blocking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AccountResult {

 UserSummary get user; ViewerRelationship get relationship;
/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountResultCopyWith<AccountResult> get copyWith => _$AccountResultCopyWithImpl<AccountResult>(this as AccountResult, _$identity);

  /// Serializes this AccountResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountResult&&(identical(other.user, user) || other.user == user)&&(identical(other.relationship, relationship) || other.relationship == relationship));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,relationship);

@override
String toString() {
  return 'AccountResult(user: $user, relationship: $relationship)';
}


}

/// @nodoc
abstract mixin class $AccountResultCopyWith<$Res>  {
  factory $AccountResultCopyWith(AccountResult value, $Res Function(AccountResult) _then) = _$AccountResultCopyWithImpl;
@useResult
$Res call({
 UserSummary user, ViewerRelationship relationship
});


$UserSummaryCopyWith<$Res> get user;$ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class _$AccountResultCopyWithImpl<$Res>
    implements $AccountResultCopyWith<$Res> {
  _$AccountResultCopyWithImpl(this._self, this._then);

  final AccountResult _self;
  final $Res Function(AccountResult) _then;

/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? relationship = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserSummary,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,
  ));
}
/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get user {
  
  return $UserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewerRelationshipCopyWith<$Res> get relationship {
  
  return $ViewerRelationshipCopyWith<$Res>(_self.relationship, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountResult].
extension AccountResultPatterns on AccountResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountResult value)  $default,){
final _that = this;
switch (_that) {
case _AccountResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountResult value)?  $default,){
final _that = this;
switch (_that) {
case _AccountResult() when $default != null:
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
case _AccountResult() when $default != null:
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
case _AccountResult():
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
case _AccountResult() when $default != null:
return $default(_that.user,_that.relationship);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountResult implements AccountResult {
  const _AccountResult({required this.user, required this.relationship});
  factory _AccountResult.fromJson(Map<String, dynamic> json) => _$AccountResultFromJson(json);

@override final  UserSummary user;
@override final  ViewerRelationship relationship;

/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountResultCopyWith<_AccountResult> get copyWith => __$AccountResultCopyWithImpl<_AccountResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountResult&&(identical(other.user, user) || other.user == user)&&(identical(other.relationship, relationship) || other.relationship == relationship));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,relationship);

@override
String toString() {
  return 'AccountResult(user: $user, relationship: $relationship)';
}


}

/// @nodoc
abstract mixin class _$AccountResultCopyWith<$Res> implements $AccountResultCopyWith<$Res> {
  factory _$AccountResultCopyWith(_AccountResult value, $Res Function(_AccountResult) _then) = __$AccountResultCopyWithImpl;
@override @useResult
$Res call({
 UserSummary user, ViewerRelationship relationship
});


@override $UserSummaryCopyWith<$Res> get user;@override $ViewerRelationshipCopyWith<$Res> get relationship;

}
/// @nodoc
class __$AccountResultCopyWithImpl<$Res>
    implements _$AccountResultCopyWith<$Res> {
  __$AccountResultCopyWithImpl(this._self, this._then);

  final _AccountResult _self;
  final $Res Function(_AccountResult) _then;

/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? relationship = null,}) {
  return _then(_AccountResult(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserSummary,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as ViewerRelationship,
  ));
}

/// Create a copy of AccountResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get user {
  
  return $UserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AccountResult
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
mixin _$HashtagResult {

 String get tag; int get postCount;
/// Create a copy of HashtagResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HashtagResultCopyWith<HashtagResult> get copyWith => _$HashtagResultCopyWithImpl<HashtagResult>(this as HashtagResult, _$identity);

  /// Serializes this HashtagResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HashtagResult&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.postCount, postCount) || other.postCount == postCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,postCount);

@override
String toString() {
  return 'HashtagResult(tag: $tag, postCount: $postCount)';
}


}

/// @nodoc
abstract mixin class $HashtagResultCopyWith<$Res>  {
  factory $HashtagResultCopyWith(HashtagResult value, $Res Function(HashtagResult) _then) = _$HashtagResultCopyWithImpl;
@useResult
$Res call({
 String tag, int postCount
});




}
/// @nodoc
class _$HashtagResultCopyWithImpl<$Res>
    implements $HashtagResultCopyWith<$Res> {
  _$HashtagResultCopyWithImpl(this._self, this._then);

  final HashtagResult _self;
  final $Res Function(HashtagResult) _then;

/// Create a copy of HashtagResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,Object? postCount = null,}) {
  return _then(_self.copyWith(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HashtagResult].
extension HashtagResultPatterns on HashtagResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HashtagResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HashtagResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HashtagResult value)  $default,){
final _that = this;
switch (_that) {
case _HashtagResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HashtagResult value)?  $default,){
final _that = this;
switch (_that) {
case _HashtagResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tag,  int postCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HashtagResult() when $default != null:
return $default(_that.tag,_that.postCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tag,  int postCount)  $default,) {final _that = this;
switch (_that) {
case _HashtagResult():
return $default(_that.tag,_that.postCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tag,  int postCount)?  $default,) {final _that = this;
switch (_that) {
case _HashtagResult() when $default != null:
return $default(_that.tag,_that.postCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HashtagResult implements HashtagResult {
  const _HashtagResult({required this.tag, required this.postCount});
  factory _HashtagResult.fromJson(Map<String, dynamic> json) => _$HashtagResultFromJson(json);

@override final  String tag;
@override final  int postCount;

/// Create a copy of HashtagResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HashtagResultCopyWith<_HashtagResult> get copyWith => __$HashtagResultCopyWithImpl<_HashtagResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HashtagResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HashtagResult&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.postCount, postCount) || other.postCount == postCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,postCount);

@override
String toString() {
  return 'HashtagResult(tag: $tag, postCount: $postCount)';
}


}

/// @nodoc
abstract mixin class _$HashtagResultCopyWith<$Res> implements $HashtagResultCopyWith<$Res> {
  factory _$HashtagResultCopyWith(_HashtagResult value, $Res Function(_HashtagResult) _then) = __$HashtagResultCopyWithImpl;
@override @useResult
$Res call({
 String tag, int postCount
});




}
/// @nodoc
class __$HashtagResultCopyWithImpl<$Res>
    implements _$HashtagResultCopyWith<$Res> {
  __$HashtagResultCopyWithImpl(this._self, this._then);

  final _HashtagResult _self;
  final $Res Function(_HashtagResult) _then;

/// Create a copy of HashtagResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,Object? postCount = null,}) {
  return _then(_HashtagResult(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PlaceResult {

 String get id; String get name; double? get lat; double? get lng;
/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceResultCopyWith<PlaceResult> get copyWith => _$PlaceResultCopyWithImpl<PlaceResult>(this as PlaceResult, _$identity);

  /// Serializes this PlaceResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceResult&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng);

@override
String toString() {
  return 'PlaceResult(id: $id, name: $name, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $PlaceResultCopyWith<$Res>  {
  factory $PlaceResultCopyWith(PlaceResult value, $Res Function(PlaceResult) _then) = _$PlaceResultCopyWithImpl;
@useResult
$Res call({
 String id, String name, double? lat, double? lng
});




}
/// @nodoc
class _$PlaceResultCopyWithImpl<$Res>
    implements $PlaceResultCopyWith<$Res> {
  _$PlaceResultCopyWithImpl(this._self, this._then);

  final PlaceResult _self;
  final $Res Function(PlaceResult) _then;

/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaceResult].
extension PlaceResultPatterns on PlaceResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceResult value)  $default,){
final _that = this;
switch (_that) {
case _PlaceResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceResult value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double? lat,  double? lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double? lat,  double? lng)  $default,) {final _that = this;
switch (_that) {
case _PlaceResult():
return $default(_that.id,_that.name,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double? lat,  double? lng)?  $default,) {final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaceResult implements PlaceResult {
  const _PlaceResult({required this.id, required this.name, this.lat, this.lng});
  factory _PlaceResult.fromJson(Map<String, dynamic> json) => _$PlaceResultFromJson(json);

@override final  String id;
@override final  String name;
@override final  double? lat;
@override final  double? lng;

/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceResultCopyWith<_PlaceResult> get copyWith => __$PlaceResultCopyWithImpl<_PlaceResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceResult&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng);

@override
String toString() {
  return 'PlaceResult(id: $id, name: $name, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$PlaceResultCopyWith<$Res> implements $PlaceResultCopyWith<$Res> {
  factory _$PlaceResultCopyWith(_PlaceResult value, $Res Function(_PlaceResult) _then) = __$PlaceResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double? lat, double? lng
});




}
/// @nodoc
class __$PlaceResultCopyWithImpl<$Res>
    implements _$PlaceResultCopyWith<$Res> {
  __$PlaceResultCopyWithImpl(this._self, this._then);

  final _PlaceResult _self;
  final $Res Function(_PlaceResult) _then;

/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_PlaceResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$SearchTop {

 List<AccountResult> get accounts; List<HashtagResult> get hashtags; List<PlaceResult> get places;
/// Create a copy of SearchTop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchTopCopyWith<SearchTop> get copyWith => _$SearchTopCopyWithImpl<SearchTop>(this as SearchTop, _$identity);

  /// Serializes this SearchTop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchTop&&const DeepCollectionEquality().equals(other.accounts, accounts)&&const DeepCollectionEquality().equals(other.hashtags, hashtags)&&const DeepCollectionEquality().equals(other.places, places));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(accounts),const DeepCollectionEquality().hash(hashtags),const DeepCollectionEquality().hash(places));

@override
String toString() {
  return 'SearchTop(accounts: $accounts, hashtags: $hashtags, places: $places)';
}


}

/// @nodoc
abstract mixin class $SearchTopCopyWith<$Res>  {
  factory $SearchTopCopyWith(SearchTop value, $Res Function(SearchTop) _then) = _$SearchTopCopyWithImpl;
@useResult
$Res call({
 List<AccountResult> accounts, List<HashtagResult> hashtags, List<PlaceResult> places
});




}
/// @nodoc
class _$SearchTopCopyWithImpl<$Res>
    implements $SearchTopCopyWith<$Res> {
  _$SearchTopCopyWithImpl(this._self, this._then);

  final SearchTop _self;
  final $Res Function(SearchTop) _then;

/// Create a copy of SearchTop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accounts = null,Object? hashtags = null,Object? places = null,}) {
  return _then(_self.copyWith(
accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AccountResult>,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<HashtagResult>,places: null == places ? _self.places : places // ignore: cast_nullable_to_non_nullable
as List<PlaceResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchTop].
extension SearchTopPatterns on SearchTop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchTop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchTop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchTop value)  $default,){
final _that = this;
switch (_that) {
case _SearchTop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchTop value)?  $default,){
final _that = this;
switch (_that) {
case _SearchTop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AccountResult> accounts,  List<HashtagResult> hashtags,  List<PlaceResult> places)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchTop() when $default != null:
return $default(_that.accounts,_that.hashtags,_that.places);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AccountResult> accounts,  List<HashtagResult> hashtags,  List<PlaceResult> places)  $default,) {final _that = this;
switch (_that) {
case _SearchTop():
return $default(_that.accounts,_that.hashtags,_that.places);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AccountResult> accounts,  List<HashtagResult> hashtags,  List<PlaceResult> places)?  $default,) {final _that = this;
switch (_that) {
case _SearchTop() when $default != null:
return $default(_that.accounts,_that.hashtags,_that.places);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchTop extends SearchTop {
  const _SearchTop({required final  List<AccountResult> accounts, required final  List<HashtagResult> hashtags, required final  List<PlaceResult> places}): _accounts = accounts,_hashtags = hashtags,_places = places,super._();
  factory _SearchTop.fromJson(Map<String, dynamic> json) => _$SearchTopFromJson(json);

 final  List<AccountResult> _accounts;
@override List<AccountResult> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  List<HashtagResult> _hashtags;
@override List<HashtagResult> get hashtags {
  if (_hashtags is EqualUnmodifiableListView) return _hashtags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hashtags);
}

 final  List<PlaceResult> _places;
@override List<PlaceResult> get places {
  if (_places is EqualUnmodifiableListView) return _places;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_places);
}


/// Create a copy of SearchTop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchTopCopyWith<_SearchTop> get copyWith => __$SearchTopCopyWithImpl<_SearchTop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchTopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchTop&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags)&&const DeepCollectionEquality().equals(other._places, _places));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_hashtags),const DeepCollectionEquality().hash(_places));

@override
String toString() {
  return 'SearchTop(accounts: $accounts, hashtags: $hashtags, places: $places)';
}


}

/// @nodoc
abstract mixin class _$SearchTopCopyWith<$Res> implements $SearchTopCopyWith<$Res> {
  factory _$SearchTopCopyWith(_SearchTop value, $Res Function(_SearchTop) _then) = __$SearchTopCopyWithImpl;
@override @useResult
$Res call({
 List<AccountResult> accounts, List<HashtagResult> hashtags, List<PlaceResult> places
});




}
/// @nodoc
class __$SearchTopCopyWithImpl<$Res>
    implements _$SearchTopCopyWith<$Res> {
  __$SearchTopCopyWithImpl(this._self, this._then);

  final _SearchTop _self;
  final $Res Function(_SearchTop) _then;

/// Create a copy of SearchTop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accounts = null,Object? hashtags = null,Object? places = null,}) {
  return _then(_SearchTop(
accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AccountResult>,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<HashtagResult>,places: null == places ? _self._places : places // ignore: cast_nullable_to_non_nullable
as List<PlaceResult>,
  ));
}


}

// dart format on
