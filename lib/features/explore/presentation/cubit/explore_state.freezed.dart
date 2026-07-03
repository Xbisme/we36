// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExploreState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExploreState()';
}


}

/// @nodoc
class $ExploreStateCopyWith<$Res>  {
$ExploreStateCopyWith(ExploreState _, $Res Function(ExploreState) __);
}


/// Adds pattern-matching-related methods to [ExploreState].
extension ExploreStatePatterns on ExploreState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExploreInitial value)?  initial,TResult Function( ExploreLoading value)?  loading,TResult Function( ExploreLoaded value)?  loaded,TResult Function( ExploreError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExploreInitial() when initial != null:
return initial(_that);case ExploreLoading() when loading != null:
return loading(_that);case ExploreLoaded() when loaded != null:
return loaded(_that);case ExploreError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExploreInitial value)  initial,required TResult Function( ExploreLoading value)  loading,required TResult Function( ExploreLoaded value)  loaded,required TResult Function( ExploreError value)  error,}){
final _that = this;
switch (_that) {
case ExploreInitial():
return initial(_that);case ExploreLoading():
return loading(_that);case ExploreLoaded():
return loaded(_that);case ExploreError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExploreInitial value)?  initial,TResult? Function( ExploreLoading value)?  loading,TResult? Function( ExploreLoaded value)?  loaded,TResult? Function( ExploreError value)?  error,}){
final _that = this;
switch (_that) {
case ExploreInitial() when initial != null:
return initial(_that);case ExploreLoading() when loading != null:
return loading(_that);case ExploreLoaded() when loaded != null:
return loaded(_that);case ExploreError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ExploreItem> items,  bool hasMore,  bool loadingMore,  bool isOffline)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExploreInitial() when initial != null:
return initial();case ExploreLoading() when loading != null:
return loading();case ExploreLoaded() when loaded != null:
return loaded(_that.items,_that.hasMore,_that.loadingMore,_that.isOffline);case ExploreError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ExploreItem> items,  bool hasMore,  bool loadingMore,  bool isOffline)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case ExploreInitial():
return initial();case ExploreLoading():
return loading();case ExploreLoaded():
return loaded(_that.items,_that.hasMore,_that.loadingMore,_that.isOffline);case ExploreError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ExploreItem> items,  bool hasMore,  bool loadingMore,  bool isOffline)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case ExploreInitial() when initial != null:
return initial();case ExploreLoading() when loading != null:
return loading();case ExploreLoaded() when loaded != null:
return loaded(_that.items,_that.hasMore,_that.loadingMore,_that.isOffline);case ExploreError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ExploreInitial extends ExploreState {
  const ExploreInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExploreState.initial()';
}


}




/// @nodoc


class ExploreLoading extends ExploreState {
  const ExploreLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExploreState.loading()';
}


}




/// @nodoc


class ExploreLoaded extends ExploreState {
  const ExploreLoaded(final  List<ExploreItem> items, {required this.hasMore, this.loadingMore = false, this.isOffline = false}): _items = items,super._();
  

 final  List<ExploreItem> _items;
 List<ExploreItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasMore;
@JsonKey() final  bool loadingMore;
@JsonKey() final  bool isOffline;

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreLoadedCopyWith<ExploreLoaded> get copyWith => _$ExploreLoadedCopyWithImpl<ExploreLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreLoaded&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore,loadingMore,isOffline);

@override
String toString() {
  return 'ExploreState.loaded(items: $items, hasMore: $hasMore, loadingMore: $loadingMore, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class $ExploreLoadedCopyWith<$Res> implements $ExploreStateCopyWith<$Res> {
  factory $ExploreLoadedCopyWith(ExploreLoaded value, $Res Function(ExploreLoaded) _then) = _$ExploreLoadedCopyWithImpl;
@useResult
$Res call({
 List<ExploreItem> items, bool hasMore, bool loadingMore, bool isOffline
});




}
/// @nodoc
class _$ExploreLoadedCopyWithImpl<$Res>
    implements $ExploreLoadedCopyWith<$Res> {
  _$ExploreLoadedCopyWithImpl(this._self, this._then);

  final ExploreLoaded _self;
  final $Res Function(ExploreLoaded) _then;

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,Object? loadingMore = null,Object? isOffline = null,}) {
  return _then(ExploreLoaded(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExploreItem>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ExploreError extends ExploreState {
  const ExploreError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreErrorCopyWith<ExploreError> get copyWith => _$ExploreErrorCopyWithImpl<ExploreError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ExploreState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExploreErrorCopyWith<$Res> implements $ExploreStateCopyWith<$Res> {
  factory $ExploreErrorCopyWith(ExploreError value, $Res Function(ExploreError) _then) = _$ExploreErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ExploreErrorCopyWithImpl<$Res>
    implements $ExploreErrorCopyWith<$Res> {
  _$ExploreErrorCopyWithImpl(this._self, this._then);

  final ExploreError _self;
  final $Res Function(ExploreError) _then;

/// Create a copy of ExploreState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ExploreError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of ExploreState
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
