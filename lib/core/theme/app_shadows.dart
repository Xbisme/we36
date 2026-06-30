import 'package:flutter/painting.dart';

/// Soft, low-spread, ink-tinted shadows (never pure black) — Constitution VI.
abstract final class AppShadows {
  static const Color _ink = Color(0xFF1A1A2E);

  static List<BoxShadow> get xs => [
    BoxShadow(
      color: _ink.withValues(alpha: 0.06),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  static List<BoxShadow> get sm => [
    BoxShadow(
      color: _ink.withValues(alpha: 0.08),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
  static List<BoxShadow> get md => [
    BoxShadow(
      color: _ink.withValues(alpha: 0.10),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  static List<BoxShadow> get lg => [
    BoxShadow(
      color: _ink.withValues(alpha: 0.14),
      blurRadius: 28,
      offset: const Offset(0, 12),
    ),
  ];

  /// Under primary CTAs only — use sparingly.
  static List<BoxShadow> get brand => [
    BoxShadow(
      color: const Color(0xFFFF4E64).withValues(alpha: 0.32),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
