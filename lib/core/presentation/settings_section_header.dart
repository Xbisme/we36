import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Group label above a run of settings rows (Constitution VI). Tokens-only,
/// text-scaling and light/dark safe.
class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Semantics(
        header: true,
        child: Text(
          label.toUpperCase(),
          style: AppTypography.caption.copyWith(
            color: tokens.textSecondary,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
