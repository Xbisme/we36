import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/wordmark.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_cubit.dart';

/// Sign in (Group A · Screen 3): email + password, forgot-password link, footer
/// to sign up. Email-only identifier (no phone field — design delta, spec
/// FR-007). OAuth row is added in US4.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return BlocProvider<SignInCubit>(
      create: (_) => getIt<SignInCubit>(),
      child: Scaffold(
        backgroundColor: tokens.bgApp,
        body: SafeArea(
          child: BlocConsumer<SignInCubit, AppState<Object?>>(
            listener: (context, state) {
              if (state case AppError(
                :final failure,
              ) when failure is! AppFailureValidation) {
                getIt<ToastService>().show(
                  context,
                  message: failure.toMessage(context.l10n),
                  tone: ToastTone.error,
                );
              }
            },
            builder: (context, state) {
              final l10n = context.l10n;
              final submitting = state.isLoading;
              final fields = switch (state) {
                AppError(:final failure) when failure is AppFailureValidation =>
                  failure.fields,
                _ => const <String, String>{},
              };
              final emailError = fields.containsKey('email')
                  ? l10n.authEmailInvalid
                  : null;
              final passwordError = fields.containsKey('password')
                  ? l10n.authPasswordTooShort
                  : null;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const Center(child: Wordmark(fontSize: 40)),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Text(
                        l10n.authSignInSubtitle,
                        style: AppTypography.body16.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppTextField(
                      label: l10n.authEmailLabel,
                      controller: _email,
                      hint: l10n.authEmailHint,
                      errorText: emailError,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      enabled: !submitting,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.authPasswordLabel,
                      controller: _password,
                      errorText: passwordError,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      enabled: !submitting,
                      onSubmitted: (_) => _submit(context),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _LinkText(
                        label: l10n.authForgotPasswordLink,
                        onTap: () {}, // wired to forgot flow in US3
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: l10n.authSignInCta,
                      fullWidth: true,
                      onPressed: submitting ? null : () => _submit(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.authNoAccountQuestion,
                          style: AppTypography.body16.copyWith(
                            color: tokens.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _LinkText(
                          label: l10n.authCreateAccountLink,
                          onTap: () {}, // wired to sign up in US2
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    unawaited(
      context.read<SignInCubit>().submit(
        email: _email.text,
        password: _password.text,
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  const _LinkText({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        label: label,
        child: Text(
          label,
          style: AppTypography.label.copyWith(color: context.tokens.accent),
        ),
      ),
    );
  }
}
