import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/auth/fake_auth_backend.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/services/session/session_controller.dart';

import '../../support/auth_test_doubles.dart';

MeProfile _profile({required bool completed}) => MeProfile(
  id: 'me-1',
  email: 'a@we36.app',
  isPrivate: false,
  isVerified: false,
  profileCompleted: completed,
  createdAt: DateTime.utc(2026),
);

void main() {
  group('SessionController.bootstrap routing (US1, FR-008/FR-009)', () {
    test('no stored token → unauthenticated', () async {
      final h = SessionHarness();
      addTearDown(h.dispose);
      await h.controller.bootstrap();
      expect(h.controller.status, AuthStatus.unauthenticated);
      expect(h.controller.isSignedIn, isFalse);
    });

    test(
      'stored token + cached completed → authenticated, completed',
      () async {
        final h = SessionHarness(
          seededEmail: FakeAuthBackend.demoEmail,
          cachedProfileCompleted: true,
        );
        addTearDown(h.dispose);
        await h.controller.bootstrap();
        expect(h.controller.status, AuthStatus.authenticated);
        expect(h.controller.profileCompleted, isTrue);
      },
    );

    test(
      'stored token + cached incomplete → authenticated, not completed',
      () async {
        // A registered-but-not-set-up account (profileCompleted=false).
        final h = SessionHarness(cachedProfileCompleted: false);
        addTearDown(h.dispose);
        h.backend.register('new@we36.app', 'password123');
        h.tokenStore.current = 'fake-access.new@we36.app';
        await h.controller.bootstrap();
        expect(h.controller.status, AuthStatus.authenticated);
        expect(h.controller.profileCompleted, isFalse);
      },
    );
  });

  group('SessionController sign-out + wipe (US1, FR-012/FR-013, SC-010)', () {
    test('signOut clears tokens + wipes user-scoped cache', () async {
      final h = SessionHarness(
        seededEmail: FakeAuthBackend.demoEmail,
        cachedProfileCompleted: true,
      );
      addTearDown(h.dispose);
      await h.controller.bootstrap();
      // Seed cached user data, then sign out.
      await h.db.meProfileDao.upsert(_profile(completed: true));
      expect(await h.db.meProfileDao.get(), isNotNull);

      await h.controller.signOut();

      expect(h.controller.status, AuthStatus.unauthenticated);
      expect(h.tokenStore.accessToken, isNull);
      expect(await h.db.meProfileDao.get(), isNull);
    });

    test('forced unauthenticated signal signs out exactly once', () async {
      final h = SessionHarness(
        seededEmail: FakeAuthBackend.demoEmail,
        cachedProfileCompleted: true,
      );
      addTearDown(h.dispose);
      await h.controller.bootstrap();
      var notifications = 0;
      h.controller.addListener(() => notifications++);

      h.authEvents.onUnauthenticated();
      await Future<void>.delayed(Duration.zero);
      h.authEvents.onUnauthenticated(); // second signal — already signed out
      await Future<void>.delayed(Duration.zero);

      expect(h.controller.status, AuthStatus.unauthenticated);
      // Only the first signal flips state (and notifies); the second is ignored.
      expect(notifications, 1);
    });
  });
}
