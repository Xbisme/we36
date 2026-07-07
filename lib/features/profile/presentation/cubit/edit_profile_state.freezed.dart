// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState()';
}


}

/// @nodoc
class $EditProfileStateCopyWith<$Res>  {
$EditProfileStateCopyWith(EditProfileState _, $Res Function(EditProfileState) __);
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditProfileInitial value)?  initial,TResult Function( EditProfileLoading value)?  loading,TResult Function( EditProfileEditing value)?  editing,TResult Function( EditProfileError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial(_that);case EditProfileLoading() when loading != null:
return loading(_that);case EditProfileEditing() when editing != null:
return editing(_that);case EditProfileError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditProfileInitial value)  initial,required TResult Function( EditProfileLoading value)  loading,required TResult Function( EditProfileEditing value)  editing,required TResult Function( EditProfileError value)  error,}){
final _that = this;
switch (_that) {
case EditProfileInitial():
return initial(_that);case EditProfileLoading():
return loading(_that);case EditProfileEditing():
return editing(_that);case EditProfileError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditProfileInitial value)?  initial,TResult? Function( EditProfileLoading value)?  loading,TResult? Function( EditProfileEditing value)?  editing,TResult? Function( EditProfileError value)?  error,}){
final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial(_that);case EditProfileLoading() when loading != null:
return loading(_that);case EditProfileEditing() when editing != null:
return editing(_that);case EditProfileError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String displayName,  String username,  String originalUsername,  String? pronouns,  String? website,  String? bio,  String? avatarMediaId,  UsernameStatus usernameStatus,  bool saving,  bool avatarUploading,  bool dirty)?  editing,TResult Function( AppFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial();case EditProfileLoading() when loading != null:
return loading();case EditProfileEditing() when editing != null:
return editing(_that.displayName,_that.username,_that.originalUsername,_that.pronouns,_that.website,_that.bio,_that.avatarMediaId,_that.usernameStatus,_that.saving,_that.avatarUploading,_that.dirty);case EditProfileError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String displayName,  String username,  String originalUsername,  String? pronouns,  String? website,  String? bio,  String? avatarMediaId,  UsernameStatus usernameStatus,  bool saving,  bool avatarUploading,  bool dirty)  editing,required TResult Function( AppFailure failure)  error,}) {final _that = this;
switch (_that) {
case EditProfileInitial():
return initial();case EditProfileLoading():
return loading();case EditProfileEditing():
return editing(_that.displayName,_that.username,_that.originalUsername,_that.pronouns,_that.website,_that.bio,_that.avatarMediaId,_that.usernameStatus,_that.saving,_that.avatarUploading,_that.dirty);case EditProfileError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String displayName,  String username,  String originalUsername,  String? pronouns,  String? website,  String? bio,  String? avatarMediaId,  UsernameStatus usernameStatus,  bool saving,  bool avatarUploading,  bool dirty)?  editing,TResult? Function( AppFailure failure)?  error,}) {final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial();case EditProfileLoading() when loading != null:
return loading();case EditProfileEditing() when editing != null:
return editing(_that.displayName,_that.username,_that.originalUsername,_that.pronouns,_that.website,_that.bio,_that.avatarMediaId,_that.usernameStatus,_that.saving,_that.avatarUploading,_that.dirty);case EditProfileError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class EditProfileInitial extends EditProfileState {
  const EditProfileInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState.initial()';
}


}




/// @nodoc


class EditProfileLoading extends EditProfileState {
  const EditProfileLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState.loading()';
}


}




/// @nodoc


class EditProfileEditing extends EditProfileState {
  const EditProfileEditing({required this.displayName, required this.username, required this.originalUsername, this.pronouns, this.website, this.bio, this.avatarMediaId, this.usernameStatus = UsernameStatus.idle, this.saving = false, this.avatarUploading = false, this.dirty = false}): super._();
  

