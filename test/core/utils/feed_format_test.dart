import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';

/// Locks the formatter outputs the feed consumes (Constitution XIV) —
/// independent of feed UI. PostCard wiring to these helpers is covered by the
/// HomePage widget test.
void main() {
  group('CountFormatter (like counts)', () {
    const f = CountFormatter('en');
    test('full separators below 10k', () {
      expect(f.format(1240), '1,240');
    });
    test('abbreviates thousands', () {
      expect(f.format(38400), '38.4k');
    });
    test('drops a trailing .0', () {
      expect(f.format(38000), '38k');
    });
    test('abbreviates millions', () {
      expect(f.format(1200000), '1.2M');
    });
  });

  group('RelativeTimeFormatter (timestamps)', () {
    final now = DateTime.utc(2026, 7, 1, 12);
    test('English compact labels', () {
      const f = RelativeTimeFormatter();
      expect(f.format(now.subtract(const Duration(hours: 2)), now: now), '2h');
      expect(f.format(now.subtract(const Duration(days: 1)), now: now), '1d');
      expect(
        f.format(now.subtract(const Duration(seconds: 5)), now: now),
        'now',
      );
    });
    test('Vietnamese labels differ from English', () {
      const f = RelativeTimeFormatter(labels: RelativeTimeLabels.vi());
      final vi = f.format(now.subtract(const Duration(hours: 2)), now: now);
      expect(vi, isNot('2h'));
    });
  });
}
