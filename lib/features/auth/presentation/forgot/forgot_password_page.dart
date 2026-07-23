import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_cubit.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_state.dart';
import 'package:we36/features/auth/presentation/widgets/otp_input.dart';

/// Forgot password (Group A · Screen 5): request a 6-digit OTP by email, then
/// reset with the code + a new password. Resend is gated by a cooldown.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  final _newPassword = TextEditingController();
  String _code = '';

  @override
  void initState() {
    super.initState();
    _newPassword.addListener(_onFormChanged);
  }

  void _onFormChanged() => setState(() {});

  @override
  void dispose() {
    _email.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return BlocProvider<ForgotPasswordCubit>(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: Scaffold(
        backgroundColor: tokens.bgApp,
        appBar: AppBar(
          backgroundColor: tokens.bgApp,
          elevation: 0,
          foregroundColor: tokens.textPrimary,
        ),
        body: SafeArea(
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            // Only react to error/step transitions — NOT cooldown ticks (which
            // would otherwise re-show the toast every second).
            listenWhen: (prev, curr) =>
                prev.error != curr.error || prev.step != curr.step,
            listener: (context, state) {
              final failure = state.error;
              if (failure != null) {
                getIt<ToastService>().show(
                  context,
                  message: failure.toMessage(context.l10n),
                  tone: ToastTone.error,
                );
              }
              if (state.step == ForgotStep.done) {
                getIt<ToastService>().show(
                  context,
                  message: context.l10n.authResetDone,
                  tone: ToastTone.success,
                );
                context.go(AppRoutes.signIn);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: state.step == ForgotStep.email
                    ? _EmailStep(
                        controller: _email,
                        submitting: state.submitting,
                        onSubmit: () => _sendCode(context),
                      )
                    : _CodeStep(
                        email: state.email,
                        newPassword: _newPassword,
                        devCode: state.devCode,
                        resendCooldown: state.resendCooldown,
                        submitting: state.submitting,
                        onCodeChanged: (v) => setState(() => _code = v),
                        canReset:
                            _code.length == 6 &&
                            _newPassword.text.length >= 8 &&
                            !state.submitting,
                        onReset: () => _reset(context),
                        onResend: () => unawaited(
                          context.read<ForgotPasswordCubit>().resend(),
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _sendCode(BuildContext context) {
    FocusScope.of(context).unfocus();
    unawaited(context.read<ForgotPasswordCubit>().requestCode(_email.text));
  }

  void _reset(BuildContext context) {
    FocusScope.of(context).unfocus();
    unawaited(
      context.read<ForgotPasswordCubit>().resetPassword(
        code: _code,
        newPassword: _newPassword.text,
      ),
    );
  }
}

class _EmailStep extends StatelessWidget {
  const _EmailStep({
    required this.controller,
    required this.submitting,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Rose "recovery" tile (design-specific 64 / radius-20).
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: tokens.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: AppIcon(
              AppIcons.notification,
              size: 30,
              color: tokens.accent,
            ),
          ),
        ),
        Text(l10n.authForgotTitle, style: AppTypography.h1),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.authForgotSubtitle,
          style: AppTypography.body16.copyWith(color: tokens.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppTextField(
          label: l10n.authEmailLabel,
          controller: controller,
          hint: l10n.authEmailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          enabled: !submitting,
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: l10n.authSendCodeCta,
          fullWidth: true,
          onPressed: submitting ? null : onSubmit,
        ),
      ],
    );
  }
}

class _CodeStep extends StatelessWidget {
  const _CodeStep({
    required this.email,
    required this.newPassword,
    required this.devCode,
    required this.resendCooldown,
    required this.submitting,
    required this.onCodeChanged,
    required this.canReset,
    required this.onReset,
    required this.onResend,
  });

  final String email;
  final TextEditingController newPassword;
  final String? devCode;
  final int resendCooldown;
  final bool submitting;
  final ValueChanged<String> onCodeChanged;
  final bool canReset;
  final VoidCallback onReset;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.authCodeTitle, style: AppTypography.h1),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.authCodeSubtitle(email),
          style: AppTypography.body16.copyWith(color: tokens.textSecondary),
        ),
        if (devCode != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.authDevCode(devCode!),
            style: AppTypography.caption.copyWith(color: tokens.accent),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        OtpInput(onChanged: onCodeChanged, enabled: !submitting),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: l10n.authNewPasswordLabel,
          controller: newPassword,
          obscure: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          enabled: !submitting,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: l10n.authResetCta,
          fullWidth: true,
          onPressed: canReset ? onReset : null,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: resendCooldown > 0
              ? Text(
                  l10n.authResendIn(resendCooldown),
                  style: AppTypography.label.copyWith(
                    color: tokens.textTertiary,
                  ),
                )
              : GestureDetector(
                  onTap: onResend,
                  behavior: HitTestBehavior.opaque,
                  child: Semantics(
                    button: true,
                    label: l10n.authResendCode,
                    child: Text(
                      l10n.authResendCode,
                      style: AppTypography.label.copyWith(color: tokens.accent),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
