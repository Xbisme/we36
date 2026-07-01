// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_media_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SelectedMediaItem {

 String get assetId; int get order; MediaEditState get edit;
/// Create a copy of SelectedMediaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedMediaItemCopyWith<SelectedMediaItem> get copyWith => _$SelectedMediaItemCopyWithImpl<SelectedMediaItem>(this as SelectedMediaItem, _$identity);

  /// Serializes this SelectedMediaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedMediaItem&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.order, order) || other.order == order)&&(identical(other.edit, edit) || other.edit == edit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,order,edit);

@override
String toString() {
  return 'SelectedMediaItem(assetId: $assetId, order: $order, edit: $edit)';
}


}

/// @nodoc
abstract mixin class $SelectedMediaItemCopyWith<$Res>  {
  factory $SelectedMediaItemCopyWith(SelectedMediaItem value, $Res Function(SelectedMediaItem) _then) = _$SelectedMediaItemCopyWithImpl;
@useResult
$Res call({
 String assetId, int order, MediaEditState edit
});


$MediaEditStateCopyWith<$Res> get edit;

}
/// @nodoc
class _$SelectedMediaItemCopyWithImpl<$Res>
    implements $SelectedMediaItemCopyWith<$Res> {
  _$SelectedMediaItemCopyWithImpl(this._self, this._then);

  final SelectedMediaItem _self;
  final $Res Function(SelectedMediaItem) _then;

/// Create a copy of SelectedMediaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? order = null,Object? edit = null,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,edit: null == edit ? _self.edit : edit // ignore: cast_nullable_to_non_nullable
as MediaEditState,
  ));
}
/// Create a copy of SelectedMediaItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaEditStateCopyWith<$Res> get edit {
  
  return $MediaEditStateCopyWith<$Res>(_self.edit, (value) {
    return _then(_self.copyWith(edit: value));
  });
}
}


/// Adds pattern-matching-related methods to [SelectedMediaItem].
extension SelectedMediaItemPatterns on SelectedMediaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedMediaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedMediaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedMediaItem value)  $default,){
final _that = this;
switch (_that) {
case _SelectedMediaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedMediaItem value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedMediaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assetId,  int order,  MediaEditState edit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedMediaItem() when $default != null:
return $default(_that.assetId,_that.order,_that.edit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assetId,  int order,  MediaEditState edit)  $default,) {final _that = this;
switch (_that) {
case _SelectedMediaItem():
return $default(_that.assetId,_that.order,_that.edit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assetId,  int order,  MediaEditState edit)?  $default,) {final _that = this;
switch (_that) {
case _SelectedMediaItem() when $default != null:
return $default(_that.assetId,_that.order,_that.edit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SelectedMediaItem implements SelectedMediaItem {
  const _SelectedMediaItem({required this.assetId, required this.order, this.edit = const MediaEditState()});
  factory _SelectedMediaItem.fromJson(Map<String, dynamic> json) => _$SelectedMediaItemFromJson(json);

@override final  String assetId;
@override final  int order;
@override@JsonKey() final  MediaEditState edit;

/// Create a copy of SelectedMediaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedMediaItemCopyWith<_SelectedMediaItem> get copyWith => __$SelectedMediaItemCopyWithImpl<_SelectedMediaItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SelectedMediaItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedMediaItem&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.order, order) || other.order == order)&&(identical(other.edit, edit) || other.edit == edit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,order,edit);

@override
String toString() {
  return 'SelectedMediaItem(assetId: $assetId, order: $order, edit: $edit)';
}


}

/// @nodoc
abstract mixin class _$SelectedMediaItemCopyWith<$Res> implements $SelectedMediaItemCopyWith<$Res> {
  factory _$SelectedMediaItemCopyWith(_SelectedMediaItem value, $Res Function(_SelectedMediaItem) _then) = __$SelectedMediaItemCopyWithImpl;
@override @useResult
$Res call({
 String assetId, int order, MediaEditState edit
});


@override $MediaEditStateCopyWith<$Res> get edit;

}
/// @nodoc
class __$SelectedMediaItemCopyWithImpl<$Res>
    implements _$SelectedMediaItemCopyWith<$Res> {
  __$SelectedMediaItemCopyWithImpl(this._self, this._then);

  final _SelectedMediaItem _self;
  final $Res Function(_SelectedMediaItem) _then;

/// Create a copy of SelectedMediaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? order = null,Object? edit = null,}) {
  return _then(_SelectedMediaItem(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,edit: null == edit ? _self.edit : edit // ignore: cast_nullable_to_non_nullable
as MediaEditState,
  ));
}

/// Create a copy of SelectedMediaItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaEditStateCopyWith<$Res> get edit {
  
  return $MediaEditStateCopyWith<$Res>(_self.edit, (value) {
    return _then(_self.copyWith(edit: value));
  });
}
}

// dart format on
