// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_to_collection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaveToCollectionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveToCollectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SaveToCollectionState()';
}


}

/// @nodoc
class $SaveToCollectionStateCopyWith<$Res>  {
$SaveToCollectionStateCopyWith(SaveToCollectionState _, $Res Function(SaveToCollectionState) __);
}


/// Adds pattern-matching-related methods to [SaveToCollectionState].
extension SaveToCollectionStatePatterns on SaveToCollectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SaveToCollectionInitial value)?  initial,TResult Function( SaveToCollectionLoading value)?  loading,TResult Function( SaveToCollectionLoaded value)?  loaded,TResult Function( SaveToCollectionError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SaveToCollectionInitial() when initial != null:
return initial(_that);case SaveToCollectionLoading() when loading != null:
return loading(_that);case SaveToCollectionLoaded() when loaded != null:
return loaded(_that);case SaveToCollectionError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SaveToCollectionInitial value)  initial,required TResult Function( SaveToCollectionLoading value)  loading,required TResult Function( SaveToCollectionLoaded value)  loaded,required TResult Function( SaveToCollectionError value)  error,}){
final _that = this;
switch (_that) {
case SaveToCollectionInitial():
return initial(_that);case SaveToCollectionLoading():
return loading(_that);case SaveToCollectionLoaded():
return loaded(_that);case SaveToCollectionError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SaveToCollectionInitial value)?  initial,TResult? Function( SaveToCollectionLoading value)?  loading,TResult? Function( SaveToCollectionLoaded value)?  loaded,TResult? Function( SaveToCollectionError value)?  error,}){
final _that = this;
switch (_that) {
case SaveToCollectionInitial() when initial != null:
return initial(_that);case SaveToCollectionLoading() when loading != null:
return loading(_that);case SaveToCollectionLoaded() when loaded != null:
return loaded(_that);case SaveToCollectionError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PostCollectionsMembership membership,  bool creating)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SaveToCollectionInitial() when initial != null:
return initial();case SaveToCollectionLoading() when loading != null:
return loading();case SaveToCollectionLoaded() when loaded != null:
return loaded(_that.membership,_that.creating);case SaveToCollectionError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PostCollectionsMembership membership,  bool creating)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case SaveToCollectionInitial():
return initial();case SaveToCollectionLoading():
return loading();case SaveToCollectionLoaded():
return loaded(_that.membership,_that.creating);case SaveToCollectionError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PostCollectionsMembership membership,  bool creating)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case SaveToCollectionInitial() when initial != null:
return initial();case SaveToCollectionLoading() when loading != null:
return loading();case SaveToCollectionLoaded() when loaded != null:
return loaded(_that.membership,_that.creating);case SaveToCollectionError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SaveToCollectionInitial implements SaveToCollectionState {
  const SaveToCollectionInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveToCollectionInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SaveToCollectionState.initial()';
}


}




/// @nodoc


class SaveToCollectionLoading implements SaveToCollectionState {
  const SaveToCollectionLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveToCollectionLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SaveToCollectionState.loading()';
}


}




/// @nodoc


class SaveToCollectionLoaded implements SaveToCollectionState {
  const SaveToCollectionLoaded({required this.membership, this.creating = false});
  

 final  PostCollectionsMembership membership;
@JsonKey() final  bool creating;

/// Create a copy of SaveToCollectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveToCollectionLoadedCopyWith<SaveToCollectionLoaded> get copyWith => _$SaveToCollectionLoadedCopyWithImpl<SaveToCollectionLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveToCollectionLoaded&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.creating, creating) || other.creating == creating));
}


@override
int get hashCode => Object.hash(runtimeType,membership,creating);

@override
String toString() {
  return 'SaveToCollectionState.loaded(membership: $membership, creating: $creating)';
}


}

/// @nodoc
abstract mixin class $SaveToCollectionLoadedCopyWith<$Res> implements $SaveToCollectionStateCopyWith<$Res> {
  factory $SaveToCollectionLoadedCopyWith(SaveToCollectionLoaded value, $Res Function(SaveToCollectionLoaded) _then) = _$SaveToCollectionLoadedCopyWithImpl;
@useResult
$Res call({
 PostCollectionsMembership membership, bool creating
});


$PostCollectionsMembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$SaveToCollectionLoadedCopyWithImpl<$Res>
    implements $SaveToCollectionLoadedCopyWith<$Res> {
  _$SaveToCollectionLoadedCopyWithImpl(this._self, this._then);

  final SaveToCollectionLoaded _self;
  final $Res Function(SaveToCollectionLoaded) _then;

/// Create a copy of SaveToCollectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? membership = null,Object? creating = null,}) {
  return _then(SaveToCollectionLoaded(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as PostCollectionsMembership,creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SaveToCollectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCollectionsMembershipCopyWith<$Res> get membership {
  
  return $PostCollectionsMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}

/// @nodoc


class SaveToCollectionError implements SaveToCollectionState {
  const SaveToCollectionError(this.failure);
  

 final  AppFailure failure;

/// Create a copy of SaveToCollectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveToCollectionErrorCopyWith<SaveToCollectionError> get copyWith => _$SaveToCollectionErrorCopyWithImpl<SaveToCollectionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveToCollectionError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SaveToCollectionState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SaveToCollectionErrorCopyWith<$Res> implements $SaveToCollectionStateCopyWith<$Res> {
  factory $SaveToCollectionErrorCopyWith(SaveToCollectionError value, $Res Function(SaveToCollectionError) _then) = _$SaveToCollectionErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SaveToCollectionErrorCopyWithImpl<$Res>
    implements $SaveToCollectionErrorCopyWith<$Res> {
  _$SaveToCollectionErrorCopyWithImpl(this._self, this._then);

  final SaveToCollectionError _self;
  final $Res Function(SaveToCollectionError) _then;

/// Create a copy of SaveToCollectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SaveToCollectionError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of SaveToCollectionState
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
