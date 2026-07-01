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

/// US1/US4 — the compose cubit publishes a story (writes to [OwnStoryStore]),
/// cancels without a write, and retries idempotently (one segment).
void main() {
  late AppDatabase db;
  late OwnStoryStore store;
  late FakeMediaUploadService upload;
  late FakeStoryImageComposer composer;
  late StoryComposeCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = OwnStoryStore();
    upload = FakeMediaUploadService()..stepDelay = Duration.zero;
    composer = FakeStoryImageComposer();
    final repo = FakeCreateStoryRepository(upload, db, store);
    cubit = StoryComposeCubit(PublishStory(repo), composer, IdempotencyKeys());
  });
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('publish flattens, uploads, writes one segment, emits published', () async {
    cubit.startFromAsset('asset-1');
    await cubit.publish(boundaryKey: GlobalKey());

    expect(cubit.state, isA<StoryComposePublished>());
    expect(composer.flattenCalls, 1);
    final active = store.activeSegments();
    expect(active, hasLength(1));
    expect(active.single.imageUrl, startsWith('memory://'));
  });

  test('cancel mid-upload writes nothing and returns to loaded', () async {
    upload
      ..steps = 4
      ..stepDelay = const Duration(milliseconds: 5);
    cubit.startFromAsset('asset-1');
    final publishing = cubit.publish(boundaryKey: GlobalKey());
    cubit.cancel();
    await publishing;

    expect(cubit.state, isA<StoryComposeLoaded>());
    expect(store.activeSegments(), isEmpty);
  });

  test('retry after failure creates exactly one story (idempotent)', () async {
    // First attempt fails partway.
    upload.failAfterFraction = 0.5;
    cubit.startFromAsset('asset-1');
    await cubit.publish(boundaryKey: GlobalKey());
    expect(cubit.state, isA<StoryComposeError>());
    expect(store.activeSegments(), isEmpty);

    // Retry succeeds — same idempotency key ⇒ one segment.
    upload.failAfterFraction = null;
    await cubit.retry();
    await cubit.retry();
    expect(cubit.state, isA<StoryComposePublished>());
    expect(store.activeSegments(), hasLength(1));
    // Flatten happened once; retry reuses the cached bytes.
    expect(composer.flattenCalls, 1);
  });
}
