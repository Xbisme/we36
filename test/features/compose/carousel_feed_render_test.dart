import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:we36/core/presentation/post_card.dart';

import '../../helpers/pump_app.dart';

/// A distinct solid-colour JPEG per index so the carousel pages are decodable
/// and ordered deterministically (no network — Constitution XII).
ImageProvider<Object> _swatch(int i) => MemoryImage(
  Uint8List.fromList(
    img.encodeJpg(
      img.fill(
        img.Image(width: 8, height: 10),
        color: img.ColorRgb8(i * 40, 80, 120),
      ),
    ),
  ),
);

void main() {
  testWidgets('multi-photo post renders a swipeable carousel in order', (
    tester,
  ) async {
    final pages = [for (var i = 1; i <= 3; i++) _swatch(i)];
    await pumpApp(
      tester,
      Center(
        child: SizedBox(
          width: 360,
          child: PostCard(
            username: 'maivu',
            likesText: '3 likes',
            caption: 'Carousel',
            timeText: 'now',
            mediaCarousel: pages,
          ),
        ),
      ),
      surfaceSize: const Size(400, 800),
    );
    await tester.pump();

    // The carousel is a PageView; the first page is item 1 of 3.
    expect(find.byType(PageView), findsOneWidget);
    expect(find.bySemanticsLabel('Photo 1 of 3'), findsOneWidget);

    // Swiping advances to the second page (order preserved).
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.bySemanticsLabel('Photo 2 of 3'), findsOneWidget);
  });

  testWidgets('single-image post does not build a carousel', (tester) async {
    await pumpApp(
      tester,
      Center(
        child: SizedBox(
          width: 360,
          child: PostCard(
            username: 'maivu',
            likesText: '1 like',
            caption: 'Single',
            timeText: 'now',
            media: _swatch(1),
          ),
        ),
      ),
      surfaceSize: const Size(400, 800),
    );
    await tester.pump();
    expect(find.byType(PageView), findsNothing);
  });
}
