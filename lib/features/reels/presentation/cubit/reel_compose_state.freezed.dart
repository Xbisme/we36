// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reel_compose_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReelComposeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelComposeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReelComposeState()';
}


}

/// @nodoc
class $ReelComposeStateCopyWith<$Res>  {
$ReelComposeStateCopyWith(ReelComposeState _, $Res Function(ReelComposeState) __);
}


/// Adds pattern-matching-related methods to [ReelComposeState].
extension ReelComposeStatePatterns on ReelComposeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReelComposeInitial value)?  initial,TResult Function( ReelComposeLoading value)?  loading,TResult Function( ReelComposeLoaded value)?  loaded,TResult Function( ReelComposeLoadedUploading value)?  loadedUploading,TResult Function( ReelComposeError value)?  error,TResult Function( ReelComposePublished value)?  published,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReelComposeInitial() when initial != null:
return initial(_that);case ReelComposeLoading() when loading != null:
return loading(_that);case ReelComposeLoaded() when loaded != null:
return loaded(_that);case ReelComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that);case ReelComposeError() when error != null:
return error(_that);case ReelComposePublished() when published != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReelComposeInitial value)  initial,required TResult Function( ReelComposeLoading value)  loading,required TResult Function( ReelComposeLoaded value)  loaded,required TResult Function( ReelComposeLoadedUploading value)  loadedUploading,required TResult Function( ReelComposeError value)  error,required TResult Function( ReelComposePublished value)  published,}){
final _that = this;
switch (_that) {
case ReelComposeInitial():
return initial(_that);case ReelComposeLoading():
return loading(_that);case ReelComposeLoaded():
return loaded(_that);case ReelComposeLoadedUploading():
return loadedUploading(_that);case ReelComposeError():
return error(_that);case ReelComposePublished():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReelComposeInitial value)?  initial,TResult? Function( ReelComposeLoading value)?  loading,TResult? Function( ReelComposeLoaded value)?  loaded,TResult? Function( ReelComposeLoadedUploading value)?  loadedUploading,TResult? Function( ReelComposeError value)?  error,TResult? Function( ReelComposePublished value)?  published,}){
final _that = this;
switch (_that) {
case ReelComposeInitial() when initial != null:
return initial(_that);case ReelComposeLoading() when loading != null:
return loading(_that);case ReelComposeLoaded() when loaded != null:
return loaded(_that);case ReelComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that);case ReelComposeError() when error != null:
return error(_that);case ReelComposePublished() when published != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<AssetRef> videos,  ReelDraft? draft)?  loaded,TResult Function( ReelDraft draft,  double fraction)?  loadedUploading,TResult Function( AppFailure failure,  ReelDraft? draft)?  error,TResult Function( Reel reel)?  published,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReelComposeInitial() when initial != null:
return initial();case ReelComposeLoading() when loading != null:
return loading();case ReelComposeLoaded() when loaded != null:
return loaded(_that.videos,_that.draft);case ReelComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that.draft,_that.fraction);case ReelComposeError() when error != null:
return error(_that.failure,_that.draft);case ReelComposePublished() when published != null:
return published(_that.reel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<AssetRef> videos,  ReelDraft? draft)  loaded,required TResult Function( ReelDraft draft,  double fraction)  loadedUploading,required TResult Function( AppFailure failure,  ReelDraft? draft)  error,required TResult Function( Reel reel)  published,}) {final _that = this;
switch (_that) {
case ReelComposeInitial():
return initial();case ReelComposeLoading():
return loading();case ReelComposeLoaded():
return loaded(_that.videos,_that.draft);case ReelComposeLoadedUploading():
return loadedUploading(_that.draft,_that.fraction);case ReelComposeError():
return error(_that.failure,_that.draft);case ReelComposePublished():
return published(_that.reel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<AssetRef> videos,  ReelDraft? draft)?  loaded,TResult? Function( ReelDraft draft,  double fraction)?  loadedUploading,TResult? Function( AppFailure failure,  ReelDraft? draft)?  error,TResult? Function( Reel reel)?  published,}) {final _that = this;
switch (_that) {
case ReelComposeInitial() when initial != null:
return initial();case ReelComposeLoading() when loading != null:
return loading();case ReelComposeLoaded() when loaded != null:
return loaded(_that.videos,_that.draft);case ReelComposeLoadedUploading() when loadedUploading != null:
return loadedUploading(_that.draft,_that.fraction);case ReelComposeError() when error != null:
return error(_that.failure,_that.draft);case ReelComposePublished() when published != null:
return published(_that.reel);case _:
  return null;

}
}

}

/// @nodoc


class ReelComposeInitial extends ReelComposeState {
  const ReelComposeInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelComposeInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReelComposeState.initial()';
}


}




/// @nodoc


class ReelComposeLoading extends ReelComposeState {
  const ReelComposeLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelComposeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReelComposeState.loading()';
}


}




/// @nodoc


class ReelComposeLoaded extends ReelComposeState {
  const ReelComposeLoaded({required final  List<AssetRef> videos, this.draft}): _videos = videos,super._();
  

 final  List<AssetRef> _videos;
 List<AssetRef> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}

 final  ReelDraft? draft;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelComposeLoadedCopyWith<ReelComposeLoaded> get copyWith => _$ReelComposeLoadedCopyWithImpl<ReelComposeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelComposeLoaded&&const DeepCollectionEquality().equals(other._videos, _videos)&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_videos),draft);

@override
String toString() {
  return 'ReelComposeState.loaded(videos: $videos, draft: $draft)';
}


}

