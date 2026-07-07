// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectionDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionDetailState()';
}


}

/// @nodoc
class $CollectionDetailStateCopyWith<$Res>  {
$CollectionDetailStateCopyWith(CollectionDetailState _, $Res Function(CollectionDetailState) __);
}


/// Adds pattern-matching-related methods to [CollectionDetailState].
extension CollectionDetailStatePatterns on CollectionDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CollectionDetailInitial value)?  initial,TResult Function( CollectionDetailLoading value)?  loading,TResult Function( CollectionDetailLoaded value)?  loaded,TResult Function( CollectionDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CollectionDetailInitial() when initial != null:
return initial(_that);case CollectionDetailLoading() when loading != null:
return loading(_that);case CollectionDetailLoaded() when loaded != null:
return loaded(_that);case CollectionDetailError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CollectionDetailInitial value)  initial,required TResult Function( CollectionDetailLoading value)  loading,required TResult Function( CollectionDetailLoaded value)  loaded,required TResult Function( CollectionDetailError value)  error,}){
final _that = this;
switch (_that) {
case CollectionDetailInitial():
return initial(_that);case CollectionDetailLoading():
return loading(_that);case CollectionDetailLoaded():
return loaded(_that);case CollectionDetailError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CollectionDetailInitial value)?  initial,TResult? Function( CollectionDetailLoading value)?  loading,TResult? Function( CollectionDetailLoaded value)?  loaded,TResult? Function( CollectionDetailError value)?  error,}){
final _that = this;
switch (_that) {
case CollectionDetailInitial() when initial != null:
return initial(_that);case CollectionDetailLoading() when loading != null:
return loading(_that);case CollectionDetailLoaded() when loaded != null:
return loaded(_that);case CollectionDetailError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ExploreItem> items,  bool hasMore,  bool loadingMore)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CollectionDetailInitial() when initial != null:
return initial();case CollectionDetailLoading() when loading != null:
return loading();case CollectionDetailLoaded() when loaded != null:
return loaded(_that.items,_that.hasMore,_that.loadingMore);case CollectionDetailError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ExploreItem> items,  bool hasMore,  bool loadingMore)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case CollectionDetailInitial():
return initial();case CollectionDetailLoading():
return loading();case CollectionDetailLoaded():
return loaded(_that.items,_that.hasMore,_that.loadingMore);case CollectionDetailError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ExploreItem> items,  bool hasMore,  bool loadingMore)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case CollectionDetailInitial() when initial != null:
return initial();case CollectionDetailLoading() when loading != null:
return loading();case CollectionDetailLoaded() when loaded != null:
return loaded(_that.items,_that.hasMore,_that.loadingMore);case CollectionDetailError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class CollectionDetailInitial implements CollectionDetailState {
  const CollectionDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionDetailState.initial()';
}


}




/// @nodoc


class CollectionDetailLoading implements CollectionDetailState {
  const CollectionDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionDetailState.loading()';
}


}




/// @nodoc


class CollectionDetailLoaded implements CollectionDetailState {
  const CollectionDetailLoaded({required final  List<ExploreItem> items, required this.hasMore, this.loadingMore = false}): _items = items;
  

 final  List<ExploreItem> _items;
 List<ExploreItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasMore;
@JsonKey() final  bool loadingMore;

/// Create a copy of CollectionDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionDetailLoadedCopyWith<CollectionDetailLoaded> get copyWith => _$CollectionDetailLoadedCopyWithImpl<CollectionDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionDetailLoaded&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore,loadingMore);

@override
String toString() {
  return 'CollectionDetailState.loaded(items: $items, hasMore: $hasMore, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $CollectionDetailLoadedCopyWith<$Res> implements $CollectionDetailStateCopyWith<$Res> {
  factory $CollectionDetailLoadedCopyWith(CollectionDetailLoaded value, $Res Function(CollectionDetailLoaded) _then) = _$CollectionDetailLoadedCopyWithImpl;
@useResult
$Res call({
 List<ExploreItem> items, bool hasMore, bool loadingMore
});




}
/// @nodoc
class _$CollectionDetailLoadedCopyWithImpl<$Res>
    implements $CollectionDetailLoadedCopyWith<$Res> {
  _$CollectionDetailLoadedCopyWithImpl(this._self, this._then);

  final CollectionDetailLoaded _self;
  final $Res Function(CollectionDetailLoaded) _then;

/// Create a copy of CollectionDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(CollectionDetailLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExploreItem>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CollectionDetailError implements CollectionDetailState {
  const CollectionDetailError(this.failure);
  

 final  AppFailure failure;

/// Create a copy of CollectionDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionDetailErrorCopyWith<CollectionDetailError> get copyWith => _$CollectionDetailErrorCopyWithImpl<CollectionDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionDetailError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CollectionDetailState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CollectionDetailErrorCopyWith<$Res> implements $CollectionDetailStateCopyWith<$Res> {
  factory $CollectionDetailErrorCopyWith(CollectionDetailError value, $Res Function(CollectionDetailError) _then) = _$CollectionDetailErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$CollectionDetailErrorCopyWithImpl<$Res>
    implements $CollectionDetailErrorCopyWith<$Res> {
  _$CollectionDetailErrorCopyWithImpl(this._self, this._then);

  final CollectionDetailError _self;
  final $Res Function(CollectionDetailError) _then;

/// Create a copy of CollectionDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CollectionDetailError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of CollectionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
