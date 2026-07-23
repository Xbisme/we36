import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/auth/presentation/oauth/oauth_buttons.dart';
import 'package:we36/features/auth/presentation/sign_up/sign_up_cubit.dart';

/// Sign up (Group A · Screen 4): email + password (≥ 8) registration. Email-only
/// (no phone field — design delta, spec FR-007). On success → Profile setup via
/// the session guard. OAuth row is added in US4.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    return BlocProvider<SignUpCubit>(
      create: (_) => getIt<SignUpCubit>(),
      child: Scaffold(
        backgroundColor: tokens.bgApp,
        body: SafeArea(
          child: BlocConsumer<SignUpCubit, AppState<Object?>>(
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

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.xxl),
                          Text(
                            l10n.authSignUpTitle,
                            style: AppTypography.h2.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          // Design subtitle (no dedicated l10n key yet — English copy).
                          Text(
                            'Join the community in a minute.',
                            style: AppTypography.body16.copyWith(
                              color: tokens.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          AppTextField(
                            label: l10n.authEmailLabel,
                            controller: _email,
                            hint: l10n.authEmailHint,
                            errorText: fields.containsKey('email')
                                ? l10n.authEmailInvalid
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            enabled: !submitting,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            label: l10n.authPasswordLabel,
                            controller: _password,
                            errorText: fields.containsKey('password')
                                ? l10n.authPasswordTooShort
                                : null,
                            obscure: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            enabled: !submitting,
                            onSubmitted: (_) => _submit(context),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.authSignUpTerms,
                            style: AppTypography.caption.copyWith(
                              color: tokens.textTertiary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton(
                            label: l10n.authSignUpCta,
                            fullWidth: true,
                            onPressed: submitting
                                ? null
                                : () => _submit(context),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          const OAuthButtons(),
                        ],
                      ),
                    ),
                  ),
                  // Pinned footer bar with a hairline top divider (design A4).
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: tokens.divider)),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.authHaveAccountQuestion,
                          style: AppTypography.body16.copyWith(
                            color: tokens.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.signIn),
                          behavior: HitTestBehavior.opaque,
                          child: Semantics(
                            button: true,
                            label: l10n.authLogInLink,
                            child: Text(
                              l10n.authLogInLink,
                              style: AppTypography.label.copyWith(
                                color: tokens.accent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
      context.read<SignUpCubit>().submit(
        email: _email.text,
        password: _password.text,
      ),
    );
  }
}
