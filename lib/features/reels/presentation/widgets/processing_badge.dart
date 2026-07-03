import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// A small pill shown on an own reel whose video is still transcoding (T044,
/// US3). The optimistic just-published reel carries it until the feed reconciles
/// the ready rendition, at which point the badge disappears.
class ProcessingBadge extends StatelessWidget {
  const ProcessingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          context.l10n.reelProcessing,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
