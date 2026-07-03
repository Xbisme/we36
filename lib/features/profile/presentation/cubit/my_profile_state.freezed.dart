// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyProfileState()';
}


}

/// @nodoc
class $MyProfileStateCopyWith<$Res>  {
$MyProfileStateCopyWith(MyProfileState _, $Res Function(MyProfileState) __);
}


/// Adds pattern-matching-related methods to [MyProfileState].
extension MyProfileStatePatterns on MyProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MyProfileInitial value)?  initial,TResult Function( MyProfileLoading value)?  loading,TResult Function( MyProfileLoaded value)?  loaded,TResult Function( MyProfileError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MyProfileInitial() when initial != null:
return initial(_that);case MyProfileLoading() when loading != null:
return loading(_that);case MyProfileLoaded() when loaded != null:
return loaded(_that);case MyProfileError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MyProfileInitial value)  initial,required TResult Function( MyProfileLoading value)  loading,required TResult Function( MyProfileLoaded value)  loaded,required TResult Function( MyProfileError value)  error,}){
final _that = this;
switch (_that) {
case MyProfileInitial():
return initial(_that);case MyProfileLoading():
return loading(_that);case MyProfileLoaded():
return loaded(_that);case MyProfileError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MyProfileInitial value)?  initial,TResult? Function( MyProfileLoading value)?  loading,TResult? Function( MyProfileLoaded value)?  loaded,TResult? Function( MyProfileError value)?  error,}){
final _that = this;
switch (_that) {
case MyProfileInitial() when initial != null:
return initial(_that);case MyProfileLoading() when loading != null:
return loading(_that);case MyProfileLoaded() when loaded != null:
return loaded(_that);case MyProfileError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ProfileView view,  ProfileTab tab,  List<ExploreItem> grid,  bool hasMore,  String? website,  bool loadingMore,  bool isOffline)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MyProfileInitial() when initial != null:
return initial();case MyProfileLoading() when loading != null:
return loading();case MyProfileLoaded() when loaded != null:
return loaded(_that.view,_that.tab,_that.grid,_that.hasMore,_that.website,_that.loadingMore,_that.isOffline);case MyProfileError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ProfileView view,  ProfileTab tab,  List<ExploreItem> grid,  bool hasMore,  String? website,  bool loadingMore,  bool isOffline)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case MyProfileInitial():
return initial();case MyProfileLoading():
return loading();case MyProfileLoaded():
return loaded(_that.view,_that.tab,_that.grid,_that.hasMore,_that.website,_that.loadingMore,_that.isOffline);case MyProfileError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ProfileView view,  ProfileTab tab,  List<ExploreItem> grid,  bool hasMore,  String? website,  bool loadingMore,  bool isOffline)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case MyProfileInitial() when initial != null:
return initial();case MyProfileLoading() when loading != null:
return loading();case MyProfileLoaded() when loaded != null:
return loaded(_that.view,_that.tab,_that.grid,_that.hasMore,_that.website,_that.loadingMore,_that.isOffline);case MyProfileError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MyProfileInitial extends MyProfileState {
  const MyProfileInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyProfileState.initial()';
}


}




/// @nodoc


class MyProfileLoading extends MyProfileState {
  const MyProfileLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MyProfileState.loading()';
}


}




/// @nodoc


class MyProfileLoaded extends MyProfileState {
  const MyProfileLoaded({required this.view, required this.tab, required final  List<ExploreItem> grid, required this.hasMore, this.website, this.loadingMore = false, this.isOffline = false}): _grid = grid,super._();
  

 final  ProfileView view;
 final  ProfileTab tab;
 final  List<ExploreItem> _grid;
 List<ExploreItem> get grid {
  if (_grid is EqualUnmodifiableListView) return _grid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grid);
}

 final  bool hasMore;
 final  String? website;
@JsonKey() final  bool loadingMore;
@JsonKey() final  bool isOffline;

/// Create a copy of MyProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileLoadedCopyWith<MyProfileLoaded> get copyWith => _$MyProfileLoadedCopyWithImpl<MyProfileLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileLoaded&&(identical(other.view, view) || other.view == view)&&(identical(other.tab, tab) || other.tab == tab)&&const DeepCollectionEquality().equals(other._grid, _grid)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.website, website) || other.website == website)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode => Object.hash(runtimeType,view,tab,const DeepCollectionEquality().hash(_grid),hasMore,website,loadingMore,isOffline);

@override
String toString() {
  return 'MyProfileState.loaded(view: $view, tab: $tab, grid: $grid, hasMore: $hasMore, website: $website, loadingMore: $loadingMore, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class $MyProfileLoadedCopyWith<$Res> implements $MyProfileStateCopyWith<$Res> {
  factory $MyProfileLoadedCopyWith(MyProfileLoaded value, $Res Function(MyProfileLoaded) _then) = _$MyProfileLoadedCopyWithImpl;
@useResult
$Res call({
 ProfileView view, ProfileTab tab, List<ExploreItem> grid, bool hasMore, String? website, bool loadingMore, bool isOffline
});


$ProfileViewCopyWith<$Res> get view;

}
/// @nodoc
class _$MyProfileLoadedCopyWithImpl<$Res>
    implements $MyProfileLoadedCopyWith<$Res> {
  _$MyProfileLoadedCopyWithImpl(this._self, this._then);

  final MyProfileLoaded _self;
  final $Res Function(MyProfileLoaded) _then;

/// Create a copy of MyProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? view = null,Object? tab = null,Object? grid = null,Object? hasMore = null,Object? website = freezed,Object? loadingMore = null,Object? isOffline = null,}) {
  return _then(MyProfileLoaded(
view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as ProfileView,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as ProfileTab,grid: null == grid ? _self._grid : grid // ignore: cast_nullable_to_non_nullable
as List<ExploreItem>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MyProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileViewCopyWith<$Res> get view {
  
  return $ProfileViewCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}
}

/// @nodoc


class MyProfileError extends MyProfileState {
  const MyProfileError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of MyProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileErrorCopyWith<MyProfileError> get copyWith => _$MyProfileErrorCopyWithImpl<MyProfileError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'MyProfileState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MyProfileErrorCopyWith<$Res> implements $MyProfileStateCopyWith<$Res> {
  factory $MyProfileErrorCopyWith(MyProfileError value, $Res Function(MyProfileError) _then) = _$MyProfileErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$MyProfileErrorCopyWithImpl<$Res>
    implements $MyProfileErrorCopyWith<$Res> {
  _$MyProfileErrorCopyWithImpl(this._self, this._then);

  final MyProfileError _self;
  final $Res Function(MyProfileError) _then;

/// Create a copy of MyProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MyProfileError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of MyProfileState
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
