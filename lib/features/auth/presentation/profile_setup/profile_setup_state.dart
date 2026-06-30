import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'profile_setup_state.freezed.dart';

/// Live status of the chosen username (drives the inline availability hint).
enum UsernameStatus { empty, checking, available, taken, invalid }

/// Profile-setup screen state: the username availability status plus the submit
/// lifecycle. A single immutable state (Constitution III spirit) since the live
/// username check and the submit are one screen's concern.
@freezed
abstract class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState({
    @Default(UsernameStatus.empty) UsernameStatus username,
    @Default(false) bool submitting,
    AppFailure? submitError,
  }) = _ProfileSetupState;

  const ProfileSetupState._();

  /// Confirmation is allowed only when the username is known-available.
  bool get usernameAvailable => username == UsernameStatus.available;
}
