// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppState<$T>()';
}


}

/// @nodoc
class $AppStateCopyWith<T,$Res>  {
$AppStateCopyWith(AppState<T> _, $Res Function(AppState<T>) __);
}


/// Adds pattern-matching-related methods to [AppState].
extension AppStatePatterns<T> on AppState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AppInitial<T> value)?  initial,TResult Function( AppLoading<T> value)?  loading,TResult Function( AppLoaded<T> value)?  loaded,TResult Function( AppError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AppInitial() when initial != null:
return initial(_that);case AppLoading() when loading != null:
return loading(_that);case AppLoaded() when loaded != null:
return loaded(_that);case AppError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AppInitial<T> value)  initial,required TResult Function( AppLoading<T> value)  loading,required TResult Function( AppLoaded<T> value)  loaded,required TResult Function( AppError<T> value)  error,}){
final _that = this;
switch (_that) {
case AppInitial():
return initial(_that);case AppLoading():
return loading(_that);case AppLoaded():
return loaded(_that);case AppError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AppInitial<T> value)?  initial,TResult? Function( AppLoading<T> value)?  loading,TResult? Function( AppLoaded<T> value)?  loaded,TResult? Function( AppError<T> value)?  error,}){
final _that = this;
switch (_that) {
case AppInitial() when initial != null:
return initial(_that);case AppLoading() when loading != null:
return loading(_that);case AppLoaded() when loaded != null:
return loaded(_that);case AppError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( T data)?  loaded,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AppInitial() when initial != null:
return initial();case AppLoading() when loading != null:
return loading();case AppLoaded() when loaded != null:
return loaded(_that.data);case AppError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( T data)  loaded,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case AppInitial():
return initial();case AppLoading():
return loading();case AppLoaded():
return loaded(_that.data);case AppError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( T data)?  loaded,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case AppInitial() when initial != null:
return initial();case AppLoading() when loading != null:
return loading();case AppLoaded() when loaded != null:
return loaded(_that.data);case AppError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AppInitial<T> extends AppState<T> {
  const AppInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppState<$T>.initial()';
}


}




/// @nodoc


class AppLoading<T> extends AppState<T> {
  const AppLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppState<$T>.loading()';
}


}




/// @nodoc


class AppLoaded<T> extends AppState<T> {
  const AppLoaded(this.data): super._();
  

 final  T data;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLoadedCopyWith<T, AppLoaded<T>> get copyWith => _$AppLoadedCopyWithImpl<T, AppLoaded<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLoaded<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'AppState<$T>.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class $AppLoadedCopyWith<T,$Res> implements $AppStateCopyWith<T, $Res> {
  factory $AppLoadedCopyWith(AppLoaded<T> value, $Res Function(AppLoaded<T>) _then) = _$AppLoadedCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$AppLoadedCopyWithImpl<T,$Res>
    implements $AppLoadedCopyWith<T, $Res> {
  _$AppLoadedCopyWithImpl(this._self, this._then);

  final AppLoaded<T> _self;
  final $Res Function(AppLoaded<T>) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(AppLoaded<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class AppError<T> extends AppState<T> {
  const AppError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppErrorCopyWith<T, AppError<T>> get copyWith => _$AppErrorCopyWithImpl<T, AppError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppError<T>&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AppState<$T>.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AppErrorCopyWith<T,$Res> implements $AppStateCopyWith<T, $Res> {
  factory $AppErrorCopyWith(AppError<T> value, $Res Function(AppError<T>) _then) = _$AppErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$AppErrorCopyWithImpl<T,$Res>
    implements $AppErrorCopyWith<T, $Res> {
  _$AppErrorCopyWithImpl(this._self, this._then);

  final AppError<T> _self;
  final $Res Function(AppError<T>) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(AppError<T>(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of AppState
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
