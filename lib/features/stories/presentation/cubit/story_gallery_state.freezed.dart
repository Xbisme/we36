// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_gallery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryGalleryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGalleryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryGalleryState()';
}


}

/// @nodoc
class $StoryGalleryStateCopyWith<$Res>  {
$StoryGalleryStateCopyWith(StoryGalleryState _, $Res Function(StoryGalleryState) __);
}


/// Adds pattern-matching-related methods to [StoryGalleryState].
extension StoryGalleryStatePatterns on StoryGalleryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StoryGalleryInitial value)?  initial,TResult Function( StoryGalleryLoading value)?  loading,TResult Function( StoryGalleryLoaded value)?  loaded,TResult Function( StoryGalleryLoadedPaginating value)?  loadedPaginating,TResult Function( StoryGalleryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StoryGalleryInitial() when initial != null:
return initial(_that);case StoryGalleryLoading() when loading != null:
return loading(_that);case StoryGalleryLoaded() when loaded != null:
return loaded(_that);case StoryGalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case StoryGalleryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StoryGalleryInitial value)  initial,required TResult Function( StoryGalleryLoading value)  loading,required TResult Function( StoryGalleryLoaded value)  loaded,required TResult Function( StoryGalleryLoadedPaginating value)  loadedPaginating,required TResult Function( StoryGalleryError value)  error,}){
final _that = this;
switch (_that) {
case StoryGalleryInitial():
return initial(_that);case StoryGalleryLoading():
return loading(_that);case StoryGalleryLoaded():
return loaded(_that);case StoryGalleryLoadedPaginating():
return loadedPaginating(_that);case StoryGalleryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StoryGalleryInitial value)?  initial,TResult? Function( StoryGalleryLoading value)?  loading,TResult? Function( StoryGalleryLoaded value)?  loaded,TResult? Function( StoryGalleryLoadedPaginating value)?  loadedPaginating,TResult? Function( StoryGalleryError value)?  error,}){
final _that = this;
switch (_that) {
case StoryGalleryInitial() when initial != null:
return initial(_that);case StoryGalleryLoading() when loading != null:
return loading(_that);case StoryGalleryLoaded() when loaded != null:
return loaded(_that);case StoryGalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that);case StoryGalleryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AssetRef> assets,  bool hasMore,  String? selectedId)?  loaded,TResult Function( List<AssetRef> assets,  bool hasMore,  String? selectedId)?  loadedPaginating,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StoryGalleryInitial() when initial != null:
return initial();case StoryGalleryLoading() when loading != null:
return loading();case StoryGalleryLoaded() when loaded != null:
return loaded(_that.assets,_that.hasMore,_that.selectedId);case StoryGalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.assets,_that.hasMore,_that.selectedId);case StoryGalleryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AssetRef> assets,  bool hasMore,  String? selectedId)  loaded,required TResult Function( List<AssetRef> assets,  bool hasMore,  String? selectedId)  loadedPaginating,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case StoryGalleryInitial():
return initial();case StoryGalleryLoading():
return loading();case StoryGalleryLoaded():
return loaded(_that.assets,_that.hasMore,_that.selectedId);case StoryGalleryLoadedPaginating():
return loadedPaginating(_that.assets,_that.hasMore,_that.selectedId);case StoryGalleryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AssetRef> assets,  bool hasMore,  String? selectedId)?  loaded,TResult? Function( List<AssetRef> assets,  bool hasMore,  String? selectedId)?  loadedPaginating,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case StoryGalleryInitial() when initial != null:
return initial();case StoryGalleryLoading() when loading != null:
return loading();case StoryGalleryLoaded() when loaded != null:
return loaded(_that.assets,_that.hasMore,_that.selectedId);case StoryGalleryLoadedPaginating() when loadedPaginating != null:
return loadedPaginating(_that.assets,_that.hasMore,_that.selectedId);case StoryGalleryError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class StoryGalleryInitial extends StoryGalleryState {
  const StoryGalleryInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGalleryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryGalleryState.initial()';
}


}




/// @nodoc


class StoryGalleryLoading extends StoryGalleryState {
  const StoryGalleryLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGalleryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryGalleryState.loading()';
}


}




/// @nodoc


class StoryGalleryLoaded extends StoryGalleryState {
  const StoryGalleryLoaded({required final  List<AssetRef> assets, required this.hasMore, this.selectedId}): _assets = assets,super._();
  

