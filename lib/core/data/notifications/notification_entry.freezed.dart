// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActorCard {

 String get id; String? get username; String? get displayName; String? get avatarUrl;
/// Create a copy of ActorCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActorCardCopyWith<ActorCard> get copyWith => _$ActorCardCopyWithImpl<ActorCard>(this as ActorCard, _$identity);

  /// Serializes this ActorCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActorCard&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl);

@override
String toString() {
  return 'ActorCard(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ActorCardCopyWith<$Res>  {
  factory $ActorCardCopyWith(ActorCard value, $Res Function(ActorCard) _then) = _$ActorCardCopyWithImpl;
@useResult
$Res call({
 String id, String? username, String? displayName, String? avatarUrl
});




}
/// @nodoc
class _$ActorCardCopyWithImpl<$Res>
    implements $ActorCardCopyWith<$Res> {
  _$ActorCardCopyWithImpl(this._self, this._then);

  final ActorCard _self;
  final $Res Function(ActorCard) _then;

/// Create a copy of ActorCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActorCard].
extension ActorCardPatterns on ActorCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActorCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActorCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActorCard value)  $default,){
final _that = this;
switch (_that) {
case _ActorCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActorCard value)?  $default,){
final _that = this;
switch (_that) {
case _ActorCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? username,  String? displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActorCard() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? username,  String? displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ActorCard():
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? username,  String? displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ActorCard() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActorCard extends ActorCard {
  const _ActorCard({required this.id, this.username, this.displayName, this.avatarUrl}): super._();
  factory _ActorCard.fromJson(Map<String, dynamic> json) => _$ActorCardFromJson(json);

@override final  String id;
@override final  String? username;
@override final  String? displayName;
@override final  String? avatarUrl;

/// Create a copy of ActorCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActorCardCopyWith<_ActorCard> get copyWith => __$ActorCardCopyWithImpl<_ActorCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActorCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActorCard&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl);

@override
String toString() {
  return 'ActorCard(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ActorCardCopyWith<$Res> implements $ActorCardCopyWith<$Res> {
  factory _$ActorCardCopyWith(_ActorCard value, $Res Function(_ActorCard) _then) = __$ActorCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String? username, String? displayName, String? avatarUrl
});




}
/// @nodoc
class __$ActorCardCopyWithImpl<$Res>
    implements _$ActorCardCopyWith<$Res> {
  __$ActorCardCopyWithImpl(this._self, this._then);

  final _ActorCard _self;
  final $Res Function(_ActorCard) _then;

/// Create a copy of ActorCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_ActorCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NotificationTarget {

@JsonKey(unknownEnumValue: TargetKind.unknown) TargetKind get kind; String get id; String? get postId; String? get thumbnailUrl;
/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTargetCopyWith<NotificationTarget> get copyWith => _$NotificationTargetCopyWithImpl<NotificationTarget>(this as NotificationTarget, _$identity);

  /// Serializes this NotificationTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTarget&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,id,postId,thumbnailUrl);

@override
String toString() {
  return 'NotificationTarget(kind: $kind, id: $id, postId: $postId, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $NotificationTargetCopyWith<$Res>  {
  factory $NotificationTargetCopyWith(NotificationTarget value, $Res Function(NotificationTarget) _then) = _$NotificationTargetCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: TargetKind.unknown) TargetKind kind, String id, String? postId, String? thumbnailUrl
});




}
/// @nodoc
class _$NotificationTargetCopyWithImpl<$Res>
    implements $NotificationTargetCopyWith<$Res> {
  _$NotificationTargetCopyWithImpl(this._self, this._then);

  final NotificationTarget _self;
  final $Res Function(NotificationTarget) _then;

/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? postId = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TargetKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationTarget].
extension NotificationTargetPatterns on NotificationTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationTarget value)  $default,){
final _that = this;
switch (_that) {
case _NotificationTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationTarget value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: TargetKind.unknown)  TargetKind kind,  String id,  String? postId,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationTarget() when $default != null:
return $default(_that.kind,_that.id,_that.postId,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: TargetKind.unknown)  TargetKind kind,  String id,  String? postId,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _NotificationTarget():
return $default(_that.kind,_that.id,_that.postId,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: TargetKind.unknown)  TargetKind kind,  String id,  String? postId,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _NotificationTarget() when $default != null:
return $default(_that.kind,_that.id,_that.postId,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationTarget extends NotificationTarget {
  const _NotificationTarget({@JsonKey(unknownEnumValue: TargetKind.unknown) required this.kind, required this.id, this.postId, this.thumbnailUrl}): super._();
  factory _NotificationTarget.fromJson(Map<String, dynamic> json) => _$NotificationTargetFromJson(json);

@override@JsonKey(unknownEnumValue: TargetKind.unknown) final  TargetKind kind;
@override final  String id;
@override final  String? postId;
@override final  String? thumbnailUrl;

/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationTargetCopyWith<_NotificationTarget> get copyWith => __$NotificationTargetCopyWithImpl<_NotificationTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationTarget&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,id,postId,thumbnailUrl);

@override
String toString() {
  return 'NotificationTarget(kind: $kind, id: $id, postId: $postId, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$NotificationTargetCopyWith<$Res> implements $NotificationTargetCopyWith<$Res> {
  factory _$NotificationTargetCopyWith(_NotificationTarget value, $Res Function(_NotificationTarget) _then) = __$NotificationTargetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: TargetKind.unknown) TargetKind kind, String id, String? postId, String? thumbnailUrl
});




}
/// @nodoc
class __$NotificationTargetCopyWithImpl<$Res>
    implements _$NotificationTargetCopyWith<$Res> {
  __$NotificationTargetCopyWithImpl(this._self, this._then);

  final _NotificationTarget _self;
  final $Res Function(_NotificationTarget) _then;

/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? postId = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_NotificationTarget(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TargetKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NotificationEntry {

 String get id;@JsonKey(unknownEnumValue: NotificationType.unknown) NotificationType get type; DateTime get createdAt; DateTime get updatedAt; List<ActorCard> get actors; int get actorCount; NotificationTarget? get target; bool get isRead;
/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEntryCopyWith<NotificationEntry> get copyWith => _$NotificationEntryCopyWithImpl<NotificationEntry>(this as NotificationEntry, _$identity);

  /// Serializes this NotificationEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.actors, actors)&&(identical(other.actorCount, actorCount) || other.actorCount == actorCount)&&(identical(other.target, target) || other.target == target)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,createdAt,updatedAt,const DeepCollectionEquality().hash(actors),actorCount,target,isRead);

@override
String toString() {
  return 'NotificationEntry(id: $id, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, actors: $actors, actorCount: $actorCount, target: $target, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class $NotificationEntryCopyWith<$Res>  {
  factory $NotificationEntryCopyWith(NotificationEntry value, $Res Function(NotificationEntry) _then) = _$NotificationEntryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: NotificationType.unknown) NotificationType type, DateTime createdAt, DateTime updatedAt, List<ActorCard> actors, int actorCount, NotificationTarget? target, bool isRead
});


$NotificationTargetCopyWith<$Res>? get target;

}
/// @nodoc
class _$NotificationEntryCopyWithImpl<$Res>
    implements $NotificationEntryCopyWith<$Res> {
  _$NotificationEntryCopyWithImpl(this._self, this._then);

  final NotificationEntry _self;
  final $Res Function(NotificationEntry) _then;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? createdAt = null,Object? updatedAt = null,Object? actors = null,Object? actorCount = null,Object? target = freezed,Object? isRead = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,actors: null == actors ? _self.actors : actors // ignore: cast_nullable_to_non_nullable
as List<ActorCard>,actorCount: null == actorCount ? _self.actorCount : actorCount // ignore: cast_nullable_to_non_nullable
as int,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as NotificationTarget?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTargetCopyWith<$Res>? get target {
    if (_self.target == null) {
    return null;
  }

  return $NotificationTargetCopyWith<$Res>(_self.target!, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationEntry].
extension NotificationEntryPatterns on NotificationEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEntry value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEntry value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: NotificationType.unknown)  NotificationType type,  DateTime createdAt,  DateTime updatedAt,  List<ActorCard> actors,  int actorCount,  NotificationTarget? target,  bool isRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
return $default(_that.id,_that.type,_that.createdAt,_that.updatedAt,_that.actors,_that.actorCount,_that.target,_that.isRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: NotificationType.unknown)  NotificationType type,  DateTime createdAt,  DateTime updatedAt,  List<ActorCard> actors,  int actorCount,  NotificationTarget? target,  bool isRead)  $default,) {final _that = this;
switch (_that) {
case _NotificationEntry():
return $default(_that.id,_that.type,_that.createdAt,_that.updatedAt,_that.actors,_that.actorCount,_that.target,_that.isRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: NotificationType.unknown)  NotificationType type,  DateTime createdAt,  DateTime updatedAt,  List<ActorCard> actors,  int actorCount,  NotificationTarget? target,  bool isRead)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
return $default(_that.id,_that.type,_that.createdAt,_that.updatedAt,_that.actors,_that.actorCount,_that.target,_that.isRead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationEntry extends NotificationEntry {
  const _NotificationEntry({required this.id, @JsonKey(unknownEnumValue: NotificationType.unknown) required this.type, required this.createdAt, required this.updatedAt, final  List<ActorCard> actors = const <ActorCard>[], this.actorCount = 1, this.target, this.isRead = false}): _actors = actors,super._();
  factory _NotificationEntry.fromJson(Map<String, dynamic> json) => _$NotificationEntryFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: NotificationType.unknown) final  NotificationType type;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<ActorCard> _actors;
@override@JsonKey() List<ActorCard> get actors {
  if (_actors is EqualUnmodifiableListView) return _actors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actors);
}

@override@JsonKey() final  int actorCount;
@override final  NotificationTarget? target;
@override@JsonKey() final  bool isRead;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEntryCopyWith<_NotificationEntry> get copyWith => __$NotificationEntryCopyWithImpl<_NotificationEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._actors, _actors)&&(identical(other.actorCount, actorCount) || other.actorCount == actorCount)&&(identical(other.target, target) || other.target == target)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,createdAt,updatedAt,const DeepCollectionEquality().hash(_actors),actorCount,target,isRead);

