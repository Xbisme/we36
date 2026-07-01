// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState()';
}


}

/// @nodoc
class $FeedStateCopyWith<$Res>  {
$FeedStateCopyWith(FeedState _, $Res Function(FeedState) __);
}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FeedInitial value)?  initial,TResult Function( FeedLoading value)?  loading,TResult Function( FeedLoaded value)?  loaded,TResult Function( FeedLoadedPaginating value)?  loadedPaginating,TResult Function( FeedLoadedRefreshing value)?  loadedRefreshing,TResult Function( FeedError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial(_that);case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case FeedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that);case FeedError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FeedInitial value)  initial,required TResult Function( FeedLoading value)  loading,required TResult Function( FeedLoaded value)  loaded,required TResult Function( FeedLoadedPaginating value)  loadedPaginating,required TResult Function( FeedLoadedRefreshing value)  loadedRefreshing,required TResult Function( FeedError value)  error,}){
final _that = this;
switch (_that) {
case FeedInitial():
return initial(_that);case FeedLoading():
return loading(_that);case FeedLoaded():
return loaded(_that);case FeedLoadedPaginating():
return loadedPaginating(_that);case FeedLoadedRefreshing():
return loadedRefreshing(_that);case FeedError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FeedInitial value)?  initial,TResult? Function( FeedLoading value)?  loading,TResult? Function( FeedLoaded value)?  loaded,TResult? Function( FeedLoadedPaginating value)?  loadedPaginating,TResult? Function( FeedLoadedRefreshing value)?  loadedRefreshing,TResult? Function( FeedError value)?  error,}){
final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial(_that);case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case FeedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that);case FeedError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Post> posts,  bool hasMore)?  loaded,TResult Function( List<Post> posts,  bool hasMore)?  loadedPaginating,TResult Function( List<Post> posts,  bool hasMore)?  loadedRefreshing,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial();case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.posts,_that.hasMore);case FeedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.posts,_that.hasMore);case FeedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that.posts,_that.hasMore);case FeedError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Post> posts,  bool hasMore)  loaded,required TResult Function( List<Post> posts,  bool hasMore)  loadedPaginating,required TResult Function( List<Post> posts,  bool hasMore)  loadedRefreshing,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case FeedInitial():
return initial();case FeedLoading():
return loading();case FeedLoaded():
return loaded(_that.posts,_that.hasMore);case FeedLoadedPaginating():
return loadedPaginating(_that.posts,_that.hasMore);case FeedLoadedRefreshing():
return loadedRefreshing(_that.posts,_that.hasMore);case FeedError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Post> posts,  bool hasMore)?  loaded,TResult? Function( List<Post> posts,  bool hasMore)?  loadedPaginating,TResult? Function( List<Post> posts,  bool hasMore)?  loadedRefreshing,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial();case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.posts,_that.hasMore);case FeedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.posts,_that.hasMore);case FeedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that.posts,_that.hasMore);case FeedError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FeedInitial extends FeedState {
  const FeedInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.initial()';
}


}




/// @nodoc


class FeedLoading extends FeedState {
  const FeedLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.loading()';
}


}




/// @nodoc


class FeedLoaded extends FeedState {
  const FeedLoaded(final  List<Post> posts, {required this.hasMore}): _posts = posts,super._();
  

 final  List<Post> _posts;
 List<Post> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  bool hasMore;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedLoadedCopyWith<FeedLoaded> get copyWith => _$FeedLoadedCopyWithImpl<FeedLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoaded&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),hasMore);

@override
String toString() {
  return 'FeedState.loaded(posts: $posts, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $FeedLoadedCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedLoadedCopyWith(FeedLoaded value, $Res Function(FeedLoaded) _then) = _$FeedLoadedCopyWithImpl;
@useResult
$Res call({
 List<Post> posts, bool hasMore
});




}
/// @nodoc
class _$FeedLoadedCopyWithImpl<$Res>
    implements $FeedLoadedCopyWith<$Res> {
  _$FeedLoadedCopyWithImpl(this._self, this._then);

  final FeedLoaded _self;
  final $Res Function(FeedLoaded) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? hasMore = null,}) {
  return _then(FeedLoaded(
null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class FeedLoadedPaginating extends FeedState {
  const FeedLoadedPaginating(final  List<Post> posts, {required this.hasMore}): _posts = posts,super._();
  

 final  List<Post> _posts;
 List<Post> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  bool hasMore;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedLoadedPaginatingCopyWith<FeedLoadedPaginating> get copyWith => _$FeedLoadedPaginatingCopyWithImpl<FeedLoadedPaginating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoadedPaginating&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),hasMore);

@override
String toString() {
  return 'FeedState.loadedPaginating(posts: $posts, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $FeedLoadedPaginatingCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedLoadedPaginatingCopyWith(FeedLoadedPaginating value, $Res Function(FeedLoadedPaginating) _then) = _$FeedLoadedPaginatingCopyWithImpl;
@useResult
$Res call({
 List<Post> posts, bool hasMore
});




}
/// @nodoc
class _$FeedLoadedPaginatingCopyWithImpl<$Res>
    implements $FeedLoadedPaginatingCopyWith<$Res> {
  _$FeedLoadedPaginatingCopyWithImpl(this._self, this._then);

  final FeedLoadedPaginating _self;
  final $Res Function(FeedLoadedPaginating) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? hasMore = null,}) {
  return _then(FeedLoadedPaginating(
null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class FeedLoadedRefreshing extends FeedState {
  const FeedLoadedRefreshing(final  List<Post> posts, {required this.hasMore}): _posts = posts,super._();
  

 final  List<Post> _posts;
 List<Post> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  bool hasMore;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedLoadedRefreshingCopyWith<FeedLoadedRefreshing> get copyWith => _$FeedLoadedRefreshingCopyWithImpl<FeedLoadedRefreshing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoadedRefreshing&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),hasMore);

@override
String toString() {
  return 'FeedState.loadedRefreshing(posts: $posts, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $FeedLoadedRefreshingCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedLoadedRefreshingCopyWith(FeedLoadedRefreshing value, $Res Function(FeedLoadedRefreshing) _then) = _$FeedLoadedRefreshingCopyWithImpl;
@useResult
$Res call({
 List<Post> posts, bool hasMore
});




}
/// @nodoc
class _$FeedLoadedRefreshingCopyWithImpl<$Res>
    implements $FeedLoadedRefreshingCopyWith<$Res> {
  _$FeedLoadedRefreshingCopyWithImpl(this._self, this._then);

  final FeedLoadedRefreshing _self;
  final $Res Function(FeedLoadedRefreshing) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? hasMore = null,}) {
  return _then(FeedLoadedRefreshing(
null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class FeedError extends FeedState {
  const FeedError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedErrorCopyWith<FeedError> get copyWith => _$FeedErrorCopyWithImpl<FeedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FeedState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FeedErrorCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedErrorCopyWith(FeedError value, $Res Function(FeedError) _then) = _$FeedErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FeedErrorCopyWithImpl<$Res>
    implements $FeedErrorCopyWith<$Res> {
  _$FeedErrorCopyWithImpl(this._self, this._then);

  final FeedError _self;
  final $Res Function(FeedError) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FeedError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of FeedState
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
