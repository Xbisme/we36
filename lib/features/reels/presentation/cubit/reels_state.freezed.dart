// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reels_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReelsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReelsState()';
}


}

/// @nodoc
class $ReelsStateCopyWith<$Res>  {
$ReelsStateCopyWith(ReelsState _, $Res Function(ReelsState) __);
}


/// Adds pattern-matching-related methods to [ReelsState].
extension ReelsStatePatterns on ReelsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReelsInitial value)?  initial,TResult Function( ReelsLoading value)?  loading,TResult Function( ReelsLoaded value)?  loaded,TResult Function( ReelsLoadedPaginating value)?  loadedPaginating,TResult Function( ReelsLoadedRefreshing value)?  loadedRefreshing,TResult Function( ReelsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReelsInitial() when initial != null:
return initial(_that);case ReelsLoading() when loading != null:
return loading(_that);case ReelsLoaded() when loaded != null:
return loaded(_that);case ReelsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case ReelsLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that);case ReelsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReelsInitial value)  initial,required TResult Function( ReelsLoading value)  loading,required TResult Function( ReelsLoaded value)  loaded,required TResult Function( ReelsLoadedPaginating value)  loadedPaginating,required TResult Function( ReelsLoadedRefreshing value)  loadedRefreshing,required TResult Function( ReelsError value)  error,}){
final _that = this;
switch (_that) {
case ReelsInitial():
return initial(_that);case ReelsLoading():
return loading(_that);case ReelsLoaded():
return loaded(_that);case ReelsLoadedPaginating():
return loadedPaginating(_that);case ReelsLoadedRefreshing():
return loadedRefreshing(_that);case ReelsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReelsInitial value)?  initial,TResult? Function( ReelsLoading value)?  loading,TResult? Function( ReelsLoaded value)?  loaded,TResult? Function( ReelsLoadedPaginating value)?  loadedPaginating,TResult? Function( ReelsLoadedRefreshing value)?  loadedRefreshing,TResult? Function( ReelsError value)?  error,}){
final _that = this;
switch (_that) {
case ReelsInitial() when initial != null:
return initial(_that);case ReelsLoading() when loading != null:
return loading(_that);case ReelsLoaded() when loaded != null:
return loaded(_that);case ReelsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case ReelsLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that);case ReelsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Reel> reels,  bool hasMore)?  loaded,TResult Function( List<Reel> reels,  bool hasMore)?  loadedPaginating,TResult Function( List<Reel> reels,  bool hasMore)?  loadedRefreshing,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReelsInitial() when initial != null:
return initial();case ReelsLoading() when loading != null:
return loading();case ReelsLoaded() when loaded != null:
return loaded(_that.reels,_that.hasMore);case ReelsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.reels,_that.hasMore);case ReelsLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that.reels,_that.hasMore);case ReelsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Reel> reels,  bool hasMore)  loaded,required TResult Function( List<Reel> reels,  bool hasMore)  loadedPaginating,required TResult Function( List<Reel> reels,  bool hasMore)  loadedRefreshing,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case ReelsInitial():
return initial();case ReelsLoading():
return loading();case ReelsLoaded():
return loaded(_that.reels,_that.hasMore);case ReelsLoadedPaginating():
return loadedPaginating(_that.reels,_that.hasMore);case ReelsLoadedRefreshing():
return loadedRefreshing(_that.reels,_that.hasMore);case ReelsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Reel> reels,  bool hasMore)?  loaded,TResult? Function( List<Reel> reels,  bool hasMore)?  loadedPaginating,TResult? Function( List<Reel> reels,  bool hasMore)?  loadedRefreshing,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case ReelsInitial() when initial != null:
return initial();case ReelsLoading() when loading != null:
return loading();case ReelsLoaded() when loaded != null:
return loaded(_that.reels,_that.hasMore);case ReelsLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.reels,_that.hasMore);case ReelsLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that.reels,_that.hasMore);case ReelsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ReelsInitial extends ReelsState {
  const ReelsInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReelsState.initial()';
}


}




/// @nodoc


class ReelsLoading extends ReelsState {
  const ReelsLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReelsState.loading()';
}


}




/// @nodoc


class ReelsLoaded extends ReelsState {
  const ReelsLoaded(final  List<Reel> reels, {required this.hasMore}): _reels = reels,super._();
  

 final  List<Reel> _reels;
 List<Reel> get reels {
  if (_reels is EqualUnmodifiableListView) return _reels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reels);
}

 final  bool hasMore;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelsLoadedCopyWith<ReelsLoaded> get copyWith => _$ReelsLoadedCopyWithImpl<ReelsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelsLoaded&&const DeepCollectionEquality().equals(other._reels, _reels)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reels),hasMore);

