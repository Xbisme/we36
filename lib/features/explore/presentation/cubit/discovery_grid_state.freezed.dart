// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_grid_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryGridState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryGridState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryGridState()';
}


}

/// @nodoc
class $DiscoveryGridStateCopyWith<$Res>  {
$DiscoveryGridStateCopyWith(DiscoveryGridState _, $Res Function(DiscoveryGridState) __);
}


/// Adds pattern-matching-related methods to [DiscoveryGridState].
extension DiscoveryGridStatePatterns on DiscoveryGridState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DiscoveryGridInitial value)?  initial,TResult Function( DiscoveryGridLoading value)?  loading,TResult Function( DiscoveryGridLoaded value)?  loaded,TResult Function( DiscoveryGridError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DiscoveryGridInitial() when initial != null:
return initial(_that);case DiscoveryGridLoading() when loading != null:
return loading(_that);case DiscoveryGridLoaded() when loaded != null:
return loaded(_that);case DiscoveryGridError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DiscoveryGridInitial value)  initial,required TResult Function( DiscoveryGridLoading value)  loading,required TResult Function( DiscoveryGridLoaded value)  loaded,required TResult Function( DiscoveryGridError value)  error,}){
final _that = this;
switch (_that) {
case DiscoveryGridInitial():
return initial(_that);case DiscoveryGridLoading():
return loading(_that);case DiscoveryGridLoaded():
return loaded(_that);case DiscoveryGridError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DiscoveryGridInitial value)?  initial,TResult? Function( DiscoveryGridLoading value)?  loading,TResult? Function( DiscoveryGridLoaded value)?  loaded,TResult? Function( DiscoveryGridError value)?  error,}){
final _that = this;
switch (_that) {
case DiscoveryGridInitial() when initial != null:
return initial(_that);case DiscoveryGridLoading() when loading != null:
return loading(_that);case DiscoveryGridLoaded() when loaded != null:
return loaded(_that);case DiscoveryGridError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( DiscoveryPageKind kind,  String title,  int postCount,  List<ExploreItem> items,  bool hasMore,  bool loadingMore)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DiscoveryGridInitial() when initial != null:
return initial();case DiscoveryGridLoading() when loading != null:
return loading();case DiscoveryGridLoaded() when loaded != null:
return loaded(_that.kind,_that.title,_that.postCount,_that.items,_that.hasMore,_that.loadingMore);case DiscoveryGridError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( DiscoveryPageKind kind,  String title,  int postCount,  List<ExploreItem> items,  bool hasMore,  bool loadingMore)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case DiscoveryGridInitial():
return initial();case DiscoveryGridLoading():
return loading();case DiscoveryGridLoaded():
return loaded(_that.kind,_that.title,_that.postCount,_that.items,_that.hasMore,_that.loadingMore);case DiscoveryGridError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( DiscoveryPageKind kind,  String title,  int postCount,  List<ExploreItem> items,  bool hasMore,  bool loadingMore)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case DiscoveryGridInitial() when initial != null:
return initial();case DiscoveryGridLoading() when loading != null:
return loading();case DiscoveryGridLoaded() when loaded != null:
return loaded(_that.kind,_that.title,_that.postCount,_that.items,_that.hasMore,_that.loadingMore);case DiscoveryGridError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DiscoveryGridInitial extends DiscoveryGridState {
  const DiscoveryGridInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryGridInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryGridState.initial()';
}


}




/// @nodoc


class DiscoveryGridLoading extends DiscoveryGridState {
  const DiscoveryGridLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryGridLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryGridState.loading()';
}


}




/// @nodoc


class DiscoveryGridLoaded extends DiscoveryGridState {
  const DiscoveryGridLoaded({required this.kind, required this.title, required this.postCount, required final  List<ExploreItem> items, required this.hasMore, this.loadingMore = false}): _items = items,super._();
  

 final  DiscoveryPageKind kind;
 final  String title;
 final  int postCount;
 final  List<ExploreItem> _items;
 List<ExploreItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasMore;
@JsonKey() final  bool loadingMore;

/// Create a copy of DiscoveryGridState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryGridLoadedCopyWith<DiscoveryGridLoaded> get copyWith => _$DiscoveryGridLoadedCopyWithImpl<DiscoveryGridLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryGridLoaded&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,kind,title,postCount,const DeepCollectionEquality().hash(_items),hasMore,loadingMore);

@override
String toString() {
  return 'DiscoveryGridState.loaded(kind: $kind, title: $title, postCount: $postCount, items: $items, hasMore: $hasMore, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $DiscoveryGridLoadedCopyWith<$Res> implements $DiscoveryGridStateCopyWith<$Res> {
  factory $DiscoveryGridLoadedCopyWith(DiscoveryGridLoaded value, $Res Function(DiscoveryGridLoaded) _then) = _$DiscoveryGridLoadedCopyWithImpl;
@useResult
$Res call({
 DiscoveryPageKind kind, String title, int postCount, List<ExploreItem> items, bool hasMore, bool loadingMore
});




}
/// @nodoc
class _$DiscoveryGridLoadedCopyWithImpl<$Res>
    implements $DiscoveryGridLoadedCopyWith<$Res> {
  _$DiscoveryGridLoadedCopyWithImpl(this._self, this._then);

  final DiscoveryGridLoaded _self;
  final $Res Function(DiscoveryGridLoaded) _then;

/// Create a copy of DiscoveryGridState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? title = null,Object? postCount = null,Object? items = null,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(DiscoveryGridLoaded(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DiscoveryPageKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExploreItem>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class DiscoveryGridError extends DiscoveryGridState {
  const DiscoveryGridError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of DiscoveryGridState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryGridErrorCopyWith<DiscoveryGridError> get copyWith => _$DiscoveryGridErrorCopyWithImpl<DiscoveryGridError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryGridError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DiscoveryGridState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DiscoveryGridErrorCopyWith<$Res> implements $DiscoveryGridStateCopyWith<$Res> {
  factory $DiscoveryGridErrorCopyWith(DiscoveryGridError value, $Res Function(DiscoveryGridError) _then) = _$DiscoveryGridErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DiscoveryGridErrorCopyWithImpl<$Res>
    implements $DiscoveryGridErrorCopyWith<$Res> {
  _$DiscoveryGridErrorCopyWithImpl(this._self, this._then);

  final DiscoveryGridError _self;
  final $Res Function(DiscoveryGridError) _then;

/// Create a copy of DiscoveryGridState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DiscoveryGridError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of DiscoveryGridState
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
