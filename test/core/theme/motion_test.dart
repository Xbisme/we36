import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_motion.dart';

void main() {
  group('Reduce Motion (SC-011)', () {
    testWidgets('context.reduceMotion reflects disableAnimations', (
      tester,
    ) async {
      late bool reduced;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              reduced = context.reduceMotion;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(reduced, isTrue);
    });

    testWidgets('defaults to false when not requested', (tester) async {
      late bool reduced;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Builder(
            builder: (context) {
              reduced = context.reduceMotion;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(reduced, isFalse);
    });
  });
}
