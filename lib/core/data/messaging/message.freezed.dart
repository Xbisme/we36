// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostRef {

 String get id; PostKind get kind; String? get thumbUrl; String? get authorName; bool get unavailable;
/// Create a copy of PostRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostRefCopyWith<PostRef> get copyWith => _$PostRefCopyWithImpl<PostRef>(this as PostRef, _$identity);

  /// Serializes this PostRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostRef&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.unavailable, unavailable) || other.unavailable == unavailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,thumbUrl,authorName,unavailable);

@override
String toString() {
  return 'PostRef(id: $id, kind: $kind, thumbUrl: $thumbUrl, authorName: $authorName, unavailable: $unavailable)';
}


}

/// @nodoc
abstract mixin class $PostRefCopyWith<$Res>  {
  factory $PostRefCopyWith(PostRef value, $Res Function(PostRef) _then) = _$PostRefCopyWithImpl;
@useResult
$Res call({
 String id, PostKind kind, String? thumbUrl, String? authorName, bool unavailable
});




}
/// @nodoc
class _$PostRefCopyWithImpl<$Res>
    implements $PostRefCopyWith<$Res> {
  _$PostRefCopyWithImpl(this._self, this._then);

  final PostRef _self;
  final $Res Function(PostRef) _then;

/// Create a copy of PostRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? thumbUrl = freezed,Object? authorName = freezed,Object? unavailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PostKind,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PostRef].
extension PostRefPatterns on PostRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostRef value)  $default,){
final _that = this;
switch (_that) {
case _PostRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostRef value)?  $default,){
final _that = this;
switch (_that) {
case _PostRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PostKind kind,  String? thumbUrl,  String? authorName,  bool unavailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostRef() when $default != null:
return $default(_that.id,_that.kind,_that.thumbUrl,_that.authorName,_that.unavailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PostKind kind,  String? thumbUrl,  String? authorName,  bool unavailable)  $default,) {final _that = this;
switch (_that) {
case _PostRef():
return $default(_that.id,_that.kind,_that.thumbUrl,_that.authorName,_that.unavailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PostKind kind,  String? thumbUrl,  String? authorName,  bool unavailable)?  $default,) {final _that = this;
switch (_that) {
case _PostRef() when $default != null:
return $default(_that.id,_that.kind,_that.thumbUrl,_that.authorName,_that.unavailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostRef implements PostRef {
  const _PostRef({required this.id, required this.kind, this.thumbUrl, this.authorName, this.unavailable = false});
  factory _PostRef.fromJson(Map<String, dynamic> json) => _$PostRefFromJson(json);

@override final  String id;
@override final  PostKind kind;
@override final  String? thumbUrl;
@override final  String? authorName;
@override@JsonKey() final  bool unavailable;

/// Create a copy of PostRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostRefCopyWith<_PostRef> get copyWith => __$PostRefCopyWithImpl<_PostRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostRef&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.unavailable, unavailable) || other.unavailable == unavailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,thumbUrl,authorName,unavailable);

@override
String toString() {
  return 'PostRef(id: $id, kind: $kind, thumbUrl: $thumbUrl, authorName: $authorName, unavailable: $unavailable)';
}


}

/// @nodoc
abstract mixin class _$PostRefCopyWith<$Res> implements $PostRefCopyWith<$Res> {
  factory _$PostRefCopyWith(_PostRef value, $Res Function(_PostRef) _then) = __$PostRefCopyWithImpl;
@override @useResult
$Res call({
 String id, PostKind kind, String? thumbUrl, String? authorName, bool unavailable
});




}
/// @nodoc
class __$PostRefCopyWithImpl<$Res>
    implements _$PostRefCopyWith<$Res> {
  __$PostRefCopyWithImpl(this._self, this._then);

  final _PostRef _self;
  final $Res Function(_PostRef) _then;

/// Create a copy of PostRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? thumbUrl = freezed,Object? authorName = freezed,Object? unavailable = null,}) {
  return _then(_PostRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PostKind,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

MessageContent _$MessageContentFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'text':
          return TextContent.fromJson(
            json
          );
                case 'photo':
          return PhotoContent.fromJson(
            json
          );
                case 'sharedPost':
          return SharedPostContent.fromJson(
            json
          );
                case 'sticker':
          return StickerContent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'MessageContent',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$MessageContent {



  /// Serializes this MessageContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageContent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageContent()';
}


}

/// @nodoc
class $MessageContentCopyWith<$Res>  {
$MessageContentCopyWith(MessageContent _, $Res Function(MessageContent) __);
}


/// Adds pattern-matching-related methods to [MessageContent].
extension MessageContentPatterns on MessageContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextContent value)?  text,TResult Function( PhotoContent value)?  photo,TResult Function( SharedPostContent value)?  sharedPost,TResult Function( StickerContent value)?  sticker,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that);case PhotoContent() when photo != null:
return photo(_that);case SharedPostContent() when sharedPost != null:
return sharedPost(_that);case StickerContent() when sticker != null:
return sticker(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextContent value)  text,required TResult Function( PhotoContent value)  photo,required TResult Function( SharedPostContent value)  sharedPost,required TResult Function( StickerContent value)  sticker,}){
final _that = this;
switch (_that) {
case TextContent():
return text(_that);case PhotoContent():
return photo(_that);case SharedPostContent():
return sharedPost(_that);case StickerContent():
return sticker(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextContent value)?  text,TResult? Function( PhotoContent value)?  photo,TResult? Function( SharedPostContent value)?  sharedPost,TResult? Function( StickerContent value)?  sticker,}){
final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that);case PhotoContent() when photo != null:
return photo(_that);case SharedPostContent() when sharedPost != null:
return sharedPost(_that);case StickerContent() when sticker != null:
return sticker(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String body)?  text,TResult Function( String? mediaId,  String? localPath,  String? url,  double? uploadProgress)?  photo,TResult Function( PostRef ref)?  sharedPost,TResult Function( String glyphId)?  sticker,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that.body);case PhotoContent() when photo != null:
return photo(_that.mediaId,_that.localPath,_that.url,_that.uploadProgress);case SharedPostContent() when sharedPost != null:
return sharedPost(_that.ref);case StickerContent() when sticker != null:
return sticker(_that.glyphId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String body)  text,required TResult Function( String? mediaId,  String? localPath,  String? url,  double? uploadProgress)  photo,required TResult Function( PostRef ref)  sharedPost,required TResult Function( String glyphId)  sticker,}) {final _that = this;
switch (_that) {
case TextContent():
return text(_that.body);case PhotoContent():
return photo(_that.mediaId,_that.localPath,_that.url,_that.uploadProgress);case SharedPostContent():
return sharedPost(_that.ref);case StickerContent():
return sticker(_that.glyphId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String body)?  text,TResult? Function( String? mediaId,  String? localPath,  String? url,  double? uploadProgress)?  photo,TResult? Function( PostRef ref)?  sharedPost,TResult? Function( String glyphId)?  sticker,}) {final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that.body);case PhotoContent() when photo != null:
return photo(_that.mediaId,_that.localPath,_that.url,_that.uploadProgress);case SharedPostContent() when sharedPost != null:
return sharedPost(_that.ref);case StickerContent() when sticker != null:
return sticker(_that.glyphId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TextContent implements MessageContent {
  const TextContent({required this.body, final  String? $type}): $type = $type ?? 'text';
  factory TextContent.fromJson(Map<String, dynamic> json) => _$TextContentFromJson(json);

 final  String body;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextContentCopyWith<TextContent> get copyWith => _$TextContentCopyWithImpl<TextContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextContent&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'MessageContent.text(body: $body)';
}


}

