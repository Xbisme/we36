import 'package:injectable/injectable.dart';
import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/data/settings/settings_repository.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory account settings (#014) — the impl that runs in `environment:
/// 'fake'` and all hermetic tests. Zero-network; mutations mutate a held copy.
@LazySingleton(as: SettingsRepository, env: ['fake'])
class FakeSettingsRepository implements SettingsRepository {
  AccountSettings _settings = const AccountSettings(
    isPrivate: false,
    activityStatusVisible: true,
    twoFactorEnabled: false,
    closeFriendsCount: 3,
    notifications: NotificationPrefs(
      likes: true,
      comments: true,
      mentions: true,
      follows: true,
      followRequests: true,
      directMessages: true,
      globalMute: false,
    ),
  );

  @override
  Future<Result<AccountSettings>> getSettings() async =>
      Result<AccountSettings>.ok(_settings);

  @override
  Future<Result<AccountSettings>> setPrivate({required bool isPrivate}) async {
    _settings = _settings.copyWith(isPrivate: isPrivate);
    return Result<AccountSettings>.ok(_settings);
  }

  @override
  Future<Result<AccountSettings>> setActivityStatus({
    required bool visible,
  }) async {
    _settings = _settings.copyWith(activityStatusVisible: visible);
    return Result<AccountSettings>.ok(_settings);
  }

  @override
  Future<Result<AccountSettings>> setNotifications(
    NotificationPrefs prefs,
  ) async {
    _settings = _settings.copyWith(notifications: prefs);
    return Result<AccountSettings>.ok(_settings);
  }
}
