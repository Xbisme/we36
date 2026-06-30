import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Tablet content-area header (h60, 22px display title) — replaces `TopBar`
/// for the wide-layout content pane. Constitution VI/VII.
class PaneHeader extends StatelessWidget {
  const PaneHeader({
    required this.title,
    this.onBack,
    this.actions = const [],
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: Row(
        children: [
          if (onBack != null)
            AppIconButton(
              icon: AppIcons.back,
              semanticLabel: 'Back',
              onPressed: onBack,
            ),
          Expanded(
            child: Text(
              title,
              style: AppTypography.h2.copyWith(
                color: tokens.textPrimary,
                fontSize: 22,
              ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
