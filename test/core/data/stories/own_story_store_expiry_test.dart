import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/story.dart';

StorySegment _segment(String id, DateTime createdAt) => StorySegment(
  id: id,
  authorId: 'me',
  imageUrl: 'memory://$id',
  durationMs: 5000,
  position: 0,
  createdAt: createdAt,
);

/// US5 — a story expires 24h after creation; expiry is a read-time filter using
/// the injected clock (FR-013 / SC-006).
void main() {
  final now = DateTime.utc(2026, 7, 2, 12);
  OwnStoryStore storeAt(DateTime clock) => OwnStoryStore(clock: () => clock);

  test('segments < 24h old are active, > 24h old are excluded', () {
    final store = storeAt(now)
      ..add(_segment('recent', now.subtract(const Duration(hours: 1))))
      ..add(_segment('old', now.subtract(const Duration(hours: 25))));

    expect(store.activeSegments().map((s) => s.id), ['recent']);
  });

  test('when every own segment has expired, none are active (no ring)', () {
    final store = storeAt(now)
      ..add(_segment('old', now.subtract(const Duration(hours: 25))));

    expect(store.activeSegments(), isEmpty);
    expect(store.hasActive, isFalse);
  });

  test('a segment exactly at the 24h boundary is expired', () {
    final store = storeAt(now)
      ..add(_segment('edge', now.subtract(const Duration(hours: 24))));

    expect(store.activeSegments(), isEmpty);
  });
}
