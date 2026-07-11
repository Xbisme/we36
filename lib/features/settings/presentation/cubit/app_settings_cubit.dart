import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/services/preferences/app_preferences.dart';

/// App-level appearance + language selection (#014, US5). Holds the current
/// [ThemeMode] and [Locale] (null = system) that `We36App` feeds into
/// `MaterialApp.router`. Not the 4-state async pattern — it's a simple settings
/// holder; setters persist to [AppPreferences] (device-scoped).
class AppSettingsState {
  const AppSettingsState({this.themeMode = ThemeMode.system, this.locale});

  final ThemeMode themeMode;

  /// Null = follow the device language.
  final Locale? locale;
}

@lazySingleton
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(this._prefs) : super(const AppSettingsState());

  final AppPreferences _prefs;

  /// Load persisted values at startup. Defensive: if the prefs backend is
  /// unavailable (e.g. a hermetic test with no platform channel), keep the
  /// defaults rather than failing app boot.
  Future<void> load() async {
    try {
      final mode = await _prefs.getThemeMode();
      final locale = await _prefs.getLocale();
      if (isClosed) return;
      emit(AppSettingsState(themeMode: mode, locale: locale));
    } on Object {
      // Keep defaults (system theme, device locale).
    }
  }

  void setThemeMode(ThemeMode mode) {
    emit(AppSettingsState(themeMode: mode, locale: state.locale));
    unawaited(_prefs.setThemeMode(mode));
  }

  /// [locale] null = follow the system language.
  void setLocale(Locale? locale) {
    emit(AppSettingsState(themeMode: state.themeMode, locale: locale));
    unawaited(_prefs.setLocale(locale));
  }
}
