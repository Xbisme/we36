# Contract — OwnStoryStore (core in-memory store)

`lib/core/data/stories/own_story_store.dart`

The one canonical representation of the current user's own published story segments **this session**
(Constitution IX). Bridges the write path (`CreateStoryRepository` fake) and the #004 read path
(`FakeStoriesRepository`) without a repo→repo dependency and without a drift schema change (research
R3). Session-scoped: not persisted across app-kill (acceptable with no backend; revisit when a backend
stories contract lands).

## Interface

```dart
@lazySingleton
class OwnStoryStore {
  OwnStoryStore({ DateTime Function()? clock });   // injectable clock for expiry tests

  /// Append a freshly published segment (newest last); notifies [changes].
  void add(StorySegment segment);

  /// Own segments still active (createdAt > now - 24h), newest first (FR-013).
  List<StorySegment> activeSegments();

  /// Fires after add()/clear() so StoriesRailCubit re-reads and the rail repaints (FR-011).
  Stream<void> get changes;         // or a Listenable

  /// Wipe on logout (privacy) — called from clearUserScoped().
  void clear();
}
```

## Behavior
- `activeSegments()` applies the 24h filter using the injected clock — the single source of the expiry
  rule (also usable by future fetched reels).
- `FakeStoriesRepository.loadReels()` prepends `activeSegments()` into the `isYou:'you'` reel and
  recomputes `hasUnseen`/`latestAt`.
- `changes` is consumed by the rail via a `WatchOwnStoryChanges` use case → `StoriesRailCubit` re-runs
  `load()`, so a publish repaints the rail with no manual refresh (FR-011).
- Idempotency is enforced upstream (by `CreateStoryRepository` keyed on `idempotencyKey`); the store
  itself just holds segments.

## Test coverage
- `add` then `activeSegments` returns it; a segment with `createdAt` 25h ago (via clock) is excluded
  (FR-013 / SC-006); `clear()` empties; `changes` emits on add.
