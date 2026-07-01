import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/features/stories/data/create_story_repository_fake.dart';
import 'package:we36/features/stories/domain/usecases/publish_story.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_state.dart';

import '../../support/fake_story_image_composer.dart';

/// US4 — resilient publishing: a cancel leaves no story (FR-010/SC-005); a
/// failed-then-retried publish yields exactly one (FR-009/SC-004).
void main() {
  late AppDatabase db;
  late OwnStoryStore store;
  late FakeMediaUploadService upload;
  late StoryComposeCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = OwnStoryStore();
    upload = FakeMediaUploadService()..stepDelay = Duration.zero;
    final repo = FakeCreateStoryRepository(upload, db, store);
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

  test('cancel mid-upload leaves zero stories', () async {
    upload
      ..steps = 4
      ..stepDelay = const Duration(milliseconds: 5);
    final publishing = cubit.publish(boundaryKey: GlobalKey());
    cubit.cancel();
    await publishing;

    expect(store.activeSegments(), isEmpty);
    expect(cubit.state, isA<StoryComposeLoaded>());
  });

  test('fail then retry twice creates exactly one story', () async {
    upload.failAfterFraction = 0.5;
    await cubit.publish(boundaryKey: GlobalKey());
    expect(cubit.state, isA<StoryComposeError>());
    expect(store.activeSegments(), isEmpty);

    upload.failAfterFraction = null;
    await cubit.retry();
    await cubit.retry();
    expect(cubit.state, isA<StoryComposePublished>());
    expect(store.activeSegments(), hasLength(1));
  });
}
