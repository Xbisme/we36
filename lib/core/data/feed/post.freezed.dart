// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSummary {

 String get id; bool get isVerified; String? get username; String? get displayName; String? get avatarUrl;
/// Create a copy of UserSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<UserSummary> get copyWith => _$UserSummaryCopyWithImpl<UserSummary>(this as UserSummary, _$identity);

  /// Serializes this UserSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isVerified,username,displayName,avatarUrl);

@override
String toString() {
  return 'UserSummary(id: $id, isVerified: $isVerified, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $UserSummaryCopyWith<$Res>  {
  factory $UserSummaryCopyWith(UserSummary value, $Res Function(UserSummary) _then) = _$UserSummaryCopyWithImpl;
@useResult
$Res call({
 String id, bool isVerified, String? username, String? displayName, String? avatarUrl
});




}
/// @nodoc
class _$UserSummaryCopyWithImpl<$Res>
    implements $UserSummaryCopyWith<$Res> {
  _$UserSummaryCopyWithImpl(this._self, this._then);

  final UserSummary _self;
  final $Res Function(UserSummary) _then;

/// Create a copy of UserSummary
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


/// Adds pattern-matching-related methods to [UserSummary].
extension UserSummaryPatterns on UserSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSummary value)  $default,){
final _that = this;
switch (_that) {
case _UserSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSummary value)?  $default,){
final _that = this;
switch (_that) {
case _UserSummary() when $default != null:
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
case _UserSummary() when $default != null:
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
case _UserSummary():
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
case _UserSummary() when $default != null:
return $default(_that.id,_that.isVerified,_that.username,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSummary implements UserSummary {
  const _UserSummary({required this.id, required this.isVerified, this.username, this.displayName, this.avatarUrl});
  factory _UserSummary.fromJson(Map<String, dynamic> json) => _$UserSummaryFromJson(json);

@override final  String id;
@override final  bool isVerified;
@override final  String? username;
@override final  String? displayName;
@override final  String? avatarUrl;

/// Create a copy of UserSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSummaryCopyWith<_UserSummary> get copyWith => __$UserSummaryCopyWithImpl<_UserSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isVerified,username,displayName,avatarUrl);

@override
String toString() {
  return 'UserSummary(id: $id, isVerified: $isVerified, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$UserSummaryCopyWith<$Res> implements $UserSummaryCopyWith<$Res> {
  factory _$UserSummaryCopyWith(_UserSummary value, $Res Function(_UserSummary) _then) = __$UserSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, bool isVerified, String? username, String? displayName, String? avatarUrl
});




}
/// @nodoc
class __$UserSummaryCopyWithImpl<$Res>
    implements _$UserSummaryCopyWith<$Res> {
  __$UserSummaryCopyWithImpl(this._self, this._then);

  final _UserSummary _self;
  final $Res Function(_UserSummary) _then;

/// Create a copy of UserSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isVerified = null,Object? username = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_UserSummary(
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
mixin _$Media {

 String get id; MediaKind get kind; MediaStatus get status; int? get width; int? get height; int? get durationMs; Map<String, dynamic>? get variants;
/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCopyWith<Media> get copyWith => _$MediaCopyWithImpl<Media>(this as Media, _$identity);

  /// Serializes this Media to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Media&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&const DeepCollectionEquality().equals(other.variants, variants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,status,width,height,durationMs,const DeepCollectionEquality().hash(variants));

@override
String toString() {
  return 'Media(id: $id, kind: $kind, status: $status, width: $width, height: $height, durationMs: $durationMs, variants: $variants)';
}


}

/// @nodoc
abstract mixin class $MediaCopyWith<$Res>  {
  factory $MediaCopyWith(Media value, $Res Function(Media) _then) = _$MediaCopyWithImpl;
@useResult
$Res call({
 String id, MediaKind kind, MediaStatus status, int? width, int? height, int? durationMs, Map<String, dynamic>? variants
});




}
/// @nodoc
class _$MediaCopyWithImpl<$Res>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._self, this._then);

  final Media _self;
  final $Res Function(Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? status = null,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? variants = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MediaStatus,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,variants: freezed == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Media].
extension MediaPatterns on Media {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Media value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Media() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Media value)  $default,){
final _that = this;
switch (_that) {
case _Media():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Media value)?  $default,){
final _that = this;
switch (_that) {
case _Media() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MediaKind kind,  MediaStatus status,  int? width,  int? height,  int? durationMs,  Map<String, dynamic>? variants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.kind,_that.status,_that.width,_that.height,_that.durationMs,_that.variants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MediaKind kind,  MediaStatus status,  int? width,  int? height,  int? durationMs,  Map<String, dynamic>? variants)  $default,) {final _that = this;
switch (_that) {
case _Media():
return $default(_that.id,_that.kind,_that.status,_that.width,_that.height,_that.durationMs,_that.variants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MediaKind kind,  MediaStatus status,  int? width,  int? height,  int? durationMs,  Map<String, dynamic>? variants)?  $default,) {final _that = this;
switch (_that) {
case _Media() when $default != null:
return $default(_that.id,_that.kind,_that.status,_that.width,_that.height,_that.durationMs,_that.variants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Media implements Media {
  const _Media({required this.id, required this.kind, required this.status, this.width, this.height, this.durationMs, final  Map<String, dynamic>? variants}): _variants = variants;
  factory _Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

@override final  String id;
@override final  MediaKind kind;
@override final  MediaStatus status;
@override final  int? width;
@override final  int? height;
@override final  int? durationMs;
 final  Map<String, dynamic>? _variants;
@override Map<String, dynamic>? get variants {
  final value = _variants;
  if (value == null) return null;
  if (_variants is EqualUnmodifiableMapView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaCopyWith<_Media> get copyWith => __$MediaCopyWithImpl<_Media>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Media&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&const DeepCollectionEquality().equals(other._variants, _variants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,status,width,height,durationMs,const DeepCollectionEquality().hash(_variants));

@override
String toString() {
  return 'Media(id: $id, kind: $kind, status: $status, width: $width, height: $height, durationMs: $durationMs, variants: $variants)';
}


}

/// @nodoc
abstract mixin class _$MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$MediaCopyWith(_Media value, $Res Function(_Media) _then) = __$MediaCopyWithImpl;
@override @useResult
$Res call({
 String id, MediaKind kind, MediaStatus status, int? width, int? height, int? durationMs, Map<String, dynamic>? variants
});




}
/// @nodoc
class __$MediaCopyWithImpl<$Res>
    implements _$MediaCopyWith<$Res> {
  __$MediaCopyWithImpl(this._self, this._then);

  final _Media _self;
  final $Res Function(_Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? status = null,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? variants = freezed,}) {
  return _then(_Media(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MediaStatus,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,variants: freezed == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$PostMedia {

 int get position; Media get media;
/// Create a copy of PostMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostMediaCopyWith<PostMedia> get copyWith => _$PostMediaCopyWithImpl<PostMedia>(this as PostMedia, _$identity);

  /// Serializes this PostMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostMedia&&(identical(other.position, position) || other.position == position)&&(identical(other.media, media) || other.media == media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,media);

@override
String toString() {
  return 'PostMedia(position: $position, media: $media)';
}


}

/// @nodoc
abstract mixin class $PostMediaCopyWith<$Res>  {
  factory $PostMediaCopyWith(PostMedia value, $Res Function(PostMedia) _then) = _$PostMediaCopyWithImpl;
@useResult
$Res call({
 int position, Media media
});


$MediaCopyWith<$Res> get media;

}
/// @nodoc
class _$PostMediaCopyWithImpl<$Res>
    implements $PostMediaCopyWith<$Res> {
  _$PostMediaCopyWithImpl(this._self, this._then);

  final PostMedia _self;
  final $Res Function(PostMedia) _then;

/// Create a copy of PostMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? media = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media,
  ));
}
/// Create a copy of PostMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res> get media {
  
  return $MediaCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostMedia].
extension PostMediaPatterns on PostMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostMedia value)  $default,){
final _that = this;
switch (_that) {
case _PostMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostMedia value)?  $default,){
final _that = this;
switch (_that) {
case _PostMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int position,  Media media)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostMedia() when $default != null:
return $default(_that.position,_that.media);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int position,  Media media)  $default,) {final _that = this;
switch (_that) {
case _PostMedia():
return $default(_that.position,_that.media);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int position,  Media media)?  $default,) {final _that = this;
switch (_that) {
case _PostMedia() when $default != null:
return $default(_that.position,_that.media);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostMedia implements PostMedia {
  const _PostMedia({required this.position, required this.media});
  factory _PostMedia.fromJson(Map<String, dynamic> json) => _$PostMediaFromJson(json);

@override final  int position;
@override final  Media media;

/// Create a copy of PostMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostMediaCopyWith<_PostMedia> get copyWith => __$PostMediaCopyWithImpl<_PostMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostMedia&&(identical(other.position, position) || other.position == position)&&(identical(other.media, media) || other.media == media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,media);

@override
String toString() {
  return 'PostMedia(position: $position, media: $media)';
}


}

/// @nodoc
abstract mixin class _$PostMediaCopyWith<$Res> implements $PostMediaCopyWith<$Res> {
  factory _$PostMediaCopyWith(_PostMedia value, $Res Function(_PostMedia) _then) = __$PostMediaCopyWithImpl;
@override @useResult
$Res call({
 int position, Media media
});


@override $MediaCopyWith<$Res> get media;

}
/// @nodoc
class __$PostMediaCopyWithImpl<$Res>
    implements _$PostMediaCopyWith<$Res> {
  __$PostMediaCopyWithImpl(this._self, this._then);

  final _PostMedia _self;
  final $Res Function(_PostMedia) _then;

/// Create a copy of PostMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? media = null,}) {
  return _then(_PostMedia(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media,
  ));
}

/// Create a copy of PostMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res> get media {
  
  return $MediaCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// @nodoc
mixin _$Place {

 String get id; String get name; double? get lat; double? get lng; String? get externalId;
/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceCopyWith<Place> get copyWith => _$PlaceCopyWithImpl<Place>(this as Place, _$identity);

  /// Serializes this Place to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Place&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.externalId, externalId) || other.externalId == externalId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,externalId);

@override
String toString() {
  return 'Place(id: $id, name: $name, lat: $lat, lng: $lng, externalId: $externalId)';
}


}

/// @nodoc
abstract mixin class $PlaceCopyWith<$Res>  {
  factory $PlaceCopyWith(Place value, $Res Function(Place) _then) = _$PlaceCopyWithImpl;
@useResult
$Res call({
 String id, String name, double? lat, double? lng, String? externalId
});




}
/// @nodoc
class _$PlaceCopyWithImpl<$Res>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._self, this._then);

  final Place _self;
  final $Res Function(Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = freezed,Object? lng = freezed,Object? externalId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,externalId: freezed == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Place].
extension PlacePatterns on Place {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Place value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Place value)  $default,){
final _that = this;
switch (_that) {
case _Place():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Place value)?  $default,){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double? lat,  double? lng,  String? externalId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.externalId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double? lat,  double? lng,  String? externalId)  $default,) {final _that = this;
switch (_that) {
case _Place():
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.externalId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double? lat,  double? lng,  String? externalId)?  $default,) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.externalId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Place implements Place {
  const _Place({required this.id, required this.name, this.lat, this.lng, this.externalId});
  factory _Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

@override final  String id;
@override final  String name;
@override final  double? lat;
@override final  double? lng;
@override final  String? externalId;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceCopyWith<_Place> get copyWith => __$PlaceCopyWithImpl<_Place>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Place&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.externalId, externalId) || other.externalId == externalId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,externalId);

@override
String toString() {
  return 'Place(id: $id, name: $name, lat: $lat, lng: $lng, externalId: $externalId)';
}


}

