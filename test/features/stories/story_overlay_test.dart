import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/features/stories/data/create_story_repository_fake.dart';
import 'package:we36/features/stories/domain/models/story_text_overlay.dart';
import 'package:we36/features/stories/domain/usecases/publish_story.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';

import '../../support/fake_story_image_composer.dart';

/// US2 — text + sticker overlays: add / move (clamped) / remove, and the
/// ~100-char text limit (AS-2.6).
void main() {
  late AppDatabase db;
  late StoryComposeCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = FakeCreateStoryRepository(
      FakeMediaUploadService()..stepDelay = Duration.zero,
      db,
      OwnStoryStore(),
    );
    cubit = StoryComposeCubit(
      PublishStory(repo),
      FakeStoryImageComposer(),
      IdempotencyKeys(),
    )..startFromAsset('asset-1');
  });
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('add / move / remove text overlay', () {
    cubit.addText('hello');
    expect(cubit.state.draftOrNull!.textOverlays, hasLength(1));
    final id = cubit.state.draftOrNull!.textOverlays.single.id;

    cubit.moveText(id, 2, -1); // out of range → clamped to [0, 1]
    final moved = cubit.state.draftOrNull!.textOverlays.single;
    expect(moved.dx, 1.0);
    expect(moved.dy, 0.0);

    cubit.removeText(id);
    expect(cubit.state.draftOrNull!.textOverlays, isEmpty);
  });

  test('add / move / remove sticker overlay', () {
    cubit.addSticker('❤️');
    expect(cubit.state.draftOrNull!.stickerOverlays, hasLength(1));
    final id = cubit.state.draftOrNull!.stickerOverlays.single.id;

    cubit.moveSticker(id, 0.25, 0.75);
    final moved = cubit.state.draftOrNull!.stickerOverlays.single;
    expect(moved.dx, 0.25);
    expect(moved.dy, 0.75);

    cubit.removeSticker(id);
    expect(cubit.state.draftOrNull!.stickerOverlays, isEmpty);
  });

  test('text overlay limit is 100 chars and the formatter enforces it', () {
    expect(kStoryTextMaxLength, 100);
    final formatter = LengthLimitingTextInputFormatter(kStoryTextMaxLength);
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: 'a' * 150),
    );
    expect(result.text.length, 100);
  });
}
