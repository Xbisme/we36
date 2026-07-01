import 'dart:async';

import 'package:drift/native.dart';
import 'package:we36/core/data/auth/fake_auth_backend.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/me/fake_me_repository.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/services/session/auth_events.dart';
import 'package:we36/core/services/session/local_flags.dart';
import 'package:we36/core/services/session/session_controller.dart';
import 'package:we36/core/services/session/token_store.dart';

/// In-memory [LocalFlags] for tests (no `shared_preferences` platform channel).
class FakeLocalFlags implements LocalFlags {
  FakeLocalFlags({bool onboardingSeen = false, bool? profileCompleted})
    : _onboardingSeen = onboardingSeen,
      _profileCompleted = profileCompleted;

  bool _onboardingSeen;
  bool? _profileCompleted;

  @override
  Future<bool> getOnboardingSeen() async => _onboardingSeen;

  @override
  Future<void> setOnboardingSeen({required bool seen}) async =>
      _onboardingSeen = seen;

  @override
  Future<bool?> getProfileCompleted() async => _profileCompleted;

  @override
  Future<void> setProfileCompleted({required bool completed}) async =>
      _profileCompleted = completed;

  @override
  Future<void> clearProfileCompleted() async => _profileCompleted = null;
}

/// Bundles the in-memory collaborators of a [SessionController] for tests, all
/// backed by the production `fake` repositories (zero network).
class SessionHarness {
  SessionHarness({
    String? seededEmail,
    bool onboardingSeen = false,
    bool? cachedProfileCompleted,
  }) : tokenStore = FakeTokenStore(),
       backend = FakeAuthBackend(),
       db = AppDatabase.forTesting(NativeDatabase.memory()),
       authEvents = AuthEvents(),
       flags = FakeLocalFlags(
         onboardingSeen: onboardingSeen,
         profileCompleted: cachedProfileCompleted,
       ) {
    if (seededEmail != null) {
      unawaited(
        tokenStore.save(
          accessToken: 'fake-access.$seededEmail',
          refreshToken: 'fake-refresh.$seededEmail',
        ),
      );
    }
    me = FakeMeRepository(backend, tokenStore);
    controller = SessionController(
      tokenStore,
      me,
      flags,
      db,
      OwnStoryStore(),
      authEvents,
    );
  }

  final FakeTokenStore tokenStore;
  final FakeAuthBackend backend;
  final AppDatabase db;
  final AuthEvents authEvents;
  final FakeLocalFlags flags;
  late final FakeMeRepository me;
  late final SessionController controller;

  Future<void> dispose() async {
    controller.dispose();
    await db.close();
  }
}
