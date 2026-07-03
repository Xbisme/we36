// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recents_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecentsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecentsState()';
}


}

/// @nodoc
class $RecentsStateCopyWith<$Res>  {
$RecentsStateCopyWith(RecentsState _, $Res Function(RecentsState) __);
}


/// Adds pattern-matching-related methods to [RecentsState].
extension RecentsStatePatterns on RecentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RecentsInitial value)?  initial,TResult Function( RecentsLoading value)?  loading,TResult Function( RecentsLoaded value)?  loaded,TResult Function( RecentsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RecentsInitial() when initial != null:
return initial(_that);case RecentsLoading() when loading != null:
return loading(_that);case RecentsLoaded() when loaded != null:
return loaded(_that);case RecentsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RecentsInitial value)  initial,required TResult Function( RecentsLoading value)  loading,required TResult Function( RecentsLoaded value)  loaded,required TResult Function( RecentsError value)  error,}){
final _that = this;
switch (_that) {
case RecentsInitial():
return initial(_that);case RecentsLoading():
return loading(_that);case RecentsLoaded():
return loaded(_that);case RecentsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RecentsInitial value)?  initial,TResult? Function( RecentsLoading value)?  loading,TResult? Function( RecentsLoaded value)?  loaded,TResult? Function( RecentsError value)?  error,}){
final _that = this;
switch (_that) {
case RecentsInitial() when initial != null:
return initial(_that);case RecentsLoading() when loading != null:
return loading(_that);case RecentsLoaded() when loaded != null:
return loaded(_that);case RecentsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SearchRecent> items)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RecentsInitial() when initial != null:
return initial();case RecentsLoading() when loading != null:
return loading();case RecentsLoaded() when loaded != null:
return loaded(_that.items);case RecentsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SearchRecent> items)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case RecentsInitial():
return initial();case RecentsLoading():
return loading();case RecentsLoaded():
return loaded(_that.items);case RecentsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SearchRecent> items)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case RecentsInitial() when initial != null:
return initial();case RecentsLoading() when loading != null:
return loading();case RecentsLoaded() when loaded != null:
return loaded(_that.items);case RecentsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class RecentsInitial extends RecentsState {
  const RecentsInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecentsState.initial()';
}


}




/// @nodoc


class RecentsLoading extends RecentsState {
  const RecentsLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecentsState.loading()';
}


}




/// @nodoc


class RecentsLoaded extends RecentsState {
  const RecentsLoaded(final  List<SearchRecent> items): _items = items,super._();
  

 final  List<SearchRecent> _items;
 List<SearchRecent> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of RecentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentsLoadedCopyWith<RecentsLoaded> get copyWith => _$RecentsLoadedCopyWithImpl<RecentsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentsLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'RecentsState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class $RecentsLoadedCopyWith<$Res> implements $RecentsStateCopyWith<$Res> {
  factory $RecentsLoadedCopyWith(RecentsLoaded value, $Res Function(RecentsLoaded) _then) = _$RecentsLoadedCopyWithImpl;
@useResult
$Res call({
 List<SearchRecent> items
});




}
/// @nodoc
class _$RecentsLoadedCopyWithImpl<$Res>
    implements $RecentsLoadedCopyWith<$Res> {
  _$RecentsLoadedCopyWithImpl(this._self, this._then);

  final RecentsLoaded _self;
  final $Res Function(RecentsLoaded) _then;

/// Create a copy of RecentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(RecentsLoaded(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SearchRecent>,
  ));
}


}

/// @nodoc


class RecentsError extends RecentsState {
  const RecentsError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of RecentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentsErrorCopyWith<RecentsError> get copyWith => _$RecentsErrorCopyWithImpl<RecentsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'RecentsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $RecentsErrorCopyWith<$Res> implements $RecentsStateCopyWith<$Res> {
  factory $RecentsErrorCopyWith(RecentsError value, $Res Function(RecentsError) _then) = _$RecentsErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$RecentsErrorCopyWithImpl<$Res>
    implements $RecentsErrorCopyWith<$Res> {
  _$RecentsErrorCopyWithImpl(this._self, this._then);

  final RecentsError _self;
  final $Res Function(RecentsError) _then;

/// Create a copy of RecentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(RecentsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of RecentsState
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
