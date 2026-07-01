// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_edit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CropRect {

 double get left; double get top; double get width; double get height;
/// Create a copy of CropRect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CropRectCopyWith<CropRect> get copyWith => _$CropRectCopyWithImpl<CropRect>(this as CropRect, _$identity);

  /// Serializes this CropRect to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CropRect&&(identical(other.left, left) || other.left == left)&&(identical(other.top, top) || other.top == top)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,left,top,width,height);

@override
String toString() {
  return 'CropRect(left: $left, top: $top, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $CropRectCopyWith<$Res>  {
  factory $CropRectCopyWith(CropRect value, $Res Function(CropRect) _then) = _$CropRectCopyWithImpl;
@useResult
$Res call({
 double left, double top, double width, double height
});




}
/// @nodoc
class _$CropRectCopyWithImpl<$Res>
    implements $CropRectCopyWith<$Res> {
  _$CropRectCopyWithImpl(this._self, this._then);

  final CropRect _self;
  final $Res Function(CropRect) _then;

/// Create a copy of CropRect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CropRect].
extension CropRectPatterns on CropRect {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CropRect value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CropRect() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CropRect value)  $default,){
final _that = this;
switch (_that) {
case _CropRect():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CropRect value)?  $default,){
final _that = this;
switch (_that) {
case _CropRect() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CropRect() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _CropRect():
return $default(_that.left,_that.top,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double left,  double top,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _CropRect() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CropRect implements CropRect {
  const _CropRect({required this.left, required this.top, required this.width, required this.height});
  factory _CropRect.fromJson(Map<String, dynamic> json) => _$CropRectFromJson(json);

@override final  double left;
@override final  double top;
@override final  double width;
@override final  double height;

/// Create a copy of CropRect
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CropRectCopyWith<_CropRect> get copyWith => __$CropRectCopyWithImpl<_CropRect>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CropRectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CropRect&&(identical(other.left, left) || other.left == left)&&(identical(other.top, top) || other.top == top)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,left,top,width,height);

@override
String toString() {
  return 'CropRect(left: $left, top: $top, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$CropRectCopyWith<$Res> implements $CropRectCopyWith<$Res> {
  factory _$CropRectCopyWith(_CropRect value, $Res Function(_CropRect) _then) = __$CropRectCopyWithImpl;
@override @useResult
$Res call({
 double left, double top, double width, double height
});




}
/// @nodoc
class __$CropRectCopyWithImpl<$Res>
    implements _$CropRectCopyWith<$Res> {
  __$CropRectCopyWithImpl(this._self, this._then);

  final _CropRect _self;
  final $Res Function(_CropRect) _then;

/// Create a copy of CropRect
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,}) {
  return _then(_CropRect(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$MediaEditState {

 CropRect? get cropRect; FilterPreset get filter; double get brightness; double get contrast; double get warmth;
/// Create a copy of MediaEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaEditStateCopyWith<MediaEditState> get copyWith => _$MediaEditStateCopyWithImpl<MediaEditState>(this as MediaEditState, _$identity);

  /// Serializes this MediaEditState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaEditState&&(identical(other.cropRect, cropRect) || other.cropRect == cropRect)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.brightness, brightness) || other.brightness == brightness)&&(identical(other.contrast, contrast) || other.contrast == contrast)&&(identical(other.warmth, warmth) || other.warmth == warmth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cropRect,filter,brightness,contrast,warmth);

@override
String toString() {
  return 'MediaEditState(cropRect: $cropRect, filter: $filter, brightness: $brightness, contrast: $contrast, warmth: $warmth)';
}


}

/// @nodoc
abstract mixin class $MediaEditStateCopyWith<$Res>  {
  factory $MediaEditStateCopyWith(MediaEditState value, $Res Function(MediaEditState) _then) = _$MediaEditStateCopyWithImpl;
@useResult
$Res call({
 CropRect? cropRect, FilterPreset filter, double brightness, double contrast, double warmth
});


$CropRectCopyWith<$Res>? get cropRect;

}
/// @nodoc
class _$MediaEditStateCopyWithImpl<$Res>
    implements $MediaEditStateCopyWith<$Res> {
  _$MediaEditStateCopyWithImpl(this._self, this._then);

  final MediaEditState _self;
  final $Res Function(MediaEditState) _then;

/// Create a copy of MediaEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cropRect = freezed,Object? filter = null,Object? brightness = null,Object? contrast = null,Object? warmth = null,}) {
  return _then(_self.copyWith(
cropRect: freezed == cropRect ? _self.cropRect : cropRect // ignore: cast_nullable_to_non_nullable
as CropRect?,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as FilterPreset,brightness: null == brightness ? _self.brightness : brightness // ignore: cast_nullable_to_non_nullable
as double,contrast: null == contrast ? _self.contrast : contrast // ignore: cast_nullable_to_non_nullable
as double,warmth: null == warmth ? _self.warmth : warmth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of MediaEditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CropRectCopyWith<$Res>? get cropRect {
    if (_self.cropRect == null) {
    return null;
  }

  return $CropRectCopyWith<$Res>(_self.cropRect!, (value) {
    return _then(_self.copyWith(cropRect: value));
  });
}
}


/// Adds pattern-matching-related methods to [MediaEditState].
extension MediaEditStatePatterns on MediaEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaEditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaEditState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaEditState value)  $default,){
final _that = this;
switch (_that) {
case _MediaEditState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaEditState value)?  $default,){
final _that = this;
switch (_that) {
case _MediaEditState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CropRect? cropRect,  FilterPreset filter,  double brightness,  double contrast,  double warmth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaEditState() when $default != null:
return $default(_that.cropRect,_that.filter,_that.brightness,_that.contrast,_that.warmth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CropRect? cropRect,  FilterPreset filter,  double brightness,  double contrast,  double warmth)  $default,) {final _that = this;
switch (_that) {
case _MediaEditState():
return $default(_that.cropRect,_that.filter,_that.brightness,_that.contrast,_that.warmth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CropRect? cropRect,  FilterPreset filter,  double brightness,  double contrast,  double warmth)?  $default,) {final _that = this;
switch (_that) {
case _MediaEditState() when $default != null:
return $default(_that.cropRect,_that.filter,_that.brightness,_that.contrast,_that.warmth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaEditState implements MediaEditState {
  const _MediaEditState({this.cropRect, this.filter = FilterPreset.original, this.brightness = 0.0, this.contrast = 0.0, this.warmth = 0.0});
  factory _MediaEditState.fromJson(Map<String, dynamic> json) => _$MediaEditStateFromJson(json);

@override final  CropRect? cropRect;
@override@JsonKey() final  FilterPreset filter;
@override@JsonKey() final  double brightness;
@override@JsonKey() final  double contrast;
@override@JsonKey() final  double warmth;

/// Create a copy of MediaEditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaEditStateCopyWith<_MediaEditState> get copyWith => __$MediaEditStateCopyWithImpl<_MediaEditState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaEditStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaEditState&&(identical(other.cropRect, cropRect) || other.cropRect == cropRect)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.brightness, brightness) || other.brightness == brightness)&&(identical(other.contrast, contrast) || other.contrast == contrast)&&(identical(other.warmth, warmth) || other.warmth == warmth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cropRect,filter,brightness,contrast,warmth);

@override
String toString() {
  return 'MediaEditState(cropRect: $cropRect, filter: $filter, brightness: $brightness, contrast: $contrast, warmth: $warmth)';
}


}

/// @nodoc
abstract mixin class _$MediaEditStateCopyWith<$Res> implements $MediaEditStateCopyWith<$Res> {
  factory _$MediaEditStateCopyWith(_MediaEditState value, $Res Function(_MediaEditState) _then) = __$MediaEditStateCopyWithImpl;
@override @useResult
$Res call({
 CropRect? cropRect, FilterPreset filter, double brightness, double contrast, double warmth
});


@override $CropRectCopyWith<$Res>? get cropRect;

}
/// @nodoc
class __$MediaEditStateCopyWithImpl<$Res>
    implements _$MediaEditStateCopyWith<$Res> {
  __$MediaEditStateCopyWithImpl(this._self, this._then);

  final _MediaEditState _self;
  final $Res Function(_MediaEditState) _then;

/// Create a copy of MediaEditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cropRect = freezed,Object? filter = null,Object? brightness = null,Object? contrast = null,Object? warmth = null,}) {
  return _then(_MediaEditState(
cropRect: freezed == cropRect ? _self.cropRect : cropRect // ignore: cast_nullable_to_non_nullable
as CropRect?,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as FilterPreset,brightness: null == brightness ? _self.brightness : brightness // ignore: cast_nullable_to_non_nullable
as double,contrast: null == contrast ? _self.contrast : contrast // ignore: cast_nullable_to_non_nullable
as double,warmth: null == warmth ? _self.warmth : warmth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of MediaEditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CropRectCopyWith<$Res>? get cropRect {
    if (_self.cropRect == null) {
    return null;
  }

  return $CropRectCopyWith<$Res>(_self.cropRect!, (value) {
    return _then(_self.copyWith(cropRect: value));
  });
}
}

// dart format on
