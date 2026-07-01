import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';
import 'package:we36/features/compose/domain/models/selected_media_item.dart';

void main() {
  late AppDatabase db;
  late ComposeDraftStore store;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = ComposeDraftStore(db);
  });
  tearDown(() => db.close());

  ComposeDraft draft() => ComposeDraft(
    id: 'draft-1',
    idempotencyKey: 'key-1',
    createdAt: DateTime.utc(2026, 7, 1, 12),
    items: const [
      SelectedMediaItem(
        assetId: 'a',
        order: 0,
        edit: MediaEditState(filter: FilterPreset.lux, brightness: 0.3),
      ),
      SelectedMediaItem(assetId: 'b', order: 1),
    ],
    caption: 'hello #we36',
    metadata: const PostMetadata(
      commentsDisabled: true,
      location: PlaceRef(label: 'Da Nang'),
      taggedUserIds: ['u1', 'u2'],
    ),
  );

  test(
    'save → read round-trips the full draft (items, edits, metadata)',
    () async {
      await store.save(draft());
      final restored = await store.read();

      expect(restored, isNotNull);
      expect(restored!.id, 'draft-1');
      expect(restored.idempotencyKey, 'key-1');
      expect(restored.caption, 'hello #we36');
      expect(restored.items, hasLength(2));
      expect(restored.items.first.edit.filter, FilterPreset.lux);
      expect(restored.items.first.edit.brightness, 0.3);
      expect(restored.metadata.commentsDisabled, isTrue);
      expect(restored.metadata.location?.label, 'Da Nang');
      expect(restored.metadata.taggedUserIds, ['u1', 'u2']);
    },
  );

  test('save replaces the single draft (no accumulation)', () async {
    await store.save(draft());
    await store.save(draft().copyWith(caption: 'updated'));
    final restored = await store.read();
    expect(restored!.caption, 'updated');
  });

  test('clear removes the draft', () async {
    await store.save(draft());
    await store.clear();
    expect(await store.read(), isNull);
  });

  test(
    'clearUserScoped wipes the draft on logout (Constitution I/IX)',
    () async {
      await store.save(draft());
      await db.clearUserScoped();
      expect(await store.read(), isNull);
    },
  );
}
