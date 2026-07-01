// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_compose_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryComposeDraft {

 String get assetId; String get idempotencyKey; List<StoryTextOverlay> get textOverlays; List<StoryStickerOverlay> get stickerOverlays; StoryAudience get audience;
/// Create a copy of StoryComposeDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryComposeDraftCopyWith<StoryComposeDraft> get copyWith => _$StoryComposeDraftCopyWithImpl<StoryComposeDraft>(this as StoryComposeDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryComposeDraft&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&const DeepCollectionEquality().equals(other.textOverlays, textOverlays)&&const DeepCollectionEquality().equals(other.stickerOverlays, stickerOverlays)&&(identical(other.audience, audience) || other.audience == audience));
}


@override
int get hashCode => Object.hash(runtimeType,assetId,idempotencyKey,const DeepCollectionEquality().hash(textOverlays),const DeepCollectionEquality().hash(stickerOverlays),audience);

@override
String toString() {
  return 'StoryComposeDraft(assetId: $assetId, idempotencyKey: $idempotencyKey, textOverlays: $textOverlays, stickerOverlays: $stickerOverlays, audience: $audience)';
}


}

/// @nodoc
abstract mixin class $StoryComposeDraftCopyWith<$Res>  {
  factory $StoryComposeDraftCopyWith(StoryComposeDraft value, $Res Function(StoryComposeDraft) _then) = _$StoryComposeDraftCopyWithImpl;
@useResult
$Res call({
 String assetId, String idempotencyKey, List<StoryTextOverlay> textOverlays, List<StoryStickerOverlay> stickerOverlays, StoryAudience audience
});




}
/// @nodoc
class _$StoryComposeDraftCopyWithImpl<$Res>
    implements $StoryComposeDraftCopyWith<$Res> {
  _$StoryComposeDraftCopyWithImpl(this._self, this._then);

  final StoryComposeDraft _self;
  final $Res Function(StoryComposeDraft) _then;

/// Create a copy of StoryComposeDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? idempotencyKey = null,Object? textOverlays = null,Object? stickerOverlays = null,Object? audience = null,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,textOverlays: null == textOverlays ? _self.textOverlays : textOverlays // ignore: cast_nullable_to_non_nullable
as List<StoryTextOverlay>,stickerOverlays: null == stickerOverlays ? _self.stickerOverlays : stickerOverlays // ignore: cast_nullable_to_non_nullable
as List<StoryStickerOverlay>,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as StoryAudience,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryComposeDraft].
extension StoryComposeDraftPatterns on StoryComposeDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryComposeDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryComposeDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryComposeDraft value)  $default,){
final _that = this;
switch (_that) {
case _StoryComposeDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryComposeDraft value)?  $default,){
final _that = this;
switch (_that) {
case _StoryComposeDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assetId,  String idempotencyKey,  List<StoryTextOverlay> textOverlays,  List<StoryStickerOverlay> stickerOverlays,  StoryAudience audience)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryComposeDraft() when $default != null:
return $default(_that.assetId,_that.idempotencyKey,_that.textOverlays,_that.stickerOverlays,_that.audience);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assetId,  String idempotencyKey,  List<StoryTextOverlay> textOverlays,  List<StoryStickerOverlay> stickerOverlays,  StoryAudience audience)  $default,) {final _that = this;
switch (_that) {
case _StoryComposeDraft():
return $default(_that.assetId,_that.idempotencyKey,_that.textOverlays,_that.stickerOverlays,_that.audience);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assetId,  String idempotencyKey,  List<StoryTextOverlay> textOverlays,  List<StoryStickerOverlay> stickerOverlays,  StoryAudience audience)?  $default,) {final _that = this;
switch (_that) {
case _StoryComposeDraft() when $default != null:
return $default(_that.assetId,_that.idempotencyKey,_that.textOverlays,_that.stickerOverlays,_that.audience);case _:
  return null;

}
}

}

/// @nodoc


class _StoryComposeDraft extends StoryComposeDraft {
  const _StoryComposeDraft({required this.assetId, required this.idempotencyKey, final  List<StoryTextOverlay> textOverlays = const <StoryTextOverlay>[], final  List<StoryStickerOverlay> stickerOverlays = const <StoryStickerOverlay>[], this.audience = StoryAudience.yourStory}): _textOverlays = textOverlays,_stickerOverlays = stickerOverlays,super._();
  

@override final  String assetId;
@override final  String idempotencyKey;
 final  List<StoryTextOverlay> _textOverlays;
@override@JsonKey() List<StoryTextOverlay> get textOverlays {
  if (_textOverlays is EqualUnmodifiableListView) return _textOverlays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_textOverlays);
}

 final  List<StoryStickerOverlay> _stickerOverlays;
@override@JsonKey() List<StoryStickerOverlay> get stickerOverlays {
  if (_stickerOverlays is EqualUnmodifiableListView) return _stickerOverlays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stickerOverlays);
}

@override@JsonKey() final  StoryAudience audience;

/// Create a copy of StoryComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryComposeDraftCopyWith<_StoryComposeDraft> get copyWith => __$StoryComposeDraftCopyWithImpl<_StoryComposeDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryComposeDraft&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&const DeepCollectionEquality().equals(other._textOverlays, _textOverlays)&&const DeepCollectionEquality().equals(other._stickerOverlays, _stickerOverlays)&&(identical(other.audience, audience) || other.audience == audience));
}


@override
int get hashCode => Object.hash(runtimeType,assetId,idempotencyKey,const DeepCollectionEquality().hash(_textOverlays),const DeepCollectionEquality().hash(_stickerOverlays),audience);

@override
String toString() {
  return 'StoryComposeDraft(assetId: $assetId, idempotencyKey: $idempotencyKey, textOverlays: $textOverlays, stickerOverlays: $stickerOverlays, audience: $audience)';
}


}

/// @nodoc
abstract mixin class _$StoryComposeDraftCopyWith<$Res> implements $StoryComposeDraftCopyWith<$Res> {
  factory _$StoryComposeDraftCopyWith(_StoryComposeDraft value, $Res Function(_StoryComposeDraft) _then) = __$StoryComposeDraftCopyWithImpl;
@override @useResult
$Res call({
 String assetId, String idempotencyKey, List<StoryTextOverlay> textOverlays, List<StoryStickerOverlay> stickerOverlays, StoryAudience audience
});




}
/// @nodoc
class __$StoryComposeDraftCopyWithImpl<$Res>
    implements _$StoryComposeDraftCopyWith<$Res> {
  __$StoryComposeDraftCopyWithImpl(this._self, this._then);

  final _StoryComposeDraft _self;
  final $Res Function(_StoryComposeDraft) _then;

/// Create a copy of StoryComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? idempotencyKey = null,Object? textOverlays = null,Object? stickerOverlays = null,Object? audience = null,}) {
  return _then(_StoryComposeDraft(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,textOverlays: null == textOverlays ? _self._textOverlays : textOverlays // ignore: cast_nullable_to_non_nullable
as List<StoryTextOverlay>,stickerOverlays: null == stickerOverlays ? _self._stickerOverlays : stickerOverlays // ignore: cast_nullable_to_non_nullable
as List<StoryStickerOverlay>,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as StoryAudience,
  ));
}


}

// dart format on
