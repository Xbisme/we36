import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/features/stories/data/create_story_repository_fake.dart';
import 'package:we36/features/stories/domain/usecases/publish_story.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_state.dart';

import '../../support/fake_story_image_composer.dart';

/// US3 — audience: the toggle records the choice on the published segment;
/// "Close friends" publishes even with no close-friends list (FR-006/FR-007).
void main() {
  late AppDatabase db;
  late OwnStoryStore store;
  late StoryComposeCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = OwnStoryStore();
    final repo = FakeCreateStoryRepository(
      FakeMediaUploadService()..stepDelay = Duration.zero,
      db,
      store,
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

  test('default audience is Your story', () {
    expect(cubit.state.draftOrNull!.audience, StoryAudience.yourStory);
  });

  test('publishing to Close friends records it on the segment', () async {
    cubit.setAudience(StoryAudience.closeFriends);
    expect(cubit.state.draftOrNull!.audience, StoryAudience.closeFriends);

    await cubit.publish(boundaryKey: GlobalKey());
    expect(cubit.state, isA<StoryComposePublished>());
    // Published with no close-friends list configured — still succeeds.
    expect(store.activeSegments().single.audience, StoryAudience.closeFriends);
  });
}
