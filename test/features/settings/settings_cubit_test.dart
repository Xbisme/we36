import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/data/settings/settings_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/preferences/presence_visibility.dart';
import 'package:we36/features/settings/presentation/cubit/settings_cubit.dart';

const _seed = AccountSettings(
  isPrivate: false,
  activityStatusVisible: true,
  twoFactorEnabled: false,
  closeFriendsCount: 2,
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

class _StubSettingsRepo implements SettingsRepository {
  AccountSettings _s = _seed;
  bool fail = false;

  @override
  Future<Result<AccountSettings>> getSettings() async =>
      Result<AccountSettings>.ok(_s);

  @override
  Future<Result<AccountSettings>> setPrivate({required bool isPrivate}) async {
    if (fail) {
      return const Result<AccountSettings>.err(AppFailure.networkError());
    }
    _s = _s.copyWith(isPrivate: isPrivate);
    return Result<AccountSettings>.ok(_s);
  }

  @override
  Future<Result<AccountSettings>> setActivityStatus({
    required bool visible,
  }) async {
    if (fail) {
      return const Result<AccountSettings>.err(AppFailure.networkError());
    }
    _s = _s.copyWith(activityStatusVisible: visible);
    return Result<AccountSettings>.ok(_s);
  }

  @override
  Future<Result<AccountSettings>> setNotifications(
    NotificationPrefs prefs,
  ) async {
    if (fail) {
      return const Result<AccountSettings>.err(AppFailure.networkError());
    }
    _s = _s.copyWith(notifications: prefs);
    return Result<AccountSettings>.ok(_s);
  }
}

void main() {
  group('SettingsCubit (#014 US2/US6)', () {
    test('load emits loaded settings', () async {
      final cubit = SettingsCubit(_StubSettingsRepo(), PresenceVisibility());
      await cubit.load();
      expect(cubit.state.dataOrNull?.isPrivate, isFalse);
      await cubit.close();
    });

    test('setPrivate updates state on success', () async {
      final cubit = SettingsCubit(_StubSettingsRepo(), PresenceVisibility());
      await cubit.load();
      await cubit.setPrivate(value: true);
      expect(cubit.state.dataOrNull?.isPrivate, isTrue);
      await cubit.close();
    });

    test('setPrivate rolls back and reports the failure', () async {
      final repo = _StubSettingsRepo()..fail = true;
      final cubit = SettingsCubit(repo, PresenceVisibility());
      await cubit.load();

      final errors = <AppFailure>[];
      final sub = cubit.errors.listen(errors.add);

      await cubit.setPrivate(value: true);
      await Future<void>.delayed(Duration.zero); // flush broadcast delivery

      expect(cubit.state.dataOrNull?.isPrivate, isFalse); // rolled back
      expect(errors, hasLength(1));
      await sub.cancel();
      await cubit.close();
    });

    test('setActivityStatus updates state on success', () async {
      final cubit = SettingsCubit(_StubSettingsRepo(), PresenceVisibility());
      await cubit.load();
      await cubit.setActivityStatus(value: false);
      expect(cubit.state.dataOrNull?.activityStatusVisible, isFalse);
      await cubit.close();
    });

    test('setNotifications updates the prefs optimistically', () async {
      final cubit = SettingsCubit(_StubSettingsRepo(), PresenceVisibility());
      await cubit.load();
      await cubit.setNotifications(
        _seed.notifications.copyWith(likes: false, globalMute: true),
      );
      expect(cubit.state.dataOrNull?.notifications.likes, isFalse);
      expect(cubit.state.dataOrNull?.notifications.globalMute, isTrue);
      await cubit.close();
    });
  });
}
