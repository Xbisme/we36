// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedCollection {

 String get id; String get name; int get itemCount; DateTime get updatedAt; List<String> get coverRefs; bool get isDefault;
/// Create a copy of SavedCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedCollectionCopyWith<SavedCollection> get copyWith => _$SavedCollectionCopyWithImpl<SavedCollection>(this as SavedCollection, _$identity);

  /// Serializes this SavedCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.coverRefs, coverRefs)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,itemCount,updatedAt,const DeepCollectionEquality().hash(coverRefs),isDefault);

@override
String toString() {
  return 'SavedCollection(id: $id, name: $name, itemCount: $itemCount, updatedAt: $updatedAt, coverRefs: $coverRefs, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $SavedCollectionCopyWith<$Res>  {
  factory $SavedCollectionCopyWith(SavedCollection value, $Res Function(SavedCollection) _then) = _$SavedCollectionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int itemCount, DateTime updatedAt, List<String> coverRefs, bool isDefault
});




}
/// @nodoc
class _$SavedCollectionCopyWithImpl<$Res>
    implements $SavedCollectionCopyWith<$Res> {
  _$SavedCollectionCopyWithImpl(this._self, this._then);

  final SavedCollection _self;
  final $Res Function(SavedCollection) _then;

/// Create a copy of SavedCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? itemCount = null,Object? updatedAt = null,Object? coverRefs = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverRefs: null == coverRefs ? _self.coverRefs : coverRefs // ignore: cast_nullable_to_non_nullable
as List<String>,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedCollection].
extension SavedCollectionPatterns on SavedCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedCollection value)  $default,){
final _that = this;
switch (_that) {
case _SavedCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedCollection value)?  $default,){
final _that = this;
switch (_that) {
case _SavedCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int itemCount,  DateTime updatedAt,  List<String> coverRefs,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedCollection() when $default != null:
return $default(_that.id,_that.name,_that.itemCount,_that.updatedAt,_that.coverRefs,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int itemCount,  DateTime updatedAt,  List<String> coverRefs,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _SavedCollection():
return $default(_that.id,_that.name,_that.itemCount,_that.updatedAt,_that.coverRefs,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int itemCount,  DateTime updatedAt,  List<String> coverRefs,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _SavedCollection() when $default != null:
return $default(_that.id,_that.name,_that.itemCount,_that.updatedAt,_that.coverRefs,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedCollection extends SavedCollection {
  const _SavedCollection({required this.id, required this.name, required this.itemCount, required this.updatedAt, final  List<String> coverRefs = const <String>[], this.isDefault = false}): _coverRefs = coverRefs,super._();
  factory _SavedCollection.fromJson(Map<String, dynamic> json) => _$SavedCollectionFromJson(json);

@override final  String id;
@override final  String name;
@override final  int itemCount;
@override final  DateTime updatedAt;
 final  List<String> _coverRefs;
@override@JsonKey() List<String> get coverRefs {
  if (_coverRefs is EqualUnmodifiableListView) return _coverRefs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coverRefs);
}

@override@JsonKey() final  bool isDefault;

/// Create a copy of SavedCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedCollectionCopyWith<_SavedCollection> get copyWith => __$SavedCollectionCopyWithImpl<_SavedCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._coverRefs, _coverRefs)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,itemCount,updatedAt,const DeepCollectionEquality().hash(_coverRefs),isDefault);

@override
String toString() {
  return 'SavedCollection(id: $id, name: $name, itemCount: $itemCount, updatedAt: $updatedAt, coverRefs: $coverRefs, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$SavedCollectionCopyWith<$Res> implements $SavedCollectionCopyWith<$Res> {
  factory _$SavedCollectionCopyWith(_SavedCollection value, $Res Function(_SavedCollection) _then) = __$SavedCollectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int itemCount, DateTime updatedAt, List<String> coverRefs, bool isDefault
});




}
/// @nodoc
class __$SavedCollectionCopyWithImpl<$Res>
    implements _$SavedCollectionCopyWith<$Res> {
  __$SavedCollectionCopyWithImpl(this._self, this._then);

  final _SavedCollection _self;
  final $Res Function(_SavedCollection) _then;

/// Create a copy of SavedCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? itemCount = null,Object? updatedAt = null,Object? coverRefs = null,Object? isDefault = null,}) {
  return _then(_SavedCollection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverRefs: null == coverRefs ? _self._coverRefs : coverRefs // ignore: cast_nullable_to_non_nullable
as List<String>,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