/// @nodoc
abstract mixin class _$PlaceCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$PlaceCopyWith(_Place value, $Res Function(_Place) _then) = __$PlaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double? lat, double? lng, String? externalId
});




}
/// @nodoc
class __$PlaceCopyWithImpl<$Res>
    implements _$PlaceCopyWith<$Res> {
  __$PlaceCopyWithImpl(this._self, this._then);

  final _Place _self;
  final $Res Function(_Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = freezed,Object? lng = freezed,Object? externalId = freezed,}) {
  return _then(_Place(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,externalId: freezed == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Post {

 String get id; UserSummary get author; List<PostMedia> get media; List<String> get hashtags; List<UserSummary> get taggedUsers; bool get commentsDisabled; int get likeCount; int get saveCount; int get commentCount; bool get viewerHasLiked; bool get viewerHasSaved; DateTime get createdAt; String? get caption; Place? get location;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.media, media)&&const DeepCollectionEquality().equals(other.hashtags, hashtags)&&const DeepCollectionEquality().equals(other.taggedUsers, taggedUsers)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.viewerHasSaved, viewerHasSaved) || other.viewerHasSaved == viewerHasSaved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,const DeepCollectionEquality().hash(media),const DeepCollectionEquality().hash(hashtags),const DeepCollectionEquality().hash(taggedUsers),commentsDisabled,likeCount,saveCount,commentCount,viewerHasLiked,viewerHasSaved,createdAt,caption,location);

@override
String toString() {
  return 'Post(id: $id, author: $author, media: $media, hashtags: $hashtags, taggedUsers: $taggedUsers, commentsDisabled: $commentsDisabled, likeCount: $likeCount, saveCount: $saveCount, commentCount: $commentCount, viewerHasLiked: $viewerHasLiked, viewerHasSaved: $viewerHasSaved, createdAt: $createdAt, caption: $caption, location: $location)';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
 String id, UserSummary author, List<PostMedia> media, List<String> hashtags, List<UserSummary> taggedUsers, bool commentsDisabled, int likeCount, int saveCount, int commentCount, bool viewerHasLiked, bool viewerHasSaved, DateTime createdAt, String? caption, Place? location
});


