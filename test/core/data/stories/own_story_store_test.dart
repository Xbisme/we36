import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/story.dart';

StorySegment _segment(String id, {DateTime? createdAt}) => StorySegment(
  id: id,
  authorId: 'me',
  imageUrl: 'file:///tmp/$id.jpg',
  durationMs: 5000,
  position: 0,
  createdAt: createdAt ?? DateTime.utc(2026, 7, 1, 12),
);

void main() {
  group('OwnStoryStore', () {
    test('add exposes the segment via activeSegments (newest first)', () {
      final store = OwnStoryStore(clock: () => DateTime.utc(2026, 7, 1, 12))
        ..add(_segment('a', createdAt: DateTime.utc(2026, 7, 1, 10)))
        ..add(_segment('b', createdAt: DateTime.utc(2026, 7, 1, 11)));

      final active = store.activeSegments();
      expect(active.map((s) => s.id), ['b', 'a']); // newest first
      expect(store.hasActive, isTrue);
    });

    test('clear empties the store', () {
      final store = OwnStoryStore(clock: () => DateTime.utc(2026, 7, 1, 12))
        ..add(_segment('a'));
      expect(store.activeSegments(), isNotEmpty);

      store.clear();
      expect(store.activeSegments(), isEmpty);
      expect(store.hasActive, isFalse);
    });

    test('changes emits on add and clear', () async {
      final store = OwnStoryStore(clock: () => DateTime.utc(2026, 7, 1, 12));
      final events = <void>[];
      final sub = store.changes.listen(events.add);

      store.add(_segment('a'));
      await Future<void>.delayed(Duration.zero);
      expect(events, hasLength(1));

      store.clear();
      await Future<void>.delayed(Duration.zero);
      expect(events, hasLength(2));

      await sub.cancel();
    });
  });
}
