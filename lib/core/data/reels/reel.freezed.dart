// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reel {

 String get id; UserSummary get author; Media get video; List<String> get hashtags; List<UserSummary> get taggedUsers; bool get commentsDisabled; int get likeCount; int get saveCount; int get commentCount; bool get viewerHasLiked; bool get viewerHasSaved; bool get isVideoReady; DateTime get createdAt; String? get caption; Place? get location;
/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelCopyWith<Reel> get copyWith => _$ReelCopyWithImpl<Reel>(this as Reel, _$identity);

  /// Serializes this Reel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reel&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.video, video) || other.video == video)&&const DeepCollectionEquality().equals(other.hashtags, hashtags)&&const DeepCollectionEquality().equals(other.taggedUsers, taggedUsers)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.viewerHasSaved, viewerHasSaved) || other.viewerHasSaved == viewerHasSaved)&&(identical(other.isVideoReady, isVideoReady) || other.isVideoReady == isVideoReady)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,video,const DeepCollectionEquality().hash(hashtags),const DeepCollectionEquality().hash(taggedUsers),commentsDisabled,likeCount,saveCount,commentCount,viewerHasLiked,viewerHasSaved,isVideoReady,createdAt,caption,location);

@override
String toString() {
  return 'Reel(id: $id, author: $author, video: $video, hashtags: $hashtags, taggedUsers: $taggedUsers, commentsDisabled: $commentsDisabled, likeCount: $likeCount, saveCount: $saveCount, commentCount: $commentCount, viewerHasLiked: $viewerHasLiked, viewerHasSaved: $viewerHasSaved, isVideoReady: $isVideoReady, createdAt: $createdAt, caption: $caption, location: $location)';
}


}

/// @nodoc
abstract mixin class $ReelCopyWith<$Res>  {
  factory $ReelCopyWith(Reel value, $Res Function(Reel) _then) = _$ReelCopyWithImpl;
@useResult
$Res call({
 String id, UserSummary author, Media video, List<String> hashtags, List<UserSummary> taggedUsers, bool commentsDisabled, int likeCount, int saveCount, int commentCount, bool viewerHasLiked, bool viewerHasSaved, bool isVideoReady, DateTime createdAt, String? caption, Place? location
});


$UserSummaryCopyWith<$Res> get author;$MediaCopyWith<$Res> get video;$PlaceCopyWith<$Res>? get location;

}
/// @nodoc
class _$ReelCopyWithImpl<$Res>
    implements $ReelCopyWith<$Res> {
  _$ReelCopyWithImpl(this._self, this._then);

  final Reel _self;
  final $Res Function(Reel) _then;

/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? video = null,Object? hashtags = null,Object? taggedUsers = null,Object? commentsDisabled = null,Object? likeCount = null,Object? saveCount = null,Object? commentCount = null,Object? viewerHasLiked = null,Object? viewerHasSaved = null,Object? isVideoReady = null,Object? createdAt = null,Object? caption = freezed,Object? location = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserSummary,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as Media,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,taggedUsers: null == taggedUsers ? _self.taggedUsers : taggedUsers // ignore: cast_nullable_to_non_nullable
as List<UserSummary>,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,viewerHasSaved: null == viewerHasSaved ? _self.viewerHasSaved : viewerHasSaved // ignore: cast_nullable_to_non_nullable
as bool,isVideoReady: null == isVideoReady ? _self.isVideoReady : isVideoReady // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Place?,
  ));
}
/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get author {
  
  return $UserSummaryCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res> get video {
  
  return $MediaCopyWith<$Res>(_self.video, (value) {
    return _then(_self.copyWith(video: value));
  });
}/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $PlaceCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [Reel].
extension ReelPatterns on Reel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reel value)  $default,){
final _that = this;
switch (_that) {
case _Reel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reel value)?  $default,){
final _that = this;
switch (_that) {
case _Reel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UserSummary author,  Media video,  List<String> hashtags,  List<UserSummary> taggedUsers,  bool commentsDisabled,  int likeCount,  int saveCount,  int commentCount,  bool viewerHasLiked,  bool viewerHasSaved,  bool isVideoReady,  DateTime createdAt,  String? caption,  Place? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reel() when $default != null:
return $default(_that.id,_that.author,_that.video,_that.hashtags,_that.taggedUsers,_that.commentsDisabled,_that.likeCount,_that.saveCount,_that.commentCount,_that.viewerHasLiked,_that.viewerHasSaved,_that.isVideoReady,_that.createdAt,_that.caption,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UserSummary author,  Media video,  List<String> hashtags,  List<UserSummary> taggedUsers,  bool commentsDisabled,  int likeCount,  int saveCount,  int commentCount,  bool viewerHasLiked,  bool viewerHasSaved,  bool isVideoReady,  DateTime createdAt,  String? caption,  Place? location)  $default,) {final _that = this;
switch (_that) {
case _Reel():
return $default(_that.id,_that.author,_that.video,_that.hashtags,_that.taggedUsers,_that.commentsDisabled,_that.likeCount,_that.saveCount,_that.commentCount,_that.viewerHasLiked,_that.viewerHasSaved,_that.isVideoReady,_that.createdAt,_that.caption,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UserSummary author,  Media video,  List<String> hashtags,  List<UserSummary> taggedUsers,  bool commentsDisabled,  int likeCount,  int saveCount,  int commentCount,  bool viewerHasLiked,  bool viewerHasSaved,  bool isVideoReady,  DateTime createdAt,  String? caption,  Place? location)?  $default,) {final _that = this;
switch (_that) {
case _Reel() when $default != null:
return $default(_that.id,_that.author,_that.video,_that.hashtags,_that.taggedUsers,_that.commentsDisabled,_that.likeCount,_that.saveCount,_that.commentCount,_that.viewerHasLiked,_that.viewerHasSaved,_that.isVideoReady,_that.createdAt,_that.caption,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reel extends Reel {
  const _Reel({required this.id, required this.author, required this.video, required final  List<String> hashtags, required final  List<UserSummary> taggedUsers, required this.commentsDisabled, required this.likeCount, required this.saveCount, required this.commentCount, required this.viewerHasLiked, required this.viewerHasSaved, required this.isVideoReady, required this.createdAt, this.caption, this.location}): _hashtags = hashtags,_taggedUsers = taggedUsers,super._();
  factory _Reel.fromJson(Map<String, dynamic> json) => _$ReelFromJson(json);

@override final  String id;
@override final  UserSummary author;
@override final  Media video;
 final  List<String> _hashtags;
@override List<String> get hashtags {
  if (_hashtags is EqualUnmodifiableListView) return _hashtags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hashtags);
}

 final  List<UserSummary> _taggedUsers;
@override List<UserSummary> get taggedUsers {
  if (_taggedUsers is EqualUnmodifiableListView) return _taggedUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taggedUsers);
}

@override final  bool commentsDisabled;
@override final  int likeCount;
@override final  int saveCount;
@override final  int commentCount;
@override final  bool viewerHasLiked;
@override final  bool viewerHasSaved;
@override final  bool isVideoReady;
@override final  DateTime createdAt;
@override final  String? caption;
@override final  Place? location;

/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReelCopyWith<_Reel> get copyWith => __$ReelCopyWithImpl<_Reel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reel&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.video, video) || other.video == video)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags)&&const DeepCollectionEquality().equals(other._taggedUsers, _taggedUsers)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.viewerHasSaved, viewerHasSaved) || other.viewerHasSaved == viewerHasSaved)&&(identical(other.isVideoReady, isVideoReady) || other.isVideoReady == isVideoReady)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,video,const DeepCollectionEquality().hash(_hashtags),const DeepCollectionEquality().hash(_taggedUsers),commentsDisabled,likeCount,saveCount,commentCount,viewerHasLiked,viewerHasSaved,isVideoReady,createdAt,caption,location);

