import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/settings/fake_settings_repository.dart';

void main() {
  group('FakeSettingsRepository (#014 US2/US6)', () {
    test('getSettings returns a default settings view', () async {
      final repo = FakeSettingsRepository();
      final result = await repo.getSettings();
      final s = result.valueOrNull!;
      expect(s.isPrivate, isFalse);
      expect(s.activityStatusVisible, isTrue);
      expect(s.notifications.likes, isTrue);
    });

    test('setPrivate persists the new value', () async {
      final repo = FakeSettingsRepository();
      await repo.setPrivate(isPrivate: true);
      final s = (await repo.getSettings()).valueOrNull!;
      expect(s.isPrivate, isTrue);
    });

    test('setActivityStatus persists the new value', () async {
      final repo = FakeSettingsRepository();
      await repo.setActivityStatus(visible: false);
      final s = (await repo.getSettings()).valueOrNull!;
      expect(s.activityStatusVisible, isFalse);
    });
  });
}
