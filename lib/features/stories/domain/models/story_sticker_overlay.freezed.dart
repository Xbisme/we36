// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_sticker_overlay.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryStickerOverlay {

 String get id; String get assetKey; double get dx; double get dy;
/// Create a copy of StoryStickerOverlay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryStickerOverlayCopyWith<StoryStickerOverlay> get copyWith => _$StoryStickerOverlayCopyWithImpl<StoryStickerOverlay>(this as StoryStickerOverlay, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryStickerOverlay&&(identical(other.id, id) || other.id == id)&&(identical(other.assetKey, assetKey) || other.assetKey == assetKey)&&(identical(other.dx, dx) || other.dx == dx)&&(identical(other.dy, dy) || other.dy == dy));
}


@override
int get hashCode => Object.hash(runtimeType,id,assetKey,dx,dy);

@override
String toString() {
  return 'StoryStickerOverlay(id: $id, assetKey: $assetKey, dx: $dx, dy: $dy)';
}


}

/// @nodoc
abstract mixin class $StoryStickerOverlayCopyWith<$Res>  {
  factory $StoryStickerOverlayCopyWith(StoryStickerOverlay value, $Res Function(StoryStickerOverlay) _then) = _$StoryStickerOverlayCopyWithImpl;
@useResult
$Res call({
 String id, String assetKey, double dx, double dy
});




}
/// @nodoc
class _$StoryStickerOverlayCopyWithImpl<$Res>
    implements $StoryStickerOverlayCopyWith<$Res> {
  _$StoryStickerOverlayCopyWithImpl(this._self, this._then);

  final StoryStickerOverlay _self;
  final $Res Function(StoryStickerOverlay) _then;

/// Create a copy of StoryStickerOverlay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetKey = null,Object? dx = null,Object? dy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetKey: null == assetKey ? _self.assetKey : assetKey // ignore: cast_nullable_to_non_nullable
as String,dx: null == dx ? _self.dx : dx // ignore: cast_nullable_to_non_nullable
as double,dy: null == dy ? _self.dy : dy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryStickerOverlay].
extension StoryStickerOverlayPatterns on StoryStickerOverlay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryStickerOverlay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryStickerOverlay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryStickerOverlay value)  $default,){
final _that = this;
switch (_that) {
case _StoryStickerOverlay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryStickerOverlay value)?  $default,){
final _that = this;
switch (_that) {
case _StoryStickerOverlay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetKey,  double dx,  double dy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryStickerOverlay() when $default != null:
return $default(_that.id,_that.assetKey,_that.dx,_that.dy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetKey,  double dx,  double dy)  $default,) {final _that = this;
switch (_that) {
case _StoryStickerOverlay():
return $default(_that.id,_that.assetKey,_that.dx,_that.dy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetKey,  double dx,  double dy)?  $default,) {final _that = this;
switch (_that) {
case _StoryStickerOverlay() when $default != null:
return $default(_that.id,_that.assetKey,_that.dx,_that.dy);case _:
  return null;

}
}

}

/// @nodoc


class _StoryStickerOverlay implements StoryStickerOverlay {
  const _StoryStickerOverlay({required this.id, required this.assetKey, this.dx = 0.5, this.dy = 0.5});
  

@override final  String id;
@override final  String assetKey;
@override@JsonKey() final  double dx;
@override@JsonKey() final  double dy;

/// Create a copy of StoryStickerOverlay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryStickerOverlayCopyWith<_StoryStickerOverlay> get copyWith => __$StoryStickerOverlayCopyWithImpl<_StoryStickerOverlay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryStickerOverlay&&(identical(other.id, id) || other.id == id)&&(identical(other.assetKey, assetKey) || other.assetKey == assetKey)&&(identical(other.dx, dx) || other.dx == dx)&&(identical(other.dy, dy) || other.dy == dy));
}


@override
int get hashCode => Object.hash(runtimeType,id,assetKey,dx,dy);

@override
String toString() {
  return 'StoryStickerOverlay(id: $id, assetKey: $assetKey, dx: $dx, dy: $dy)';
}


}

/// @nodoc
abstract mixin class _$StoryStickerOverlayCopyWith<$Res> implements $StoryStickerOverlayCopyWith<$Res> {
  factory _$StoryStickerOverlayCopyWith(_StoryStickerOverlay value, $Res Function(_StoryStickerOverlay) _then) = __$StoryStickerOverlayCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetKey, double dx, double dy
});




}
/// @nodoc
class __$StoryStickerOverlayCopyWithImpl<$Res>
    implements _$StoryStickerOverlayCopyWith<$Res> {
  __$StoryStickerOverlayCopyWithImpl(this._self, this._then);

  final _StoryStickerOverlay _self;
  final $Res Function(_StoryStickerOverlay) _then;

/// Create a copy of StoryStickerOverlay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetKey = null,Object? dx = null,Object? dy = null,}) {
  return _then(_StoryStickerOverlay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetKey: null == assetKey ? _self.assetKey : assetKey // ignore: cast_nullable_to_non_nullable
as String,dx: null == dx ? _self.dx : dx // ignore: cast_nullable_to_non_nullable
as double,dy: null == dy ? _self.dy : dy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
