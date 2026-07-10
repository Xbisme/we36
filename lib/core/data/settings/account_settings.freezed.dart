// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationPrefs {

 bool get likes; bool get comments; bool get mentions; bool get follows; bool get followRequests; bool get directMessages; bool get globalMute;
/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPrefsCopyWith<NotificationPrefs> get copyWith => _$NotificationPrefsCopyWithImpl<NotificationPrefs>(this as NotificationPrefs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPrefs&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.mentions, mentions) || other.mentions == mentions)&&(identical(other.follows, follows) || other.follows == follows)&&(identical(other.followRequests, followRequests) || other.followRequests == followRequests)&&(identical(other.directMessages, directMessages) || other.directMessages == directMessages)&&(identical(other.globalMute, globalMute) || other.globalMute == globalMute));
}


@override
int get hashCode => Object.hash(runtimeType,likes,comments,mentions,follows,followRequests,directMessages,globalMute);

@override
String toString() {
  return 'NotificationPrefs(likes: $likes, comments: $comments, mentions: $mentions, follows: $follows, followRequests: $followRequests, directMessages: $directMessages, globalMute: $globalMute)';
}


}

/// @nodoc
abstract mixin class $NotificationPrefsCopyWith<$Res>  {
  factory $NotificationPrefsCopyWith(NotificationPrefs value, $Res Function(NotificationPrefs) _then) = _$NotificationPrefsCopyWithImpl;
@useResult
$Res call({
 bool likes, bool comments, bool mentions, bool follows, bool followRequests, bool directMessages, bool globalMute
});




}
/// @nodoc
class _$NotificationPrefsCopyWithImpl<$Res>
    implements $NotificationPrefsCopyWith<$Res> {
  _$NotificationPrefsCopyWithImpl(this._self, this._then);

  final NotificationPrefs _self;
  final $Res Function(NotificationPrefs) _then;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likes = null,Object? comments = null,Object? mentions = null,Object? follows = null,Object? followRequests = null,Object? directMessages = null,Object? globalMute = null,}) {
  return _then(_self.copyWith(
likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as bool,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as bool,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as bool,follows: null == follows ? _self.follows : follows // ignore: cast_nullable_to_non_nullable
as bool,followRequests: null == followRequests ? _self.followRequests : followRequests // ignore: cast_nullable_to_non_nullable
as bool,directMessages: null == directMessages ? _self.directMessages : directMessages // ignore: cast_nullable_to_non_nullable
as bool,globalMute: null == globalMute ? _self.globalMute : globalMute // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPrefs].
extension NotificationPrefsPatterns on NotificationPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPrefs value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPrefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool likes,  bool comments,  bool mentions,  bool follows,  bool followRequests,  bool directMessages,  bool globalMute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
return $default(_that.likes,_that.comments,_that.mentions,_that.follows,_that.followRequests,_that.directMessages,_that.globalMute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool likes,  bool comments,  bool mentions,  bool follows,  bool followRequests,  bool directMessages,  bool globalMute)  $default,) {final _that = this;
switch (_that) {
case _NotificationPrefs():
return $default(_that.likes,_that.comments,_that.mentions,_that.follows,_that.followRequests,_that.directMessages,_that.globalMute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool likes,  bool comments,  bool mentions,  bool follows,  bool followRequests,  bool directMessages,  bool globalMute)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
return $default(_that.likes,_that.comments,_that.mentions,_that.follows,_that.followRequests,_that.directMessages,_that.globalMute);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationPrefs implements NotificationPrefs {
  const _NotificationPrefs({required this.likes, required this.comments, required this.mentions, required this.follows, required this.followRequests, required this.directMessages, required this.globalMute});
  

@override final  bool likes;
@override final  bool comments;
@override final  bool mentions;
@override final  bool follows;
@override final  bool followRequests;
@override final  bool directMessages;
@override final  bool globalMute;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPrefsCopyWith<_NotificationPrefs> get copyWith => __$NotificationPrefsCopyWithImpl<_NotificationPrefs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPrefs&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.mentions, mentions) || other.mentions == mentions)&&(identical(other.follows, follows) || other.follows == follows)&&(identical(other.followRequests, followRequests) || other.followRequests == followRequests)&&(identical(other.directMessages, directMessages) || other.directMessages == directMessages)&&(identical(other.globalMute, globalMute) || other.globalMute == globalMute));
}


@override
int get hashCode => Object.hash(runtimeType,likes,comments,mentions,follows,followRequests,directMessages,globalMute);

@override
String toString() {
  return 'NotificationPrefs(likes: $likes, comments: $comments, mentions: $mentions, follows: $follows, followRequests: $followRequests, directMessages: $directMessages, globalMute: $globalMute)';
}


}

