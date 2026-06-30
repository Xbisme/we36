import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/features/auth/domain/usecases/request_password_reset.dart';
import 'package:we36/features/auth/domain/usecases/reset_password.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_state.dart';

/// Drives the recovery flow: request an OTP by email, then reset with the code +
/// a new password. Tracks a resend cooldown so the user can't spam the endpoint
/// (spec FR-018). All responses are uniform / non-revealing (FR-015/FR-017).
@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._request, this._reset)
    : super(const ForgotPasswordState());

  static const int _cooldownSeconds = 45;

  final RequestPasswordReset _request;
  final ResetPassword _reset;
  Timer? _cooldown;

  Future<void> requestCode(String email) async {
    emit(state.copyWith(submitting: true, error: null));
    final result = await _request(email.trim());
    if (isClosed) return;
    result.fold(
      (devCode) {
        emit(
          state.copyWith(
            step: ForgotStep.code,
            email: email.trim(),
            submitting: false,
            devCode: devCode,
          ),
        );
        _startCooldown();
      },
      (failure) => emit(state.copyWith(submitting: false, error: failure)),
    );
  }

  Future<void> resend() async {
    if (state.resendCooldown > 0) return;
    await requestCode(state.email);
  }

  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    emit(state.copyWith(submitting: true, error: null));
    final result = await _reset(
      email: state.email,
      code: code,
      newPassword: newPassword,
    );
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(step: ForgotStep.done, submitting: false)),
      (failure) => emit(state.copyWith(submitting: false, error: failure)),
    );
  }

  void _startCooldown() {
    _cooldown?.cancel();
    emit(state.copyWith(resendCooldown: _cooldownSeconds));
    _cooldown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      final next = state.resendCooldown - 1;
      emit(state.copyWith(resendCooldown: next < 0 ? 0 : next));
      if (next <= 0) timer.cancel();
    });
  }

  @override
  Future<void> close() {
    _cooldown?.cancel();
    return super.close();
  }
}
