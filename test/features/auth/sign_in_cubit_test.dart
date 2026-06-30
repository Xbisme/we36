import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/auth/domain/usecases/sign_in.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_cubit.dart';

class _MockSignIn extends Mock implements SignIn {}

final _profile = MeProfile(
  id: 'me-1',
  email: 'a@we36.app',
  isPrivate: false,
  isVerified: false,
  profileCompleted: true,
  createdAt: DateTime.utc(2026),
);

void main() {
  late _MockSignIn signIn;

  setUp(() => signIn = _MockSignIn());

  blocTest<SignInCubit, AppState<MeProfile>>(
    'valid credentials → [loading, loaded]',
    build: () {
      when(() => signIn.call(any(), any())).thenAnswer(
        (_) async => Result<MeProfile>.ok(_profile),
      );
      return SignInCubit(signIn);
    },
    act: (c) => c.submit(email: 'a@we36.app', password: 'password123'),
    expect: () => [isA<AppLoading<MeProfile>>(), isA<AppLoaded<MeProfile>>()],
  );

  blocTest<SignInCubit, AppState<MeProfile>>(
    'wrong password → [loading, error(invalidCredentials)]',
    build: () {
      when(() => signIn.call(any(), any())).thenAnswer(
        (_) async =>
            const Result<MeProfile>.err(AppFailure.invalidCredentials()),
      );
      return SignInCubit(signIn);
    },
    act: (c) => c.submit(email: 'a@we36.app', password: 'password123'),
    expect: () => [
      isA<AppLoading<MeProfile>>(),
      isA<AppError<MeProfile>>().having(
        (s) => s.failure,
        'failure',
        isA<AppFailureInvalidCredentials>(),
      ),
    ],
  );

  blocTest<SignInCubit, AppState<MeProfile>>(
    'invalid email is rejected client-side (no use-case call)',
    build: () => SignInCubit(signIn),
    act: (c) => c.submit(email: 'not-an-email', password: 'password123'),
    expect: () => [
      isA<AppError<MeProfile>>().having(
        (s) => (s.failure as AppFailureValidation).fields.keys,
        'fields',
        contains('email'),
      ),
    ],
    verify: (_) => verifyNever(() => signIn.call(any(), any())),
  );

  blocTest<SignInCubit, AppState<MeProfile>>(
    'short password is rejected client-side',
    build: () => SignInCubit(signIn),
    act: (c) => c.submit(email: 'a@we36.app', password: 'short'),
    expect: () => [
      isA<AppError<MeProfile>>().having(
        (s) => (s.failure as AppFailureValidation).fields.keys,
        'fields',
        contains('password'),
      ),
    ],
  );
}
