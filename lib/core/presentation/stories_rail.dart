import 'package:flutter/material.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// One entry in the stories rail.
class StoryItem {
  const StoryItem({
    required this.label,
    this.image,
    this.seen = false,
    this.isYou = false,
  });

  final String label;
  final ImageProvider<Object>? image;
  final bool seen;
  final bool isYou;
}

/// Horizontal rail of story avatars; the first tile is the current user's
/// add-story entry (create badge). Constitution VI.
class StoriesRail extends StatelessWidget {
  const StoriesRail({required this.items, this.onTap, super.key});

  final List<StoryItem> items;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, i) {
            final item = items[i];
            return GestureDetector(
              onTap: onTap == null ? null : () => onTap!(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Avatar(
                    size: 56,
                    image: item.image,
                    initials: item.isYou
                        ? null
                        : (item.label.isNotEmpty
                              ? item.label.characters.first.toUpperCase()
                              : null),
                    ring: item.isYou
                        ? AvatarRing.none
                        : (item.seen ? AvatarRing.seen : AvatarRing.unseen),
                    showCreateBadge: item.isYou,
                    semanticLabel: item.label,
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 64,
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
