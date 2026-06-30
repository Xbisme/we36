import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:we36/features/auth/presentation/oauth/oauth_buttons.dart';
import 'package:we36/features/auth/presentation/oauth/oauth_cubit.dart';

import '../../helpers/pump_app.dart';

class _MockGoogle extends Mock implements SignInWithGoogle {}

class _MockApple extends Mock implements SignInWithApple {}

final _me = MeProfile(
  id: 'me-1',
  email: 'g@we36.app',
  isPrivate: false,
  isVerified: false,
  profileCompleted: false,
  createdAt: DateTime.utc(2026),
);

void main() {
  late _MockGoogle google;
  late _MockApple apple;

  setUp(() {
    google = _MockGoogle();
    apple = _MockApple();
  });

  group('OAuthCubit', () {
    blocTest<OAuthCubit, AppState<MeProfile>>(
      'google success → [loading, loaded]',
      build: () {
        when(
          () => google.call(),
        ).thenAnswer((_) async => Result<MeProfile>.ok(_me));
        return OAuthCubit(google, apple);
      },
      act: (c) => c.google(),
      expect: () => [isA<AppLoading<MeProfile>>(), isA<AppLoaded<MeProfile>>()],
    );

    blocTest<OAuthCubit, AppState<MeProfile>>(
      'google cancel → [loading, error(oauthCancelled)]',
      build: () {
        when(() => google.call()).thenAnswer(
          (_) async => const Result<MeProfile>.err(AppFailure.oauthCancelled()),
        );
        return OAuthCubit(google, apple);
      },
      act: (c) => c.google(),
      expect: () => [
        isA<AppLoading<MeProfile>>(),
        isA<AppError<MeProfile>>().having(
          (s) => s.failure,
          'failure',
          isA<AppFailureOauthCancelled>(),
        ),
      ],
    );

    blocTest<OAuthCubit, AppState<MeProfile>>(
      'apple failure → [loading, error(oauthFailed)]',
      build: () {
        when(() => apple.call()).thenAnswer(
          (_) async => const Result<MeProfile>.err(AppFailure.oauthFailed()),
        );
        return OAuthCubit(google, apple);
      },
      act: (c) => c.apple(),
      expect: () => [
        isA<AppLoading<MeProfile>>(),
        isA<AppError<MeProfile>>().having(
          (s) => s.failure,
          'failure',
          isA<AppFailureOauthFailed>(),
        ),
      ],
    );
  });

  group('OAuthButtons (FR-021/FR-022)', () {
    setUp(() {
      getIt
        ..registerFactory<OAuthCubit>(() => OAuthCubit(google, apple))
        ..registerLazySingleton<ToastService>(ToastService.new);
    });
    tearDown(getIt.reset);

    testWidgets('Apple is hidden on non-Apple platforms; Google shown', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await pumpApp(tester, const OAuthButtons());
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsNothing);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('user cancel is silent — no error toast', (tester) async {
      when(() => google.call()).thenAnswer(
        (_) async => const Result<MeProfile>.err(AppFailure.oauthCancelled()),
      );
      await pumpApp(tester, const OAuthButtons());
      await tester.tap(find.text('Continue with Google'));
      await tester.pump();
      await tester.pump();
      // No toast surfaced for a deliberate cancel.
      expect(find.text('Sign-in was cancelled.'), findsNothing);
    });
  });
}
