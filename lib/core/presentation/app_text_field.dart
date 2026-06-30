import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// The We36 text input (Constitution VI): a bordered, radius-12 field with a
/// label, optional inline error, and a password obscure toggle. Built once and
/// reused across auth + edit screens — never an inline `TextField` at call sites.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.label.copyWith(color: tokens.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: hasError ? tokens.error : tokens.border,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: _obscured,
                  enabled: widget.enabled,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  style: AppTypography.body16.copyWith(
                    color: tokens.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    hintText: widget.hint,
                    hintStyle: AppTypography.body16.copyWith(
                      color: tokens.textTertiary,
                    ),
                  ),
                ),
              ),
              if (widget.obscure)
                GestureDetector(
                  onTap: () => setState(() => _obscured = !_obscured),
                  behavior: HitTestBehavior.opaque,
                  child: Semantics(
                    button: true,
                    label: _obscured ? 'Show password' : 'Hide password',
                    child: AppIcon(
                      _obscured ? AppIcons.eye : AppIcons.eyeOff,
                      size: 20,
                      color: tokens.textTertiary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: AppTypography.caption.copyWith(color: tokens.error),
          ),
        ],
      ],
    );
  }
}
