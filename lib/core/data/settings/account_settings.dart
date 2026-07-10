import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_settings.freezed.dart';

/// On/off notification preferences (#014, mirrors the backend `notifications`
/// block of `SettingsView`). Per-type granularity beyond these toggles is
/// deferred; `quietHours` is round-tripped opaquely and not surfaced here.
@freezed
abstract class NotificationPrefs with _$NotificationPrefs {
  const factory NotificationPrefs({
    required bool likes,
    required bool comments,
    required bool mentions,
    required bool follows,
    required bool followRequests,
    required bool directMessages,
    required bool globalMute,
  }) = _NotificationPrefs;
}

/// The one-stop account settings read model (#014, mirrors the backend
/// `SettingsView`). `twoFactorEnabled` + `closeFriendsCount` are read-only here
/// (toggled via their own endpoints). Decoded in `SettingsRemoteDataSource`.
@freezed
abstract class AccountSettings with _$AccountSettings {
  const factory AccountSettings({
    required bool isPrivate,
    required bool activityStatusVisible,
    required bool twoFactorEnabled,
    required int closeFriendsCount,
    required NotificationPrefs notifications,
  }) = _AccountSettings;
}
