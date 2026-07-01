import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/features/stories/domain/models/story_compose_draft.dart';
import 'package:we36/features/stories/domain/models/story_sticker_overlay.dart';
import 'package:we36/features/stories/domain/models/story_text_overlay.dart';
import 'package:we36/features/stories/presentation/widgets/story_overlay_layer.dart';

/// US2 — preview == export (FR-005): the overlays a user places live in the
/// widget subtree the `RepaintBoundary` flattens, so they are present in the
/// rendered tree exactly as arranged.
void main() {
  testWidgets('placed text + sticker overlays render in the canvas subtree', (
    tester,
  ) async {
    const draft = StoryComposeDraft(
      assetId: 'asset-1',
      idempotencyKey: 'key-1',
      textOverlays: [
        StoryTextOverlay(id: 't1', text: 'hello', styleId: 'default'),
      ],
      stickerOverlays: [
        StoryStickerOverlay(id: 's1', assetKey: '❤️'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 270,
            height: 480,
            child: RepaintBoundary(
              child: StoryOverlayLayer(
                draft: draft,
                onMoveText: (_, _, _) {},
                onMoveSticker: (_, _, _) {},
                onRemoveText: (_) {},
                onRemoveSticker: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('hello'), findsOneWidget);
    expect(find.text('❤️'), findsOneWidget);
  });
}
