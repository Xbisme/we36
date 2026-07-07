// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_edit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectionEditState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionEditState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionEditState()';
}


}

/// @nodoc
class $CollectionEditStateCopyWith<$Res>  {
$CollectionEditStateCopyWith(CollectionEditState _, $Res Function(CollectionEditState) __);
}


/// Adds pattern-matching-related methods to [CollectionEditState].
extension CollectionEditStatePatterns on CollectionEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CollectionEditIdle value)?  idle,TResult Function( CollectionEditWorking value)?  working,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CollectionEditIdle() when idle != null:
return idle(_that);case CollectionEditWorking() when working != null:
return working(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CollectionEditIdle value)  idle,required TResult Function( CollectionEditWorking value)  working,}){
final _that = this;
switch (_that) {
case CollectionEditIdle():
return idle(_that);case CollectionEditWorking():
return working(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CollectionEditIdle value)?  idle,TResult? Function( CollectionEditWorking value)?  working,}){
final _that = this;
switch (_that) {
case CollectionEditIdle() when idle != null:
return idle(_that);case CollectionEditWorking() when working != null:
return working(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  working,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CollectionEditIdle() when idle != null:
return idle();case CollectionEditWorking() when working != null:
return working();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  working,}) {final _that = this;
switch (_that) {
case CollectionEditIdle():
return idle();case CollectionEditWorking():
return working();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  working,}) {final _that = this;
switch (_that) {
case CollectionEditIdle() when idle != null:
return idle();case CollectionEditWorking() when working != null:
return working();case _:
  return null;

}
}

}

/// @nodoc


class CollectionEditIdle implements CollectionEditState {
  const CollectionEditIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionEditIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionEditState.idle()';
}


}




/// @nodoc


class CollectionEditWorking implements CollectionEditState {
  const CollectionEditWorking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionEditWorking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CollectionEditState.working()';
}


}




// dart format on
