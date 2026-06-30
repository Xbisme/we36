import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/auth/domain/usecases/sign_up.dart';
import 'package:we36/features/auth/presentation/sign_up/sign_up_cubit.dart';

class _MockSignUp extends Mock implements SignUp {}

final _profile = MeProfile(
  id: 'me-1',
  email: 'new@we36.app',
  isPrivate: false,
  isVerified: false,
  profileCompleted: false,
  createdAt: DateTime.utc(2026),
);

void main() {
  late _MockSignUp signUp;
  setUp(() => signUp = _MockSignUp());

  blocTest<SignUpCubit, AppState<MeProfile>>(
    'valid registration → [loading, loaded]',
    build: () {
      when(
        () => signUp.call(any(), any()),
      ).thenAnswer((_) async => Result<MeProfile>.ok(_profile));
      return SignUpCubit(signUp);
    },
    act: (c) => c.submit(email: 'new@we36.app', password: 'password123'),
    expect: () => [isA<AppLoading<MeProfile>>(), isA<AppLoaded<MeProfile>>()],
  );

  blocTest<SignUpCubit, AppState<MeProfile>>(
    'duplicate email → [loading, error(conflict)]',
    build: () {
      when(() => signUp.call(any(), any())).thenAnswer(
        (_) async => const Result<MeProfile>.err(AppFailure.conflict()),
      );
      return SignUpCubit(signUp);
    },
    act: (c) => c.submit(email: 'taken@we36.app', password: 'password123'),
    expect: () => [
      isA<AppLoading<MeProfile>>(),
      isA<AppError<MeProfile>>().having(
        (s) => s.failure,
        'failure',
        isA<AppFailureConflict>(),
      ),
    ],
  );

  blocTest<SignUpCubit, AppState<MeProfile>>(
    'short password rejected client-side (no use-case call)',
    build: () => SignUpCubit(signUp),
    act: (c) => c.submit(email: 'new@we36.app', password: 'short'),
    expect: () => [
      isA<AppError<MeProfile>>().having(
        (s) => (s.failure as AppFailureValidation).fields.keys,
        'fields',
        contains('password'),
      ),
    ],
    verify: (_) => verifyNever(() => signUp.call(any(), any())),
  );
}
