import 'package:flutter/material.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/theme/app_colors_x.dart';

/// On tablet/iPad width, renders [child] inside a centered, constrained
/// mobile-width frame (FR-016); on phone width it fills the screen. Used to
/// wrap pre-auth + flow routes that have no dedicated tablet layout at v1.0.
class CenteredMobile extends StatelessWidget {
  const CenteredMobile({
    required this.child,
    this.maxWidth = 420,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppBreakpoints.tablet) return child;
    final tokens = context.tokens;
    return ColoredBox(
      color: tokens.surfaceSunken,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Material(color: tokens.bgApp, child: child),
        ),
      ),
    );
  }
}
