import 'package:flutter/widgets.dart';

/// Motion tokens. Press feedback = scale-down; no infinite decorative loops;
/// Reduce-Motion degrades to a static state (Constitution VI).
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 200);
  static const Duration emphasized = Duration(milliseconds: 320);

  static const Curve standardCurve = Cubic(0.2, 0, 0, 1);
  static const Curve emphasizedCurve = Cubic(0.3, 0, 0, 1);
  static const Curve springCurve = Cubic(0.34, 1.56, 0.64, 1);

  /// Press scale-down targets.
  static const double pressScaleButton = 0.97;
  static const double pressScaleIcon = 0.88;
}

/// `context.reduceMotion` — true when the OS asks to minimize motion.
extension ReduceMotionX on BuildContext {
  bool get reduceMotion => MediaQuery.maybeOf(this)?.disableAnimations ?? false;
}
