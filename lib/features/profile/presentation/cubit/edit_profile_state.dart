import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'edit_profile_state.freezed.dart';

/// Live username-availability status for the edit form (#010 FR-022).
enum UsernameStatus { idle, checking, available, taken, invalid }

/// The edit-profile form (#010 US5; Constitution III 4-state). `editing` holds the
/// working field values, the username check status, and the in-flight flags.
@freezed
sealed class EditProfileState with _$EditProfileState {
  const EditProfileState._();

  const factory EditProfileState.initial() = EditProfileInitial;

  const factory EditProfileState.loading() = EditProfileLoading;

  const factory EditProfileState.editing({
    required String displayName,
    required String username,
    required String originalUsername,
    String? pronouns,
    String? website,
    String? bio,
    String? avatarMediaId,
    @Default(UsernameStatus.idle) UsernameStatus usernameStatus,
    @Default(false) bool saving,
    @Default(false) bool avatarUploading,
    @Default(false) bool dirty,
  }) = EditProfileEditing;

  const factory EditProfileState.error(AppFailure failure) = EditProfileError;

  /// Save is allowed only with a non-empty name, a settled username, and pending
  /// changes (FR-022/024/025).
  bool get canSave => switch (this) {
    EditProfileEditing(
      :final displayName,
      :final usernameStatus,
      :final saving,
      :final dirty,
    ) =>
      dirty &&
          !saving &&
          displayName.trim().isNotEmpty &&
          (usernameStatus == UsernameStatus.idle ||
              usernameStatus == UsernameStatus.available),
    _ => false,
  };
}
