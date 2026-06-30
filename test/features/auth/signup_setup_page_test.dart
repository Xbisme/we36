import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/features/auth/domain/usecases/check_username.dart';
import 'package:we36/features/auth/domain/usecases/setup_profile.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:we36/features/auth/domain/usecases/sign_up.dart';
import 'package:we36/features/auth/presentation/oauth/oauth_cubit.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_cubit.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_page.dart';
import 'package:we36/features/auth/presentation/sign_up/sign_up_cubit.dart';
import 'package:we36/features/auth/presentation/sign_up/sign_up_page.dart';

import '../../helpers/pump_app.dart';

class _MockSignUp extends Mock implements SignUp {}

class _MockCheck extends Mock implements CheckUsername {}

class _MockSetup extends Mock implements SetupProfile {}

class _MockGoogle extends Mock implements SignInWithGoogle {}

class _MockApple extends Mock implements SignInWithApple {}

final _me = MeProfile(
  id: 'me-1',
  email: 'new@we36.app',
  isPrivate: false,
  isVerified: false,
  profileCompleted: false,
  createdAt: DateTime.utc(2026),
);

void main() {
  tearDown(getIt.reset);

  group('SignUpPage', () {
    late _MockSignUp signUp;
    setUp(() {
      signUp = _MockSignUp();
      getIt
        ..registerFactory<SignUpCubit>(() => SignUpCubit(signUp))
        ..registerFactory<OAuthCubit>(
          () => OAuthCubit(_MockGoogle(), _MockApple()),
        )
        ..registerLazySingleton<ToastService>(ToastService.new);
    });

    testWidgets('valid registration submits through SignUp', (tester) async {
      when(
        () => signUp.call(any(), any()),
      ).thenAnswer((_) async => Result<MeProfile>.ok(_me));
      await pumpApp(tester, const SignUpPage());
      await tester.enterText(find.byType(TextField).at(0), 'new@we36.app');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pump();
      verify(() => signUp.call('new@we36.app', 'password123')).called(1);
    });
  });

  group('ProfileSetupPage', () {
    late _MockCheck check;
    late _MockSetup setup;
    setUp(() {
      check = _MockCheck();
      setup = _MockSetup();
      getIt
        ..registerFactory<ProfileSetupCubit>(
          () => ProfileSetupCubit(check, setup),
        )
        ..registerLazySingleton<ToastService>(ToastService.new);
    });

    testWidgets('available username unlocks Continue → setup called', (
      tester,
    ) async {
      when(() => check.call(any())).thenAnswer(
        (_) async => const Result.ok(UsernameAvailability(available: true)),
      );
      when(
        () => setup.call(
          username: any(named: 'username'),
          displayName: any(named: 'displayName'),
          bio: any(named: 'bio'),
        ),
      ).thenAnswer((_) async => Result<MeProfile>.ok(_me));

      await pumpApp(tester, const ProfileSetupPage());
      await tester.enterText(find.byType(TextField).at(0), 'alice');
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.text('Available'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(1), 'Alice');
      await tester.pump();
      await tester.ensureVisible(find.text('Continue'));
      await tester.tap(find.text('Continue'));
      await tester.pump();
      verify(
        () => setup.call(
          username: 'alice',
          displayName: 'Alice',
          bio: any(named: 'bio'),
        ),
      ).called(1);
    });

    testWidgets('taken username shows the inline hint', (tester) async {
      when(() => check.call(any())).thenAnswer(
        (_) async => const Result.ok(
          UsernameAvailability(available: false, reason: UsernameReason.taken),
        ),
      );
      await pumpApp(tester, const ProfileSetupPage());
      await tester.enterText(find.byType(TextField).at(0), 'demo');
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.text('That username is taken.'), findsOneWidget);
    });
  });
}
