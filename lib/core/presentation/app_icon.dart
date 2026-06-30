import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:we36/core/theme/app_colors_x.dart';

/// Curated, semantic icon names → a single Lucide family (Constitution VI).
/// Never use Flutter `Icons`/`CupertinoIcons` or emoji-as-icon directly.
abstract final class AppIcons {
  static const IconData home = LucideIcons.house;
  static const IconData search = LucideIcons.search;
  static const IconData reels = LucideIcons.clapperboard;
  static const IconData messages = LucideIcons.messageCircle;
  static const IconData profile = LucideIcons.circleUser;
  static const IconData like = LucideIcons.heart;
  static const IconData comment = LucideIcons.messageCircle;
  static const IconData share = LucideIcons.send;
  static const IconData save = LucideIcons.bookmark;
  static const IconData notification = LucideIcons.bell;
  static const IconData plus = LucideIcons.plus;
  static const IconData more = LucideIcons.ellipsis;
  static const IconData settings = LucideIcons.settings;
  static const IconData check = LucideIcons.check;
  static const IconData close = LucideIcons.x;
  static const IconData camera = LucideIcons.camera;
  static const IconData back = LucideIcons.chevronLeft;
  static const IconData sticker = LucideIcons.sticker;
  static const IconData location = LucideIcons.mapPin;
  static const IconData music = LucideIcons.music;
}

/// Single icon wrapper: 24px default, token-colored. `active` switches to the
/// accent (rose) color — Lucide is an outline family, so "solid active" is
/// approximated by the accent color (see research.md R6).
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    this.size = 24,
    this.active = false,
    this.color,
    super.key,
  });

  final IconData icon;
  final double size;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Icon(
      icon,
      size: size,
      color: color ?? (active ? tokens.iconActive : tokens.icon),
    );
  }
}