@override
String toString() {
  return 'NotificationEntry(id: $id, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, actors: $actors, actorCount: $actorCount, target: $target, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class _$NotificationEntryCopyWith<$Res> implements $NotificationEntryCopyWith<$Res> {
  factory _$NotificationEntryCopyWith(_NotificationEntry value, $Res Function(_NotificationEntry) _then) = __$NotificationEntryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: NotificationType.unknown) NotificationType type, DateTime createdAt, DateTime updatedAt, List<ActorCard> actors, int actorCount, NotificationTarget? target, bool isRead
});


@override $NotificationTargetCopyWith<$Res>? get target;

}
/// @nodoc
class __$NotificationEntryCopyWithImpl<$Res>
    implements _$NotificationEntryCopyWith<$Res> {
  __$NotificationEntryCopyWithImpl(this._self, this._then);

  final _NotificationEntry _self;
  final $Res Function(_NotificationEntry) _then;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? createdAt = null,Object? updatedAt = null,Object? actors = null,Object? actorCount = null,Object? target = freezed,Object? isRead = null,}) {
  return _then(_NotificationEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,actors: null == actors ? _self._actors : actors // ignore: cast_nullable_to_non_nullable
as List<ActorCard>,actorCount: null == actorCount ? _self.actorCount : actorCount // ignore: cast_nullable_to_non_nullable
as int,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as NotificationTarget?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTargetCopyWith<$Res>? get target {
    if (_self.target == null) {
    return null;
  }

  return $NotificationTargetCopyWith<$Res>(_self.target!, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}

// dart format on
