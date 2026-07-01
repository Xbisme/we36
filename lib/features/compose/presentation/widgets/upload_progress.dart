import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Determinate publish-progress bar with a cancel affordance (FR-017). Shown
/// while the compose flow is in `loadedUploading`; cancelling aborts the upload
/// with no post created (FR-018a).
class UploadProgress extends StatelessWidget {
  const UploadProgress({
    required this.progress,
    required this.onCancel,
    super.key,
  });

  /// Overall 0.0..1.0 across the whole draft.
  final double progress;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      label: context.l10n.composeUploading,
      value: '${(progress * 100).round()}%',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.composeUploading,
                    style: AppTypography.label.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      color: tokens.accent,
                      backgroundColor: tokens.surface2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppButton(
              label: context.l10n.composeCancel,
              kind: AppButtonKind.ghost,
              size: AppButtonSize.sm,
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
