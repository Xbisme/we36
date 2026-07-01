import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';

void main() {
  late AppDatabase db;
  late ComposeDraftStore store;

  ComposeCubit build() => ComposeCubit(
    PublishPost(
      FakePhotoLibraryService(),
      const ImageProcessingService(),
      FakeMediaUploadService()..stepDelay = Duration.zero,
      FakeCreatePostRepository(db),
    ),
    store,
    IdempotencyKeys(),
  );

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = ComposeDraftStore(db);
  });
  tearDown(() => db.close());

  test('a mutation persists a draft that a fresh cubit can restore', () async {
    final first = build();
    await first.startFromAssets(['fake-asset-0', 'fake-asset-1']);
    first.setCaption('draft caption');
    await first.close();

    // A brand-new cubit (app relaunch) restores the persisted draft.
    final second = build();
    expect(await second.hasStoredDraft(), isTrue);
    final restored = await second.tryRestore();
    expect(restored, isTrue);
    expect(second.state, isA<ComposeLoaded>());
    expect(second.state.draftOrNull!.caption, 'draft caption');
    expect(second.state.draftOrNull!.items, hasLength(2));
    await second.close();
  });

  test('discard clears the persisted draft', () async {
    final cubit = build();
    await cubit.startFromAssets(['fake-asset-0']);
    expect(await store.read(), isNotNull);

    await cubit.discard();
    expect(cubit.state, isA<ComposeInitial>());
    expect(await store.read(), isNull);
    await cubit.close();
  });

  test(
    'restore drops items whose device asset is gone, re-packing order',
    () async {
      final first = build();
      await first.startFromAssets(['gone', 'fake-asset-1', 'also-gone']);
      await first.close();

      final second = build();
      final restored = await second.tryRestore(
        assetStillExists: (id) async => id == 'fake-asset-1',
      );
      expect(restored, isTrue);
      final items = second.state.draftOrNull!.items;
      expect(items, hasLength(1));
      expect(items.first.assetId, 'fake-asset-1');
      expect(items.first.order, 0); // re-packed
      await second.close();
    },
  );

  test('metadata set on the draft is carried into the created post', () async {
    final cubit = build();
    await cubit.startFromAssets(['fake-asset-0']);
    cubit
      ..toggleComments(disabled: true)
      ..setLocation(const PlaceRef(label: 'Da Nang'));

    await cubit.publish();

    expect(cubit.state, isA<ComposePublished>());
    final post = (cubit.state as ComposePublished).post;
    expect(post.commentsDisabled, isTrue);
    expect(post.location?.name, 'Da Nang');
    await cubit.close();
  });
}
