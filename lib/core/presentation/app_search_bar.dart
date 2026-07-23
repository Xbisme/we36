import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Pill search field. When `readOnly` it acts as a tappable entry point
/// (e.g. Explore → Search screen). Constitution VI.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    required this.hint,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autofocus = false,
    this.readOnly = false,
    super.key,
  });

  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final bool autofocus;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      textField: true,
      label: hint,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: tokens.surface2,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          children: [
            AppIcon(AppIcons.search, size: 18, color: tokens.textTertiary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: readOnly
                  ? GestureDetector(
                      onTap: onTap,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        hint,
                        style: AppTypography.body16.copyWith(
                          color: tokens.textTertiary,
                        ),
                      ),
                    )
                  : TextField(
                      controller: controller,
                      autofocus: autofocus,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      textInputAction: TextInputAction.search,
                      style: AppTypography.body16.copyWith(
                        color: tokens.textPrimary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: AppTypography.body16.copyWith(
                          color: tokens.textTertiary,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
