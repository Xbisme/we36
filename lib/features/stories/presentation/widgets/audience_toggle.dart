import 'package:flutter/material.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Story audience selector (#005 US3): "Your story" (followers) vs "Close
/// friends". Recorded on the published segment (FR-006). Managing the
/// close-friends list itself is out of scope (→ #014); this only picks a value.
class AudienceToggle extends StatelessWidget {
  const AudienceToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final StoryAudience value;
  final ValueChanged<StoryAudience> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Pill(
          label: context.l10n.yourStory,
          selected: value == StoryAudience.yourStory,
          onTap: () => onChanged(StoryAudience.yourStory),
        ),
        const SizedBox(width: AppSpacing.sm),
        _Pill(
          label: context.l10n.storyCloseFriends,
          selected: value == StoryAudience.closeFriends,
          onTap: () => onChanged(StoryAudience.closeFriends),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Both pills stay translucent white on the media (Constitution VI — no
    // solid brand fill here). Selection reads as a brighter scrim + a leading
    // check, not a rose block.
    return Pressable(
      onTap: onTap,
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: selected ? 0.32 : 0.18),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const AppIcon(AppIcons.check, size: 16, color: Colors.white),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: AppTypography.label.copyWith(
                  color: Colors.white,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
