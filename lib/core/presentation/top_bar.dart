import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Full-screen route header: optional back chevron + title + trailing actions.
/// `large` uses a 20px title (Activity/Settings). Constitution VI.
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    this.title,
    this.onBack,
    this.actions = const [],
    this.large = false,
    super.key,
  });

  final String? title;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final bool large;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: 52,
      color: tokens.surface,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (onBack != null)
            AppIconButton(
              icon: AppIcons.back,
              semanticLabel: 'Back',
              onPressed: onBack,
            )
          else
            const SizedBox(width: 8),
          Expanded(
            child: Text(
              title ?? '',
              style: (large ? AppTypography.h3 : AppTypography.label).copyWith(
                color: tokens.textPrimary,
                fontSize: large ? 20 : 17,
              ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
