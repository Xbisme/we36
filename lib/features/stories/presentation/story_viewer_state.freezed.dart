// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_viewer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryViewerState {

 List<StoryReel> get reels; int get reelIndex; int get segmentIndex; bool get paused; bool get closed; bool get unavailable;
/// Create a copy of StoryViewerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryViewerStateCopyWith<StoryViewerState> get copyWith => _$StoryViewerStateCopyWithImpl<StoryViewerState>(this as StoryViewerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryViewerState&&const DeepCollectionEquality().equals(other.reels, reels)&&(identical(other.reelIndex, reelIndex) || other.reelIndex == reelIndex)&&(identical(other.segmentIndex, segmentIndex) || other.segmentIndex == segmentIndex)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.unavailable, unavailable) || other.unavailable == unavailable));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(reels),reelIndex,segmentIndex,paused,closed,unavailable);

@override
String toString() {
  return 'StoryViewerState(reels: $reels, reelIndex: $reelIndex, segmentIndex: $segmentIndex, paused: $paused, closed: $closed, unavailable: $unavailable)';
}


}

/// @nodoc
abstract mixin class $StoryViewerStateCopyWith<$Res>  {
  factory $StoryViewerStateCopyWith(StoryViewerState value, $Res Function(StoryViewerState) _then) = _$StoryViewerStateCopyWithImpl;
@useResult
$Res call({
 List<StoryReel> reels, int reelIndex, int segmentIndex, bool paused, bool closed, bool unavailable
});




}
/// @nodoc
class _$StoryViewerStateCopyWithImpl<$Res>
    implements $StoryViewerStateCopyWith<$Res> {
  _$StoryViewerStateCopyWithImpl(this._self, this._then);

  final StoryViewerState _self;
  final $Res Function(StoryViewerState) _then;

/// Create a copy of StoryViewerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reels = null,Object? reelIndex = null,Object? segmentIndex = null,Object? paused = null,Object? closed = null,Object? unavailable = null,}) {
  return _then(_self.copyWith(
reels: null == reels ? _self.reels : reels // ignore: cast_nullable_to_non_nullable
as List<StoryReel>,reelIndex: null == reelIndex ? _self.reelIndex : reelIndex // ignore: cast_nullable_to_non_nullable
as int,segmentIndex: null == segmentIndex ? _self.segmentIndex : segmentIndex // ignore: cast_nullable_to_non_nullable
as int,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryViewerState].
extension StoryViewerStatePatterns on StoryViewerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryViewerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryViewerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryViewerState value)  $default,){
final _that = this;
switch (_that) {
case _StoryViewerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryViewerState value)?  $default,){
final _that = this;
switch (_that) {
case _StoryViewerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StoryReel> reels,  int reelIndex,  int segmentIndex,  bool paused,  bool closed,  bool unavailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryViewerState() when $default != null:
return $default(_that.reels,_that.reelIndex,_that.segmentIndex,_that.paused,_that.closed,_that.unavailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StoryReel> reels,  int reelIndex,  int segmentIndex,  bool paused,  bool closed,  bool unavailable)  $default,) {final _that = this;
switch (_that) {
case _StoryViewerState():
return $default(_that.reels,_that.reelIndex,_that.segmentIndex,_that.paused,_that.closed,_that.unavailable);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StoryReel> reels,  int reelIndex,  int segmentIndex,  bool paused,  bool closed,  bool unavailable)?  $default,) {final _that = this;
switch (_that) {
case _StoryViewerState() when $default != null:
return $default(_that.reels,_that.reelIndex,_that.segmentIndex,_that.paused,_that.closed,_that.unavailable);case _:
  return null;

}
}

}

/// @nodoc


class _StoryViewerState extends StoryViewerState {
  const _StoryViewerState({required final  List<StoryReel> reels, required this.reelIndex, required this.segmentIndex, this.paused = false, this.closed = false, this.unavailable = false}): _reels = reels,super._();
  

 final  List<StoryReel> _reels;
@override List<StoryReel> get reels {
  if (_reels is EqualUnmodifiableListView) return _reels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reels);
}

@override final  int reelIndex;
@override final  int segmentIndex;
@override@JsonKey() final  bool paused;
@override@JsonKey() final  bool closed;
@override@JsonKey() final  bool unavailable;

/// Create a copy of StoryViewerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryViewerStateCopyWith<_StoryViewerState> get copyWith => __$StoryViewerStateCopyWithImpl<_StoryViewerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryViewerState&&const DeepCollectionEquality().equals(other._reels, _reels)&&(identical(other.reelIndex, reelIndex) || other.reelIndex == reelIndex)&&(identical(other.segmentIndex, segmentIndex) || other.segmentIndex == segmentIndex)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.unavailable, unavailable) || other.unavailable == unavailable));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reels),reelIndex,segmentIndex,paused,closed,unavailable);

@override
String toString() {
  return 'StoryViewerState(reels: $reels, reelIndex: $reelIndex, segmentIndex: $segmentIndex, paused: $paused, closed: $closed, unavailable: $unavailable)';
}


}

/// @nodoc
abstract mixin class _$StoryViewerStateCopyWith<$Res> implements $StoryViewerStateCopyWith<$Res> {
  factory _$StoryViewerStateCopyWith(_StoryViewerState value, $Res Function(_StoryViewerState) _then) = __$StoryViewerStateCopyWithImpl;
@override @useResult
$Res call({
 List<StoryReel> reels, int reelIndex, int segmentIndex, bool paused, bool closed, bool unavailable
});




}
/// @nodoc
class __$StoryViewerStateCopyWithImpl<$Res>
    implements _$StoryViewerStateCopyWith<$Res> {
  __$StoryViewerStateCopyWithImpl(this._self, this._then);

  final _StoryViewerState _self;
  final $Res Function(_StoryViewerState) _then;

/// Create a copy of StoryViewerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reels = null,Object? reelIndex = null,Object? segmentIndex = null,Object? paused = null,Object? closed = null,Object? unavailable = null,}) {
  return _then(_StoryViewerState(
reels: null == reels ? _self._reels : reels // ignore: cast_nullable_to_non_nullable
as List<StoryReel>,reelIndex: null == reelIndex ? _self.reelIndex : reelIndex // ignore: cast_nullable_to_non_nullable
as int,segmentIndex: null == segmentIndex ? _self.segmentIndex : segmentIndex // ignore: cast_nullable_to_non_nullable
as int,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
