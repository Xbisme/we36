// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FollowListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FollowListState()';
}


}

/// @nodoc
class $FollowListStateCopyWith<$Res>  {
$FollowListStateCopyWith(FollowListState _, $Res Function(FollowListState) __);
}


/// Adds pattern-matching-related methods to [FollowListState].
extension FollowListStatePatterns on FollowListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FollowListInitial value)?  initial,TResult Function( FollowListLoading value)?  loading,TResult Function( FollowListLoaded value)?  loaded,TResult Function( FollowListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FollowListInitial() when initial != null:
return initial(_that);case FollowListLoading() when loading != null:
return loading(_that);case FollowListLoaded() when loaded != null:
return loaded(_that);case FollowListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FollowListInitial value)  initial,required TResult Function( FollowListLoading value)  loading,required TResult Function( FollowListLoaded value)  loaded,required TResult Function( FollowListError value)  error,}){
final _that = this;
switch (_that) {
case FollowListInitial():
return initial(_that);case FollowListLoading():
return loading(_that);case FollowListLoaded():
return loaded(_that);case FollowListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FollowListInitial value)?  initial,TResult? Function( FollowListLoading value)?  loading,TResult? Function( FollowListLoaded value)?  loaded,TResult? Function( FollowListError value)?  error,}){
final _that = this;
switch (_that) {
case FollowListInitial() when initial != null:
return initial(_that);case FollowListLoading() when loading != null:
return loading(_that);case FollowListLoaded() when loaded != null:
return loaded(_that);case FollowListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( FollowConnTab tab,  List<AccountRow> rows,  bool hasMore,  String query,  bool loadingMore)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FollowListInitial() when initial != null:
return initial();case FollowListLoading() when loading != null:
return loading();case FollowListLoaded() when loaded != null:
return loaded(_that.tab,_that.rows,_that.hasMore,_that.query,_that.loadingMore);case FollowListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( FollowConnTab tab,  List<AccountRow> rows,  bool hasMore,  String query,  bool loadingMore)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case FollowListInitial():
return initial();case FollowListLoading():
return loading();case FollowListLoaded():
return loaded(_that.tab,_that.rows,_that.hasMore,_that.query,_that.loadingMore);case FollowListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( FollowConnTab tab,  List<AccountRow> rows,  bool hasMore,  String query,  bool loadingMore)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case FollowListInitial() when initial != null:
return initial();case FollowListLoading() when loading != null:
return loading();case FollowListLoaded() when loaded != null:
return loaded(_that.tab,_that.rows,_that.hasMore,_that.query,_that.loadingMore);case FollowListError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FollowListInitial extends FollowListState {
  const FollowListInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FollowListState.initial()';
}


}




/// @nodoc


class FollowListLoading extends FollowListState {
  const FollowListLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FollowListState.loading()';
}


}




/// @nodoc


class FollowListLoaded extends FollowListState {
  const FollowListLoaded({required this.tab, required final  List<AccountRow> rows, required this.hasMore, this.query = '', this.loadingMore = false}): _rows = rows,super._();
  

 final  FollowConnTab tab;
 final  List<AccountRow> _rows;
 List<AccountRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

 final  bool hasMore;
@JsonKey() final  String query;
@JsonKey() final  bool loadingMore;

/// Create a copy of FollowListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowListLoadedCopyWith<FollowListLoaded> get copyWith => _$FollowListLoadedCopyWithImpl<FollowListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowListLoaded&&(identical(other.tab, tab) || other.tab == tab)&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.query, query) || other.query == query)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,tab,const DeepCollectionEquality().hash(_rows),hasMore,query,loadingMore);

@override
String toString() {
  return 'FollowListState.loaded(tab: $tab, rows: $rows, hasMore: $hasMore, query: $query, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $FollowListLoadedCopyWith<$Res> implements $FollowListStateCopyWith<$Res> {
  factory $FollowListLoadedCopyWith(FollowListLoaded value, $Res Function(FollowListLoaded) _then) = _$FollowListLoadedCopyWithImpl;
@useResult
$Res call({
 FollowConnTab tab, List<AccountRow> rows, bool hasMore, String query, bool loadingMore
});




}
/// @nodoc
class _$FollowListLoadedCopyWithImpl<$Res>
    implements $FollowListLoadedCopyWith<$Res> {
  _$FollowListLoadedCopyWithImpl(this._self, this._then);

  final FollowListLoaded _self;
  final $Res Function(FollowListLoaded) _then;

/// Create a copy of FollowListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? rows = null,Object? hasMore = null,Object? query = null,Object? loadingMore = null,}) {
  return _then(FollowListLoaded(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as FollowConnTab,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<AccountRow>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class FollowListError extends FollowListState {
  const FollowListError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of FollowListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowListErrorCopyWith<FollowListError> get copyWith => _$FollowListErrorCopyWithImpl<FollowListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowListError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FollowListState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FollowListErrorCopyWith<$Res> implements $FollowListStateCopyWith<$Res> {
  factory $FollowListErrorCopyWith(FollowListError value, $Res Function(FollowListError) _then) = _$FollowListErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FollowListErrorCopyWithImpl<$Res>
    implements $FollowListErrorCopyWith<$Res> {
  _$FollowListErrorCopyWithImpl(this._self, this._then);

  final FollowListError _self;
  final $Res Function(FollowListError) _then;

/// Create a copy of FollowListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FollowListError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of FollowListState
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
