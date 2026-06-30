import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_badge.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_motion.dart';

/// A 24px icon inside a ≥44px tap target. Press = scale 0.88. Optional unread
/// badge. Always carries a semantic label (Constitution VI/VII).
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.active = false,
    this.badgeCount,
    this.color,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool active;
  final int? badgeCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onPressed,
      scale: AppMotion.pressScaleIcon,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: SizedBox(
          width: AppSpacing.tapTarget,
          height: AppSpacing.tapTarget,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppIcon(icon, active: active, color: color),
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
