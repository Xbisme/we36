// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComposeDraft {

 String get id; String get idempotencyKey; DateTime get createdAt; List<SelectedMediaItem> get items; String get caption; PostMetadata get metadata;
/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeDraftCopyWith<ComposeDraft> get copyWith => _$ComposeDraftCopyWithImpl<ComposeDraft>(this as ComposeDraft, _$identity);

  /// Serializes this ComposeDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idempotencyKey,createdAt,const DeepCollectionEquality().hash(items),caption,metadata);

@override
String toString() {
  return 'ComposeDraft(id: $id, idempotencyKey: $idempotencyKey, createdAt: $createdAt, items: $items, caption: $caption, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ComposeDraftCopyWith<$Res>  {
  factory $ComposeDraftCopyWith(ComposeDraft value, $Res Function(ComposeDraft) _then) = _$ComposeDraftCopyWithImpl;
@useResult
$Res call({
 String id, String idempotencyKey, DateTime createdAt, List<SelectedMediaItem> items, String caption, PostMetadata metadata
});


$PostMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$ComposeDraftCopyWithImpl<$Res>
    implements $ComposeDraftCopyWith<$Res> {
  _$ComposeDraftCopyWithImpl(this._self, this._then);

  final ComposeDraft _self;
  final $Res Function(ComposeDraft) _then;

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idempotencyKey = null,Object? createdAt = null,Object? items = null,Object? caption = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SelectedMediaItem>,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PostMetadata,
  ));
}
/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostMetadataCopyWith<$Res> get metadata {
  
  return $PostMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComposeDraft].
extension ComposeDraftPatterns on ComposeDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComposeDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComposeDraft value)  $default,){
final _that = this;
switch (_that) {
case _ComposeDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComposeDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String idempotencyKey,  DateTime createdAt,  List<SelectedMediaItem> items,  String caption,  PostMetadata metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
return $default(_that.id,_that.idempotencyKey,_that.createdAt,_that.items,_that.caption,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String idempotencyKey,  DateTime createdAt,  List<SelectedMediaItem> items,  String caption,  PostMetadata metadata)  $default,) {final _that = this;
switch (_that) {
case _ComposeDraft():
return $default(_that.id,_that.idempotencyKey,_that.createdAt,_that.items,_that.caption,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String idempotencyKey,  DateTime createdAt,  List<SelectedMediaItem> items,  String caption,  PostMetadata metadata)?  $default,) {final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
return $default(_that.id,_that.idempotencyKey,_that.createdAt,_that.items,_that.caption,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComposeDraft extends ComposeDraft {
  const _ComposeDraft({required this.id, required this.idempotencyKey, required this.createdAt, final  List<SelectedMediaItem> items = const <SelectedMediaItem>[], this.caption = '', this.metadata = const PostMetadata()}): _items = items,super._();
  factory _ComposeDraft.fromJson(Map<String, dynamic> json) => _$ComposeDraftFromJson(json);

@override final  String id;
@override final  String idempotencyKey;
@override final  DateTime createdAt;
 final  List<SelectedMediaItem> _items;
@override@JsonKey() List<SelectedMediaItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String caption;
@override@JsonKey() final  PostMetadata metadata;

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComposeDraftCopyWith<_ComposeDraft> get copyWith => __$ComposeDraftCopyWithImpl<_ComposeDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComposeDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComposeDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idempotencyKey,createdAt,const DeepCollectionEquality().hash(_items),caption,metadata);

@override
String toString() {
  return 'ComposeDraft(id: $id, idempotencyKey: $idempotencyKey, createdAt: $createdAt, items: $items, caption: $caption, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ComposeDraftCopyWith<$Res> implements $ComposeDraftCopyWith<$Res> {
  factory _$ComposeDraftCopyWith(_ComposeDraft value, $Res Function(_ComposeDraft) _then) = __$ComposeDraftCopyWithImpl;
@override @useResult
$Res call({
 String id, String idempotencyKey, DateTime createdAt, List<SelectedMediaItem> items, String caption, PostMetadata metadata
});


@override $PostMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$ComposeDraftCopyWithImpl<$Res>
    implements _$ComposeDraftCopyWith<$Res> {
  __$ComposeDraftCopyWithImpl(this._self, this._then);

  final _ComposeDraft _self;
  final $Res Function(_ComposeDraft) _then;

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idempotencyKey = null,Object? createdAt = null,Object? items = null,Object? caption = null,Object? metadata = null,}) {
  return _then(_ComposeDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SelectedMediaItem>,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PostMetadata,
  ));
}

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostMetadataCopyWith<$Res> get metadata {
  
  return $PostMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
