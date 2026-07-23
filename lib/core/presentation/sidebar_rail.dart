import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_badge.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/nav_item.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/presentation/wordmark.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Tablet/iPad left rail replacing the bottom nav: 5 destinations + first-class
/// Notifications + Create + a profile chip. `compact` = icon-only (~84),
/// otherwise icon+label (~240). Constitution VI/VII.
class SidebarRail extends StatelessWidget {
  const SidebarRail({
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    required this.compact,
    this.profileImage,
    this.profileName,
    this.profileSubtitle,
    this.profileActive = false,
    super.key,
  });

  final List<NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final bool compact;
  final ImageProvider<Object>? profileImage;
  final String? profileName;

  /// Optional secondary line under [profileName] (e.g. the display name).
  final String? profileSubtitle;

  /// When true, the profile chip's avatar shows the active (brand) ring.
  final bool profileActive;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: compact ? 84 : 240,
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(right: BorderSide(color: tokens.divider)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: compact
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: compact
                  ? const Wordmark(fontSize: 22)
                  : const Wordmark(fontSize: 28),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < items.length; i++)
              _RailItem(
                item: items[i],
                active: i == currentIndex,
                compact: compact,
                onTap: () => onSelect(i),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Avatar(
                    size: 36,
                    image: profileImage,
                    ring: profileActive ? AvatarRing.unseen : AvatarRing.none,
                    semanticLabel: profileName,
                  ),
                  if (!compact && profileName != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            profileName!,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label.copyWith(
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (profileSubtitle != null)
                            Text(
                              profileSubtitle!,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                color: tokens.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.item,
    required this.active,
    required this.compact,
    required this.onTap,
  });

  final NavItemData item;
  final bool active;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Pressable(
        onTap: onTap,
        child: Semantics(
          button: true,
          selected: active,
          label: item.label,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 0 : AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: active ? tokens.accentSoft : null,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisAlignment: compact
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppIcon(item.icon, size: 26, active: active),
                    if (item.badgeCount != null && item.badgeCount! > 0)
                      Positioned(
                        top: -4,
                        right: -6,
                        child: AppBadge(count: item.badgeCount),
                      ),
                  ],
                ),
                if (!compact) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(
                        fontSize: 16,
                        color: active ? tokens.iconActive : tokens.textPrimary,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
