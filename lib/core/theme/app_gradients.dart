import 'package:flutter/painting.dart';
import 'package:we36/core/theme/app_colors.dart';

/// Brand gradients. NEVER used as a full-page background (Constitution VI):
/// only CTAs, the wordmark, own message bubbles, create actions, and the
/// unseen story ring.
abstract final class AppGradients {
  static const brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.rose500, AppColors.violet500],
  );

  static const brandSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.rose400, AppColors.violet400],
  );

  /// Unseen story ring only; seen rings use a flat gray border.
  static const story = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.amber400, AppColors.rose500, AppColors.violet500],
    stops: [0.0, 0.45, 1.0],
  );
}
