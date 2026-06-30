import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/di/injection.dart';
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

void main() {
  setUp(() {
    getIt
      ..registerFactory<SignInCubit>(() => SignInCubit(_MockSignIn()))
      ..registerFactory<OAuthCubit>(
        () => OAuthCubit(_MockGoogle(), _MockApple()),
      )
      ..registerLazySingleton<ToastService>(ToastService.new);
  });
  tearDown(getIt.reset);

  testWidgets('SignInPage golden — light', (tester) async {
    await pumpApp(
      tester,
      const SignInPage(),
      surfaceSize: const Size(390, 844),
    );
    await expectLater(
      find.byType(SignInPage),
      matchesGoldenFile('goldens/sign_in_light.png'),
    );
  });

  testWidgets('SignInPage golden — dark', (tester) async {
    await pumpApp(
      tester,
      const SignInPage(),
      surfaceSize: const Size(390, 844),
      themeMode: ThemeMode.dark,
    );
    await expectLater(
      find.byType(SignInPage),
      matchesGoldenFile('goldens/sign_in_dark.png'),
    );
  });
}