@override
String toString() {
  return 'Reel(id: $id, author: $author, video: $video, hashtags: $hashtags, taggedUsers: $taggedUsers, commentsDisabled: $commentsDisabled, likeCount: $likeCount, saveCount: $saveCount, commentCount: $commentCount, viewerHasLiked: $viewerHasLiked, viewerHasSaved: $viewerHasSaved, isVideoReady: $isVideoReady, createdAt: $createdAt, caption: $caption, location: $location)';
}


}

/// @nodoc
abstract mixin class _$ReelCopyWith<$Res> implements $ReelCopyWith<$Res> {
  factory _$ReelCopyWith(_Reel value, $Res Function(_Reel) _then) = __$ReelCopyWithImpl;
@override @useResult
$Res call({
 String id, UserSummary author, Media video, List<String> hashtags, List<UserSummary> taggedUsers, bool commentsDisabled, int likeCount, int saveCount, int commentCount, bool viewerHasLiked, bool viewerHasSaved, bool isVideoReady, DateTime createdAt, String? caption, Place? location
});


@override $UserSummaryCopyWith<$Res> get author;@override $MediaCopyWith<$Res> get video;@override $PlaceCopyWith<$Res>? get location;

}
/// @nodoc
class __$ReelCopyWithImpl<$Res>
    implements _$ReelCopyWith<$Res> {
  __$ReelCopyWithImpl(this._self, this._then);

  final _Reel _self;
  final $Res Function(_Reel) _then;

/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? video = null,Object? hashtags = null,Object? taggedUsers = null,Object? commentsDisabled = null,Object? likeCount = null,Object? saveCount = null,Object? commentCount = null,Object? viewerHasLiked = null,Object? viewerHasSaved = null,Object? isVideoReady = null,Object? createdAt = null,Object? caption = freezed,Object? location = freezed,}) {
  return _then(_Reel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserSummary,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as Media,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,taggedUsers: null == taggedUsers ? _self._taggedUsers : taggedUsers // ignore: cast_nullable_to_non_nullable
as List<UserSummary>,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,viewerHasSaved: null == viewerHasSaved ? _self.viewerHasSaved : viewerHasSaved // ignore: cast_nullable_to_non_nullable
as bool,isVideoReady: null == isVideoReady ? _self.isVideoReady : isVideoReady // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Place?,
  ));
}

/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get author {
  
  return $UserSummaryCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res> get video {
  
  return $MediaCopyWith<$Res>(_self.video, (value) {
    return _then(_self.copyWith(video: value));
  });
}/// Create a copy of Reel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $PlaceCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
