import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_switch.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Trailing affordance of a [SettingsRow].
enum SettingsRowTrailing {
  /// A right chevron — the row navigates.
  chevron,

  /// A pill switch — the row toggles [SettingsRow.switchValue].
  toggle,

  /// Nothing (or a plain [SettingsRow.value] label).
  none,
}

/// One row in a settings list (Constitution VI): optional leading icon + label
/// (+ optional secondary description) + a trailing chevron / switch / value.
///
/// Tokens-only, `Semantics`-labelled, text-scaling and light/dark safe. Built
/// once here and reused by every #014 settings surface — never duplicated.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.label,
    this.description,
    this.icon,
    this.trailing = SettingsRowTrailing.chevron,
    this.value,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
    this.destructive = false,
    this.semanticLabel,
    super.key,
  });

  final String label;

  /// Optional secondary line under the label.
  final String? description;

  /// Optional leading icon.
  final IconData? icon;

  final SettingsRowTrailing trailing;

  /// A trailing value label (e.g. the current language) shown before a chevron.
  final String? value;

  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  /// Tap handler (navigation / action). Ignored for a [SettingsRowTrailing.toggle]
  /// row, which is driven by [onSwitchChanged].
  final VoidCallback? onTap;

  /// Renders the label + icon in the error color (e.g. Log out, Block).
  final bool destructive;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isToggle = trailing == SettingsRowTrailing.toggle;
    final fg = destructive ? tokens.error : tokens.textPrimary;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            AppIcon(icon!, size: 20, color: fg),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.body16.copyWith(color: fg),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: AppTypography.caption.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          _trailing(context, tokens),
        ],
      ),
    );

    if (isToggle) {
      // The switch itself is the interactive control (own Semantics).
      return content;
    }
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: Pressable(onTap: onTap, child: content),
    );
  }

  Widget _trailing(BuildContext context, AppColorsX tokens) {
    switch (trailing) {
      case SettingsRowTrailing.toggle:
        return AppSwitch(
          value: switchValue,
          onChanged: onSwitchChanged,
          semanticLabel: semanticLabel ?? label,
        );
      case SettingsRowTrailing.chevron:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null)
              Text(
                value!,
                style: AppTypography.body16.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            const SizedBox(width: 6),
            AppIcon(
              AppIcons.chevronRight,
              size: 20,
              color: tokens.textTertiary,
            ),
          ],
        );
      case SettingsRowTrailing.none:
        if (value != null) {
          return Text(
            value!,
            style: AppTypography.body16.copyWith(color: tokens.textSecondary),
          );
        }
        return const SizedBox.shrink();
    }
  }
}
