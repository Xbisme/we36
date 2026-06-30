import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// 6-box numeric OTP entry (Group A · Screen 5 — design delta: 6 boxes, not 4).
/// A single transparent field captures input; the boxes mirror each digit.
class OtpInput extends StatefulWidget {
  const OtpInput({
    required this.onChanged,
    this.length = 6,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final int length;
  final bool enabled;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = _controller.text;
    return Semantics(
      textField: true,
      label: 'Verification code',
      child: GestureDetector(
        onTap: _focus.requestFocus,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.length, (i) {
                final filled = i < text.length;
                return Container(
                  width: 48,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: filled ? tokens.accent : tokens.border,
                    ),
                  ),
                  child: Text(
                    filled ? text[i] : '',
                    style: AppTypography.h2.copyWith(color: tokens.textPrimary),
                  ),
                );
              }),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.number,
                  showCursor: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  onChanged: (v) {
                    setState(() {});
                    widget.onChanged(v);
                  },
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
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
