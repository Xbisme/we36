import 'package:flutter/widgets.dart';

/// Type tokens: Plus Jakarta Sans (display/heading/wordmark/counts) + Inter
/// (body/UI). Fonts are bundled (offline + golden-deterministic); [FontWeight]
/// drives the variable `wght` axis. Constitution VI.
abstract final class AppTypography {
  static const String display = 'PlusJakartaSans';
  static const String body = 'Inter';

  // Display / headings (Plus Jakarta Sans)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: display,
    fontSize: 44,
    height: 52 / 44,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.88,
  );
  static const TextStyle h1 = TextStyle(
    fontFamily: display,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: display,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.48,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: display,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
  );

  // Counts / stats use the display face, bold.
  static const TextStyle stat = TextStyle(
    fontFamily: display,
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w700,
  );

  // Body / UI (Inter)
  static const TextStyle body16 = TextStyle(
    fontFamily: body,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle label = TextStyle(
    fontFamily: body,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: body,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );

  /// Wordmark style (gradient-clipped at the call site).
  static const TextStyle wordmark = TextStyle(
    fontFamily: display,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.78,
  );
}