/// @nodoc
abstract mixin class _$NotificationPrefsCopyWith<$Res> implements $NotificationPrefsCopyWith<$Res> {
  factory _$NotificationPrefsCopyWith(_NotificationPrefs value, $Res Function(_NotificationPrefs) _then) = __$NotificationPrefsCopyWithImpl;
@override @useResult
$Res call({
 bool likes, bool comments, bool mentions, bool follows, bool followRequests, bool directMessages, bool globalMute
});




}
/// @nodoc
class __$NotificationPrefsCopyWithImpl<$Res>
    implements _$NotificationPrefsCopyWith<$Res> {
  __$NotificationPrefsCopyWithImpl(this._self, this._then);

  final _NotificationPrefs _self;
  final $Res Function(_NotificationPrefs) _then;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likes = null,Object? comments = null,Object? mentions = null,Object? follows = null,Object? followRequests = null,Object? directMessages = null,Object? globalMute = null,}) {
  return _then(_NotificationPrefs(
likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as bool,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as bool,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as bool,follows: null == follows ? _self.follows : follows // ignore: cast_nullable_to_non_nullable
as bool,followRequests: null == followRequests ? _self.followRequests : followRequests // ignore: cast_nullable_to_non_nullable
as bool,directMessages: null == directMessages ? _self.directMessages : directMessages // ignore: cast_nullable_to_non_nullable
as bool,globalMute: null == globalMute ? _self.globalMute : globalMute // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AccountSettings {

 bool get isPrivate; bool get activityStatusVisible; bool get twoFactorEnabled; int get closeFriendsCount; NotificationPrefs get notifications;
/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSettingsCopyWith<AccountSettings> get copyWith => _$AccountSettingsCopyWithImpl<AccountSettings>(this as AccountSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSettings&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.activityStatusVisible, activityStatusVisible) || other.activityStatusVisible == activityStatusVisible)&&(identical(other.twoFactorEnabled, twoFactorEnabled) || other.twoFactorEnabled == twoFactorEnabled)&&(identical(other.closeFriendsCount, closeFriendsCount) || other.closeFriendsCount == closeFriendsCount)&&(identical(other.notifications, notifications) || other.notifications == notifications));
}


@override
int get hashCode => Object.hash(runtimeType,isPrivate,activityStatusVisible,twoFactorEnabled,closeFriendsCount,notifications);

@override
String toString() {
  return 'AccountSettings(isPrivate: $isPrivate, activityStatusVisible: $activityStatusVisible, twoFactorEnabled: $twoFactorEnabled, closeFriendsCount: $closeFriendsCount, notifications: $notifications)';
}


}

