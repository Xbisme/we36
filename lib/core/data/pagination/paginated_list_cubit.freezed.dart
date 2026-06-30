// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedListState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedListState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginatedListState<$T>()';
}


}

/// @nodoc
class $PaginatedListStateCopyWith<T,$Res>  {
$PaginatedListStateCopyWith(PaginatedListState<T> _, $Res Function(PaginatedListState<T>) __);
}


/// Adds pattern-matching-related methods to [PaginatedListState].
extension PaginatedListStatePatterns<T> on PaginatedListState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaginatedInitial<T> value)?  initial,TResult Function( PaginatedLoading<T> value)?  loading,TResult Function( PaginatedLoaded<T> value)?  loaded,TResult Function( PaginatedLoadedPaginating<T> value)?  loadedPaginating,TResult Function( PaginatedLoadedRefreshing<T> value)?  loadedRefreshing,TResult Function( PaginatedError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial(_that);case PaginatedLoading() when loading != null:
return loading(_that);case PaginatedLoaded() when loaded != null:
return loaded(_that);case PaginatedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case PaginatedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that);case PaginatedError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaginatedInitial<T> value)  initial,required TResult Function( PaginatedLoading<T> value)  loading,required TResult Function( PaginatedLoaded<T> value)  loaded,required TResult Function( PaginatedLoadedPaginating<T> value)  loadedPaginating,required TResult Function( PaginatedLoadedRefreshing<T> value)  loadedRefreshing,required TResult Function( PaginatedError<T> value)  error,}){
final _that = this;
switch (_that) {
case PaginatedInitial():
return initial(_that);case PaginatedLoading():
return loading(_that);case PaginatedLoaded():
return loaded(_that);case PaginatedLoadedPaginating():
return loadedPaginating(_that);case PaginatedLoadedRefreshing():
return loadedRefreshing(_that);case PaginatedError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaginatedInitial<T> value)?  initial,TResult? Function( PaginatedLoading<T> value)?  loading,TResult? Function( PaginatedLoaded<T> value)?  loaded,TResult? Function( PaginatedLoadedPaginating<T> value)?  loadedPaginating,TResult? Function( PaginatedLoadedRefreshing<T> value)?  loadedRefreshing,TResult? Function( PaginatedError<T> value)?  error,}){
final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial(_that);case PaginatedLoading() when loading != null:
return loading(_that);case PaginatedLoaded() when loaded != null:
return loaded(_that);case PaginatedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case PaginatedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that);case PaginatedError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<T> items,  String? nextCursor,  bool hasMore)?  loaded,TResult Function( List<T> items,  String? nextCursor,  bool hasMore)?  loadedPaginating,TResult Function( List<T> items,  String? nextCursor,  bool hasMore)?  loadedRefreshing,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial();case PaginatedLoading() when loading != null:
return loading();case PaginatedLoaded() when loaded != null:
return loaded(_that.items,_that.nextCursor,_that.hasMore);case PaginatedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.items,_that.nextCursor,_that.hasMore);case PaginatedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that.items,_that.nextCursor,_that.hasMore);case PaginatedError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<T> items,  String? nextCursor,  bool hasMore)  loaded,required TResult Function( List<T> items,  String? nextCursor,  bool hasMore)  loadedPaginating,required TResult Function( List<T> items,  String? nextCursor,  bool hasMore)  loadedRefreshing,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case PaginatedInitial():
return initial();case PaginatedLoading():
return loading();case PaginatedLoaded():
return loaded(_that.items,_that.nextCursor,_that.hasMore);case PaginatedLoadedPaginating():
return loadedPaginating(_that.items,_that.nextCursor,_that.hasMore);case PaginatedLoadedRefreshing():
return loadedRefreshing(_that.items,_that.nextCursor,_that.hasMore);case PaginatedError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<T> items,  String? nextCursor,  bool hasMore)?  loaded,TResult? Function( List<T> items,  String? nextCursor,  bool hasMore)?  loadedPaginating,TResult? Function( List<T> items,  String? nextCursor,  bool hasMore)?  loadedRefreshing,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial();case PaginatedLoading() when loading != null:
return loading();case PaginatedLoaded() when loaded != null:
return loaded(_that.items,_that.nextCursor,_that.hasMore);case PaginatedLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.items,_that.nextCursor,_that.hasMore);case PaginatedLoadedRefreshing() when loadedRefreshing != null:
return loadedRefreshing(_that.items,_that.nextCursor,_that.hasMore);case PaginatedError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PaginatedInitial<T> extends PaginatedListState<T> {
  const PaginatedInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginatedListState<$T>.initial()';
}


}




/// @nodoc


class PaginatedLoading<T> extends PaginatedListState<T> {
  const PaginatedLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginatedListState<$T>.loading()';
}


}




/// @nodoc


