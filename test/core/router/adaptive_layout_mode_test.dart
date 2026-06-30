import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/router/adaptive_layout_mode.dart';

void main() {
  group('AdaptiveLayoutMode.fromWidth boundaries', () {
    test('phone below 700', () {
      expect(AdaptiveLayoutMode.fromWidth(699), AdaptiveLayoutMode.phone);
    });
    test('tabletCompact at 700..979', () {
      expect(
        AdaptiveLayoutMode.fromWidth(700),
        AdaptiveLayoutMode.tabletCompact,
      );
      expect(
        AdaptiveLayoutMode.fromWidth(979),
        AdaptiveLayoutMode.tabletCompact,
      );
    });
    test('tabletFull at 980..1099', () {
      expect(AdaptiveLayoutMode.fromWidth(980), AdaptiveLayoutMode.tabletFull);
      expect(AdaptiveLayoutMode.fromWidth(1099), AdaptiveLayoutMode.tabletFull);
    });
    test('tabletWide at 1100+', () {
      expect(AdaptiveLayoutMode.fromWidth(1100), AdaptiveLayoutMode.tabletWide);
    });
    test('flags', () {
      expect(AdaptiveLayoutMode.phone.isPhone, isTrue);
      expect(AdaptiveLayoutMode.tabletCompact.railCompact, isTrue);
      expect(AdaptiveLayoutMode.tabletWide.showRightRail, isTrue);
      expect(AdaptiveLayoutMode.tabletFull.showRightRail, isFalse);
    });
  });
}
