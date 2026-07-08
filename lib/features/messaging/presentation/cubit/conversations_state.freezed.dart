// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversations_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConversationsState()';
}


}

/// @nodoc
class $ConversationsStateCopyWith<$Res>  {
$ConversationsStateCopyWith(ConversationsState _, $Res Function(ConversationsState) __);
}


/// Adds pattern-matching-related methods to [ConversationsState].
extension ConversationsStatePatterns on ConversationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConversationsInitial value)?  initial,TResult Function( ConversationsLoading value)?  loading,TResult Function( ConversationsLoaded value)?  loaded,TResult Function( ConversationsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConversationsInitial() when initial != null:
return initial(_that);case ConversationsLoading() when loading != null:
return loading(_that);case ConversationsLoaded() when loaded != null:
return loaded(_that);case ConversationsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConversationsInitial value)  initial,required TResult Function( ConversationsLoading value)  loading,required TResult Function( ConversationsLoaded value)  loaded,required TResult Function( ConversationsError value)  error,}){
final _that = this;
switch (_that) {
case ConversationsInitial():
return initial(_that);case ConversationsLoading():
return loading(_that);case ConversationsLoaded():
return loaded(_that);case ConversationsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConversationsInitial value)?  initial,TResult? Function( ConversationsLoading value)?  loading,TResult? Function( ConversationsLoaded value)?  loaded,TResult? Function( ConversationsError value)?  error,}){
final _that = this;
switch (_that) {
case ConversationsInitial() when initial != null:
return initial(_that);case ConversationsLoading() when loading != null:
return loading(_that);case ConversationsLoaded() when loaded != null:
return loaded(_that);case ConversationsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Conversation> conversations,  String query,  bool isOffline)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConversationsInitial() when initial != null:
return initial();case ConversationsLoading() when loading != null:
return loading();case ConversationsLoaded() when loaded != null:
return loaded(_that.conversations,_that.query,_that.isOffline);case ConversationsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Conversation> conversations,  String query,  bool isOffline)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case ConversationsInitial():
return initial();case ConversationsLoading():
return loading();case ConversationsLoaded():
return loaded(_that.conversations,_that.query,_that.isOffline);case ConversationsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Conversation> conversations,  String query,  bool isOffline)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case ConversationsInitial() when initial != null:
return initial();case ConversationsLoading() when loading != null:
return loading();case ConversationsLoaded() when loaded != null:
return loaded(_that.conversations,_that.query,_that.isOffline);case ConversationsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ConversationsInitial extends ConversationsState {
  const ConversationsInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConversationsState.initial()';
}


}




/// @nodoc


class ConversationsLoading extends ConversationsState {
  const ConversationsLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConversationsState.loading()';
}


}




/// @nodoc


class ConversationsLoaded extends ConversationsState {
  const ConversationsLoaded({required final  List<Conversation> conversations, this.query = '', this.isOffline = false}): _conversations = conversations,super._();
  

 final  List<Conversation> _conversations;
 List<Conversation> get conversations {
  if (_conversations is EqualUnmodifiableListView) return _conversations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conversations);
}

@JsonKey() final  String query;
@JsonKey() final  bool isOffline;

/// Create a copy of ConversationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationsLoadedCopyWith<ConversationsLoaded> get copyWith => _$ConversationsLoadedCopyWithImpl<ConversationsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationsLoaded&&const DeepCollectionEquality().equals(other._conversations, _conversations)&&(identical(other.query, query) || other.query == query)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_conversations),query,isOffline);

@override
String toString() {
  return 'ConversationsState.loaded(conversations: $conversations, query: $query, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class $ConversationsLoadedCopyWith<$Res> implements $ConversationsStateCopyWith<$Res> {
  factory $ConversationsLoadedCopyWith(ConversationsLoaded value, $Res Function(ConversationsLoaded) _then) = _$ConversationsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Conversation> conversations, String query, bool isOffline
});




}
/// @nodoc
class _$ConversationsLoadedCopyWithImpl<$Res>
    implements $ConversationsLoadedCopyWith<$Res> {
  _$ConversationsLoadedCopyWithImpl(this._self, this._then);

  final ConversationsLoaded _self;
  final $Res Function(ConversationsLoaded) _then;

/// Create a copy of ConversationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conversations = null,Object? query = null,Object? isOffline = null,}) {
  return _then(ConversationsLoaded(
conversations: null == conversations ? _self._conversations : conversations // ignore: cast_nullable_to_non_nullable
as List<Conversation>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ConversationsError extends ConversationsState {
  const ConversationsError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of ConversationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationsErrorCopyWith<ConversationsError> get copyWith => _$ConversationsErrorCopyWithImpl<ConversationsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ConversationsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ConversationsErrorCopyWith<$Res> implements $ConversationsStateCopyWith<$Res> {
  factory $ConversationsErrorCopyWith(ConversationsError value, $Res Function(ConversationsError) _then) = _$ConversationsErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ConversationsErrorCopyWithImpl<$Res>
    implements $ConversationsErrorCopyWith<$Res> {
  _$ConversationsErrorCopyWithImpl(this._self, this._then);

  final ConversationsError _self;
  final $Res Function(ConversationsError) _then;

/// Create a copy of ConversationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ConversationsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of ConversationsState
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
