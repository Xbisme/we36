import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/features/settings/presentation/cubit/app_settings_cubit.dart';

import '../../helpers/app_settings_double.dart';

void main() {
  group('AppSettingsCubit (#014 US5)', () {
    test('load reads persisted theme + locale', () async {
      final prefs = InMemoryAppPreferences();
      await prefs.setThemeMode(ThemeMode.dark);
      await prefs.setLocale(const Locale('vi'));
      final cubit = AppSettingsCubit(prefs);

      await cubit.load();

      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(cubit.state.locale?.languageCode, 'vi');
      await cubit.close();
    });

    test('setThemeMode emits and persists', () async {
      final prefs = InMemoryAppPreferences();
      final cubit = AppSettingsCubit(prefs)..setThemeMode(ThemeMode.light);
      expect(cubit.state.themeMode, ThemeMode.light);
      expect(await prefs.getThemeMode(), ThemeMode.light);
      await cubit.close();
    });

    test('setLocale(null) follows the system and persists', () async {
      final prefs = InMemoryAppPreferences();
      final cubit = AppSettingsCubit(prefs)
        ..setLocale(const Locale('en'))
        ..setLocale(null);
      expect(cubit.state.locale, isNull);
      expect(await prefs.getLocale(), isNull);
      await cubit.close();
    });
  });
}
