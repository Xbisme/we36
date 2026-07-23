import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_badge.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_motion.dart';

enum AppIconButtonSize { sm, md, lg }

/// An icon inside a tap target. Press = scale 0.88. Optional unread badge.
/// Always carries a semantic label (Constitution VI/VII). Design sizes
/// (_ds IconButton): sm box36/icon18 · md box44/icon22 · lg box52/icon26.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.active = false,
    this.badgeCount,
    this.color,
    this.size = AppIconButtonSize.md,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool active;
  final int? badgeCount;
  final Color? color;
  final AppIconButtonSize size;

  @override
  Widget build(BuildContext context) {
    final (box, iconSize) = switch (size) {
      AppIconButtonSize.sm => (36.0, 18.0),
      AppIconButtonSize.md => (44.0, 22.0),
      AppIconButtonSize.lg => (52.0, 26.0),
    };
    return Pressable(
      onTap: onPressed,
      scale: AppMotion.pressScaleIcon,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: SizedBox(
          width: box,
          height: box,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppIcon(icon, size: iconSize, active: active, color: color),
              if (badgeCount != null)
                Positioned(
                  top: 8,
                  right: 6,
                  child: AppBadge(count: badgeCount),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