@override
String toString() {
  return 'ReelsState.loaded(reels: $reels, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ReelsLoadedCopyWith<$Res> implements $ReelsStateCopyWith<$Res> {
  factory $ReelsLoadedCopyWith(ReelsLoaded value, $Res Function(ReelsLoaded) _then) = _$ReelsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Reel> reels, bool hasMore
});




}
/// @nodoc
class _$ReelsLoadedCopyWithImpl<$Res>
    implements $ReelsLoadedCopyWith<$Res> {
  _$ReelsLoadedCopyWithImpl(this._self, this._then);

  final ReelsLoaded _self;
  final $Res Function(ReelsLoaded) _then;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reels = null,Object? hasMore = null,}) {
  return _then(ReelsLoaded(
null == reels ? _self._reels : reels // ignore: cast_nullable_to_non_nullable
as List<Reel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ReelsLoadedPaginating extends ReelsState {
  const ReelsLoadedPaginating(final  List<Reel> reels, {required this.hasMore}): _reels = reels,super._();
  

 final  List<Reel> _reels;
 List<Reel> get reels {
  if (_reels is EqualUnmodifiableListView) return _reels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reels);
}

 final  bool hasMore;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelsLoadedPaginatingCopyWith<ReelsLoadedPaginating> get copyWith => _$ReelsLoadedPaginatingCopyWithImpl<ReelsLoadedPaginating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelsLoadedPaginating&&const DeepCollectionEquality().equals(other._reels, _reels)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reels),hasMore);

@override
String toString() {
  return 'ReelsState.loadedPaginating(reels: $reels, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ReelsLoadedPaginatingCopyWith<$Res> implements $ReelsStateCopyWith<$Res> {
  factory $ReelsLoadedPaginatingCopyWith(ReelsLoadedPaginating value, $Res Function(ReelsLoadedPaginating) _then) = _$ReelsLoadedPaginatingCopyWithImpl;
@useResult
$Res call({
 List<Reel> reels, bool hasMore
});




}
/// @nodoc
class _$ReelsLoadedPaginatingCopyWithImpl<$Res>
    implements $ReelsLoadedPaginatingCopyWith<$Res> {
  _$ReelsLoadedPaginatingCopyWithImpl(this._self, this._then);

  final ReelsLoadedPaginating _self;
  final $Res Function(ReelsLoadedPaginating) _then;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reels = null,Object? hasMore = null,}) {
  return _then(ReelsLoadedPaginating(
null == reels ? _self._reels : reels // ignore: cast_nullable_to_non_nullable
as List<Reel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ReelsLoadedRefreshing extends ReelsState {
  const ReelsLoadedRefreshing(final  List<Reel> reels, {required this.hasMore}): _reels = reels,super._();
  

 final  List<Reel> _reels;
 List<Reel> get reels {
  if (_reels is EqualUnmodifiableListView) return _reels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reels);
}

 final  bool hasMore;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelsLoadedRefreshingCopyWith<ReelsLoadedRefreshing> get copyWith => _$ReelsLoadedRefreshingCopyWithImpl<ReelsLoadedRefreshing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelsLoadedRefreshing&&const DeepCollectionEquality().equals(other._reels, _reels)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reels),hasMore);

@override
String toString() {
  return 'ReelsState.loadedRefreshing(reels: $reels, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ReelsLoadedRefreshingCopyWith<$Res> implements $ReelsStateCopyWith<$Res> {
  factory $ReelsLoadedRefreshingCopyWith(ReelsLoadedRefreshing value, $Res Function(ReelsLoadedRefreshing) _then) = _$ReelsLoadedRefreshingCopyWithImpl;
@useResult
$Res call({
 List<Reel> reels, bool hasMore
});




}
/// @nodoc
class _$ReelsLoadedRefreshingCopyWithImpl<$Res>
    implements $ReelsLoadedRefreshingCopyWith<$Res> {
  _$ReelsLoadedRefreshingCopyWithImpl(this._self, this._then);

  final ReelsLoadedRefreshing _self;
  final $Res Function(ReelsLoadedRefreshing) _then;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reels = null,Object? hasMore = null,}) {
  return _then(ReelsLoadedRefreshing(
null == reels ? _self._reels : reels // ignore: cast_nullable_to_non_nullable
as List<Reel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ReelsError extends ReelsState {
  const ReelsError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelsErrorCopyWith<ReelsError> get copyWith => _$ReelsErrorCopyWithImpl<ReelsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ReelsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ReelsErrorCopyWith<$Res> implements $ReelsStateCopyWith<$Res> {
  factory $ReelsErrorCopyWith(ReelsError value, $Res Function(ReelsError) _then) = _$ReelsErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ReelsErrorCopyWithImpl<$Res>
    implements $ReelsErrorCopyWith<$Res> {
  _$ReelsErrorCopyWithImpl(this._self, this._then);

  final ReelsError _self;
  final $Res Function(ReelsError) _then;

/// Create a copy of ReelsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ReelsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of ReelsState
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
