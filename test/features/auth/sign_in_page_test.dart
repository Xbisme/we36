import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/features/auth/domain/usecases/sign_in.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:we36/features/auth/presentation/oauth/oauth_cubit.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_cubit.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_page.dart';

import '../../helpers/pump_app.dart';

class _MockSignIn extends Mock implements SignIn {}

class _MockGoogle extends Mock implements SignInWithGoogle {}

class _MockApple extends Mock implements SignInWithApple {}

final _profile = MeProfile(
  id: 'me-1',
  email: 'a@we36.app',
  isPrivate: false,
  isVerified: false,
  profileCompleted: true,
  createdAt: DateTime.utc(2026),
);

/// Applies a text-scale factor to its subtree, reading the ambient MediaQuery.
class _TextScale extends StatelessWidget {
  const _TextScale({required this.scale, required this.child});
  final double scale;
  final Widget child;
  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child,
  );
}

Future<void> _enterCredentials(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.enterText(find.byType(TextField).at(1), password);
}

Future<void> _tapLogin(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Log in'));
  await tester.pump();
  await tester.tap(find.text('Log in'));
}

void main() {
  late _MockSignIn signIn;

  setUp(() {
    signIn = _MockSignIn();
    getIt
      ..registerFactory<SignInCubit>(() => SignInCubit(signIn))
      ..registerFactory<OAuthCubit>(
        () => OAuthCubit(_MockGoogle(), _MockApple()),
      )
      ..registerLazySingleton<ToastService>(ToastService.new);
  });

  tearDown(getIt.reset);

  testWidgets('valid credentials submit through the SignIn use case', (
    tester,
  ) async {
    when(
      () => signIn.call(any(), any()),
    ).thenAnswer((_) async => Result<MeProfile>.ok(_profile));
    await pumpApp(tester, const SignInPage());
    await _enterCredentials(
      tester,
      email: 'a@we36.app',
      password: 'password123',
    );
    await _tapLogin(tester);
    await tester.pump();
    verify(() => signIn.call('a@we36.app', 'password123')).called(1);
  });

  testWidgets('wrong password shows a neutral error toast', (tester) async {
    when(() => signIn.call(any(), any())).thenAnswer(
      (_) async => const Result<MeProfile>.err(AppFailure.invalidCredentials()),
    );
    await pumpApp(tester, const SignInPage());
    await _enterCredentials(
      tester,
      email: 'a@we36.app',
      password: 'password123',
    );
    await _tapLogin(tester);
    await tester.pump();
    await tester.pump();
    expect(find.text('Incorrect email or password.'), findsOneWidget);
    // Flush the toast auto-dismiss timer so no timers are left pending.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('invalid email is flagged inline, no use-case call', (
    tester,
  ) async {
    await pumpApp(tester, const SignInPage());
    await _enterCredentials(
      tester,
      email: 'nope',
      password: 'password123',
    );
    await _tapLogin(tester);
    await tester.pump();
    expect(find.text('Enter a valid email.'), findsOneWidget);
    verifyNever(() => signIn.call(any(), any()));
  });

  testWidgets('adaptive + a11y: tablet width, dark, 2x text scale, semantics', (
    tester,
  ) async {
    // Tablet width + dark theme.
    await pumpApp(
      tester,
      const _TextScale(scale: 2, child: SignInPage()),
      surfaceSize: const Size(1000, 1400),
      themeMode: ThemeMode.dark,
    );
    expect(find.byType(SignInPage), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    // No layout overflow under 2x text scaling.
    expect(tester.takeException(), isNull);
  });
}
