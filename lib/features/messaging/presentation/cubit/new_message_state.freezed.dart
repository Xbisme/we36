// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_message_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewMessageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewMessageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewMessageState()';
}


}

/// @nodoc
class $NewMessageStateCopyWith<$Res>  {
$NewMessageStateCopyWith(NewMessageState _, $Res Function(NewMessageState) __);
}


/// Adds pattern-matching-related methods to [NewMessageState].
extension NewMessageStatePatterns on NewMessageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NewMessageInitial value)?  initial,TResult Function( NewMessageLoading value)?  loading,TResult Function( NewMessageLoaded value)?  loaded,TResult Function( NewMessageError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NewMessageInitial() when initial != null:
return initial(_that);case NewMessageLoading() when loading != null:
return loading(_that);case NewMessageLoaded() when loaded != null:
return loaded(_that);case NewMessageError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NewMessageInitial value)  initial,required TResult Function( NewMessageLoading value)  loading,required TResult Function( NewMessageLoaded value)  loaded,required TResult Function( NewMessageError value)  error,}){
final _that = this;
switch (_that) {
case NewMessageInitial():
return initial(_that);case NewMessageLoading():
return loading(_that);case NewMessageLoaded():
return loaded(_that);case NewMessageError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NewMessageInitial value)?  initial,TResult? Function( NewMessageLoading value)?  loading,TResult? Function( NewMessageLoaded value)?  loaded,TResult? Function( NewMessageError value)?  error,}){
final _that = this;
switch (_that) {
case NewMessageInitial() when initial != null:
return initial(_that);case NewMessageLoading() when loading != null:
return loading(_that);case NewMessageLoaded() when loaded != null:
return loaded(_that);case NewMessageError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<UserSummary> people,  String query)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NewMessageInitial() when initial != null:
return initial();case NewMessageLoading() when loading != null:
return loading();case NewMessageLoaded() when loaded != null:
return loaded(_that.people,_that.query);case NewMessageError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<UserSummary> people,  String query)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case NewMessageInitial():
return initial();case NewMessageLoading():
return loading();case NewMessageLoaded():
return loaded(_that.people,_that.query);case NewMessageError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<UserSummary> people,  String query)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case NewMessageInitial() when initial != null:
return initial();case NewMessageLoading() when loading != null:
return loading();case NewMessageLoaded() when loaded != null:
return loaded(_that.people,_that.query);case NewMessageError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class NewMessageInitial implements NewMessageState {
  const NewMessageInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewMessageInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewMessageState.initial()';
}


}




/// @nodoc


class NewMessageLoading implements NewMessageState {
  const NewMessageLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewMessageLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewMessageState.loading()';
}


}




/// @nodoc


class NewMessageLoaded implements NewMessageState {
  const NewMessageLoaded({required final  List<UserSummary> people, this.query = ''}): _people = people;
  

 final  List<UserSummary> _people;
 List<UserSummary> get people {
  if (_people is EqualUnmodifiableListView) return _people;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_people);
}

@JsonKey() final  String query;

/// Create a copy of NewMessageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewMessageLoadedCopyWith<NewMessageLoaded> get copyWith => _$NewMessageLoadedCopyWithImpl<NewMessageLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewMessageLoaded&&const DeepCollectionEquality().equals(other._people, _people)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_people),query);

@override
String toString() {
  return 'NewMessageState.loaded(people: $people, query: $query)';
}


}

/// @nodoc
abstract mixin class $NewMessageLoadedCopyWith<$Res> implements $NewMessageStateCopyWith<$Res> {
  factory $NewMessageLoadedCopyWith(NewMessageLoaded value, $Res Function(NewMessageLoaded) _then) = _$NewMessageLoadedCopyWithImpl;
@useResult
$Res call({
 List<UserSummary> people, String query
});




}
/// @nodoc
class _$NewMessageLoadedCopyWithImpl<$Res>
    implements $NewMessageLoadedCopyWith<$Res> {
  _$NewMessageLoadedCopyWithImpl(this._self, this._then);

  final NewMessageLoaded _self;
  final $Res Function(NewMessageLoaded) _then;

/// Create a copy of NewMessageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? people = null,Object? query = null,}) {
  return _then(NewMessageLoaded(
people: null == people ? _self._people : people // ignore: cast_nullable_to_non_nullable
as List<UserSummary>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NewMessageError implements NewMessageState {
  const NewMessageError(this.failure);
  

 final  AppFailure failure;

/// Create a copy of NewMessageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewMessageErrorCopyWith<NewMessageError> get copyWith => _$NewMessageErrorCopyWithImpl<NewMessageError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewMessageError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'NewMessageState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $NewMessageErrorCopyWith<$Res> implements $NewMessageStateCopyWith<$Res> {
  factory $NewMessageErrorCopyWith(NewMessageError value, $Res Function(NewMessageError) _then) = _$NewMessageErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$NewMessageErrorCopyWithImpl<$Res>
    implements $NewMessageErrorCopyWith<$Res> {
  _$NewMessageErrorCopyWithImpl(this._self, this._then);

  final NewMessageError _self;
  final $Res Function(NewMessageError) _then;

/// Create a copy of NewMessageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(NewMessageError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of NewMessageState
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