 final  List<AssetRef> _assets;
 List<AssetRef> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

 final  bool hasMore;
 final  String? selectedId;

/// Create a copy of StoryGalleryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryGalleryLoadedCopyWith<StoryGalleryLoaded> get copyWith => _$StoryGalleryLoadedCopyWithImpl<StoryGalleryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGalleryLoaded&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_assets),hasMore,selectedId);

@override
String toString() {
  return 'StoryGalleryState.loaded(assets: $assets, hasMore: $hasMore, selectedId: $selectedId)';
}


}

/// @nodoc
abstract mixin class $StoryGalleryLoadedCopyWith<$Res> implements $StoryGalleryStateCopyWith<$Res> {
  factory $StoryGalleryLoadedCopyWith(StoryGalleryLoaded value, $Res Function(StoryGalleryLoaded) _then) = _$StoryGalleryLoadedCopyWithImpl;
@useResult
$Res call({
 List<AssetRef> assets, bool hasMore, String? selectedId
});




}
/// @nodoc
class _$StoryGalleryLoadedCopyWithImpl<$Res>
    implements $StoryGalleryLoadedCopyWith<$Res> {
  _$StoryGalleryLoadedCopyWithImpl(this._self, this._then);

  final StoryGalleryLoaded _self;
  final $Res Function(StoryGalleryLoaded) _then;

/// Create a copy of StoryGalleryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assets = null,Object? hasMore = null,Object? selectedId = freezed,}) {
  return _then(StoryGalleryLoaded(
assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<AssetRef>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class StoryGalleryLoadedPaginating extends StoryGalleryState {
  const StoryGalleryLoadedPaginating({required final  List<AssetRef> assets, required this.hasMore, this.selectedId}): _assets = assets,super._();
  

 final  List<AssetRef> _assets;
 List<AssetRef> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

 final  bool hasMore;
 final  String? selectedId;

/// Create a copy of StoryGalleryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryGalleryLoadedPaginatingCopyWith<StoryGalleryLoadedPaginating> get copyWith => _$StoryGalleryLoadedPaginatingCopyWithImpl<StoryGalleryLoadedPaginating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGalleryLoadedPaginating&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_assets),hasMore,selectedId);

@override
String toString() {
  return 'StoryGalleryState.loadedPaginating(assets: $assets, hasMore: $hasMore, selectedId: $selectedId)';
}


}

/// @nodoc
abstract mixin class $StoryGalleryLoadedPaginatingCopyWith<$Res> implements $StoryGalleryStateCopyWith<$Res> {
  factory $StoryGalleryLoadedPaginatingCopyWith(StoryGalleryLoadedPaginating value, $Res Function(StoryGalleryLoadedPaginating) _then) = _$StoryGalleryLoadedPaginatingCopyWithImpl;
@useResult
$Res call({
 List<AssetRef> assets, bool hasMore, String? selectedId
});




}
/// @nodoc
class _$StoryGalleryLoadedPaginatingCopyWithImpl<$Res>
    implements $StoryGalleryLoadedPaginatingCopyWith<$Res> {
  _$StoryGalleryLoadedPaginatingCopyWithImpl(this._self, this._then);

  final StoryGalleryLoadedPaginating _self;
  final $Res Function(StoryGalleryLoadedPaginating) _then;

/// Create a copy of StoryGalleryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assets = null,Object? hasMore = null,Object? selectedId = freezed,}) {
  return _then(StoryGalleryLoadedPaginating(
assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<AssetRef>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class StoryGalleryError extends StoryGalleryState {
  const StoryGalleryError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of StoryGalleryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryGalleryErrorCopyWith<StoryGalleryError> get copyWith => _$StoryGalleryErrorCopyWithImpl<StoryGalleryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGalleryError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'StoryGalleryState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $StoryGalleryErrorCopyWith<$Res> implements $StoryGalleryStateCopyWith<$Res> {
  factory $StoryGalleryErrorCopyWith(StoryGalleryError value, $Res Function(StoryGalleryError) _then) = _$StoryGalleryErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$StoryGalleryErrorCopyWithImpl<$Res>
    implements $StoryGalleryErrorCopyWith<$Res> {
  _$StoryGalleryErrorCopyWithImpl(this._self, this._then);

  final StoryGalleryError _self;
  final $Res Function(StoryGalleryError) _then;

/// Create a copy of StoryGalleryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(StoryGalleryError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of StoryGalleryState
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
