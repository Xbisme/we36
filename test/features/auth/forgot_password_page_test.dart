import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/features/auth/domain/usecases/request_password_reset.dart';
import 'package:we36/features/auth/domain/usecases/reset_password.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_cubit.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_page.dart';
import 'package:we36/features/auth/presentation/widgets/otp_input.dart';

import '../../helpers/pump_app.dart';

class _MockRequest extends Mock implements RequestPasswordReset {}

class _MockReset extends Mock implements ResetPassword {}

void main() {
  late _MockRequest request;
  late _MockReset reset;

  setUp(() {
    request = _MockRequest();
    reset = _MockReset();
    getIt
      ..registerFactory<ForgotPasswordCubit>(
        () => ForgotPasswordCubit(request, reset),
      )
      ..registerLazySingleton<ToastService>(ToastService.new);
  });

  tearDown(getIt.reset);

  testWidgets('email → code step reveals the 6-box OTP', (tester) async {
    when(
      () => request.call(any()),
    ).thenAnswer((_) async => const Result<String?>.ok('123456'));
    await pumpApp(tester, const ForgotPasswordPage());
    await tester.enterText(find.byType(TextField).first, 'a@we36.app');
    await tester.tap(find.text('Send code'));
    await tester.pump();
    expect(find.byType(OtpInput), findsOneWidget);
    expect(find.text('Enter the code'), findsOneWidget);
    await tester.pumpWidget(
      const SizedBox(),
    ); // dispose → cancel cooldown timer
  });

  testWidgets('bad code shows a non-revealing error', (tester) async {
    when(
      () => request.call(any()),
    ).thenAnswer((_) async => const Result<String?>.ok('123456'));
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
    await pumpApp(tester, const ForgotPasswordPage());
    await tester.enterText(find.byType(TextField).first, 'a@we36.app');
    await tester.tap(find.text('Send code'));
    await tester.pump();

    // Code step: OTP field is TextField[0], new password is TextField[1].
    await tester.enterText(find.byType(TextField).at(0), '000000');
    await tester.enterText(find.byType(TextField).at(1), 'newpass123');
    await tester.pump();
    await tester.ensureVisible(find.text('Reset password'));
    await tester.tap(find.text('Reset password'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Please check the highlighted fields.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3)); // flush toast timer
    await tester.pumpWidget(
      const SizedBox(),
    ); // dispose → cancel cooldown timer
  });
}
