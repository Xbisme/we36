import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/auth/domain/usecases/request_password_reset.dart';
import 'package:we36/features/auth/domain/usecases/reset_password.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_cubit.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_state.dart';

class _MockRequest extends Mock implements RequestPasswordReset {}

class _MockReset extends Mock implements ResetPassword {}

void main() {
  late _MockRequest request;
  late _MockReset reset;

  setUp(() {
    request = _MockRequest();
    reset = _MockReset();
  });

  blocTest<ForgotPasswordCubit, ForgotPasswordState>(
    'request code → code step (with dev code) + resend cooldown',
    build: () {
      when(
        () => request.call(any()),
      ).thenAnswer((_) async => const Result<String?>.ok('123456'));
      return ForgotPasswordCubit(request, reset);
    },
    act: (c) => c.requestCode('a@we36.app'),
    expect: () => [
      isA<ForgotPasswordState>().having(
        (s) => s.submitting,
        'submitting',
        true,
      ),
      isA<ForgotPasswordState>()
          .having((s) => s.step, 'step', ForgotStep.code)
          .having((s) => s.devCode, 'devCode', '123456'),
      isA<ForgotPasswordState>().having(
        (s) => s.resendCooldown,
        'cooldown',
        45,
      ),
    ],
  );

  blocTest<ForgotPasswordCubit, ForgotPasswordState>(
    'reset with valid code → done',
    build: () {
      when(
        () => reset.call(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => const Result<void>.ok(null));
      return ForgotPasswordCubit(request, reset);
    },
    seed: () => const ForgotPasswordState(
      step: ForgotStep.code,
      email: 'a@we36.app',
    ),
    act: (c) => c.resetPassword(code: '123456', newPassword: 'newpass123'),
    expect: () => [
      isA<ForgotPasswordState>().having(
        (s) => s.submitting,
        'submitting',
        true,
      ),
      isA<ForgotPasswordState>().having((s) => s.step, 'step', ForgotStep.done),
    ],
  );

  blocTest<ForgotPasswordCubit, ForgotPasswordState>(
    'reset with bad code → validation error, stays on code step',
    build: () {
      when(
        () => reset.call(
          email: any(named: 'email'),
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer(
        (_) async => const Result<void>.err(
          AppFailure.validation(fields: {'code': 'invalid or expired'}),
        ),
      );
      return ForgotPasswordCubit(request, reset);
    },
    seed: () => const ForgotPasswordState(
      step: ForgotStep.code,
      email: 'a@we36.app',
    ),
    act: (c) => c.resetPassword(code: '000000', newPassword: 'newpass123'),
    expect: () => [
      isA<ForgotPasswordState>().having(
        (s) => s.submitting,
        'submitting',
        true,
      ),
      isA<ForgotPasswordState>()
          .having((s) => s.step, 'step', ForgotStep.code)
          .having((s) => s.error, 'error', isA<AppFailureValidation>()),
    ],
  );

  blocTest<ForgotPasswordCubit, ForgotPasswordState>(
    'resend during cooldown is a no-op',
    build: () {
      when(
        () => request.call(any()),
      ).thenAnswer((_) async => const Result<String?>.ok(null));
      return ForgotPasswordCubit(request, reset);
    },
    seed: () => const ForgotPasswordState(
      step: ForgotStep.code,
      email: 'a@we36.app',
      resendCooldown: 30,
    ),
    act: (c) => c.resend(),
    expect: () => const <ForgotPasswordState>[],
    verify: (_) => verifyNever(() => request.call(any())),
  );
}
