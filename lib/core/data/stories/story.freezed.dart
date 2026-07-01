// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StorySegment {

 String get id; String get authorId; String get imageUrl; int get durationMs; int get position; DateTime get createdAt; bool get viewerHasLiked;
/// Create a copy of StorySegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorySegmentCopyWith<StorySegment> get copyWith => _$StorySegmentCopyWithImpl<StorySegment>(this as StorySegment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorySegment&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked));
}


@override
int get hashCode => Object.hash(runtimeType,id,authorId,imageUrl,durationMs,position,createdAt,viewerHasLiked);

@override
String toString() {
  return 'StorySegment(id: $id, authorId: $authorId, imageUrl: $imageUrl, durationMs: $durationMs, position: $position, createdAt: $createdAt, viewerHasLiked: $viewerHasLiked)';
}


}

/// @nodoc
abstract mixin class $StorySegmentCopyWith<$Res>  {
  factory $StorySegmentCopyWith(StorySegment value, $Res Function(StorySegment) _then) = _$StorySegmentCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, String imageUrl, int durationMs, int position, DateTime createdAt, bool viewerHasLiked
});




}
/// @nodoc
class _$StorySegmentCopyWithImpl<$Res>
    implements $StorySegmentCopyWith<$Res> {
  _$StorySegmentCopyWithImpl(this._self, this._then);

  final StorySegment _self;
  final $Res Function(StorySegment) _then;

/// Create a copy of StorySegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? imageUrl = null,Object? durationMs = null,Object? position = null,Object? createdAt = null,Object? viewerHasLiked = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorySegment].
extension StorySegmentPatterns on StorySegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorySegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorySegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorySegment value)  $default,){
final _that = this;
switch (_that) {
case _StorySegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorySegment value)?  $default,){
final _that = this;
switch (_that) {
case _StorySegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  String imageUrl,  int durationMs,  int position,  DateTime createdAt,  bool viewerHasLiked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorySegment() when $default != null:
return $default(_that.id,_that.authorId,_that.imageUrl,_that.durationMs,_that.position,_that.createdAt,_that.viewerHasLiked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  String imageUrl,  int durationMs,  int position,  DateTime createdAt,  bool viewerHasLiked)  $default,) {final _that = this;
switch (_that) {
case _StorySegment():
return $default(_that.id,_that.authorId,_that.imageUrl,_that.durationMs,_that.position,_that.createdAt,_that.viewerHasLiked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  String imageUrl,  int durationMs,  int position,  DateTime createdAt,  bool viewerHasLiked)?  $default,) {final _that = this;
switch (_that) {
case _StorySegment() when $default != null:
return $default(_that.id,_that.authorId,_that.imageUrl,_that.durationMs,_that.position,_that.createdAt,_that.viewerHasLiked);case _:
  return null;

}
}

}

/// @nodoc


class _StorySegment implements StorySegment {
  const _StorySegment({required this.id, required this.authorId, required this.imageUrl, required this.durationMs, required this.position, required this.createdAt, this.viewerHasLiked = false});
  

@override final  String id;
@override final  String authorId;
@override final  String imageUrl;
@override final  int durationMs;
@override final  int position;
@override final  DateTime createdAt;
@override@JsonKey() final  bool viewerHasLiked;

/// Create a copy of StorySegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorySegmentCopyWith<_StorySegment> get copyWith => __$StorySegmentCopyWithImpl<_StorySegment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorySegment&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked));
}


@override
int get hashCode => Object.hash(runtimeType,id,authorId,imageUrl,durationMs,position,createdAt,viewerHasLiked);

@override
String toString() {
  return 'StorySegment(id: $id, authorId: $authorId, imageUrl: $imageUrl, durationMs: $durationMs, position: $position, createdAt: $createdAt, viewerHasLiked: $viewerHasLiked)';
}


}

