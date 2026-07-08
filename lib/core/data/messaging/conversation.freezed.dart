// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conversation {

 String get id; UserSummary get participant; DateTime get lastActivityAt; int get unreadCount; String? get lastMessagePreview; bool get isTyping; bool get participantOnline;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.participant, participant) || other.participant == participant)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.participantOnline, participantOnline) || other.participantOnline == participantOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participant,lastActivityAt,unreadCount,lastMessagePreview,isTyping,participantOnline);

@override
String toString() {
  return 'Conversation(id: $id, participant: $participant, lastActivityAt: $lastActivityAt, unreadCount: $unreadCount, lastMessagePreview: $lastMessagePreview, isTyping: $isTyping, participantOnline: $participantOnline)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 String id, UserSummary participant, DateTime lastActivityAt, int unreadCount, String? lastMessagePreview, bool isTyping, bool participantOnline
});


$UserSummaryCopyWith<$Res> get participant;

}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participant = null,Object? lastActivityAt = null,Object? unreadCount = null,Object? lastMessagePreview = freezed,Object? isTyping = null,Object? participantOnline = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participant: null == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as UserSummary,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,participantOnline: null == participantOnline ? _self.participantOnline : participantOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get participant {
  
  return $UserSummaryCopyWith<$Res>(_self.participant, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UserSummary participant,  DateTime lastActivityAt,  int unreadCount,  String? lastMessagePreview,  bool isTyping,  bool participantOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.participant,_that.lastActivityAt,_that.unreadCount,_that.lastMessagePreview,_that.isTyping,_that.participantOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UserSummary participant,  DateTime lastActivityAt,  int unreadCount,  String? lastMessagePreview,  bool isTyping,  bool participantOnline)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.participant,_that.lastActivityAt,_that.unreadCount,_that.lastMessagePreview,_that.isTyping,_that.participantOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UserSummary participant,  DateTime lastActivityAt,  int unreadCount,  String? lastMessagePreview,  bool isTyping,  bool participantOnline)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.participant,_that.lastActivityAt,_that.unreadCount,_that.lastMessagePreview,_that.isTyping,_that.participantOnline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conversation extends Conversation {
  const _Conversation({required this.id, required this.participant, required this.lastActivityAt, this.unreadCount = 0, this.lastMessagePreview, this.isTyping = false, this.participantOnline = false}): super._();
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

@override final  String id;
@override final  UserSummary participant;
@override final  DateTime lastActivityAt;
@override@JsonKey() final  int unreadCount;
@override final  String? lastMessagePreview;
@override@JsonKey() final  bool isTyping;
@override@JsonKey() final  bool participantOnline;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.participant, participant) || other.participant == participant)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.participantOnline, participantOnline) || other.participantOnline == participantOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participant,lastActivityAt,unreadCount,lastMessagePreview,isTyping,participantOnline);

@override
String toString() {
  return 'Conversation(id: $id, participant: $participant, lastActivityAt: $lastActivityAt, unreadCount: $unreadCount, lastMessagePreview: $lastMessagePreview, isTyping: $isTyping, participantOnline: $participantOnline)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, UserSummary participant, DateTime lastActivityAt, int unreadCount, String? lastMessagePreview, bool isTyping, bool participantOnline
});


@override $UserSummaryCopyWith<$Res> get participant;

}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participant = null,Object? lastActivityAt = null,Object? unreadCount = null,Object? lastMessagePreview = freezed,Object? isTyping = null,Object? participantOnline = null,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participant: null == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as UserSummary,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,participantOnline: null == participantOnline ? _self.participantOnline : participantOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSummaryCopyWith<$Res> get participant {
  
  return $UserSummaryCopyWith<$Res>(_self.participant, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}

// dart format on
