// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentAuthor {

 String get id; bool get isVerified; String? get username; String? get displayName; String? get avatarUrl;
/// Create a copy of CommentAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentAuthorCopyWith<CommentAuthor> get copyWith => _$CommentAuthorCopyWithImpl<CommentAuthor>(this as CommentAuthor, _$identity);

  /// Serializes this CommentAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isVerified,username,displayName,avatarUrl);

@override
String toString() {
  return 'CommentAuthor(id: $id, isVerified: $isVerified, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $CommentAuthorCopyWith<$Res>  {
  factory $CommentAuthorCopyWith(CommentAuthor value, $Res Function(CommentAuthor) _then) = _$CommentAuthorCopyWithImpl;
@useResult
$Res call({
 String id, bool isVerified, String? username, String? displayName, String? avatarUrl
});




}
/// @nodoc
class _$CommentAuthorCopyWithImpl<$Res>
    implements $CommentAuthorCopyWith<$Res> {
  _$CommentAuthorCopyWithImpl(this._self, this._then);

  final CommentAuthor _self;
  final $Res Function(CommentAuthor) _then;

/// Create a copy of CommentAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isVerified = null,Object? username = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentAuthor].
extension CommentAuthorPatterns on CommentAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentAuthor value)  $default,){
final _that = this;
switch (_that) {
case _CommentAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _CommentAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool isVerified,  String? username,  String? displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentAuthor() when $default != null:
return $default(_that.id,_that.isVerified,_that.username,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool isVerified,  String? username,  String? displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _CommentAuthor():
return $default(_that.id,_that.isVerified,_that.username,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool isVerified,  String? username,  String? displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _CommentAuthor() when $default != null:
return $default(_that.id,_that.isVerified,_that.username,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentAuthor implements CommentAuthor {
  const _CommentAuthor({required this.id, required this.isVerified, this.username, this.displayName, this.avatarUrl});
  factory _CommentAuthor.fromJson(Map<String, dynamic> json) => _$CommentAuthorFromJson(json);

@override final  String id;
@override final  bool isVerified;
@override final  String? username;
@override final  String? displayName;
@override final  String? avatarUrl;

/// Create a copy of CommentAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentAuthorCopyWith<_CommentAuthor> get copyWith => __$CommentAuthorCopyWithImpl<_CommentAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isVerified,username,displayName,avatarUrl);

@override
String toString() {
  return 'CommentAuthor(id: $id, isVerified: $isVerified, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$CommentAuthorCopyWith<$Res> implements $CommentAuthorCopyWith<$Res> {
  factory _$CommentAuthorCopyWith(_CommentAuthor value, $Res Function(_CommentAuthor) _then) = __$CommentAuthorCopyWithImpl;
@override @useResult
$Res call({
 String id, bool isVerified, String? username, String? displayName, String? avatarUrl
});




}
/// @nodoc
class __$CommentAuthorCopyWithImpl<$Res>
    implements _$CommentAuthorCopyWith<$Res> {
  __$CommentAuthorCopyWithImpl(this._self, this._then);

  final _CommentAuthor _self;
  final $Res Function(_CommentAuthor) _then;

/// Create a copy of CommentAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isVerified = null,Object? username = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_CommentAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Comment {

 String get id; String get postId; CommentAuthor get author;// Backend `CommentDto` names the content `body`.
@JsonKey(name: 'body') String get text; DateTime get createdAt; int get likeCount; bool get viewerHasLiked;// Not sent by the backend — derived at render (author == current user).
@JsonKey(includeFromJson: false, includeToJson: false) bool get isOwn; int get replyCount; String? get parentId;@JsonKey(includeFromJson: false, includeToJson: false) bool get pending;@JsonKey(includeFromJson: false, includeToJson: false) String? get clientKey;
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.author, author) || other.author == author)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,author,text,createdAt,likeCount,viewerHasLiked,isOwn,replyCount,parentId,pending,clientKey);

@override
String toString() {
  return 'Comment(id: $id, postId: $postId, author: $author, text: $text, createdAt: $createdAt, likeCount: $likeCount, viewerHasLiked: $viewerHasLiked, isOwn: $isOwn, replyCount: $replyCount, parentId: $parentId, pending: $pending, clientKey: $clientKey)';
}


}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 String id, String postId, CommentAuthor author,@JsonKey(name: 'body') String text, DateTime createdAt, int likeCount, bool viewerHasLiked,@JsonKey(includeFromJson: false, includeToJson: false) bool isOwn, int replyCount, String? parentId,@JsonKey(includeFromJson: false, includeToJson: false) bool pending,@JsonKey(includeFromJson: false, includeToJson: false) String? clientKey
});


$CommentAuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? author = null,Object? text = null,Object? createdAt = null,Object? likeCount = null,Object? viewerHasLiked = null,Object? isOwn = null,Object? replyCount = null,Object? parentId = freezed,Object? pending = null,Object? clientKey = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as CommentAuthor,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,clientKey: freezed == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentAuthorCopyWith<$Res> get author {
  
  return $CommentAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String postId,  CommentAuthor author, @JsonKey(name: 'body')  String text,  DateTime createdAt,  int likeCount,  bool viewerHasLiked, @JsonKey(includeFromJson: false, includeToJson: false)  bool isOwn,  int replyCount,  String? parentId, @JsonKey(includeFromJson: false, includeToJson: false)  bool pending, @JsonKey(includeFromJson: false, includeToJson: false)  String? clientKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.postId,_that.author,_that.text,_that.createdAt,_that.likeCount,_that.viewerHasLiked,_that.isOwn,_that.replyCount,_that.parentId,_that.pending,_that.clientKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String postId,  CommentAuthor author, @JsonKey(name: 'body')  String text,  DateTime createdAt,  int likeCount,  bool viewerHasLiked, @JsonKey(includeFromJson: false, includeToJson: false)  bool isOwn,  int replyCount,  String? parentId, @JsonKey(includeFromJson: false, includeToJson: false)  bool pending, @JsonKey(includeFromJson: false, includeToJson: false)  String? clientKey)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.id,_that.postId,_that.author,_that.text,_that.createdAt,_that.likeCount,_that.viewerHasLiked,_that.isOwn,_that.replyCount,_that.parentId,_that.pending,_that.clientKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String postId,  CommentAuthor author, @JsonKey(name: 'body')  String text,  DateTime createdAt,  int likeCount,  bool viewerHasLiked, @JsonKey(includeFromJson: false, includeToJson: false)  bool isOwn,  int replyCount,  String? parentId, @JsonKey(includeFromJson: false, includeToJson: false)  bool pending, @JsonKey(includeFromJson: false, includeToJson: false)  String? clientKey)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.postId,_that.author,_that.text,_that.createdAt,_that.likeCount,_that.viewerHasLiked,_that.isOwn,_that.replyCount,_that.parentId,_that.pending,_that.clientKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Comment extends Comment {
  const _Comment({required this.id, required this.postId, required this.author, @JsonKey(name: 'body') required this.text, required this.createdAt, required this.likeCount, required this.viewerHasLiked, @JsonKey(includeFromJson: false, includeToJson: false) this.isOwn = false, this.replyCount = 0, this.parentId, @JsonKey(includeFromJson: false, includeToJson: false) this.pending = false, @JsonKey(includeFromJson: false, includeToJson: false) this.clientKey}): super._();
  factory _Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

@override final  String id;
@override final  String postId;
@override final  CommentAuthor author;
// Backend `CommentDto` names the content `body`.
@override@JsonKey(name: 'body') final  String text;
@override final  DateTime createdAt;
@override final  int likeCount;
@override final  bool viewerHasLiked;
// Not sent by the backend — derived at render (author == current user).
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isOwn;
@override@JsonKey() final  int replyCount;
@override final  String? parentId;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool pending;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? clientKey;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.author, author) || other.author == author)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,author,text,createdAt,likeCount,viewerHasLiked,isOwn,replyCount,parentId,pending,clientKey);

@override
String toString() {
  return 'Comment(id: $id, postId: $postId, author: $author, text: $text, createdAt: $createdAt, likeCount: $likeCount, viewerHasLiked: $viewerHasLiked, isOwn: $isOwn, replyCount: $replyCount, parentId: $parentId, pending: $pending, clientKey: $clientKey)';
}


}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String postId, CommentAuthor author,@JsonKey(name: 'body') String text, DateTime createdAt, int likeCount, bool viewerHasLiked,@JsonKey(includeFromJson: false, includeToJson: false) bool isOwn, int replyCount, String? parentId,@JsonKey(includeFromJson: false, includeToJson: false) bool pending,@JsonKey(includeFromJson: false, includeToJson: false) String? clientKey
});


@override $CommentAuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? author = null,Object? text = null,Object? createdAt = null,Object? likeCount = null,Object? viewerHasLiked = null,Object? isOwn = null,Object? replyCount = null,Object? parentId = freezed,Object? pending = null,Object? clientKey = freezed,}) {
  return _then(_Comment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as CommentAuthor,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,clientKey: freezed == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentAuthorCopyWith<$Res> get author {
  
  return $CommentAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