/// @nodoc
abstract mixin class $ReelComposeLoadedCopyWith<$Res> implements $ReelComposeStateCopyWith<$Res> {
  factory $ReelComposeLoadedCopyWith(ReelComposeLoaded value, $Res Function(ReelComposeLoaded) _then) = _$ReelComposeLoadedCopyWithImpl;
@useResult
$Res call({
 List<AssetRef> videos, ReelDraft? draft
});


$ReelDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class _$ReelComposeLoadedCopyWithImpl<$Res>
    implements $ReelComposeLoadedCopyWith<$Res> {
  _$ReelComposeLoadedCopyWithImpl(this._self, this._then);

  final ReelComposeLoaded _self;
  final $Res Function(ReelComposeLoaded) _then;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? videos = null,Object? draft = freezed,}) {
  return _then(ReelComposeLoaded(
videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<AssetRef>,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReelDraft?,
  ));
}

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReelDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $ReelDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class ReelComposeLoadedUploading extends ReelComposeState {
  const ReelComposeLoadedUploading({required this.draft, required this.fraction}): super._();
  

 final  ReelDraft draft;
 final  double fraction;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelComposeLoadedUploadingCopyWith<ReelComposeLoadedUploading> get copyWith => _$ReelComposeLoadedUploadingCopyWithImpl<ReelComposeLoadedUploading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelComposeLoadedUploading&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.fraction, fraction) || other.fraction == fraction));
}


@override
int get hashCode => Object.hash(runtimeType,draft,fraction);

@override
String toString() {
  return 'ReelComposeState.loadedUploading(draft: $draft, fraction: $fraction)';
}


}

/// @nodoc
abstract mixin class $ReelComposeLoadedUploadingCopyWith<$Res> implements $ReelComposeStateCopyWith<$Res> {
  factory $ReelComposeLoadedUploadingCopyWith(ReelComposeLoadedUploading value, $Res Function(ReelComposeLoadedUploading) _then) = _$ReelComposeLoadedUploadingCopyWithImpl;
@useResult
$Res call({
 ReelDraft draft, double fraction
});


$ReelDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$ReelComposeLoadedUploadingCopyWithImpl<$Res>
    implements $ReelComposeLoadedUploadingCopyWith<$Res> {
  _$ReelComposeLoadedUploadingCopyWithImpl(this._self, this._then);

  final ReelComposeLoadedUploading _self;
  final $Res Function(ReelComposeLoadedUploading) _then;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? fraction = null,}) {
  return _then(ReelComposeLoadedUploading(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReelDraft,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReelDraftCopyWith<$Res> get draft {
  
  return $ReelDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class ReelComposeError extends ReelComposeState {
  const ReelComposeError({required this.failure, this.draft}): super._();
  

 final  AppFailure failure;
 final  ReelDraft? draft;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelComposeErrorCopyWith<ReelComposeError> get copyWith => _$ReelComposeErrorCopyWithImpl<ReelComposeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelComposeError&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,failure,draft);

@override
String toString() {
  return 'ReelComposeState.error(failure: $failure, draft: $draft)';
}


}

/// @nodoc
abstract mixin class $ReelComposeErrorCopyWith<$Res> implements $ReelComposeStateCopyWith<$Res> {
  factory $ReelComposeErrorCopyWith(ReelComposeError value, $Res Function(ReelComposeError) _then) = _$ReelComposeErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure, ReelDraft? draft
});


$AppFailureCopyWith<$Res> get failure;$ReelDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class _$ReelComposeErrorCopyWithImpl<$Res>
    implements $ReelComposeErrorCopyWith<$Res> {
  _$ReelComposeErrorCopyWithImpl(this._self, this._then);

  final ReelComposeError _self;
  final $Res Function(ReelComposeError) _then;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? draft = freezed,}) {
  return _then(ReelComposeError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReelDraft?,
  ));
}

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReelDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $ReelDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class ReelComposePublished extends ReelComposeState {
  const ReelComposePublished(this.reel): super._();
  

 final  Reel reel;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReelComposePublishedCopyWith<ReelComposePublished> get copyWith => _$ReelComposePublishedCopyWithImpl<ReelComposePublished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReelComposePublished&&(identical(other.reel, reel) || other.reel == reel));
}


@override
int get hashCode => Object.hash(runtimeType,reel);

@override
String toString() {
  return 'ReelComposeState.published(reel: $reel)';
}


}

/// @nodoc
abstract mixin class $ReelComposePublishedCopyWith<$Res> implements $ReelComposeStateCopyWith<$Res> {
  factory $ReelComposePublishedCopyWith(ReelComposePublished value, $Res Function(ReelComposePublished) _then) = _$ReelComposePublishedCopyWithImpl;
@useResult
$Res call({
 Reel reel
});


$ReelCopyWith<$Res> get reel;

}
/// @nodoc
class _$ReelComposePublishedCopyWithImpl<$Res>
    implements $ReelComposePublishedCopyWith<$Res> {
  _$ReelComposePublishedCopyWithImpl(this._self, this._then);

  final ReelComposePublished _self;
  final $Res Function(ReelComposePublished) _then;

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reel = null,}) {
  return _then(ReelComposePublished(
null == reel ? _self.reel : reel // ignore: cast_nullable_to_non_nullable
as Reel,
  ));
}

/// Create a copy of ReelComposeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReelCopyWith<$Res> get reel {
  
  return $ReelCopyWith<$Res>(_self.reel, (value) {
    return _then(_self.copyWith(reel: value));
  });
}
}

// dart format on
