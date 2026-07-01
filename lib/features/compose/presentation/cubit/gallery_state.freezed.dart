// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GalleryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GalleryState()';
}


}

/// @nodoc
class $GalleryStateCopyWith<$Res>  {
$GalleryStateCopyWith(GalleryState _, $Res Function(GalleryState) __);
}


/// Adds pattern-matching-related methods to [GalleryState].
extension GalleryStatePatterns on GalleryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GalleryInitial value)?  initial,TResult Function( GalleryLoading value)?  loading,TResult Function( GalleryLoaded value)?  loaded,TResult Function( GalleryLoadedPaginating value)?  loadedPaginating,TResult Function( GalleryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GalleryInitial() when initial != null:
return initial(_that);case GalleryLoading() when loading != null:
return loading(_that);case GalleryLoaded() when loaded != null:
return loaded(_that);case GalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case GalleryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GalleryInitial value)  initial,required TResult Function( GalleryLoading value)  loading,required TResult Function( GalleryLoaded value)  loaded,required TResult Function( GalleryLoadedPaginating value)  loadedPaginating,required TResult Function( GalleryError value)  error,}){
final _that = this;
switch (_that) {
case GalleryInitial():
return initial(_that);case GalleryLoading():
return loading(_that);case GalleryLoaded():
return loaded(_that);case GalleryLoadedPaginating():
return loadedPaginating(_that);case GalleryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GalleryInitial value)?  initial,TResult? Function( GalleryLoading value)?  loading,TResult? Function( GalleryLoaded value)?  loaded,TResult? Function( GalleryLoadedPaginating value)?  loadedPaginating,TResult? Function( GalleryError value)?  error,}){
final _that = this;
switch (_that) {
case GalleryInitial() when initial != null:
return initial(_that);case GalleryLoading() when loading != null:
return loading(_that);case GalleryLoaded() when loaded != null:
return loaded(_that);case GalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case GalleryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AssetRef> assets,  bool hasMore,  List<String> selectedIds)?  loaded,TResult Function( List<AssetRef> assets,  bool hasMore,  List<String> selectedIds)?  loadedPaginating,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GalleryInitial() when initial != null:
return initial();case GalleryLoading() when loading != null:
return loading();case GalleryLoaded() when loaded != null:
return loaded(_that.assets,_that.hasMore,_that.selectedIds);case GalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.assets,_that.hasMore,_that.selectedIds);case GalleryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AssetRef> assets,  bool hasMore,  List<String> selectedIds)  loaded,required TResult Function( List<AssetRef> assets,  bool hasMore,  List<String> selectedIds)  loadedPaginating,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case GalleryInitial():
return initial();case GalleryLoading():
return loading();case GalleryLoaded():
return loaded(_that.assets,_that.hasMore,_that.selectedIds);case GalleryLoadedPaginating():
return loadedPaginating(_that.assets,_that.hasMore,_that.selectedIds);case GalleryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AssetRef> assets,  bool hasMore,  List<String> selectedIds)?  loaded,TResult? Function( List<AssetRef> assets,  bool hasMore,  List<String> selectedIds)?  loadedPaginating,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case GalleryInitial() when initial != null:
return initial();case GalleryLoading() when loading != null:
return loading();case GalleryLoaded() when loaded != null:
return loaded(_that.assets,_that.hasMore,_that.selectedIds);case GalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.assets,_that.hasMore,_that.selectedIds);case GalleryError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class GalleryInitial extends GalleryState {
  const GalleryInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GalleryState.initial()';
}


}




/// @nodoc


class GalleryLoading extends GalleryState {
  const GalleryLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GalleryState.loading()';
}


}




/// @nodoc


class GalleryLoaded extends GalleryState {
  const GalleryLoaded({required final  List<AssetRef> assets, required this.hasMore, final  List<String> selectedIds = const <String>[]}): _assets = assets,_selectedIds = selectedIds,super._();
  

 final  List<AssetRef> _assets;
 List<AssetRef> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

 final  bool hasMore;
 final  List<String> _selectedIds;
@JsonKey() List<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableListView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedIds);
}