$UserSummaryCopyWith<$Res> get author;$PlaceCopyWith<$Res>? get location;

}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? media = null,Object? hashtags = null,Object? taggedUsers = null,Object? commentsDisabled = null,Object? likeCount = null,Object? saveCount = null,Object? commentCount = null,Object? viewerHasLiked = null,Object? viewerHasSaved = null,Object? createdAt = null,Object? caption = freezed,Object? location = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserSummary,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<PostMedia>,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,taggedUsers: null == taggedUsers ? _self.taggedUsers : taggedUsers // ignore: cast_nullable_to_non_nullable
as List<UserSummary>,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,viewerHasSaved: null == viewerHasSaved ? _self.viewerHasSaved : viewerHasSaved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Place?,
  ));
}
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get author {
  
  return $UserSummaryCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of Post
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


/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Post value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Post value)  $default,){
final _that = this;
switch (_that) {
case _Post():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Post value)?  $default,){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UserSummary author,  List<PostMedia> media,  List<String> hashtags,  List<UserSummary> taggedUsers,  bool commentsDisabled,  int likeCount,  int saveCount,  int commentCount,  bool viewerHasLiked,  bool viewerHasSaved,  DateTime createdAt,  String? caption,  Place? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.author,_that.media,_that.hashtags,_that.taggedUsers,_that.commentsDisabled,_that.likeCount,_that.saveCount,_that.commentCount,_that.viewerHasLiked,_that.viewerHasSaved,_that.createdAt,_that.caption,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UserSummary author,  List<PostMedia> media,  List<String> hashtags,  List<UserSummary> taggedUsers,  bool commentsDisabled,  int likeCount,  int saveCount,  int commentCount,  bool viewerHasLiked,  bool viewerHasSaved,  DateTime createdAt,  String? caption,  Place? location)  $default,) {final _that = this;
switch (_that) {
case _Post():
return $default(_that.id,_that.author,_that.media,_that.hashtags,_that.taggedUsers,_that.commentsDisabled,_that.likeCount,_that.saveCount,_that.commentCount,_that.viewerHasLiked,_that.viewerHasSaved,_that.createdAt,_that.caption,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UserSummary author,  List<PostMedia> media,  List<String> hashtags,  List<UserSummary> taggedUsers,  bool commentsDisabled,  int likeCount,  int saveCount,  int commentCount,  bool viewerHasLiked,  bool viewerHasSaved,  DateTime createdAt,  String? caption,  Place? location)?  $default,) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.author,_that.media,_that.hashtags,_that.taggedUsers,_that.commentsDisabled,_that.likeCount,_that.saveCount,_that.commentCount,_that.viewerHasLiked,_that.viewerHasSaved,_that.createdAt,_that.caption,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Post extends Post {
  const _Post({required this.id, required this.author, required final  List<PostMedia> media, required final  List<String> hashtags, required final  List<UserSummary> taggedUsers, required this.commentsDisabled, required this.likeCount, required this.saveCount, required this.commentCount, required this.viewerHasLiked, required this.viewerHasSaved, required this.createdAt, this.caption, this.location}): _media = media,_hashtags = hashtags,_taggedUsers = taggedUsers,super._();
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override final  String id;
@override final  UserSummary author;
 final  List<PostMedia> _media;
@override List<PostMedia> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

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
@override final  DateTime createdAt;
@override final  String? caption;
@override final  Place? location;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._media, _media)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags)&&const DeepCollectionEquality().equals(other._taggedUsers, _taggedUsers)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.viewerHasSaved, viewerHasSaved) || other.viewerHasSaved == viewerHasSaved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,const DeepCollectionEquality().hash(_media),const DeepCollectionEquality().hash(_hashtags),const DeepCollectionEquality().hash(_taggedUsers),commentsDisabled,likeCount,saveCount,commentCount,viewerHasLiked,viewerHasSaved,createdAt,caption,location);

