// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reel_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReelDraft {

 String get id; String get idempotencyKey; String get videoAssetId; int get videoDurationMs; String? get caption; bool get commentsDisabled; String? get locationName; List<String> get taggedUserIds;
/// Create a copy of ReelDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelDraftCopyWith<ReelDraft> get copyWith => _$ReelDraftCopyWithImpl<ReelDraft>(this as ReelDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.videoAssetId, videoAssetId) || other.videoAssetId == videoAssetId)&&(identical(other.videoDurationMs, videoDurationMs) || other.videoDurationMs == videoDurationMs)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&const DeepCollectionEquality().equals(other.taggedUserIds, taggedUserIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,idempotencyKey,videoAssetId,videoDurationMs,caption,commentsDisabled,locationName,const DeepCollectionEquality().hash(taggedUserIds));

@override
String toString() {
  return 'ReelDraft(id: $id, idempotencyKey: $idempotencyKey, videoAssetId: $videoAssetId, videoDurationMs: $videoDurationMs, caption: $caption, commentsDisabled: $commentsDisabled, locationName: $locationName, taggedUserIds: $taggedUserIds)';
}


}

/// @nodoc
abstract mixin class $ReelDraftCopyWith<$Res>  {
  factory $ReelDraftCopyWith(ReelDraft value, $Res Function(ReelDraft) _then) = _$ReelDraftCopyWithImpl;
@useResult
$Res call({
 String id, String idempotencyKey, String videoAssetId, int videoDurationMs, String? caption, bool commentsDisabled, String? locationName, List<String> taggedUserIds
});




}
/// @nodoc
class _$ReelDraftCopyWithImpl<$Res>
    implements $ReelDraftCopyWith<$Res> {
  _$ReelDraftCopyWithImpl(this._self, this._then);

  final ReelDraft _self;
  final $Res Function(ReelDraft) _then;

/// Create a copy of ReelDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idempotencyKey = null,Object? videoAssetId = null,Object? videoDurationMs = null,Object? caption = freezed,Object? commentsDisabled = null,Object? locationName = freezed,Object? taggedUserIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,videoAssetId: null == videoAssetId ? _self.videoAssetId : videoAssetId // ignore: cast_nullable_to_non_nullable
as String,videoDurationMs: null == videoDurationMs ? _self.videoDurationMs : videoDurationMs // ignore: cast_nullable_to_non_nullable
as int,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,taggedUserIds: null == taggedUserIds ? _self.taggedUserIds : taggedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReelDraft].
extension ReelDraftPatterns on ReelDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReelDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReelDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReelDraft value)  $default,){
final _that = this;
switch (_that) {
case _ReelDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReelDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ReelDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String idempotencyKey,  String videoAssetId,  int videoDurationMs,  String? caption,  bool commentsDisabled,  String? locationName,  List<String> taggedUserIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReelDraft() when $default != null:
return $default(_that.id,_that.idempotencyKey,_that.videoAssetId,_that.videoDurationMs,_that.caption,_that.commentsDisabled,_that.locationName,_that.taggedUserIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String idempotencyKey,  String videoAssetId,  int videoDurationMs,  String? caption,  bool commentsDisabled,  String? locationName,  List<String> taggedUserIds)  $default,) {final _that = this;
switch (_that) {
case _ReelDraft():
return $default(_that.id,_that.idempotencyKey,_that.videoAssetId,_that.videoDurationMs,_that.caption,_that.commentsDisabled,_that.locationName,_that.taggedUserIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String idempotencyKey,  String videoAssetId,  int videoDurationMs,  String? caption,  bool commentsDisabled,  String? locationName,  List<String> taggedUserIds)?  $default,) {final _that = this;
switch (_that) {
case _ReelDraft() when $default != null:
return $default(_that.id,_that.idempotencyKey,_that.videoAssetId,_that.videoDurationMs,_that.caption,_that.commentsDisabled,_that.locationName,_that.taggedUserIds);case _:
  return null;

}
}

}

/// @nodoc


class _ReelDraft implements ReelDraft {
  const _ReelDraft({required this.id, required this.idempotencyKey, required this.videoAssetId, required this.videoDurationMs, this.caption, this.commentsDisabled = false, this.locationName, final  List<String> taggedUserIds = const <String>[]}): _taggedUserIds = taggedUserIds;
  

@override final  String id;
@override final  String idempotencyKey;
@override final  String videoAssetId;
@override final  int videoDurationMs;
@override final  String? caption;
@override@JsonKey() final  bool commentsDisabled;
@override final  String? locationName;
 final  List<String> _taggedUserIds;
@override@JsonKey() List<String> get taggedUserIds {
  if (_taggedUserIds is EqualUnmodifiableListView) return _taggedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taggedUserIds);
}


/// Create a copy of ReelDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReelDraftCopyWith<_ReelDraft> get copyWith => __$ReelDraftCopyWithImpl<_ReelDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReelDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.videoAssetId, videoAssetId) || other.videoAssetId == videoAssetId)&&(identical(other.videoDurationMs, videoDurationMs) || other.videoDurationMs == videoDurationMs)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&const DeepCollectionEquality().equals(other._taggedUserIds, _taggedUserIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,idempotencyKey,videoAssetId,videoDurationMs,caption,commentsDisabled,locationName,const DeepCollectionEquality().hash(_taggedUserIds));

@override
String toString() {
  return 'ReelDraft(id: $id, idempotencyKey: $idempotencyKey, videoAssetId: $videoAssetId, videoDurationMs: $videoDurationMs, caption: $caption, commentsDisabled: $commentsDisabled, locationName: $locationName, taggedUserIds: $taggedUserIds)';
}


}

/// @nodoc
abstract mixin class _$ReelDraftCopyWith<$Res> implements $ReelDraftCopyWith<$Res> {
  factory _$ReelDraftCopyWith(_ReelDraft value, $Res Function(_ReelDraft) _then) = __$ReelDraftCopyWithImpl;
@override @useResult
$Res call({
 String id, String idempotencyKey, String videoAssetId, int videoDurationMs, String? caption, bool commentsDisabled, String? locationName, List<String> taggedUserIds
});




}
/// @nodoc
class __$ReelDraftCopyWithImpl<$Res>
    implements _$ReelDraftCopyWith<$Res> {
  __$ReelDraftCopyWithImpl(this._self, this._then);

  final _ReelDraft _self;
  final $Res Function(_ReelDraft) _then;

/// Create a copy of ReelDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idempotencyKey = null,Object? videoAssetId = null,Object? videoDurationMs = null,Object? caption = freezed,Object? commentsDisabled = null,Object? locationName = freezed,Object? taggedUserIds = null,}) {
  return _then(_ReelDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,videoAssetId: null == videoAssetId ? _self.videoAssetId : videoAssetId // ignore: cast_nullable_to_non_nullable
as String,videoDurationMs: null == videoDurationMs ? _self.videoDurationMs : videoDurationMs // ignore: cast_nullable_to_non_nullable
as int,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,taggedUserIds: null == taggedUserIds ? _self._taggedUserIds : taggedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
