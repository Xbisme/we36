import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-secret local flags (#003). Holds device-level UX state that must survive
/// restarts but is NOT a credential — so it lives in `shared_preferences`, never
/// secure storage (Constitution I): the first-launch `onboardingSeen` gate and a
/// `profileCompleted` mirror used for instant, offline cold-start routing.
abstract interface class LocalFlags {
  Future<bool> getOnboardingSeen();
  Future<void> setOnboardingSeen({required bool seen});

  /// Cached mirror of `MeProfile.profileCompleted`; null when unknown.
  Future<bool?> getProfileCompleted();
  Future<void> setProfileCompleted({required bool completed});

  /// Clear only user-scoped flags on logout (keeps `onboardingSeen`).
  Future<void> clearProfileCompleted();
}

/// `shared_preferences` implementation (uses the modern async API — no cached
/// instance to initialize at bootstrap).
@LazySingleton(as: LocalFlags)
class LocalFlagsImpl implements LocalFlags {
  LocalFlagsImpl() : _override = null;

  /// Testing seam: inject a mock async prefs.
  @visibleForTesting
  LocalFlagsImpl.withPrefs(SharedPreferencesAsync prefs) : _override = prefs;

  static const String _kOnboardingSeen = 'onboardingSeen';
  static const String _kProfileCompleted = 'profileCompleted';

  final SharedPreferencesAsync? _override;
  SharedPreferencesAsync? _cached;

  // Created lazily on first flag access — constructing `SharedPreferencesAsync`
  // touches the platform, which would throw while building the DI graph in a
  // plugin-less test. Real flag reads happen only after the app is running.
  SharedPreferencesAsync get _prefs =>
      _override ?? (_cached ??= SharedPreferencesAsync());

  @override
  Future<bool> getOnboardingSeen() async =>
      await _prefs.getBool(_kOnboardingSeen) ?? false;

  @override
  Future<void> setOnboardingSeen({required bool seen}) =>
      _prefs.setBool(_kOnboardingSeen, seen);

  @override
  Future<bool?> getProfileCompleted() => _prefs.getBool(_kProfileCompleted);

  @override
  Future<void> setProfileCompleted({required bool completed}) =>
      _prefs.setBool(_kProfileCompleted, completed);

  @override
  Future<void> clearProfileCompleted() => _prefs.remove(_kProfileCompleted);
}
