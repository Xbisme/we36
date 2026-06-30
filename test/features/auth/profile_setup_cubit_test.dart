import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/auth/domain/usecases/check_username.dart';
import 'package:we36/features/auth/domain/usecases/setup_profile.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_cubit.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_state.dart';

class _MockCheck extends Mock implements CheckUsername {}

class _MockSetup extends Mock implements SetupProfile {}

final _me = MeProfile(
  id: 'me-1',
  email: 'a@we36.app',
  username: 'alice',
  displayName: 'Alice',
  isPrivate: false,
  isVerified: false,
  profileCompleted: true,
  createdAt: DateTime.utc(2026),
);

void main() {
  late _MockCheck check;
  late _MockSetup setup;

  setUp(() {
    check = _MockCheck();
    setup = _MockSetup();
  });

  blocTest<ProfileSetupCubit, ProfileSetupState>(
    'available username → checking then available (debounced)',
    build: () {
      when(() => check.call(any())).thenAnswer(
        (_) async => const Result.ok(UsernameAvailability(available: true)),
      );
      return ProfileSetupCubit(check, setup);
    },
    act: (c) => c.onUsernameChanged('alice'),
    wait: const Duration(milliseconds: 450),
    expect: () => [
      isA<ProfileSetupState>().having(
        (s) => s.username,
        'username',
        UsernameStatus.checking,
      ),
      isA<ProfileSetupState>().having(
        (s) => s.username,
        'username',
        UsernameStatus.available,
      ),
    ],
  );

  blocTest<ProfileSetupCubit, ProfileSetupState>(
    'taken username → checking then taken',
    build: () {
      when(() => check.call(any())).thenAnswer(
        (_) async => const Result.ok(
          UsernameAvailability(available: false, reason: UsernameReason.taken),
        ),
      );
      return ProfileSetupCubit(check, setup);
    },
    act: (c) => c.onUsernameChanged('demo'),
    wait: const Duration(milliseconds: 450),
    expect: () => [
      isA<ProfileSetupState>().having(
        (s) => s.username,
        'username',
        UsernameStatus.checking,
      ),
      isA<ProfileSetupState>().having(
        (s) => s.username,
        'username',
        UsernameStatus.taken,
      ),
    ],
  );

  blocTest<ProfileSetupCubit, ProfileSetupState>(
    'invalid format rejected client-side (no network call)',
    build: () => ProfileSetupCubit(check, setup),
    act: (c) => c.onUsernameChanged('ab'), // too short
    expect: () => [
      isA<ProfileSetupState>().having(
        (s) => s.username,
        'username',
        UsernameStatus.invalid,
      ),
    ],
    verify: (_) => verifyNever(() => check.call(any())),
  );

  blocTest<ProfileSetupCubit, ProfileSetupState>(
    'submit success → submitting (SessionController routes away)',
    build: () {
      when(
        () => setup.call(
          username: any(named: 'username'),
          displayName: any(named: 'displayName'),
          bio: any(named: 'bio'),
        ),
      ).thenAnswer((_) async => Result<MeProfile>.ok(_me));
      return ProfileSetupCubit(check, setup);
    },
    act: (c) => c.submit(username: 'alice', displayName: 'Alice'),
    expect: () => [
      isA<ProfileSetupState>().having((s) => s.submitting, 'submitting', true),
    ],
  );

  blocTest<ProfileSetupCubit, ProfileSetupState>(
    'submit conflict → submitError surfaced, submitting cleared',
    build: () {
      when(
        () => setup.call(
          username: any(named: 'username'),
          displayName: any(named: 'displayName'),
          bio: any(named: 'bio'),
        ),
      ).thenAnswer(
        (_) async => const Result<MeProfile>.err(AppFailure.conflict()),
      );
      return ProfileSetupCubit(check, setup);
    },
    act: (c) => c.submit(username: 'demo', displayName: 'Demo'),
    expect: () => [
      isA<ProfileSetupState>().having((s) => s.submitting, 'submitting', true),
      isA<ProfileSetupState>()
          .having((s) => s.submitting, 'submitting', false)
          .having(
            (s) => s.submitError,
            'submitError',
            isA<AppFailureConflict>(),
          ),
    ],
  );
}