/// @nodoc
abstract mixin class $AccountSettingsCopyWith<$Res>  {
  factory $AccountSettingsCopyWith(AccountSettings value, $Res Function(AccountSettings) _then) = _$AccountSettingsCopyWithImpl;
@useResult
$Res call({
 bool isPrivate, bool activityStatusVisible, bool twoFactorEnabled, int closeFriendsCount, NotificationPrefs notifications
});


$NotificationPrefsCopyWith<$Res> get notifications;

}
/// @nodoc
class _$AccountSettingsCopyWithImpl<$Res>
    implements $AccountSettingsCopyWith<$Res> {
  _$AccountSettingsCopyWithImpl(this._self, this._then);

  final AccountSettings _self;
  final $Res Function(AccountSettings) _then;

/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPrivate = null,Object? activityStatusVisible = null,Object? twoFactorEnabled = null,Object? closeFriendsCount = null,Object? notifications = null,}) {
  return _then(_self.copyWith(
isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,activityStatusVisible: null == activityStatusVisible ? _self.activityStatusVisible : activityStatusVisible // ignore: cast_nullable_to_non_nullable
as bool,twoFactorEnabled: null == twoFactorEnabled ? _self.twoFactorEnabled : twoFactorEnabled // ignore: cast_nullable_to_non_nullable
as bool,closeFriendsCount: null == closeFriendsCount ? _self.closeFriendsCount : closeFriendsCount // ignore: cast_nullable_to_non_nullable
as int,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as NotificationPrefs,
  ));
}
/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPrefsCopyWith<$Res> get notifications {
  
  return $NotificationPrefsCopyWith<$Res>(_self.notifications, (value) {
    return _then(_self.copyWith(notifications: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountSettings].
extension AccountSettingsPatterns on AccountSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountSettings value)  $default,){
final _that = this;
switch (_that) {
case _AccountSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPrivate,  bool activityStatusVisible,  bool twoFactorEnabled,  int closeFriendsCount,  NotificationPrefs notifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
return $default(_that.isPrivate,_that.activityStatusVisible,_that.twoFactorEnabled,_that.closeFriendsCount,_that.notifications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPrivate,  bool activityStatusVisible,  bool twoFactorEnabled,  int closeFriendsCount,  NotificationPrefs notifications)  $default,) {final _that = this;
switch (_that) {
case _AccountSettings():
return $default(_that.isPrivate,_that.activityStatusVisible,_that.twoFactorEnabled,_that.closeFriendsCount,_that.notifications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPrivate,  bool activityStatusVisible,  bool twoFactorEnabled,  int closeFriendsCount,  NotificationPrefs notifications)?  $default,) {final _that = this;
switch (_that) {
case _AccountSettings() when $default != null:
return $default(_that.isPrivate,_that.activityStatusVisible,_that.twoFactorEnabled,_that.closeFriendsCount,_that.notifications);case _:
  return null;

}
}

}

/// @nodoc


class _AccountSettings implements AccountSettings {
  const _AccountSettings({required this.isPrivate, required this.activityStatusVisible, required this.twoFactorEnabled, required this.closeFriendsCount, required this.notifications});
  

@override final  bool isPrivate;
@override final  bool activityStatusVisible;
@override final  bool twoFactorEnabled;
@override final  int closeFriendsCount;
@override final  NotificationPrefs notifications;

/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountSettingsCopyWith<_AccountSettings> get copyWith => __$AccountSettingsCopyWithImpl<_AccountSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountSettings&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.activityStatusVisible, activityStatusVisible) || other.activityStatusVisible == activityStatusVisible)&&(identical(other.twoFactorEnabled, twoFactorEnabled) || other.twoFactorEnabled == twoFactorEnabled)&&(identical(other.closeFriendsCount, closeFriendsCount) || other.closeFriendsCount == closeFriendsCount)&&(identical(other.notifications, notifications) || other.notifications == notifications));
}


@override
int get hashCode => Object.hash(runtimeType,isPrivate,activityStatusVisible,twoFactorEnabled,closeFriendsCount,notifications);

@override
String toString() {
  return 'AccountSettings(isPrivate: $isPrivate, activityStatusVisible: $activityStatusVisible, twoFactorEnabled: $twoFactorEnabled, closeFriendsCount: $closeFriendsCount, notifications: $notifications)';
}


}

/// @nodoc
abstract mixin class _$AccountSettingsCopyWith<$Res> implements $AccountSettingsCopyWith<$Res> {
  factory _$AccountSettingsCopyWith(_AccountSettings value, $Res Function(_AccountSettings) _then) = __$AccountSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isPrivate, bool activityStatusVisible, bool twoFactorEnabled, int closeFriendsCount, NotificationPrefs notifications
});


@override $NotificationPrefsCopyWith<$Res> get notifications;

}
/// @nodoc
class __$AccountSettingsCopyWithImpl<$Res>
    implements _$AccountSettingsCopyWith<$Res> {
  __$AccountSettingsCopyWithImpl(this._self, this._then);

  final _AccountSettings _self;
  final $Res Function(_AccountSettings) _then;

/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPrivate = null,Object? activityStatusVisible = null,Object? twoFactorEnabled = null,Object? closeFriendsCount = null,Object? notifications = null,}) {
  return _then(_AccountSettings(
isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,activityStatusVisible: null == activityStatusVisible ? _self.activityStatusVisible : activityStatusVisible // ignore: cast_nullable_to_non_nullable
as bool,twoFactorEnabled: null == twoFactorEnabled ? _self.twoFactorEnabled : twoFactorEnabled // ignore: cast_nullable_to_non_nullable
as bool,closeFriendsCount: null == closeFriendsCount ? _self.closeFriendsCount : closeFriendsCount // ignore: cast_nullable_to_non_nullable
as int,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as NotificationPrefs,
  ));
}

/// Create a copy of AccountSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPrefsCopyWith<$Res> get notifications {
  
  return $NotificationPrefsCopyWith<$Res>(_self.notifications, (value) {
    return _then(_self.copyWith(notifications: value));
  });
}
}

// dart format on
