import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// In-flight story upload indicator (#005 US4): a progress bar + cancel. Shown
/// while publishing; cancelling stops the upload with no story created
/// (FR-008/FR-010).
class StoryUploadProgress extends StatelessWidget {
  const StoryUploadProgress({
    required this.progress,
    required this.onCancel,
    super.key,
  });

  /// 0..1, or 0 for indeterminate.
  final double progress;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: progress == 0 ? null : progress,
              minHeight: 3,
              backgroundColor: Colors.white24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          TextButton(
            onPressed: onCancel,
            child: Text(
              context.l10n.composeCancel,
              style: AppTypography.label.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
