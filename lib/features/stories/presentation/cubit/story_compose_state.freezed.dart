// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_compose_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryComposeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryComposeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryComposeState()';
}


}

/// @nodoc
class $StoryComposeStateCopyWith<$Res>  {
$StoryComposeStateCopyWith(StoryComposeState _, $Res Function(StoryComposeState) __);
}


/// Adds pattern-matching-related methods to [StoryComposeState].
extension StoryComposeStatePatterns on StoryComposeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StoryComposeInitial value)?  initial,TResult Function( StoryComposeLoaded value)?  loaded,TResult Function( StoryComposeLoadedUploading value)?  loadedUploading,TResult Function( StoryComposeError value)?  error,TResult Function( StoryComposePublished value)?  published,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StoryComposeInitial() when initial != null:
return initial(_that);case StoryComposeLoaded() when loaded != null:
return loaded(_that);case StoryComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that);case StoryComposeError() when error != null:
return error(_that);case StoryComposePublished() when published != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StoryComposeInitial value)  initial,required TResult Function( StoryComposeLoaded value)  loaded,required TResult Function( StoryComposeLoadedUploading value)  loadedUploading,required TResult Function( StoryComposeError value)  error,required TResult Function( StoryComposePublished value)  published,}){
final _that = this;
switch (_that) {
case StoryComposeInitial():
return initial(_that);case StoryComposeLoaded():
return loaded(_that);case StoryComposeLoadedUploading():
return loadedUploading(_that);case StoryComposeError():
return error(_that);case StoryComposePublished():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StoryComposeInitial value)?  initial,TResult? Function( StoryComposeLoaded value)?  loaded,TResult? Function( StoryComposeLoadedUploading value)?  loadedUploading,TResult? Function( StoryComposeError value)?  error,TResult? Function( StoryComposePublished value)?  published,}){
final _that = this;
switch (_that) {
case StoryComposeInitial() when initial != null:
return initial(_that);case StoryComposeLoaded() when loaded != null:
return loaded(_that);case StoryComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that);case StoryComposeError() when error != null:
return error(_that);case StoryComposePublished() when published != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( StoryComposeDraft draft)?  loaded,TResult Function( StoryComposeDraft draft,  double progress)?  loadedUploading,TResult Function( AppFailure failure,  StoryComposeDraft draft)?  error,TResult Function( StorySegment segment)?  published,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StoryComposeInitial() when initial != null:
return initial();case StoryComposeLoaded() when loaded != null:
return loaded(_that.draft);case StoryComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that.draft,_that.progress);case StoryComposeError() when error != null:
return error(_that.failure,_that.draft);case StoryComposePublished() when published != null:
return published(_that.segment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( StoryComposeDraft draft)  loaded,required TResult Function( StoryComposeDraft draft,  double progress)  loadedUploading,required TResult Function( AppFailure failure,  StoryComposeDraft draft)  error,required TResult Function( StorySegment segment)  published,}) {final _that = this;
switch (_that) {
case StoryComposeInitial():
return initial();case StoryComposeLoaded():
return loaded(_that.draft);case StoryComposeLoadedUploading():
return loadedUploading(_that.draft,_that.progress);case StoryComposeError():
return error(_that.failure,_that.draft);case StoryComposePublished():
return published(_that.segment);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( StoryComposeDraft draft)?  loaded,TResult? Function( StoryComposeDraft draft,  double progress)?  loadedUploading,TResult? Function( AppFailure failure,  StoryComposeDraft draft)?  error,TResult? Function( StorySegment segment)?  published,}) {final _that = this;
switch (_that) {
case StoryComposeInitial() when initial != null:
return initial();case StoryComposeLoaded() when loaded != null:
return loaded(_that.draft);case StoryComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that.draft,_that.progress);case StoryComposeError() when error != null:
return error(_that.failure,_that.draft);case StoryComposePublished() when published != null:
return published(_that.segment);case _:
  return null;

}
}

}

/// @nodoc


class StoryComposeInitial extends StoryComposeState {
  const StoryComposeInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryComposeInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryComposeState.initial()';
}


}




/// @nodoc


class StoryComposeLoaded extends StoryComposeState {
  const StoryComposeLoaded({required this.draft}): super._();
  

 final  StoryComposeDraft draft;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryComposeLoadedCopyWith<StoryComposeLoaded> get copyWith => _$StoryComposeLoadedCopyWithImpl<StoryComposeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryComposeLoaded&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,draft);

@override
String toString() {
  return 'StoryComposeState.loaded(draft: $draft)';
}


}

