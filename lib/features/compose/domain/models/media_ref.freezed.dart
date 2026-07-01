// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaRef {

 String get id; String? get url; int? get width; int? get height;
/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaRefCopyWith<MediaRef> get copyWith => _$MediaRefCopyWithImpl<MediaRef>(this as MediaRef, _$identity);

  /// Serializes this MediaRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaRef&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,width,height);

@override
String toString() {
  return 'MediaRef(id: $id, url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $MediaRefCopyWith<$Res>  {
  factory $MediaRefCopyWith(MediaRef value, $Res Function(MediaRef) _then) = _$MediaRefCopyWithImpl;
@useResult
$Res call({
 String id, String? url, int? width, int? height
});




}
/// @nodoc
class _$MediaRefCopyWithImpl<$Res>
    implements $MediaRefCopyWith<$Res> {
  _$MediaRefCopyWithImpl(this._self, this._then);

  final MediaRef _self;
  final $Res Function(MediaRef) _then;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaRef].
extension MediaRefPatterns on MediaRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaRef value)  $default,){
final _that = this;
switch (_that) {
case _MediaRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaRef value)?  $default,){
final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? url,  int? width,  int? height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
return $default(_that.id,_that.url,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? url,  int? width,  int? height)  $default,) {final _that = this;
switch (_that) {
case _MediaRef():
return $default(_that.id,_that.url,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? url,  int? width,  int? height)?  $default,) {final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
return $default(_that.id,_that.url,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaRef implements MediaRef {
  const _MediaRef({required this.id, this.url, this.width, this.height});
  factory _MediaRef.fromJson(Map<String, dynamic> json) => _$MediaRefFromJson(json);

@override final  String id;
@override final  String? url;
@override final  int? width;
@override final  int? height;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaRefCopyWith<_MediaRef> get copyWith => __$MediaRefCopyWithImpl<_MediaRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaRef&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,width,height);

@override
String toString() {
  return 'MediaRef(id: $id, url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$MediaRefCopyWith<$Res> implements $MediaRefCopyWith<$Res> {
  factory _$MediaRefCopyWith(_MediaRef value, $Res Function(_MediaRef) _then) = __$MediaRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String? url, int? width, int? height
});




}
/// @nodoc
class __$MediaRefCopyWithImpl<$Res>
    implements _$MediaRefCopyWith<$Res> {
  __$MediaRefCopyWithImpl(this._self, this._then);

  final _MediaRef _self;
  final $Res Function(_MediaRef) _then;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_MediaRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$UploadProgress {

 int get sentBytes; int get totalBytes; int get itemIndex; int get itemCount;
/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadProgressCopyWith<UploadProgress> get copyWith => _$UploadProgressCopyWithImpl<UploadProgress>(this as UploadProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadProgress&&(identical(other.sentBytes, sentBytes) || other.sentBytes == sentBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.itemIndex, itemIndex) || other.itemIndex == itemIndex)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}


@override
int get hashCode => Object.hash(runtimeType,sentBytes,totalBytes,itemIndex,itemCount);

@override
String toString() {
  return 'UploadProgress(sentBytes: $sentBytes, totalBytes: $totalBytes, itemIndex: $itemIndex, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class $UploadProgressCopyWith<$Res>  {
  factory $UploadProgressCopyWith(UploadProgress value, $Res Function(UploadProgress) _then) = _$UploadProgressCopyWithImpl;
@useResult
$Res call({
 int sentBytes, int totalBytes, int itemIndex, int itemCount
});




}
/// @nodoc
class _$UploadProgressCopyWithImpl<$Res>
    implements $UploadProgressCopyWith<$Res> {
  _$UploadProgressCopyWithImpl(this._self, this._then);

  final UploadProgress _self;
  final $Res Function(UploadProgress) _then;

/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sentBytes = null,Object? totalBytes = null,Object? itemIndex = null,Object? itemCount = null,}) {
  return _then(_self.copyWith(
sentBytes: null == sentBytes ? _self.sentBytes : sentBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,itemIndex: null == itemIndex ? _self.itemIndex : itemIndex // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadProgress].
extension UploadProgressPatterns on UploadProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadProgress value)  $default,){
final _that = this;
switch (_that) {
case _UploadProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadProgress value)?  $default,){
final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sentBytes,  int totalBytes,  int itemIndex,  int itemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
return $default(_that.sentBytes,_that.totalBytes,_that.itemIndex,_that.itemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sentBytes,  int totalBytes,  int itemIndex,  int itemCount)  $default,) {final _that = this;
switch (_that) {
case _UploadProgress():
return $default(_that.sentBytes,_that.totalBytes,_that.itemIndex,_that.itemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sentBytes,  int totalBytes,  int itemIndex,  int itemCount)?  $default,) {final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
return $default(_that.sentBytes,_that.totalBytes,_that.itemIndex,_that.itemCount);case _:
  return null;

}
}

}

/// @nodoc


class _UploadProgress extends UploadProgress {
  const _UploadProgress({required this.sentBytes, required this.totalBytes, this.itemIndex = 0, this.itemCount = 1}): super._();
  

@override final  int sentBytes;
@override final  int totalBytes;
@override@JsonKey() final  int itemIndex;
@override@JsonKey() final  int itemCount;

/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadProgressCopyWith<_UploadProgress> get copyWith => __$UploadProgressCopyWithImpl<_UploadProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadProgress&&(identical(other.sentBytes, sentBytes) || other.sentBytes == sentBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.itemIndex, itemIndex) || other.itemIndex == itemIndex)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}


@override
int get hashCode => Object.hash(runtimeType,sentBytes,totalBytes,itemIndex,itemCount);

@override
String toString() {
  return 'UploadProgress(sentBytes: $sentBytes, totalBytes: $totalBytes, itemIndex: $itemIndex, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class _$UploadProgressCopyWith<$Res> implements $UploadProgressCopyWith<$Res> {
  factory _$UploadProgressCopyWith(_UploadProgress value, $Res Function(_UploadProgress) _then) = __$UploadProgressCopyWithImpl;
@override @useResult
$Res call({
 int sentBytes, int totalBytes, int itemIndex, int itemCount
});




}
/// @nodoc
class __$UploadProgressCopyWithImpl<$Res>
    implements _$UploadProgressCopyWith<$Res> {
  __$UploadProgressCopyWithImpl(this._self, this._then);

  final _UploadProgress _self;
  final $Res Function(_UploadProgress) _then;

/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sentBytes = null,Object? totalBytes = null,Object? itemIndex = null,Object? itemCount = null,}) {
  return _then(_UploadProgress(
sentBytes: null == sentBytes ? _self.sentBytes : sentBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,itemIndex: null == itemIndex ? _self.itemIndex : itemIndex // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