/// @nodoc
abstract mixin class $TextContentCopyWith<$Res> implements $MessageContentCopyWith<$Res> {
  factory $TextContentCopyWith(TextContent value, $Res Function(TextContent) _then) = _$TextContentCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$TextContentCopyWithImpl<$Res>
    implements $TextContentCopyWith<$Res> {
  _$TextContentCopyWithImpl(this._self, this._then);

  final TextContent _self;
  final $Res Function(TextContent) _then;

/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(TextContent(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PhotoContent implements MessageContent {
  const PhotoContent({this.mediaId, this.localPath, this.url, this.uploadProgress, final  String? $type}): $type = $type ?? 'photo';
  factory PhotoContent.fromJson(Map<String, dynamic> json) => _$PhotoContentFromJson(json);

 final  String? mediaId;
 final  String? localPath;
 final  String? url;
 final  double? uploadProgress;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoContentCopyWith<PhotoContent> get copyWith => _$PhotoContentCopyWithImpl<PhotoContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoContent&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.url, url) || other.url == url)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaId,localPath,url,uploadProgress);

@override
String toString() {
  return 'MessageContent.photo(mediaId: $mediaId, localPath: $localPath, url: $url, uploadProgress: $uploadProgress)';
}


}

/// @nodoc
abstract mixin class $PhotoContentCopyWith<$Res> implements $MessageContentCopyWith<$Res> {
  factory $PhotoContentCopyWith(PhotoContent value, $Res Function(PhotoContent) _then) = _$PhotoContentCopyWithImpl;
@useResult
$Res call({
 String? mediaId, String? localPath, String? url, double? uploadProgress
});




}
/// @nodoc
class _$PhotoContentCopyWithImpl<$Res>
    implements $PhotoContentCopyWith<$Res> {
  _$PhotoContentCopyWithImpl(this._self, this._then);

  final PhotoContent _self;
  final $Res Function(PhotoContent) _then;

/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mediaId = freezed,Object? localPath = freezed,Object? url = freezed,Object? uploadProgress = freezed,}) {
  return _then(PhotoContent(
mediaId: freezed == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SharedPostContent implements MessageContent {
  const SharedPostContent({required this.ref, final  String? $type}): $type = $type ?? 'sharedPost';
  factory SharedPostContent.fromJson(Map<String, dynamic> json) => _$SharedPostContentFromJson(json);

 final  PostRef ref;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedPostContentCopyWith<SharedPostContent> get copyWith => _$SharedPostContentCopyWithImpl<SharedPostContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedPostContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedPostContent&&(identical(other.ref, ref) || other.ref == ref));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref);

@override
String toString() {
  return 'MessageContent.sharedPost(ref: $ref)';
}


}

/// @nodoc
abstract mixin class $SharedPostContentCopyWith<$Res> implements $MessageContentCopyWith<$Res> {
  factory $SharedPostContentCopyWith(SharedPostContent value, $Res Function(SharedPostContent) _then) = _$SharedPostContentCopyWithImpl;
@useResult
$Res call({
 PostRef ref
});


$PostRefCopyWith<$Res> get ref;

}
/// @nodoc
class _$SharedPostContentCopyWithImpl<$Res>
    implements $SharedPostContentCopyWith<$Res> {
  _$SharedPostContentCopyWithImpl(this._self, this._then);

  final SharedPostContent _self;
  final $Res Function(SharedPostContent) _then;

/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ref = null,}) {
  return _then(SharedPostContent(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as PostRef,
  ));
}

