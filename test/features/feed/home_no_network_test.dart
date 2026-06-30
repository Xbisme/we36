import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/stories_rail.dart';
import 'package:we36/features/feed/presentation/home_page.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets(
    'Home renders stories + post cards from mock with zero network (FR-026/SC-007)',
    (tester) async {
      await pumpApp(
        tester,
        const HomePage(),
        surfaceSize: const Size(390, 900),
      );
      await tester.pump();

      expect(find.byType(StoriesRail), findsOneWidget);
      expect(find.byType(PostCard), findsWidgets);

      // No network image providers anywhere in the tree.
      final networkImages = find.byWidgetPredicate(
        (w) => w is Image && w.image is NetworkImage,
      );
      expect(networkImages, findsNothing);
    },
  );
}
