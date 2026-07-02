// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_engagement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentEngagement {

 int get likeCount; bool get viewerHasLiked;
/// Create a copy of CommentEngagement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentEngagementCopyWith<CommentEngagement> get copyWith => _$CommentEngagementCopyWithImpl<CommentEngagement>(this as CommentEngagement, _$identity);

  /// Serializes this CommentEngagement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentEngagement&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeCount,viewerHasLiked);

@override
String toString() {
  return 'CommentEngagement(likeCount: $likeCount, viewerHasLiked: $viewerHasLiked)';
}


}

/// @nodoc
abstract mixin class $CommentEngagementCopyWith<$Res>  {
  factory $CommentEngagementCopyWith(CommentEngagement value, $Res Function(CommentEngagement) _then) = _$CommentEngagementCopyWithImpl;
@useResult
$Res call({
 int likeCount, bool viewerHasLiked
});




}
/// @nodoc
class _$CommentEngagementCopyWithImpl<$Res>
    implements $CommentEngagementCopyWith<$Res> {
  _$CommentEngagementCopyWithImpl(this._self, this._then);

  final CommentEngagement _self;
  final $Res Function(CommentEngagement) _then;

/// Create a copy of CommentEngagement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likeCount = null,Object? viewerHasLiked = null,}) {
  return _then(_self.copyWith(
likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentEngagement].
extension CommentEngagementPatterns on CommentEngagement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentEngagement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentEngagement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentEngagement value)  $default,){
final _that = this;
switch (_that) {
case _CommentEngagement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentEngagement value)?  $default,){
final _that = this;
switch (_that) {
case _CommentEngagement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int likeCount,  bool viewerHasLiked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentEngagement() when $default != null:
return $default(_that.likeCount,_that.viewerHasLiked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int likeCount,  bool viewerHasLiked)  $default,) {final _that = this;
switch (_that) {
case _CommentEngagement():
return $default(_that.likeCount,_that.viewerHasLiked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int likeCount,  bool viewerHasLiked)?  $default,) {final _that = this;
switch (_that) {
case _CommentEngagement() when $default != null:
return $default(_that.likeCount,_that.viewerHasLiked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentEngagement implements CommentEngagement {
  const _CommentEngagement({required this.likeCount, required this.viewerHasLiked});
  factory _CommentEngagement.fromJson(Map<String, dynamic> json) => _$CommentEngagementFromJson(json);

@override final  int likeCount;
@override final  bool viewerHasLiked;

/// Create a copy of CommentEngagement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentEngagementCopyWith<_CommentEngagement> get copyWith => __$CommentEngagementCopyWithImpl<_CommentEngagement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentEngagementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentEngagement&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.viewerHasLiked, viewerHasLiked) || other.viewerHasLiked == viewerHasLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeCount,viewerHasLiked);

@override
String toString() {
  return 'CommentEngagement(likeCount: $likeCount, viewerHasLiked: $viewerHasLiked)';
}


}

/// @nodoc
abstract mixin class _$CommentEngagementCopyWith<$Res> implements $CommentEngagementCopyWith<$Res> {
  factory _$CommentEngagementCopyWith(_CommentEngagement value, $Res Function(_CommentEngagement) _then) = __$CommentEngagementCopyWithImpl;
@override @useResult
$Res call({
 int likeCount, bool viewerHasLiked
});




}
/// @nodoc
class __$CommentEngagementCopyWithImpl<$Res>
    implements _$CommentEngagementCopyWith<$Res> {
  __$CommentEngagementCopyWithImpl(this._self, this._then);

  final _CommentEngagement _self;
  final $Res Function(_CommentEngagement) _then;

/// Create a copy of CommentEngagement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likeCount = null,Object? viewerHasLiked = null,}) {
  return _then(_CommentEngagement(
likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,viewerHasLiked: null == viewerHasLiked ? _self.viewerHasLiked : viewerHasLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
