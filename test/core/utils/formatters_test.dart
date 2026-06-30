import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';

void main() {
  group('CountFormatter', () {
    const f = CountFormatter('en');
    test('numbers below 10k use separators', () {
      expect(f.format(1240), '1,240');
      expect(f.format(0), '0');
      expect(f.format(9999), '9,999');
    });
    test('ten-thousands and up abbreviate to k', () {
      expect(f.format(38400), '38.4k');
      expect(f.format(24100), '24.1k');
      expect(f.format(10000), '10k');
    });
    test('millions abbreviate to M', () {
      expect(f.format(1200000), '1.2M');
    });
  });

  group('RelativeTimeFormatter', () {
    const f = RelativeTimeFormatter();
    final now = DateTime(2026, 6, 30, 12);
    test('buckets to compact units', () {
      expect(
        f.format(now.subtract(const Duration(seconds: 5)), now: now),
        'now',
      );
      expect(f.format(now.subtract(const Duration(hours: 2)), now: now), '2h');
      expect(f.format(now.subtract(const Duration(days: 1)), now: now), '1d');
      expect(f.format(now.subtract(const Duration(days: 14)), now: now), '2w');
    });

    test('Vietnamese labels apply', () {
      const vi = RelativeTimeFormatter(labels: RelativeTimeLabels.vi());
      expect(
        vi.format(now.subtract(const Duration(hours: 3)), now: now),
        '3 giờ',
      );
    });
  });
}
