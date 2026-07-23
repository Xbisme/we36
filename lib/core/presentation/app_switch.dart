import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_motion.dart';
import 'package:we36/core/theme/app_shadows.dart';

/// Pill switch with a spring knob; on = accent. Constitution VI.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final reduce = context.reduceMotion;
    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: reduce ? Duration.zero : AppMotion.standard,
          curve: AppMotion.springCurve,
          width: 48,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: value ? AppGradients.brand : null,
            color: value ? null : tokens.borderStrong,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: AnimatedAlign(
            duration: reduce ? Duration.zero : AppMotion.standard,
            curve: AppMotion.springCurve,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppShadows.sm,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
