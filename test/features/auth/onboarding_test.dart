import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/features/auth/presentation/onboarding/onboarding_cubit.dart';

import '../../support/auth_test_doubles.dart';

void main() {
  blocTest<OnboardingCubit, int>(
    'setPage emits the slide index',
    build: () => OnboardingCubit(SessionHarness().controller),
    act: (c) => c
      ..setPage(1)
      ..setPage(2),
    expect: () => [1, 2],
  );

  test('finish() marks onboarding as seen on the session', () async {
    final h = SessionHarness();
    addTearDown(h.dispose);
    final cubit = OnboardingCubit(h.controller);
    expect(h.controller.onboardingSeen, isFalse);
    await cubit.finish();
    expect(h.controller.onboardingSeen, isTrue);
    await cubit.close();
  });

  group('first-launch routing (FR-028)', () {
    test('fresh install (no flag) bootstraps to onboarding entry', () async {
      final h = SessionHarness(); // onboardingSeen defaults false, no token
      addTearDown(h.dispose);
      await h.controller.bootstrap();
      expect(h.controller.isSignedIn, isFalse);
      expect(h.controller.onboardingSeen, isFalse); // → router shows onboarding
    });

    test('after onboarding seen, relaunch skips it', () async {
      final h = SessionHarness(onboardingSeen: true);
      addTearDown(h.dispose);
      await h.controller.bootstrap();
      expect(h.controller.onboardingSeen, isTrue); // → router shows sign-in
    });
  });
}
