// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_collections_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectionPickerRow {

 SavedCollection get collection; bool get contains;
/// Create a copy of CollectionPickerRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionPickerRowCopyWith<CollectionPickerRow> get copyWith => _$CollectionPickerRowCopyWithImpl<CollectionPickerRow>(this as CollectionPickerRow, _$identity);

  /// Serializes this CollectionPickerRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionPickerRow&&(identical(other.collection, collection) || other.collection == collection)&&(identical(other.contains, contains) || other.contains == contains));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,collection,contains);

@override
String toString() {
  return 'CollectionPickerRow(collection: $collection, contains: $contains)';
}


}

/// @nodoc
abstract mixin class $CollectionPickerRowCopyWith<$Res>  {
  factory $CollectionPickerRowCopyWith(CollectionPickerRow value, $Res Function(CollectionPickerRow) _then) = _$CollectionPickerRowCopyWithImpl;
@useResult
$Res call({
 SavedCollection collection, bool contains
});


$SavedCollectionCopyWith<$Res> get collection;

}
/// @nodoc
class _$CollectionPickerRowCopyWithImpl<$Res>
    implements $CollectionPickerRowCopyWith<$Res> {
  _$CollectionPickerRowCopyWithImpl(this._self, this._then);

  final CollectionPickerRow _self;
  final $Res Function(CollectionPickerRow) _then;

/// Create a copy of CollectionPickerRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? collection = null,Object? contains = null,}) {
  return _then(_self.copyWith(
collection: null == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as SavedCollection,contains: null == contains ? _self.contains : contains // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CollectionPickerRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedCollectionCopyWith<$Res> get collection {
  
  return $SavedCollectionCopyWith<$Res>(_self.collection, (value) {
    return _then(_self.copyWith(collection: value));
  });
}
}


/// Adds pattern-matching-related methods to [CollectionPickerRow].
extension CollectionPickerRowPatterns on CollectionPickerRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionPickerRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionPickerRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionPickerRow value)  $default,){
final _that = this;
switch (_that) {
case _CollectionPickerRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionPickerRow value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionPickerRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SavedCollection collection,  bool contains)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionPickerRow() when $default != null:
return $default(_that.collection,_that.contains);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SavedCollection collection,  bool contains)  $default,) {final _that = this;
switch (_that) {
case _CollectionPickerRow():
return $default(_that.collection,_that.contains);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SavedCollection collection,  bool contains)?  $default,) {final _that = this;
switch (_that) {
case _CollectionPickerRow() when $default != null:
return $default(_that.collection,_that.contains);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionPickerRow implements CollectionPickerRow {
  const _CollectionPickerRow({required this.collection, required this.contains});
  factory _CollectionPickerRow.fromJson(Map<String, dynamic> json) => _$CollectionPickerRowFromJson(json);

@override final  SavedCollection collection;
@override final  bool contains;

/// Create a copy of CollectionPickerRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionPickerRowCopyWith<_CollectionPickerRow> get copyWith => __$CollectionPickerRowCopyWithImpl<_CollectionPickerRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionPickerRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionPickerRow&&(identical(other.collection, collection) || other.collection == collection)&&(identical(other.contains, contains) || other.contains == contains));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,collection,contains);

@override
String toString() {
  return 'CollectionPickerRow(collection: $collection, contains: $contains)';
}


}

/// @nodoc
abstract mixin class _$CollectionPickerRowCopyWith<$Res> implements $CollectionPickerRowCopyWith<$Res> {
  factory _$CollectionPickerRowCopyWith(_CollectionPickerRow value, $Res Function(_CollectionPickerRow) _then) = __$CollectionPickerRowCopyWithImpl;
@override @useResult
$Res call({
 SavedCollection collection, bool contains
});


@override $SavedCollectionCopyWith<$Res> get collection;

}
/// @nodoc
class __$CollectionPickerRowCopyWithImpl<$Res>
    implements _$CollectionPickerRowCopyWith<$Res> {
  __$CollectionPickerRowCopyWithImpl(this._self, this._then);

  final _CollectionPickerRow _self;
  final $Res Function(_CollectionPickerRow) _then;

/// Create a copy of CollectionPickerRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? collection = null,Object? contains = null,}) {
  return _then(_CollectionPickerRow(
collection: null == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as SavedCollection,contains: null == contains ? _self.contains : contains // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CollectionPickerRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedCollectionCopyWith<$Res> get collection {
  
  return $SavedCollectionCopyWith<$Res>(_self.collection, (value) {
    return _then(_self.copyWith(collection: value));
  });
}
}


/// @nodoc
mixin _$PostCollectionsMembership {

 String get postId; bool get isSaved; List<CollectionPickerRow> get collections;
/// Create a copy of PostCollectionsMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCollectionsMembershipCopyWith<PostCollectionsMembership> get copyWith => _$PostCollectionsMembershipCopyWithImpl<PostCollectionsMembership>(this as PostCollectionsMembership, _$identity);

  /// Serializes this PostCollectionsMembership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCollectionsMembership&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&const DeepCollectionEquality().equals(other.collections, collections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,isSaved,const DeepCollectionEquality().hash(collections));

@override
String toString() {
  return 'PostCollectionsMembership(postId: $postId, isSaved: $isSaved, collections: $collections)';
}


}

/// @nodoc
abstract mixin class $PostCollectionsMembershipCopyWith<$Res>  {
  factory $PostCollectionsMembershipCopyWith(PostCollectionsMembership value, $Res Function(PostCollectionsMembership) _then) = _$PostCollectionsMembershipCopyWithImpl;
@useResult
$Res call({
 String postId, bool isSaved, List<CollectionPickerRow> collections
});




}
/// @nodoc
class _$PostCollectionsMembershipCopyWithImpl<$Res>
    implements $PostCollectionsMembershipCopyWith<$Res> {
  _$PostCollectionsMembershipCopyWithImpl(this._self, this._then);

  final PostCollectionsMembership _self;
  final $Res Function(PostCollectionsMembership) _then;

/// Create a copy of PostCollectionsMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postId = null,Object? isSaved = null,Object? collections = null,}) {
  return _then(_self.copyWith(
postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,collections: null == collections ? _self.collections : collections // ignore: cast_nullable_to_non_nullable
as List<CollectionPickerRow>,
  ));
}

}


/// Adds pattern-matching-related methods to [PostCollectionsMembership].
extension PostCollectionsMembershipPatterns on PostCollectionsMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostCollectionsMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostCollectionsMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostCollectionsMembership value)  $default,){
final _that = this;
switch (_that) {
case _PostCollectionsMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostCollectionsMembership value)?  $default,){
final _that = this;
switch (_that) {
case _PostCollectionsMembership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String postId,  bool isSaved,  List<CollectionPickerRow> collections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostCollectionsMembership() when $default != null:
return $default(_that.postId,_that.isSaved,_that.collections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String postId,  bool isSaved,  List<CollectionPickerRow> collections)  $default,) {final _that = this;
switch (_that) {
case _PostCollectionsMembership():
return $default(_that.postId,_that.isSaved,_that.collections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String postId,  bool isSaved,  List<CollectionPickerRow> collections)?  $default,) {final _that = this;
switch (_that) {
case _PostCollectionsMembership() when $default != null:
return $default(_that.postId,_that.isSaved,_that.collections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostCollectionsMembership extends PostCollectionsMembership {
  const _PostCollectionsMembership({required this.postId, required this.isSaved, final  List<CollectionPickerRow> collections = const <CollectionPickerRow>[]}): _collections = collections,super._();
  factory _PostCollectionsMembership.fromJson(Map<String, dynamic> json) => _$PostCollectionsMembershipFromJson(json);

@override final  String postId;
@override final  bool isSaved;
 final  List<CollectionPickerRow> _collections;
@override@JsonKey() List<CollectionPickerRow> get collections {
  if (_collections is EqualUnmodifiableListView) return _collections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_collections);
}


/// Create a copy of PostCollectionsMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCollectionsMembershipCopyWith<_PostCollectionsMembership> get copyWith => __$PostCollectionsMembershipCopyWithImpl<_PostCollectionsMembership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCollectionsMembershipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostCollectionsMembership&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&const DeepCollectionEquality().equals(other._collections, _collections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,isSaved,const DeepCollectionEquality().hash(_collections));

@override
String toString() {
  return 'PostCollectionsMembership(postId: $postId, isSaved: $isSaved, collections: $collections)';
}


}

/// @nodoc
abstract mixin class _$PostCollectionsMembershipCopyWith<$Res> implements $PostCollectionsMembershipCopyWith<$Res> {
  factory _$PostCollectionsMembershipCopyWith(_PostCollectionsMembership value, $Res Function(_PostCollectionsMembership) _then) = __$PostCollectionsMembershipCopyWithImpl;
@override @useResult
$Res call({
 String postId, bool isSaved, List<CollectionPickerRow> collections
});




}
/// @nodoc
class __$PostCollectionsMembershipCopyWithImpl<$Res>
    implements _$PostCollectionsMembershipCopyWith<$Res> {
  __$PostCollectionsMembershipCopyWithImpl(this._self, this._then);

  final _PostCollectionsMembership _self;
  final $Res Function(_PostCollectionsMembership) _then;

/// Create a copy of PostCollectionsMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postId = null,Object? isSaved = null,Object? collections = null,}) {
  return _then(_PostCollectionsMembership(
postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,collections: null == collections ? _self._collections : collections // ignore: cast_nullable_to_non_nullable
as List<CollectionPickerRow>,
  ));
}


}

// dart format on
