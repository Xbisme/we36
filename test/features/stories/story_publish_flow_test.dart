import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/fake_stories_repository.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/stories/data/create_story_repository_fake.dart';
import 'package:we36/features/stories/domain/usecases/publish_story.dart';
import 'package:we36/features/stories/domain/usecases/story_usecases.dart';
import 'package:we36/features/stories/domain/usecases/watch_own_story_changes.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

import '../../support/fake_story_image_composer.dart';

/// US1 — the pick → Share flow: selecting a photo and publishing puts a new
/// segment at the head of the "Your story" reel with no manual refresh (FR-011).
Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
  late AppDatabase db;
  late OwnStoryStore store;
  late StoryGalleryCubit gallery;
  late StoryComposeCubit compose;
  late StoriesRailCubit rail;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = OwnStoryStore();
    gallery = StoryGalleryCubit(FakePhotoLibraryService());
    final upload = FakeMediaUploadService()..stepDelay = Duration.zero;
    final repo = FakeCreateStoryRepository(upload, db, store);
    compose = StoryComposeCubit(
      PublishStory(repo),
      FakeStoryImageComposer(),
      IdempotencyKeys(),
    );
    final storiesRepo = FakeStoriesRepository(db, store);
    rail = StoriesRailCubit(
      LoadStoryReels(storiesRepo),
      WatchSeenSegments(storiesRepo),
      WatchOwnStoryChanges(store),
    );
  });
  tearDown(() async {
    await gallery.close();
    await compose.close();
    await rail.close();
    await db.close();
  });

  test('pick a photo, publish, and the rail repaints with the new story', () async {
    await rail.load();
    final youBefore = rail.state.dataOrNull!.firstWhere((r) => r.isYou);

    // Pick one photo, then start + publish the compose flow.
    await gallery.loadInitial();
    gallery.select('fake-asset-0');
    expect(gallery.state.selectedId, 'fake-asset-0');

    compose.startFromAsset(gallery.state.selectedId!);
    await compose.publish(boundaryKey: GlobalKey());
    await _settle(); // OwnStoryStore.changes → rail re-reads (no manual refresh)

    final youAfter = rail.state.dataOrNull!.firstWhere((r) => r.isYou);
    expect(youAfter.segments.length, youBefore.segments.length + 1);
    expect(youAfter.hasUnseen, isTrue);
    expect(store.activeSegments(), hasLength(1));
  });
}
