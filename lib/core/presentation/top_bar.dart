import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
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
    // Extend the surface behind the status bar and push the 52px toolbar below
    // it (like Material AppBar) so content isn't clipped by the system bar.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                  // Design: titles use the display face (Plus Jakarta) bold.
                  child: Text(
                    title ?? '',
                    style: AppTypography.h3.copyWith(
                      color: tokens.textPrimary,
                      fontSize: large ? 20 : 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
