import 'package:intl/intl.dart';

/// Abbreviates engagement counts the We36 way: full with separators when small
/// ("1,240"), abbreviated when large ("38.4k", "1.2M"). Locale-aware via `intl`
/// (Constitution XIV). Use everywhere — never hand-format at call sites.
class CountFormatter {
  const CountFormatter([this.locale]);

  final String? locale;

  String format(int count) {
    final n = count.abs();
    // Full with separators below 10k ("1,240"), abbreviated above ("38.4k").
    if (n < 10000) {
      return NumberFormat.decimalPattern(locale).format(count);
    }
    if (n < 1000000) {
      return '${_short(count / 1000)}k';
    }
    if (n < 1000000000) {
      return '${_short(count / 1000000)}M';
    }
    return '${_short(count / 1000000000)}B';
  }

  /// One decimal, but drop a trailing ".0" (38.0k -> 38k, 38.4k stays).
  String _short(double value) {
    final fixed = NumberFormat('0.#', locale).format(value);
    return fixed;
  }
}