/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRefCopyWith<$Res> get ref {
  
  return $PostRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class StickerContent implements MessageContent {
  const StickerContent({required this.glyphId, final  String? $type}): $type = $type ?? 'sticker';
  factory StickerContent.fromJson(Map<String, dynamic> json) => _$StickerContentFromJson(json);

 final  String glyphId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StickerContentCopyWith<StickerContent> get copyWith => _$StickerContentCopyWithImpl<StickerContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StickerContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StickerContent&&(identical(other.glyphId, glyphId) || other.glyphId == glyphId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,glyphId);

@override
String toString() {
  return 'MessageContent.sticker(glyphId: $glyphId)';
}


}

/// @nodoc
abstract mixin class $StickerContentCopyWith<$Res> implements $MessageContentCopyWith<$Res> {
  factory $StickerContentCopyWith(StickerContent value, $Res Function(StickerContent) _then) = _$StickerContentCopyWithImpl;
@useResult
$Res call({
 String glyphId
});




}
/// @nodoc
class _$StickerContentCopyWithImpl<$Res>
    implements $StickerContentCopyWith<$Res> {
  _$StickerContentCopyWithImpl(this._self, this._then);

  final StickerContent _self;
  final $Res Function(StickerContent) _then;

/// Create a copy of MessageContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? glyphId = null,}) {
  return _then(StickerContent(
glyphId: null == glyphId ? _self.glyphId : glyphId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Message {

 String get clientKey; String get conversationId; String get authorId; bool get isMine; MessageKind get kind; MessageContent get content; DateTime get createdAt; DeliveryState get deliveryState; String? get serverId;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deliveryState, deliveryState) || other.deliveryState == deliveryState)&&(identical(other.serverId, serverId) || other.serverId == serverId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientKey,conversationId,authorId,isMine,kind,content,createdAt,deliveryState,serverId);

@override
String toString() {
  return 'Message(clientKey: $clientKey, conversationId: $conversationId, authorId: $authorId, isMine: $isMine, kind: $kind, content: $content, createdAt: $createdAt, deliveryState: $deliveryState, serverId: $serverId)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String clientKey, String conversationId, String authorId, bool isMine, MessageKind kind, MessageContent content, DateTime createdAt, DeliveryState deliveryState, String? serverId
});


$MessageContentCopyWith<$Res> get content;

}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientKey = null,Object? conversationId = null,Object? authorId = null,Object? isMine = null,Object? kind = null,Object? content = null,Object? createdAt = null,Object? deliveryState = null,Object? serverId = freezed,}) {
  return _then(_self.copyWith(
clientKey: null == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MessageKind,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as MessageContent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deliveryState: null == deliveryState ? _self.deliveryState : deliveryState // ignore: cast_nullable_to_non_nullable
as DeliveryState,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageContentCopyWith<$Res> get content {
  
  return $MessageContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientKey,  String conversationId,  String authorId,  bool isMine,  MessageKind kind,  MessageContent content,  DateTime createdAt,  DeliveryState deliveryState,  String? serverId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.clientKey,_that.conversationId,_that.authorId,_that.isMine,_that.kind,_that.content,_that.createdAt,_that.deliveryState,_that.serverId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientKey,  String conversationId,  String authorId,  bool isMine,  MessageKind kind,  MessageContent content,  DateTime createdAt,  DeliveryState deliveryState,  String? serverId)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.clientKey,_that.conversationId,_that.authorId,_that.isMine,_that.kind,_that.content,_that.createdAt,_that.deliveryState,_that.serverId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientKey,  String conversationId,  String authorId,  bool isMine,  MessageKind kind,  MessageContent content,  DateTime createdAt,  DeliveryState deliveryState,  String? serverId)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.clientKey,_that.conversationId,_that.authorId,_that.isMine,_that.kind,_that.content,_that.createdAt,_that.deliveryState,_that.serverId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message extends Message {
  const _Message({required this.clientKey, required this.conversationId, required this.authorId, required this.isMine, required this.kind, required this.content, required this.createdAt, required this.deliveryState, this.serverId}): super._();
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String clientKey;
@override final  String conversationId;
@override final  String authorId;
@override final  bool isMine;
@override final  MessageKind kind;
@override final  MessageContent content;
@override final  DateTime createdAt;
@override final  DeliveryState deliveryState;
@override final  String? serverId;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deliveryState, deliveryState) || other.deliveryState == deliveryState)&&(identical(other.serverId, serverId) || other.serverId == serverId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientKey,conversationId,authorId,isMine,kind,content,createdAt,deliveryState,serverId);

@override
String toString() {
  return 'Message(clientKey: $clientKey, conversationId: $conversationId, authorId: $authorId, isMine: $isMine, kind: $kind, content: $content, createdAt: $createdAt, deliveryState: $deliveryState, serverId: $serverId)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String clientKey, String conversationId, String authorId, bool isMine, MessageKind kind, MessageContent content, DateTime createdAt, DeliveryState deliveryState, String? serverId
});


@override $MessageContentCopyWith<$Res> get content;

}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientKey = null,Object? conversationId = null,Object? authorId = null,Object? isMine = null,Object? kind = null,Object? content = null,Object? createdAt = null,Object? deliveryState = null,Object? serverId = freezed,}) {
  return _then(_Message(
clientKey: null == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MessageKind,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as MessageContent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deliveryState: null == deliveryState ? _self.deliveryState : deliveryState // ignore: cast_nullable_to_non_nullable
as DeliveryState,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageContentCopyWith<$Res> get content {
  
  return $MessageContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
