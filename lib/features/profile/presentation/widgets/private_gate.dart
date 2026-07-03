import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Shown in place of the content grid on a private account the viewer is not
/// approved to see (#010 US4, FR-017).
class PrivateGate extends StatelessWidget {
  const PrivateGate({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Center(
      child: Semantics(
        label: l10n.profilePrivateTitle,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(AppIcons.eyeOff, size: 32, color: tokens.textTertiary),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.profilePrivateTitle,
                textAlign: TextAlign.center,
                style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.profilePrivateBody,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: tokens.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
