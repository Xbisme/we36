// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_text_overlay.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryTextOverlay {

 String get id; String get text;/// A key into the small fixed set of token-driven text styles/colors.
 String get styleId; double get dx; double get dy;
/// Create a copy of StoryTextOverlay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryTextOverlayCopyWith<StoryTextOverlay> get copyWith => _$StoryTextOverlayCopyWithImpl<StoryTextOverlay>(this as StoryTextOverlay, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryTextOverlay&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.styleId, styleId) || other.styleId == styleId)&&(identical(other.dx, dx) || other.dx == dx)&&(identical(other.dy, dy) || other.dy == dy));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,styleId,dx,dy);

@override
String toString() {
  return 'StoryTextOverlay(id: $id, text: $text, styleId: $styleId, dx: $dx, dy: $dy)';
}


}

/// @nodoc
abstract mixin class $StoryTextOverlayCopyWith<$Res>  {
  factory $StoryTextOverlayCopyWith(StoryTextOverlay value, $Res Function(StoryTextOverlay) _then) = _$StoryTextOverlayCopyWithImpl;
@useResult
$Res call({
 String id, String text, String styleId, double dx, double dy
});




}
/// @nodoc
class _$StoryTextOverlayCopyWithImpl<$Res>
    implements $StoryTextOverlayCopyWith<$Res> {
  _$StoryTextOverlayCopyWithImpl(this._self, this._then);

  final StoryTextOverlay _self;
  final $Res Function(StoryTextOverlay) _then;

/// Create a copy of StoryTextOverlay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? styleId = null,Object? dx = null,Object? dy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,styleId: null == styleId ? _self.styleId : styleId // ignore: cast_nullable_to_non_nullable
as String,dx: null == dx ? _self.dx : dx // ignore: cast_nullable_to_non_nullable
as double,dy: null == dy ? _self.dy : dy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryTextOverlay].
extension StoryTextOverlayPatterns on StoryTextOverlay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryTextOverlay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryTextOverlay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryTextOverlay value)  $default,){
final _that = this;
switch (_that) {
case _StoryTextOverlay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryTextOverlay value)?  $default,){
final _that = this;
switch (_that) {
case _StoryTextOverlay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  String styleId,  double dx,  double dy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryTextOverlay() when $default != null:
return $default(_that.id,_that.text,_that.styleId,_that.dx,_that.dy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  String styleId,  double dx,  double dy)  $default,) {final _that = this;
switch (_that) {
case _StoryTextOverlay():
return $default(_that.id,_that.text,_that.styleId,_that.dx,_that.dy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  String styleId,  double dx,  double dy)?  $default,) {final _that = this;
switch (_that) {
case _StoryTextOverlay() when $default != null:
return $default(_that.id,_that.text,_that.styleId,_that.dx,_that.dy);case _:
  return null;

}
}

}

/// @nodoc


class _StoryTextOverlay implements StoryTextOverlay {
  const _StoryTextOverlay({required this.id, required this.text, required this.styleId, this.dx = 0.5, this.dy = 0.5});
  

@override final  String id;
@override final  String text;
/// A key into the small fixed set of token-driven text styles/colors.
@override final  String styleId;
@override@JsonKey() final  double dx;
@override@JsonKey() final  double dy;

/// Create a copy of StoryTextOverlay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryTextOverlayCopyWith<_StoryTextOverlay> get copyWith => __$StoryTextOverlayCopyWithImpl<_StoryTextOverlay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryTextOverlay&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.styleId, styleId) || other.styleId == styleId)&&(identical(other.dx, dx) || other.dx == dx)&&(identical(other.dy, dy) || other.dy == dy));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,styleId,dx,dy);

@override
String toString() {
  return 'StoryTextOverlay(id: $id, text: $text, styleId: $styleId, dx: $dx, dy: $dy)';
}


}

/// @nodoc
abstract mixin class _$StoryTextOverlayCopyWith<$Res> implements $StoryTextOverlayCopyWith<$Res> {
  factory _$StoryTextOverlayCopyWith(_StoryTextOverlay value, $Res Function(_StoryTextOverlay) _then) = __$StoryTextOverlayCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, String styleId, double dx, double dy
});




}
/// @nodoc
class __$StoryTextOverlayCopyWithImpl<$Res>
    implements _$StoryTextOverlayCopyWith<$Res> {
  __$StoryTextOverlayCopyWithImpl(this._self, this._then);

  final _StoryTextOverlay _self;
  final $Res Function(_StoryTextOverlay) _then;

/// Create a copy of StoryTextOverlay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? styleId = null,Object? dx = null,Object? dy = null,}) {
  return _then(_StoryTextOverlay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,styleId: null == styleId ? _self.styleId : styleId // ignore: cast_nullable_to_non_nullable
as String,dx: null == dx ? _self.dx : dx // ignore: cast_nullable_to_non_nullable
as double,dy: null == dy ? _self.dy : dy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
