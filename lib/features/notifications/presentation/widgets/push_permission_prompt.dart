import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The contextual push-permission affordance shown atop the Activity feed while
/// notifications aren't granted (#013 US2). It explains the value, then [onEnable]
/// triggers the OS prompt. Subtle + dismissible — never a re-nagging modal
/// (FR-014/FR-019).
class PushPermissionPrompt extends StatelessWidget {
  const PushPermissionPrompt({required this.onEnable, super.key});

  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tokens.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pushPromptTitle,
            style: AppTypography.label.copyWith(color: tokens.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.pushPromptBody,
            style: AppTypography.caption.copyWith(color: tokens.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: l10n.pushPromptAllow,
              size: AppButtonSize.sm,
              onPressed: onEnable,
            ),
          ),
        ],
      ),
    );
  }
}
