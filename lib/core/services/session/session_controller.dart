import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/dto/session.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/services/push/push_registration_service.dart';
import 'package:we36/core/services/realtime/realtime_connection_manager.dart';
import 'package:we36/core/services/session/auth_events.dart';
import 'package:we36/core/services/session/local_flags.dart';
import 'package:we36/core/services/session/token_store.dart';

/// Whether the app has resolved the signed-in state yet, and which way.
enum AuthStatus { unknown, authenticated, unauthenticated }

/// The single app-wide session source (#003) and the router's `refreshListenable`
/// (Constitution X). Replaces the #001 `AuthGuardStub`: it restores the session
/// on cold start (offline-capable via the cached [profileCompleted] flag, spec
/// FR-008/FR-009), routes by auth + profile state, refreshes silently through the
/// #002 interceptor, and signs out exactly once on an irrecoverable session —
/// wiping all user-scoped cache (FR-012/FR-013).
@lazySingleton
class SessionController extends ChangeNotifier {
  SessionController(
    this._tokenStore,
    this._me,
    this._flags,
    this._db,
    this._ownStories,
    this._relationships,
    this._realtime,
    this._pushRegistration,
    AuthEventsSink authEvents,
  ) {
    _unauthSub = authEvents.unauthenticated.listen((_) => _forceSignOut());
  }

  final TokenStore _tokenStore;
  final MeRepository _me;
  final LocalFlags _flags;
  final AppDatabase _db;
  final OwnStoryStore _ownStories;
  final RelationshipStore _relationships;
  final RealtimeConnectionManager _realtime;
  final PushRegistrationService _pushRegistration;
  late final StreamSubscription<void> _unauthSub;

  AuthStatus _status = AuthStatus.unknown;
  bool _profileCompleted = false;
  bool _onboardingSeen = false;
  MeProfile? _profile;

  AuthStatus get status => _status;
  bool get isSignedIn => _status == AuthStatus.authenticated;
  bool get profileCompleted => _profileCompleted;
  bool get onboardingSeen => _onboardingSeen;
  MeProfile? get profile => _profile;

  /// Resolve the signed-in state at launch. Routing uses the locally cached
  /// flags first (instant, works offline); `/me` reconciles in the background.
  Future<void> bootstrap() async {
    String? token;
    try {
      await _tokenStore.hydrate();
      _onboardingSeen = await _flags.getOnboardingSeen();
      token = _tokenStore.accessToken;
      if (token != null) {
        // Route immediately from the cached flag (instant, works offline).
        _profileCompleted = await _flags.getProfileCompleted() ?? false;
      }
    } on Object {
      // Storage unavailable / corrupt → degrade to signed-out rather than hang.
      token = null;
    }

    _status = token == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    notifyListeners();
    if (token == null) return;
    // Bring the realtime channel up for the restored session (#012).
    _realtime.connect();
    // Register the push token now that the session token is hydrated (#013) —
    // POST /devices needs a Bearer, so this must not run at cold-start bootstrap.
    unawaited(_pushRegistration.register());

    // Background reconcile (a plain network failure does NOT sign out; only the
    // refresh-failure signal forces sign-out).
    final result = await _me.getMe();
    final me = result.valueOrNull;
    if (me != null) await _applyProfile(me);
  }

  /// Called by sign-in / sign-up / oauth use cases on a successful credential
  /// exchange: persist tokens, load the profile, become authenticated.
  Future<void> onAuthenticated(Session session) async {
    await _tokenStore.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    _status = AuthStatus.authenticated;
    // Bring the realtime channel up for the new session (#012).
    _realtime.connect();
    // Register the device push token for the new session (#013).
    unawaited(_pushRegistration.register());
    final result = await _me.getMe();
    final me = result.valueOrNull;
    if (me != null) {
      await _applyProfile(me);
    } else {
      notifyListeners();
    }
  }

  /// Called after profile setup completes.
  Future<void> applyProfile(MeProfile me) => _applyProfile(me);

  Future<void> _applyProfile(MeProfile me) async {
    _profile = me;
    _profileCompleted = me.profileCompleted;
    await _flags.setProfileCompleted(completed: me.profileCompleted);
    notifyListeners();
  }

  /// Mark first-launch onboarding as seen.
  Future<void> markOnboardingSeen() async {
    if (_onboardingSeen) return;
    _onboardingSeen = true;
    await _flags.setOnboardingSeen(seen: true);
    notifyListeners();
  }

  /// Explicit sign-out: clear credentials + all user-scoped cache, return to the
  /// pre-auth flow. Completes locally even when offline.
  Future<void> signOut() => _clearSession();

  /// Forced sign-out from an irrecoverable session — exactly once (subsequent
  /// signals while already signed out are ignored, so there is no loop).
  void _forceSignOut() {
    if (_status == AuthStatus.unauthenticated) return;
    unawaited(_clearSession());
  }

  Future<void> _clearSession() async {
    _status = AuthStatus.unauthenticated;
    _profile = null;
    _profileCompleted = false;
    notifyListeners();
    // Tear the realtime channel down so no events leak to the next account (#012).
    await _realtime.disconnect();
    // Unregister this device's push token so pushes stop for this account (#013).
    await _pushRegistration.unregister();
    await _tokenStore.clear();
    await _db.clearUserScoped();
    _ownStories.clear();
    _relationships.clear();
    await _flags.clearProfileCompleted();
  }

  @override
  void dispose() {
    unawaited(_unauthSub.cancel());
    super.dispose();
  }
}
