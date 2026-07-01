// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComposeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposeState()';
}


}

/// @nodoc
class $ComposeStateCopyWith<$Res>  {
$ComposeStateCopyWith(ComposeState _, $Res Function(ComposeState) __);
}


/// Adds pattern-matching-related methods to [ComposeState].
extension ComposeStatePatterns on ComposeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ComposeInitial value)?  initial,TResult Function( ComposeLoading value)?  loading,TResult Function( ComposeLoaded value)?  loaded,TResult Function( ComposeLoadedUploading value)?  loadedUploading,TResult Function( ComposeError value)?  error,TResult Function( ComposePublished value)?  published,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ComposeInitial() when initial != null:
return initial(_that);case ComposeLoading() when loading != null:
return loading(_that);case ComposeLoaded() when loaded != null:
return loaded(_that);case ComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that);case ComposeError() when error != null:
return error(_that);case ComposePublished() when published != null:
return published(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ComposeInitial value)  initial,required TResult Function( ComposeLoading value)  loading,required TResult Function( ComposeLoaded value)  loaded,required TResult Function( ComposeLoadedUploading value)  loadedUploading,required TResult Function( ComposeError value)  error,required TResult Function( ComposePublished value)  published,}){
final _that = this;
switch (_that) {
case ComposeInitial():
return initial(_that);case ComposeLoading():
return loading(_that);case ComposeLoaded():
return loaded(_that);case ComposeLoadedUploading():
return loadedUploading(_that);case ComposeError():
return error(_that);case ComposePublished():
return published(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ComposeInitial value)?  initial,TResult? Function( ComposeLoading value)?  loading,TResult? Function( ComposeLoaded value)?  loaded,TResult? Function( ComposeLoadedUploading value)?  loadedUploading,TResult? Function( ComposeError value)?  error,TResult? Function( ComposePublished value)?  published,}){
final _that = this;
switch (_that) {
case ComposeInitial() when initial != null:
return initial(_that);case ComposeLoading() when loading != null:
return loading(_that);case ComposeLoaded() when loaded != null:
return loaded(_that);case ComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that);case ComposeError() when error != null:
return error(_that);case ComposePublished() when published != null:
return published(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ComposeDraft draft,  int activeItemIndex)?  loaded,TResult Function( ComposeDraft draft,  double progress)?  loadedUploading,TResult Function( AppFailure failure,  ComposeDraft draft)?  error,TResult Function( Post post)?  published,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ComposeInitial() when initial != null:
return initial();case ComposeLoading() when loading != null:
return loading();case ComposeLoaded() when loaded != null:
return loaded(_that.draft,_that.activeItemIndex);case ComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that.draft,_that.progress);case ComposeError() when error != null:
return error(_that.failure,_that.draft);case ComposePublished() when published != null:
return published(_that.post);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ComposeDraft draft,  int activeItemIndex)  loaded,required TResult Function( ComposeDraft draft,  double progress)  loadedUploading,required TResult Function( AppFailure failure,  ComposeDraft draft)  error,required TResult Function( Post post)  published,}) {final _that = this;
switch (_that) {
case ComposeInitial():
return initial();case ComposeLoading():
return loading();case ComposeLoaded():
return loaded(_that.draft,_that.activeItemIndex);case ComposeLoadedUploading():
return loadedUploading(_that.draft,_that.progress);case ComposeError():
return error(_that.failure,_that.draft);case ComposePublished():
return published(_that.post);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ComposeDraft draft,  int activeItemIndex)?  loaded,TResult? Function( ComposeDraft draft,  double progress)?  loadedUploading,TResult? Function( AppFailure failure,  ComposeDraft draft)?  error,TResult? Function( Post post)?  published,}) {final _that = this;
switch (_that) {
case ComposeInitial() when initial != null:
return initial();case ComposeLoading() when loading != null:
return loading();case ComposeLoaded() when loaded != null:
return loaded(_that.draft,_that.activeItemIndex);case ComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that.draft,_that.progress);case ComposeError() when error != null:
return error(_that.failure,_that.draft);case ComposePublished() when published != null:
return published(_that.post);case _:
  return null;

}
}

}

/// @nodoc


class ComposeInitial extends ComposeState {
  const ComposeInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposeState.initial()';
}


}




/// @nodoc


class ComposeLoading extends ComposeState {
  const ComposeLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ComposeState.loading()';
}


}




/// @nodoc


class ComposeLoaded extends ComposeState {
  const ComposeLoaded({required this.draft, this.activeItemIndex = 0}): super._();
  

 final  ComposeDraft draft;
@JsonKey() final  int activeItemIndex;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeLoadedCopyWith<ComposeLoaded> get copyWith => _$ComposeLoadedCopyWithImpl<ComposeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeLoaded&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.activeItemIndex, activeItemIndex) || other.activeItemIndex == activeItemIndex));
}


@override
int get hashCode => Object.hash(runtimeType,draft,activeItemIndex);