/// Create a copy of GalleryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryLoadedCopyWith<GalleryLoaded> get copyWith => _$GalleryLoadedCopyWithImpl<GalleryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryLoaded&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_assets),hasMore,const DeepCollectionEquality().hash(_selectedIds));

@override
String toString() {
  return 'GalleryState.loaded(assets: $assets, hasMore: $hasMore, selectedIds: $selectedIds)';
}


}

/// @nodoc
abstract mixin class $GalleryLoadedCopyWith<$Res> implements $GalleryStateCopyWith<$Res> {
  factory $GalleryLoadedCopyWith(GalleryLoaded value, $Res Function(GalleryLoaded) _then) = _$GalleryLoadedCopyWithImpl;
@useResult
$Res call({
 List<AssetRef> assets, bool hasMore, List<String> selectedIds
});




}
/// @nodoc
class _$GalleryLoadedCopyWithImpl<$Res>
    implements $GalleryLoadedCopyWith<$Res> {
  _$GalleryLoadedCopyWithImpl(this._self, this._then);

  final GalleryLoaded _self;
  final $Res Function(GalleryLoaded) _then;

/// Create a copy of GalleryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assets = null,Object? hasMore = null,Object? selectedIds = null,}) {
  return _then(GalleryLoaded(
assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<AssetRef>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class GalleryLoadedPaginating extends GalleryState {
  const GalleryLoadedPaginating({required final  List<AssetRef> assets, required this.hasMore, final  List<String> selectedIds = const <String>[]}): _assets = assets,_selectedIds = selectedIds,super._();
  

 final  List<AssetRef> _assets;
 List<AssetRef> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

 final  bool hasMore;
 final  List<String> _selectedIds;
@JsonKey() List<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableListView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedIds);
}


/// Create a copy of GalleryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryLoadedPaginatingCopyWith<GalleryLoadedPaginating> get copyWith => _$GalleryLoadedPaginatingCopyWithImpl<GalleryLoadedPaginating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryLoadedPaginating&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_assets),hasMore,const DeepCollectionEquality().hash(_selectedIds));

@override
String toString() {
  return 'GalleryState.loadedPaginating(assets: $assets, hasMore: $hasMore, selectedIds: $selectedIds)';
}


}

/// @nodoc
abstract mixin class $GalleryLoadedPaginatingCopyWith<$Res> implements $GalleryStateCopyWith<$Res> {
  factory $GalleryLoadedPaginatingCopyWith(GalleryLoadedPaginating value, $Res Function(GalleryLoadedPaginating) _then) = _$GalleryLoadedPaginatingCopyWithImpl;
@useResult
$Res call({
 List<AssetRef> assets, bool hasMore, List<String> selectedIds
});




}
/// @nodoc
class _$GalleryLoadedPaginatingCopyWithImpl<$Res>
    implements $GalleryLoadedPaginatingCopyWith<$Res> {
  _$GalleryLoadedPaginatingCopyWithImpl(this._self, this._then);

  final GalleryLoadedPaginating _self;
  final $Res Function(GalleryLoadedPaginating) _then;

/// Create a copy of GalleryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assets = null,Object? hasMore = null,Object? selectedIds = null,}) {
  return _then(GalleryLoadedPaginating(
assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<AssetRef>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class GalleryError extends GalleryState {
  const GalleryError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of GalleryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryErrorCopyWith<GalleryError> get copyWith => _$GalleryErrorCopyWithImpl<GalleryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'GalleryState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $GalleryErrorCopyWith<$Res> implements $GalleryStateCopyWith<$Res> {
  factory $GalleryErrorCopyWith(GalleryError value, $Res Function(GalleryError) _then) = _$GalleryErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$GalleryErrorCopyWithImpl<$Res>
    implements $GalleryErrorCopyWith<$Res> {
  _$GalleryErrorCopyWithImpl(this._self, this._then);

  final GalleryError _self;
  final $Res Function(GalleryError) _then;

/// Create a copy of GalleryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(GalleryError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of GalleryState
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