/// @nodoc
abstract mixin class $StoryComposeLoadedCopyWith<$Res> implements $StoryComposeStateCopyWith<$Res> {
  factory $StoryComposeLoadedCopyWith(StoryComposeLoaded value, $Res Function(StoryComposeLoaded) _then) = _$StoryComposeLoadedCopyWithImpl;
@useResult
$Res call({
 StoryComposeDraft draft
});


$StoryComposeDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$StoryComposeLoadedCopyWithImpl<$Res>
    implements $StoryComposeLoadedCopyWith<$Res> {
  _$StoryComposeLoadedCopyWithImpl(this._self, this._then);

  final StoryComposeLoaded _self;
  final $Res Function(StoryComposeLoaded) _then;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,}) {
  return _then(StoryComposeLoaded(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as StoryComposeDraft,
  ));
}

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryComposeDraftCopyWith<$Res> get draft {
  
  return $StoryComposeDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class StoryComposeLoadedUploading extends StoryComposeState {
  const StoryComposeLoadedUploading({required this.draft, this.progress = 0.0}): super._();
  

 final  StoryComposeDraft draft;
@JsonKey() final  double progress;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryComposeLoadedUploadingCopyWith<StoryComposeLoadedUploading> get copyWith => _$StoryComposeLoadedUploadingCopyWithImpl<StoryComposeLoadedUploading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryComposeLoadedUploading&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,draft,progress);

@override
String toString() {
  return 'StoryComposeState.loadedUploading(draft: $draft, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $StoryComposeLoadedUploadingCopyWith<$Res> implements $StoryComposeStateCopyWith<$Res> {
  factory $StoryComposeLoadedUploadingCopyWith(StoryComposeLoadedUploading value, $Res Function(StoryComposeLoadedUploading) _then) = _$StoryComposeLoadedUploadingCopyWithImpl;
@useResult
$Res call({
 StoryComposeDraft draft, double progress
});


$StoryComposeDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$StoryComposeLoadedUploadingCopyWithImpl<$Res>
    implements $StoryComposeLoadedUploadingCopyWith<$Res> {
  _$StoryComposeLoadedUploadingCopyWithImpl(this._self, this._then);

  final StoryComposeLoadedUploading _self;
  final $Res Function(StoryComposeLoadedUploading) _then;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? progress = null,}) {
  return _then(StoryComposeLoadedUploading(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as StoryComposeDraft,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryComposeDraftCopyWith<$Res> get draft {
  
  return $StoryComposeDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class StoryComposeError extends StoryComposeState {
  const StoryComposeError({required this.failure, required this.draft}): super._();
  

 final  AppFailure failure;
 final  StoryComposeDraft draft;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryComposeErrorCopyWith<StoryComposeError> get copyWith => _$StoryComposeErrorCopyWithImpl<StoryComposeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryComposeError&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,failure,draft);

@override
String toString() {
  return 'StoryComposeState.error(failure: $failure, draft: $draft)';
}


}

/// @nodoc
abstract mixin class $StoryComposeErrorCopyWith<$Res> implements $StoryComposeStateCopyWith<$Res> {
  factory $StoryComposeErrorCopyWith(StoryComposeError value, $Res Function(StoryComposeError) _then) = _$StoryComposeErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure, StoryComposeDraft draft
});


$AppFailureCopyWith<$Res> get failure;$StoryComposeDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$StoryComposeErrorCopyWithImpl<$Res>
    implements $StoryComposeErrorCopyWith<$Res> {
  _$StoryComposeErrorCopyWithImpl(this._self, this._then);

  final StoryComposeError _self;
  final $Res Function(StoryComposeError) _then;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? draft = null,}) {
  return _then(StoryComposeError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as StoryComposeDraft,
  ));
}

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryComposeDraftCopyWith<$Res> get draft {
  
  return $StoryComposeDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class StoryComposePublished extends StoryComposeState {
  const StoryComposePublished(this.segment): super._();
  

 final  StorySegment segment;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryComposePublishedCopyWith<StoryComposePublished> get copyWith => _$StoryComposePublishedCopyWithImpl<StoryComposePublished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryComposePublished&&(identical(other.segment, segment) || other.segment == segment));
}


@override
int get hashCode => Object.hash(runtimeType,segment);

@override
String toString() {
  return 'StoryComposeState.published(segment: $segment)';
}


}

/// @nodoc
abstract mixin class $StoryComposePublishedCopyWith<$Res> implements $StoryComposeStateCopyWith<$Res> {
  factory $StoryComposePublishedCopyWith(StoryComposePublished value, $Res Function(StoryComposePublished) _then) = _$StoryComposePublishedCopyWithImpl;
@useResult
$Res call({
 StorySegment segment
});


$StorySegmentCopyWith<$Res> get segment;

}
/// @nodoc
class _$StoryComposePublishedCopyWithImpl<$Res>
    implements $StoryComposePublishedCopyWith<$Res> {
  _$StoryComposePublishedCopyWithImpl(this._self, this._then);

  final StoryComposePublished _self;
  final $Res Function(StoryComposePublished) _then;

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? segment = null,}) {
  return _then(StoryComposePublished(
null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as StorySegment,
  ));
}

/// Create a copy of StoryComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorySegmentCopyWith<$Res> get segment {
  
  return $StorySegmentCopyWith<$Res>(_self.segment, (value) {
    return _then(_self.copyWith(segment: value));
  });
}
}

// dart format on
