import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/auth/presentation/oauth/oauth_cubit.dart';

/// The OAuth row shared by Sign in + Sign up: "or" divider, Continue with Google
/// (always), and Continue with Apple (iOS only — App Store 4.8, spec FR-022).
class OAuthButtons extends StatelessWidget {
  const OAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OAuthCubit>(
      create: (_) => getIt<OAuthCubit>(),
      child: const _OAuthRow(),
    );
  }
}

class _OAuthRow extends StatelessWidget {
  const _OAuthRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isApplePlatform =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    return BlocConsumer<OAuthCubit, AppState<Object?>>(
      // A user cancel (`oauthCancelled`) stays silent; only real failures toast.
      listenWhen: (prev, curr) => prev != curr && curr is AppError<Object?>,
      listener: (context, state) {
        if (state case AppError(
          :final failure,
        ) when failure is! AppFailureOauthCancelled) {
          getIt<ToastService>().show(
            context,
            message: failure.toMessage(context.l10n),
            tone: ToastTone.error,
          );
        }
      },
      builder: (context, state) {
        final busy = state.isLoading;
        final cubit = context.read<OAuthCubit>();
        return Column(
          children: [
            _OrDivider(label: l10n.authOrDivider),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.authContinueWithGoogle,
              kind: AppButtonKind.secondary,
              fullWidth: true,
              onPressed: busy ? null : () => unawaited(cubit.google()),
            ),
            if (isApplePlatform) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.authContinueWithApple,
                kind: AppButtonKind.secondary,
                fullWidth: true,
                onPressed: busy ? null : () => unawaited(cubit.apple()),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Expanded(child: Divider(color: tokens.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(color: tokens.textTertiary),
          ),
        ),
        Expanded(child: Divider(color: tokens.border)),
      ],
    );
  }
}
