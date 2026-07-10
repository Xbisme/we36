import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device-scoped app preferences (#014, US5): appearance (light/dark/system) and
/// language (en/vi/system). Non-secret, so they live in `shared_preferences`
/// (like `LocalFlags`) — persisted across launches AND across logout (they are
/// NOT wiped by `SessionController`, FR-027/FR-033).
abstract interface class AppPreferences {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);

  /// Null = follow the system language.
  Future<Locale?> getLocale();
  Future<void> setLocale(Locale? locale);
}

@LazySingleton(as: AppPreferences)
class AppPreferencesImpl implements AppPreferences {
  AppPreferencesImpl() : _override = null;

  @visibleForTesting
  AppPreferencesImpl.withPrefs(SharedPreferencesAsync prefs)
    : _override = prefs;

  static const String _kThemeMode = 'themeMode';
  static const String _kLocale = 'localeCode';

  final SharedPreferencesAsync? _override;
  SharedPreferencesAsync? _cached;

  SharedPreferencesAsync get _prefs =>
      _override ?? (_cached ??= SharedPreferencesAsync());

  @override
  Future<ThemeMode> getThemeMode() async => switch (await _prefs.getString(
    _kThemeMode,
  )) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  @override
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_kThemeMode, mode.name);

  @override
  Future<Locale?> getLocale() async {
    final code = await _prefs.getString(_kLocale);
    return (code == null || code.isEmpty) ? null : Locale(code);
  }

  @override
  Future<void> setLocale(Locale? locale) =>
      _prefs.setString(_kLocale, locale?.languageCode ?? '');
}
