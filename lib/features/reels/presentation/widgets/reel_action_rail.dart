import 'package:flutter/material.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/count_formatter.dart';

/// The right-side action rail for a reel (Screen 10): like / comment / share /
/// save + more. Like & save use the solid glyph when active (brand color on
/// like). Counts are locale-formatted. All actions are callbacks owned by the
/// page (optimistic like/save via the cubit; comment opens the sheet; share /
/// more are surface-only).
class ReelActionRail extends StatelessWidget {
  const ReelActionRail({
    required this.reel,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
    required this.onMore,
    super.key,
  });

  final Reel reel;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final counts = CountFormatter(Localizations.localeOf(context).toString());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RailButton(
          icon: AppIcons.like,
          label: counts.format(reel.likeCount),
          active: reel.viewerHasLiked,
          activeColor: AppColors.rose500,
          onTap: onLike,
          semanticLabel: reel.viewerHasLiked ? 'Unlike' : 'Like',
        ),
        const SizedBox(height: AppSpacing.lg),
        _RailButton(
          icon: AppIcons.comment,
          label: counts.format(reel.commentCount),
          onTap: onComment,
          semanticLabel: 'Comments',
        ),
        const SizedBox(height: AppSpacing.lg),
        _RailButton(
          icon: AppIcons.save,
          label: counts.format(reel.saveCount),
          active: reel.viewerHasSaved,
          onTap: onSave,
          semanticLabel: reel.viewerHasSaved ? 'Remove from saved' : 'Save',
        ),
        const SizedBox(height: AppSpacing.lg),
        _RailButton(
          icon: AppIcons.share,
          label: 'Share',
          onTap: onShare,
          semanticLabel: 'Share',
        ),
        const SizedBox(height: AppSpacing.lg),
        _RailButton(
          icon: AppIcons.more,
          onTap: onMore,
          semanticLabel: 'More options',
        ),
      ],
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
    this.label,
    this.active = false,
    this.activeColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;
  final String? label;
  final bool active;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              icon,
              color: active ? activeColor : Colors.white,
              active: active,
              size: 30,
            ),
            if (label != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                label!,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
