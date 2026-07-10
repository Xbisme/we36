import 'package:flutter/material.dart';
import 'package:we36/core/services/preferences/app_preferences.dart';
import 'package:we36/features/settings/presentation/cubit/app_settings_cubit.dart';

/// In-memory [AppPreferences] for tests (no shared_preferences platform channel).
class InMemoryAppPreferences implements AppPreferences {
  ThemeMode _mode = ThemeMode.system;
  Locale? _locale;

  @override
  Future<ThemeMode> getThemeMode() async => _mode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async => _mode = mode;

  @override
  Future<Locale?> getLocale() async => _locale;

  @override
  Future<void> setLocale(Locale? locale) async => _locale = locale;
}

/// A ready [AppSettingsCubit] for widget tests that build `We36App`.
AppSettingsCubit testAppSettings() =>
    AppSettingsCubit(InMemoryAppPreferences());