/// @nodoc
abstract mixin class _$StorySegmentCopyWith<$Res> implements $StorySegmentCopyWith<$Res> {
  factory _$StorySegmentCopyWith(_StorySegment value, $Res Function(_StorySegment) _then) = __$StorySegmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, String imageUrl, int durationMs, int position, DateTime createdAt, bool viewerHasLiked
});




}
/// @nodoc
class __$StorySegmentCopyWithImpl<$Res>
    implements _$StorySegmentCopyWith<$Res> {
  __$StorySegmentCopyWithImpl(this._self, this._then);

  final _StorySegment _self;
  final $Res Function(_StorySegment) _then;

/// Create a copy of StorySegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? imageUrl = null,Object? durationMs = null,Object? position = null,Object? createdAt = null,Object? viewerHasLiked = null,}) {
  return _then(_StorySegment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$StoryReel {

 String get authorId; String get username; List<StorySegment> get segments; bool get hasUnseen; DateTime get latestAt; String? get avatarUrl; bool get isYou;
/// Create a copy of StoryReel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryReelCopyWith<StoryReel> get copyWith => _$StoryReelCopyWithImpl<StoryReel>(this as StoryReel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryReel&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.username, username) || other.username == username)&&const DeepCollectionEquality().equals(other.segments, segments)&&(identical(other.hasUnseen, hasUnseen) || other.hasUnseen == hasUnseen)&&(identical(other.latestAt, latestAt) || other.latestAt == latestAt)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isYou, isYou) || other.isYou == isYou));
}


@override
int get hashCode => Object.hash(runtimeType,authorId,username,const DeepCollectionEquality().hash(segments),hasUnseen,latestAt,avatarUrl,isYou);

@override
String toString() {
  return 'StoryReel(authorId: $authorId, username: $username, segments: $segments, hasUnseen: $hasUnseen, latestAt: $latestAt, avatarUrl: $avatarUrl, isYou: $isYou)';
}


}

/// @nodoc
abstract mixin class $StoryReelCopyWith<$Res>  {
  factory $StoryReelCopyWith(StoryReel value, $Res Function(StoryReel) _then) = _$StoryReelCopyWithImpl;
@useResult
$Res call({
 String authorId, String username, List<StorySegment> segments, bool hasUnseen, DateTime latestAt, String? avatarUrl, bool isYou
});




}
/// @nodoc
class _$StoryReelCopyWithImpl<$Res>
    implements $StoryReelCopyWith<$Res> {
  _$StoryReelCopyWithImpl(this._self, this._then);

  final StoryReel _self;
  final $Res Function(StoryReel) _then;

/// Create a copy of StoryReel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authorId = null,Object? username = null,Object? segments = null,Object? hasUnseen = null,Object? latestAt = null,Object? avatarUrl = freezed,Object? isYou = null,}) {
  return _then(_self.copyWith(
authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<StorySegment>,hasUnseen: null == hasUnseen ? _self.hasUnseen : hasUnseen // ignore: cast_nullable_to_non_nullable
as bool,latestAt: null == latestAt ? _self.latestAt : latestAt // ignore: cast_nullable_to_non_nullable
as DateTime,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isYou: null == isYou ? _self.isYou : isYou // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryReel].
extension StoryReelPatterns on StoryReel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryReel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryReel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryReel value)  $default,){
final _that = this;
switch (_that) {
case _StoryReel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryReel value)?  $default,){
final _that = this;
switch (_that) {
case _StoryReel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authorId,  String username,  List<StorySegment> segments,  bool hasUnseen,  DateTime latestAt,  String? avatarUrl,  bool isYou)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryReel() when $default != null:
return $default(_that.authorId,_that.username,_that.segments,_that.hasUnseen,_that.latestAt,_that.avatarUrl,_that.isYou);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authorId,  String username,  List<StorySegment> segments,  bool hasUnseen,  DateTime latestAt,  String? avatarUrl,  bool isYou)  $default,) {final _that = this;
switch (_that) {
case _StoryReel():
return $default(_that.authorId,_that.username,_that.segments,_that.hasUnseen,_that.latestAt,_that.avatarUrl,_that.isYou);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authorId,  String username,  List<StorySegment> segments,  bool hasUnseen,  DateTime latestAt,  String? avatarUrl,  bool isYou)?  $default,) {final _that = this;
switch (_that) {
case _StoryReel() when $default != null:
return $default(_that.authorId,_that.username,_that.segments,_that.hasUnseen,_that.latestAt,_that.avatarUrl,_that.isYou);case _:
  return null;

}
}

}

/// @nodoc


class _StoryReel implements StoryReel {
  const _StoryReel({required this.authorId, required this.username, required final  List<StorySegment> segments, required this.hasUnseen, required this.latestAt, this.avatarUrl, this.isYou = false}): _segments = segments;
  

@override final  String authorId;
@override final  String username;
 final  List<StorySegment> _segments;
@override List<StorySegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

@override final  bool hasUnseen;
@override final  DateTime latestAt;
@override final  String? avatarUrl;
@override@JsonKey() final  bool isYou;

/// Create a copy of StoryReel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryReelCopyWith<_StoryReel> get copyWith => __$StoryReelCopyWithImpl<_StoryReel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryReel&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.username, username) || other.username == username)&&const DeepCollectionEquality().equals(other._segments, _segments)&&(identical(other.hasUnseen, hasUnseen) || other.hasUnseen == hasUnseen)&&(identical(other.latestAt, latestAt) || other.latestAt == latestAt)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isYou, isYou) || other.isYou == isYou));
}


@override
int get hashCode => Object.hash(runtimeType,authorId,username,const DeepCollectionEquality().hash(_segments),hasUnseen,latestAt,avatarUrl,isYou);

@override
String toString() {
  return 'StoryReel(authorId: $authorId, username: $username, segments: $segments, hasUnseen: $hasUnseen, latestAt: $latestAt, avatarUrl: $avatarUrl, isYou: $isYou)';
}


}

/// @nodoc
abstract mixin class _$StoryReelCopyWith<$Res> implements $StoryReelCopyWith<$Res> {
  factory _$StoryReelCopyWith(_StoryReel value, $Res Function(_StoryReel) _then) = __$StoryReelCopyWithImpl;
@override @useResult
$Res call({
 String authorId, String username, List<StorySegment> segments, bool hasUnseen, DateTime latestAt, String? avatarUrl, bool isYou
});




}
/// @nodoc
class __$StoryReelCopyWithImpl<$Res>
    implements _$StoryReelCopyWith<$Res> {
  __$StoryReelCopyWithImpl(this._self, this._then);

  final _StoryReel _self;
  final $Res Function(_StoryReel) _then;

/// Create a copy of StoryReel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authorId = null,Object? username = null,Object? segments = null,Object? hasUnseen = null,Object? latestAt = null,Object? avatarUrl = freezed,Object? isYou = null,}) {
  return _then(_StoryReel(
authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<StorySegment>,hasUnseen: null == hasUnseen ? _self.hasUnseen : hasUnseen // ignore: cast_nullable_to_non_nullable
as bool,latestAt: null == latestAt ? _self.latestAt : latestAt // ignore: cast_nullable_to_non_nullable
as DateTime,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isYou: null == isYou ? _self.isYou : isYou // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
