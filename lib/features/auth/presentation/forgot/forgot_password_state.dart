import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'forgot_password_state.freezed.dart';

/// Steps of the recovery flow: enter email → enter the OTP + new password → done.
enum ForgotStep { email, code, done }

/// Forgot-password screen state: the current step, the email being reset, the
/// submit lifecycle, the resend cooldown, and (dev flavor only) the surfaced OTP.
@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(ForgotStep.email) ForgotStep step,
    @Default('') String email,
    @Default(false) bool submitting,
    @Default(0) int resendCooldown,
    AppFailure? error,
    String? devCode,
  }) = _ForgotPasswordState;
}