@override
String toString() {
  return 'Post(id: $id, author: $author, media: $media, hashtags: $hashtags, taggedUsers: $taggedUsers, commentsDisabled: $commentsDisabled, likeCount: $likeCount, saveCount: $saveCount, commentCount: $commentCount, viewerHasLiked: $viewerHasLiked, viewerHasSaved: $viewerHasSaved, createdAt: $createdAt, caption: $caption, location: $location)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
 String id, UserSummary author, List<PostMedia> media, List<String> hashtags, List<UserSummary> taggedUsers, bool commentsDisabled, int likeCount, int saveCount, int commentCount, bool viewerHasLiked, bool viewerHasSaved, DateTime createdAt, String? caption, Place? location
});


@override $UserSummaryCopyWith<$Res> get author;@override $PlaceCopyWith<$Res>? get location;

}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? media = null,Object? hashtags = null,Object? taggedUsers = null,Object? commentsDisabled = null,Object? likeCount = null,Object? saveCount = null,Object? commentCount = null,Object? viewerHasLiked = null,Object? viewerHasSaved = null,Object? createdAt = null,Object? caption = freezed,Object? location = freezed,}) {
  return _then(_Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserSummary,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<PostMedia>,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,taggedUsers: null == taggedUsers ? _self._taggedUsers : taggedUsers // ignore: cast_nullable_to_non_nullable
as List<UserSummary>,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,viewerHasSaved: null == viewerHasSaved ? _self.viewerHasSaved : viewerHasSaved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Place?,
  ));
}

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get author {
  
  return $UserSummaryCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of Post
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


/// @nodoc
mixin _$EngagementState {

 String get postId; int get likeCount; int get saveCount; bool get viewerHasLiked; bool get viewerHasSaved;
/// Create a copy of EngagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngagementStateCopyWith<EngagementState> get copyWith => _$EngagementStateCopyWithImpl<EngagementState>(this as EngagementState, _$identity);

  /// Serializes this EngagementState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EngagementState&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.viewerHasSaved, viewerHasSaved) || other.viewerHasSaved == viewerHasSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,likeCount,saveCount,viewerHasLiked,viewerHasSaved);

@override
String toString() {
  return 'EngagementState(postId: $postId, likeCount: $likeCount, saveCount: $saveCount, viewerHasLiked: $viewerHasLiked, viewerHasSaved: $viewerHasSaved)';
}


}

/// @nodoc
abstract mixin class $EngagementStateCopyWith<$Res>  {
  factory $EngagementStateCopyWith(EngagementState value, $Res Function(EngagementState) _then) = _$EngagementStateCopyWithImpl;
@useResult
$Res call({
 String postId, int likeCount, int saveCount, bool viewerHasLiked, bool viewerHasSaved
});




}
/// @nodoc
class _$EngagementStateCopyWithImpl<$Res>
    implements $EngagementStateCopyWith<$Res> {
  _$EngagementStateCopyWithImpl(this._self, this._then);

  final EngagementState _self;
  final $Res Function(EngagementState) _then;

/// Create a copy of EngagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postId = null,Object? likeCount = null,Object? saveCount = null,Object? viewerHasLiked = null,Object? viewerHasSaved = null,}) {
  return _then(_self.copyWith(
postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,viewerHasSaved: null == viewerHasSaved ? _self.viewerHasSaved : viewerHasSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EngagementState].
extension EngagementStatePatterns on EngagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EngagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EngagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EngagementState value)  $default,){
final _that = this;
switch (_that) {
case _EngagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EngagementState value)?  $default,){
final _that = this;
switch (_that) {
case _EngagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String postId,  int likeCount,  int saveCount,  bool viewerHasLiked,  bool viewerHasSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EngagementState() when $default != null:
return $default(_that.postId,_that.likeCount,_that.saveCount,_that.viewerHasLiked,_that.viewerHasSaved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String postId,  int likeCount,  int saveCount,  bool viewerHasLiked,  bool viewerHasSaved)  $default,) {final _that = this;
switch (_that) {
case _EngagementState():
return $default(_that.postId,_that.likeCount,_that.saveCount,_that.viewerHasLiked,_that.viewerHasSaved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String postId,  int likeCount,  int saveCount,  bool viewerHasLiked,  bool viewerHasSaved)?  $default,) {final _that = this;
switch (_that) {
case _EngagementState() when $default != null:
return $default(_that.postId,_that.likeCount,_that.saveCount,_that.viewerHasLiked,_that.viewerHasSaved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EngagementState implements EngagementState {
  const _EngagementState({required this.postId, required this.likeCount, required this.saveCount, required this.viewerHasLiked, required this.viewerHasSaved});
  factory _EngagementState.fromJson(Map<String, dynamic> json) => _$EngagementStateFromJson(json);

@override final  String postId;
@override final  int likeCount;
@override final  int saveCount;
@override final  bool viewerHasLiked;
@override final  bool viewerHasSaved;

/// Create a copy of EngagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngagementStateCopyWith<_EngagementState> get copyWith => __$EngagementStateCopyWithImpl<_EngagementState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngagementStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EngagementState&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked)&&(identical(other.viewerHasSaved, viewerHasSaved) || other.viewerHasSaved == viewerHasSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,likeCount,saveCount,viewerHasLiked,viewerHasSaved);

@override
String toString() {
  return 'EngagementState(postId: $postId, likeCount: $likeCount, saveCount: $saveCount, viewerHasLiked: $viewerHasLiked, viewerHasSaved: $viewerHasSaved)';
}


}

/// @nodoc
abstract mixin class _$EngagementStateCopyWith<$Res> implements $EngagementStateCopyWith<$Res> {
  factory _$EngagementStateCopyWith(_EngagementState value, $Res Function(_EngagementState) _then) = __$EngagementStateCopyWithImpl;
@override @useResult
$Res call({
 String postId, int likeCount, int saveCount, bool viewerHasLiked, bool viewerHasSaved
});




}
/// @nodoc
class __$EngagementStateCopyWithImpl<$Res>
    implements _$EngagementStateCopyWith<$Res> {
  __$EngagementStateCopyWithImpl(this._self, this._then);

  final _EngagementState _self;
  final $Res Function(_EngagementState) _then;

/// Create a copy of EngagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postId = null,Object? likeCount = null,Object? saveCount = null,Object? viewerHasLiked = null,Object? viewerHasSaved = null,}) {
  return _then(_EngagementState(
postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,viewerHasSaved: null == viewerHasSaved ? _self.viewerHasSaved : viewerHasSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