@override
String toString() {
  return 'ComposeState.loaded(draft: $draft, activeItemIndex: $activeItemIndex)';
}


}

/// @nodoc
abstract mixin class $ComposeLoadedCopyWith<$Res> implements $ComposeStateCopyWith<$Res> {
  factory $ComposeLoadedCopyWith(ComposeLoaded value, $Res Function(ComposeLoaded) _then) = _$ComposeLoadedCopyWithImpl;
@useResult
$Res call({
 ComposeDraft draft, int activeItemIndex
});


$ComposeDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$ComposeLoadedCopyWithImpl<$Res>
    implements $ComposeLoadedCopyWith<$Res> {
  _$ComposeLoadedCopyWithImpl(this._self, this._then);

  final ComposeLoaded _self;
  final $Res Function(ComposeLoaded) _then;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? activeItemIndex = null,}) {
  return _then(ComposeLoaded(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ComposeDraft,activeItemIndex: null == activeItemIndex ? _self.activeItemIndex : activeItemIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComposeDraftCopyWith<$Res> get draft {
  
  return $ComposeDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class ComposeLoadedUploading extends ComposeState {
  const ComposeLoadedUploading({required this.draft, this.progress = 0.0}): super._();
  

 final  ComposeDraft draft;
@JsonKey() final  double progress;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeLoadedUploadingCopyWith<ComposeLoadedUploading> get copyWith => _$ComposeLoadedUploadingCopyWithImpl<ComposeLoadedUploading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeLoadedUploading&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,draft,progress);

@override
String toString() {
  return 'ComposeState.loadedUploading(draft: $draft, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $ComposeLoadedUploadingCopyWith<$Res> implements $ComposeStateCopyWith<$Res> {
  factory $ComposeLoadedUploadingCopyWith(ComposeLoadedUploading value, $Res Function(ComposeLoadedUploading) _then) = _$ComposeLoadedUploadingCopyWithImpl;
@useResult
$Res call({
 ComposeDraft draft, double progress
});


$ComposeDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$ComposeLoadedUploadingCopyWithImpl<$Res>
    implements $ComposeLoadedUploadingCopyWith<$Res> {
  _$ComposeLoadedUploadingCopyWithImpl(this._self, this._then);

  final ComposeLoadedUploading _self;
  final $Res Function(ComposeLoadedUploading) _then;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? progress = null,}) {
  return _then(ComposeLoadedUploading(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ComposeDraft,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComposeDraftCopyWith<$Res> get draft {
  
  return $ComposeDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class ComposeError extends ComposeState {
  const ComposeError({required this.failure, required this.draft}): super._();
  

 final  AppFailure failure;
 final  ComposeDraft draft;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeErrorCopyWith<ComposeError> get copyWith => _$ComposeErrorCopyWithImpl<ComposeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeError&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,failure,draft);

@override
String toString() {
  return 'ComposeState.error(failure: $failure, draft: $draft)';
}


}

/// @nodoc
abstract mixin class $ComposeErrorCopyWith<$Res> implements $ComposeStateCopyWith<$Res> {
  factory $ComposeErrorCopyWith(ComposeError value, $Res Function(ComposeError) _then) = _$ComposeErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure, ComposeDraft draft
});


$AppFailureCopyWith<$Res> get failure;$ComposeDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$ComposeErrorCopyWithImpl<$Res>
    implements $ComposeErrorCopyWith<$Res> {
  _$ComposeErrorCopyWithImpl(this._self, this._then);

  final ComposeError _self;
  final $Res Function(ComposeError) _then;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? draft = null,}) {
  return _then(ComposeError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ComposeDraft,
  ));
}

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComposeDraftCopyWith<$Res> get draft {
  
  return $ComposeDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class ComposePublished extends ComposeState {
  const ComposePublished(this.post): super._();
  

 final  Post post;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposePublishedCopyWith<ComposePublished> get copyWith => _$ComposePublishedCopyWithImpl<ComposePublished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposePublished&&(identical(other.post, post) || other.post == post));
}


@override
int get hashCode => Object.hash(runtimeType,post);

@override
String toString() {
  return 'ComposeState.published(post: $post)';
}


}

/// @nodoc
abstract mixin class $ComposePublishedCopyWith<$Res> implements $ComposeStateCopyWith<$Res> {
  factory $ComposePublishedCopyWith(ComposePublished value, $Res Function(ComposePublished) _then) = _$ComposePublishedCopyWithImpl;
@useResult
$Res call({
 Post post
});


$PostCopyWith<$Res> get post;

}
/// @nodoc
class _$ComposePublishedCopyWithImpl<$Res>
    implements $ComposePublishedCopyWith<$Res> {
  _$ComposePublishedCopyWithImpl(this._self, this._then);

  final ComposePublished _self;
  final $Res Function(ComposePublished) _then;

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = null,}) {
  return _then(ComposePublished(
null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post,
  ));
}

/// Create a copy of ComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res> get post {
  
  return $PostCopyWith<$Res>(_self.post, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}

// dart format on
