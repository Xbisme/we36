import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_switch.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors.dart';
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

/// Tint of a [SettingsRow]'s leading icon tile.
enum SettingsRowTone {
  /// Neutral `surface2` tile (default).
  neutral,

  /// Rose accent tile (accent-soft background, accent icon).
  rose,

  /// Mint tile (mint tint background, mint icon).
  mint,
}

/// Corner radius of the leading icon tile (design: 9; no AppRadius token maps
/// to this exact value).
const double _iconTileRadius = 9;

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
    this.tone = SettingsRowTone.neutral,
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

  /// Optional leading icon, rendered inside a tinted tile.
  final IconData? icon;

  /// Tint of the leading icon tile. Ignored when [icon] is null.
  final SettingsRowTone tone;

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

    final content = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              _IconTile(icon: icon!, tone: tone, fg: fg),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.body16.copyWith(
                      color: fg,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
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
              color: tokens.icon,
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

/// 34×34 tinted tile holding an 18px leading icon (Constitution VI).
class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.tone, required this.fg});

  final IconData icon;
  final SettingsRowTone tone;

  /// Foreground color inherited from the row (error when destructive) — used
  /// by the neutral tone.
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final (Color background, Color foreground) = switch (tone) {
      SettingsRowTone.neutral => (tokens.surface2, fg),
      SettingsRowTone.rose => (tokens.accentSoft, tokens.accent),
      SettingsRowTone.mint => (
        AppColors.mint400.withValues(alpha: 0.15),
        AppColors.mint500,
      ),
    };
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(_iconTileRadius),
      ),
      child: AppIcon(icon, size: 18, color: foreground),
    );
  }
}