class PaginatedLoaded<T> extends PaginatedListState<T> {
  const PaginatedLoaded({required final  List<T> items, required this.nextCursor, required this.hasMore}): _items = items,super._();
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  String? nextCursor;
 final  bool hasMore;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedLoadedCopyWith<T, PaginatedLoaded<T>> get copyWith => _$PaginatedLoadedCopyWithImpl<T, PaginatedLoaded<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedLoaded<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'PaginatedListState<$T>.loaded(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $PaginatedLoadedCopyWith<T,$Res> implements $PaginatedListStateCopyWith<T, $Res> {
  factory $PaginatedLoadedCopyWith(PaginatedLoaded<T> value, $Res Function(PaginatedLoaded<T>) _then) = _$PaginatedLoadedCopyWithImpl;
@useResult
$Res call({
 List<T> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class _$PaginatedLoadedCopyWithImpl<T,$Res>
    implements $PaginatedLoadedCopyWith<T, $Res> {
  _$PaginatedLoadedCopyWithImpl(this._self, this._then);

  final PaginatedLoaded<T> _self;
  final $Res Function(PaginatedLoaded<T>) _then;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(PaginatedLoaded<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PaginatedLoadedPaginating<T> extends PaginatedListState<T> {
  const PaginatedLoadedPaginating({required final  List<T> items, required this.nextCursor, required this.hasMore}): _items = items,super._();
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  String? nextCursor;
 final  bool hasMore;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedLoadedPaginatingCopyWith<T, PaginatedLoadedPaginating<T>> get copyWith => _$PaginatedLoadedPaginatingCopyWithImpl<T, PaginatedLoadedPaginating<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedLoadedPaginating<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'PaginatedListState<$T>.loadedPaginating(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $PaginatedLoadedPaginatingCopyWith<T,$Res> implements $PaginatedListStateCopyWith<T, $Res> {
  factory $PaginatedLoadedPaginatingCopyWith(PaginatedLoadedPaginating<T> value, $Res Function(PaginatedLoadedPaginating<T>) _then) = _$PaginatedLoadedPaginatingCopyWithImpl;
@useResult
$Res call({
 List<T> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class _$PaginatedLoadedPaginatingCopyWithImpl<T,$Res>
    implements $PaginatedLoadedPaginatingCopyWith<T, $Res> {
  _$PaginatedLoadedPaginatingCopyWithImpl(this._self, this._then);

  final PaginatedLoadedPaginating<T> _self;
  final $Res Function(PaginatedLoadedPaginating<T>) _then;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(PaginatedLoadedPaginating<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PaginatedLoadedRefreshing<T> extends PaginatedListState<T> {
  const PaginatedLoadedRefreshing({required final  List<T> items, required this.nextCursor, required this.hasMore}): _items = items,super._();
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  String? nextCursor;
 final  bool hasMore;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedLoadedRefreshingCopyWith<T, PaginatedLoadedRefreshing<T>> get copyWith => _$PaginatedLoadedRefreshingCopyWithImpl<T, PaginatedLoadedRefreshing<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedLoadedRefreshing<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'PaginatedListState<$T>.loadedRefreshing(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $PaginatedLoadedRefreshingCopyWith<T,$Res> implements $PaginatedListStateCopyWith<T, $Res> {
  factory $PaginatedLoadedRefreshingCopyWith(PaginatedLoadedRefreshing<T> value, $Res Function(PaginatedLoadedRefreshing<T>) _then) = _$PaginatedLoadedRefreshingCopyWithImpl;
@useResult
$Res call({
 List<T> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class _$PaginatedLoadedRefreshingCopyWithImpl<T,$Res>
    implements $PaginatedLoadedRefreshingCopyWith<T, $Res> {
  _$PaginatedLoadedRefreshingCopyWithImpl(this._self, this._then);

  final PaginatedLoadedRefreshing<T> _self;
  final $Res Function(PaginatedLoadedRefreshing<T>) _then;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(PaginatedLoadedRefreshing<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PaginatedError<T> extends PaginatedListState<T> {
  const PaginatedError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedErrorCopyWith<T, PaginatedError<T>> get copyWith => _$PaginatedErrorCopyWithImpl<T, PaginatedError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedError<T>&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'PaginatedListState<$T>.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PaginatedErrorCopyWith<T,$Res> implements $PaginatedListStateCopyWith<T, $Res> {
  factory $PaginatedErrorCopyWith(PaginatedError<T> value, $Res Function(PaginatedError<T>) _then) = _$PaginatedErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PaginatedErrorCopyWithImpl<T,$Res>
    implements $PaginatedErrorCopyWith<T, $Res> {
  _$PaginatedErrorCopyWithImpl(this._self, this._then);

  final PaginatedError<T> _self;
  final $Res Function(PaginatedError<T>) _then;

/// Create a copy of PaginatedListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PaginatedError<T>(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of PaginatedListState
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
