// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaceRef {

 String get label; String? get id;
/// Create a copy of PlaceRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceRefCopyWith<PlaceRef> get copyWith => _$PlaceRefCopyWithImpl<PlaceRef>(this as PlaceRef, _$identity);

  /// Serializes this PlaceRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceRef&&(identical(other.label, label) || other.label == label)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,id);

@override
String toString() {
  return 'PlaceRef(label: $label, id: $id)';
}


}

/// @nodoc
abstract mixin class $PlaceRefCopyWith<$Res>  {
  factory $PlaceRefCopyWith(PlaceRef value, $Res Function(PlaceRef) _then) = _$PlaceRefCopyWithImpl;
@useResult
$Res call({
 String label, String? id
});




}
/// @nodoc
class _$PlaceRefCopyWithImpl<$Res>
    implements $PlaceRefCopyWith<$Res> {
  _$PlaceRefCopyWithImpl(this._self, this._then);

  final PlaceRef _self;
  final $Res Function(PlaceRef) _then;

/// Create a copy of PlaceRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? id = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaceRef].
extension PlaceRefPatterns on PlaceRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceRef value)  $default,){
final _that = this;
switch (_that) {
case _PlaceRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceRef value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceRef() when $default != null:
return $default(_that.label,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String? id)  $default,) {final _that = this;
switch (_that) {
case _PlaceRef():
return $default(_that.label,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String? id)?  $default,) {final _that = this;
switch (_that) {
case _PlaceRef() when $default != null:
return $default(_that.label,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaceRef implements PlaceRef {
  const _PlaceRef({required this.label, this.id});
  factory _PlaceRef.fromJson(Map<String, dynamic> json) => _$PlaceRefFromJson(json);

@override final  String label;
@override final  String? id;

/// Create a copy of PlaceRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceRefCopyWith<_PlaceRef> get copyWith => __$PlaceRefCopyWithImpl<_PlaceRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceRef&&(identical(other.label, label) || other.label == label)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,id);

@override
String toString() {
  return 'PlaceRef(label: $label, id: $id)';
}


}

/// @nodoc
abstract mixin class _$PlaceRefCopyWith<$Res> implements $PlaceRefCopyWith<$Res> {
  factory _$PlaceRefCopyWith(_PlaceRef value, $Res Function(_PlaceRef) _then) = __$PlaceRefCopyWithImpl;
@override @useResult
$Res call({
 String label, String? id
});




}
/// @nodoc
class __$PlaceRefCopyWithImpl<$Res>
    implements _$PlaceRefCopyWith<$Res> {
  __$PlaceRefCopyWithImpl(this._self, this._then);

  final _PlaceRef _self;
  final $Res Function(_PlaceRef) _then;

/// Create a copy of PlaceRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? id = freezed,}) {
  return _then(_PlaceRef(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PostMetadata {

 List<String> get taggedUserIds; PlaceRef? get location; bool get commentsDisabled;
/// Create a copy of PostMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostMetadataCopyWith<PostMetadata> get copyWith => _$PostMetadataCopyWithImpl<PostMetadata>(this as PostMetadata, _$identity);

  /// Serializes this PostMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostMetadata&&const DeepCollectionEquality().equals(other.taggedUserIds, taggedUserIds)&&(identical(other.location, location) || other.location == location)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(taggedUserIds),location,commentsDisabled);

@override
String toString() {
  return 'PostMetadata(taggedUserIds: $taggedUserIds, location: $location, commentsDisabled: $commentsDisabled)';
}


}

/// @nodoc
abstract mixin class $PostMetadataCopyWith<$Res>  {
  factory $PostMetadataCopyWith(PostMetadata value, $Res Function(PostMetadata) _then) = _$PostMetadataCopyWithImpl;
@useResult
$Res call({
 List<String> taggedUserIds, PlaceRef? location, bool commentsDisabled
});


$PlaceRefCopyWith<$Res>? get location;

}
/// @nodoc
class _$PostMetadataCopyWithImpl<$Res>
    implements $PostMetadataCopyWith<$Res> {
  _$PostMetadataCopyWithImpl(this._self, this._then);

  final PostMetadata _self;
  final $Res Function(PostMetadata) _then;

/// Create a copy of PostMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taggedUserIds = null,Object? location = freezed,Object? commentsDisabled = null,}) {
  return _then(_self.copyWith(
taggedUserIds: null == taggedUserIds ? _self.taggedUserIds : taggedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as PlaceRef?,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PostMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceRefCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $PlaceRefCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostMetadata].
extension PostMetadataPatterns on PostMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostMetadata value)  $default,){
final _that = this;
switch (_that) {
case _PostMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _PostMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> taggedUserIds,  PlaceRef? location,  bool commentsDisabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostMetadata() when $default != null:
return $default(_that.taggedUserIds,_that.location,_that.commentsDisabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> taggedUserIds,  PlaceRef? location,  bool commentsDisabled)  $default,) {final _that = this;
switch (_that) {
case _PostMetadata():
return $default(_that.taggedUserIds,_that.location,_that.commentsDisabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> taggedUserIds,  PlaceRef? location,  bool commentsDisabled)?  $default,) {final _that = this;
switch (_that) {
case _PostMetadata() when $default != null:
return $default(_that.taggedUserIds,_that.location,_that.commentsDisabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostMetadata implements PostMetadata {
  const _PostMetadata({final  List<String> taggedUserIds = const <String>[], this.location, this.commentsDisabled = false}): _taggedUserIds = taggedUserIds;
  factory _PostMetadata.fromJson(Map<String, dynamic> json) => _$PostMetadataFromJson(json);

 final  List<String> _taggedUserIds;
@override@JsonKey() List<String> get taggedUserIds {
  if (_taggedUserIds is EqualUnmodifiableListView) return _taggedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taggedUserIds);
}

@override final  PlaceRef? location;
@override@JsonKey() final  bool commentsDisabled;

/// Create a copy of PostMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostMetadataCopyWith<_PostMetadata> get copyWith => __$PostMetadataCopyWithImpl<_PostMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostMetadata&&const DeepCollectionEquality().equals(other._taggedUserIds, _taggedUserIds)&&(identical(other.location, location) || other.location == location)&&(identical(other.commentsDisabled, commentsDisabled) || other.commentsDisabled == commentsDisabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_taggedUserIds),location,commentsDisabled);

@override
String toString() {
  return 'PostMetadata(taggedUserIds: $taggedUserIds, location: $location, commentsDisabled: $commentsDisabled)';
}


}

/// @nodoc
abstract mixin class _$PostMetadataCopyWith<$Res> implements $PostMetadataCopyWith<$Res> {
  factory _$PostMetadataCopyWith(_PostMetadata value, $Res Function(_PostMetadata) _then) = __$PostMetadataCopyWithImpl;
@override @useResult
$Res call({
 List<String> taggedUserIds, PlaceRef? location, bool commentsDisabled
});


@override $PlaceRefCopyWith<$Res>? get location;

}
/// @nodoc
class __$PostMetadataCopyWithImpl<$Res>
    implements _$PostMetadataCopyWith<$Res> {
  __$PostMetadataCopyWithImpl(this._self, this._then);

  final _PostMetadata _self;
  final $Res Function(_PostMetadata) _then;

/// Create a copy of PostMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taggedUserIds = null,Object? location = freezed,Object? commentsDisabled = null,}) {
  return _then(_PostMetadata(
taggedUserIds: null == taggedUserIds ? _self._taggedUserIds : taggedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as PlaceRef?,commentsDisabled: null == commentsDisabled ? _self.commentsDisabled : commentsDisabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PostMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceRefCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $PlaceRefCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
