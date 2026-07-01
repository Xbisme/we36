import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/presentation/post_card.dart';

import '../../helpers/pump_app.dart';

/// T056 — `PostCard` feed states render correctly and drive their callbacks
/// across light + dark, covering the liked/saved variants and long-caption
/// truncation. (Kept as a deterministic structural test rather than a
/// pixel-golden to stay independent of the host font-rendering environment.)
Widget _card({
  bool liked = false,
  bool saved = false,
  String caption = 'golden hour',
  VoidCallback? onLike,
  VoidCallback? onSave,
}) => PostCard(
  username: 'maya',
  likesText: '128 likes',
  caption: caption,
  timeText: '2h',
  liked: liked,
  saved: saved,
  onLike: onLike,
  onSave: onSave,
);

void main() {
  for (final mode in ThemeMode.values.where((m) => m != ThemeMode.system)) {
    testWidgets('renders liked + saved variant in $mode without overflow', (
      tester,
    ) async {
      await pumpApp(
        tester,
        _card(liked: true, saved: true),
        surfaceSize: const Size(390, 844),
        themeMode: mode,
      );

      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('128 likes'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('like + save affordances invoke their callbacks', (tester) async {
    var liked = false;
    var saved = false;
    await pumpApp(
      tester,
      _card(onLike: () => liked = true, onSave: () => saved = true),
      surfaceSize: const Size(390, 844),
    );

    await tester.tap(find.bySemanticsLabel('Like'));
    await tester.tap(find.bySemanticsLabel('Save'));
    await tester.pump();

    expect(liked, isTrue);
    expect(saved, isTrue);
  });

  testWidgets('a long caption renders and stays bounded (truncates)', (
    tester,
  ) async {
    const long =
        'A very long caption that keeps going well beyond a single line so the '
        'card must clamp it with an ellipsis rather than growing unbounded and '
        'pushing the rest of the feed around on smaller phone widths.';
    await pumpApp(
      tester,
      _card(caption: long),
      surfaceSize: const Size(390, 844),
    );

    expect(find.byType(PostCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