 final  String displayName;
 final  String username;
 final  String originalUsername;
 final  String? pronouns;
 final  String? website;
 final  String? bio;
 final  String? avatarMediaId;
@JsonKey() final  UsernameStatus usernameStatus;
@JsonKey() final  bool saving;
@JsonKey() final  bool avatarUploading;
@JsonKey() final  bool dirty;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileEditingCopyWith<EditProfileEditing> get copyWith => _$EditProfileEditingCopyWithImpl<EditProfileEditing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileEditing&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.username, username) || other.username == username)&&(identical(other.originalUsername, originalUsername) || other.originalUsername == originalUsername)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns)&&(identical(other.website, website) || other.website == website)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatarMediaId, avatarMediaId) || other.avatarMediaId == avatarMediaId)&&(identical(other.usernameStatus, usernameStatus) || other.usernameStatus == usernameStatus)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.avatarUploading, avatarUploading) || other.avatarUploading == avatarUploading)&&(identical(other.dirty, dirty) || other.dirty == dirty));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,username,originalUsername,pronouns,website,bio,avatarMediaId,usernameStatus,saving,avatarUploading,dirty);

@override
String toString() {
  return 'EditProfileState.editing(displayName: $displayName, username: $username, originalUsername: $originalUsername, pronouns: $pronouns, website: $website, bio: $bio, avatarMediaId: $avatarMediaId, usernameStatus: $usernameStatus, saving: $saving, avatarUploading: $avatarUploading, dirty: $dirty)';
}


}

/// @nodoc
abstract mixin class $EditProfileEditingCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileEditingCopyWith(EditProfileEditing value, $Res Function(EditProfileEditing) _then) = _$EditProfileEditingCopyWithImpl;
@useResult
$Res call({
 String displayName, String username, String originalUsername, String? pronouns, String? website, String? bio, String? avatarMediaId, UsernameStatus usernameStatus, bool saving, bool avatarUploading, bool dirty
});




}
/// @nodoc
class _$EditProfileEditingCopyWithImpl<$Res>
    implements $EditProfileEditingCopyWith<$Res> {
  _$EditProfileEditingCopyWithImpl(this._self, this._then);

  final EditProfileEditing _self;
  final $Res Function(EditProfileEditing) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? username = null,Object? originalUsername = null,Object? pronouns = freezed,Object? website = freezed,Object? bio = freezed,Object? avatarMediaId = freezed,Object? usernameStatus = null,Object? saving = null,Object? avatarUploading = null,Object? dirty = null,}) {
  return _then(EditProfileEditing(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,originalUsername: null == originalUsername ? _self.originalUsername : originalUsername // ignore: cast_nullable_to_non_nullable
as String,pronouns: freezed == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,avatarMediaId: freezed == avatarMediaId ? _self.avatarMediaId : avatarMediaId // ignore: cast_nullable_to_non_nullable
as String?,usernameStatus: null == usernameStatus ? _self.usernameStatus : usernameStatus // ignore: cast_nullable_to_non_nullable
as UsernameStatus,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,avatarUploading: null == avatarUploading ? _self.avatarUploading : avatarUploading // ignore: cast_nullable_to_non_nullable
as bool,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class EditProfileError extends EditProfileState {
  const EditProfileError(this.failure): super._();
  

 final  AppFailure failure;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileErrorCopyWith<EditProfileError> get copyWith => _$EditProfileErrorCopyWithImpl<EditProfileError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'EditProfileState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EditProfileErrorCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileErrorCopyWith(EditProfileError value, $Res Function(EditProfileError) _then) = _$EditProfileErrorCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$EditProfileErrorCopyWithImpl<$Res>
    implements $EditProfileErrorCopyWith<$Res> {
  _$EditProfileErrorCopyWithImpl(this._self, this._then);

  final EditProfileError _self;
  final $Res Function(EditProfileError) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(EditProfileError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of EditProfileState
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
