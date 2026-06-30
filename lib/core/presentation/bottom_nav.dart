import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_badge.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/nav_item.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_motion.dart';

/// Phone bottom navigation: 5 destinations, active = solid + accent, unread
/// badge on Messages. Constitution VI.
class BottomNav extends StatelessWidget {
  const BottomNav({
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    super.key,
  });

  final List<NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Pressable(
                    onTap: () => onSelect(i),
                    scale: AppMotion.pressScaleIcon,
                    child: Semantics(
                      button: true,
                      selected: i == currentIndex,
                      label: items[i].label,
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AppIcon(items[i].icon, active: i == currentIndex),
                            if (items[i].badgeCount != null &&
                                items[i].badgeCount! > 0)
                              Positioned(
                                top: -4,
                                right: -6,
                                child: AppBadge(count: items[i].badgeCount),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
