// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExploreItem {

 ExploreItemKind get kind; Post? get post; Reel? get reel;
/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreItemCopyWith<ExploreItem> get copyWith => _$ExploreItemCopyWithImpl<ExploreItem>(this as ExploreItem, _$identity);

  /// Serializes this ExploreItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreItem&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.post, post) || other.post == post)&&(identical(other.reel, reel) || other.reel == reel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,post,reel);

@override
String toString() {
  return 'ExploreItem(kind: $kind, post: $post, reel: $reel)';
}


}

/// @nodoc
abstract mixin class $ExploreItemCopyWith<$Res>  {
  factory $ExploreItemCopyWith(ExploreItem value, $Res Function(ExploreItem) _then) = _$ExploreItemCopyWithImpl;
@useResult
$Res call({
 ExploreItemKind kind, Post? post, Reel? reel
});


$PostCopyWith<$Res>? get post;$ReelCopyWith<$Res>? get reel;

}
/// @nodoc
class _$ExploreItemCopyWithImpl<$Res>
    implements $ExploreItemCopyWith<$Res> {
  _$ExploreItemCopyWithImpl(this._self, this._then);

  final ExploreItem _self;
  final $Res Function(ExploreItem) _then;

/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? post = freezed,Object? reel = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ExploreItemKind,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post?,reel: freezed == reel ? _self.reel : reel // ignore: cast_nullable_to_non_nullable
as Reel?,
  ));
}
/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReelCopyWith<$Res>? get reel {
    if (_self.reel == null) {
    return null;
  }

  return $ReelCopyWith<$Res>(_self.reel!, (value) {
    return _then(_self.copyWith(reel: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExploreItem].
extension ExploreItemPatterns on ExploreItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExploreItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExploreItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExploreItem value)  $default,){
final _that = this;
switch (_that) {
case _ExploreItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExploreItem value)?  $default,){
final _that = this;
switch (_that) {
case _ExploreItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExploreItemKind kind,  Post? post,  Reel? reel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExploreItem() when $default != null:
return $default(_that.kind,_that.post,_that.reel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExploreItemKind kind,  Post? post,  Reel? reel)  $default,) {final _that = this;
switch (_that) {
case _ExploreItem():
return $default(_that.kind,_that.post,_that.reel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExploreItemKind kind,  Post? post,  Reel? reel)?  $default,) {final _that = this;
switch (_that) {
case _ExploreItem() when $default != null:
return $default(_that.kind,_that.post,_that.reel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExploreItem extends ExploreItem {
  const _ExploreItem({required this.kind, this.post, this.reel}): super._();
  factory _ExploreItem.fromJson(Map<String, dynamic> json) => _$ExploreItemFromJson(json);

@override final  ExploreItemKind kind;
@override final  Post? post;
@override final  Reel? reel;

/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExploreItemCopyWith<_ExploreItem> get copyWith => __$ExploreItemCopyWithImpl<_ExploreItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExploreItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExploreItem&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.post, post) || other.post == post)&&(identical(other.reel, reel) || other.reel == reel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,post,reel);

@override
String toString() {
  return 'ExploreItem(kind: $kind, post: $post, reel: $reel)';
}


}

/// @nodoc
abstract mixin class _$ExploreItemCopyWith<$Res> implements $ExploreItemCopyWith<$Res> {
  factory _$ExploreItemCopyWith(_ExploreItem value, $Res Function(_ExploreItem) _then) = __$ExploreItemCopyWithImpl;
@override @useResult
$Res call({
 ExploreItemKind kind, Post? post, Reel? reel
});


@override $PostCopyWith<$Res>? get post;@override $ReelCopyWith<$Res>? get reel;

}
/// @nodoc
class __$ExploreItemCopyWithImpl<$Res>
    implements _$ExploreItemCopyWith<$Res> {
  __$ExploreItemCopyWithImpl(this._self, this._then);

  final _ExploreItem _self;
  final $Res Function(_ExploreItem) _then;

/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? post = freezed,Object? reel = freezed,}) {
  return _then(_ExploreItem(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ExploreItemKind,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as Post?,reel: freezed == reel ? _self.reel : reel // ignore: cast_nullable_to_non_nullable
as Reel?,
  ));
}

/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $PostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}/// Create a copy of ExploreItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReelCopyWith<$Res>? get reel {
    if (_self.reel == null) {
    return null;
  }

  return $ReelCopyWith<$Res>(_self.reel!, (value) {
    return _then(_self.copyWith(reel: value));
  });
}
}

// dart format on
