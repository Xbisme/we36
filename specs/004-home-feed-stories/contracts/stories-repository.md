# Contract: StoriesRepository

**No backend contract exists yet** (backend has auth/posts/media/comments only). Stories are
client-defined and **fake-driven** in #004; a real seam is registered for DI-graph completeness and
awaits a future backend stories spec.

## Interface (`core/data/stories/stories_repository.dart`)

```dart
abstract interface class StoriesRepository {
  Future<Result<List<StoryReel>>> loadReels();                             // synthesized (fake)
  Stream<Set<String>> watchSeen();                                          // drift-backed seen ids
  Future<Result<void>> markSegmentSeen(String segmentId, String authorId);  // persist seen (drift)
  Future<Result<void>> likeSegment(String segmentId, {required bool like}); // in-memory (fake) in #004
}
```

## Models

`StoryReel { authorId, username, avatarUrl?, isYou, segments[], hasUnseen, latestAt }`,
`StorySegment { id, authorId, imageUrl, durationMs, createdAt, viewerHasLiked, position }` — see
[data-model.md](../data-model.md). Image segments only (no video in #004).

## Rail ordering & ring

- Order: `isYou` ("Your story") first → unseen reels (`latestAt` desc) → seen reels.
- `hasUnseen` = reel has ≥1 segment id ∉ `watchSeen()` set → `Avatar(ring: unseen)` (brand
  gradient); else `Avatar(ring: seen)` (desaturated). "Your story" with no self-reel = inert entry,
  no create action (FR-017).

## Seen persistence

`markSegmentSeen` → `StorySeenDao.markSeen` (drift `StorySeenSegments`). Seen survives relaunch
(FR-027); reels are re-synthesized deterministically each launch, only seen-state persists.

## Fake vs real

| | `env:['fake']` (runs) | `env:['real']` (seam) |
|---|---|---|
| `loadReels` | deterministic reels for followed accounts + optional self-reel | provisional → `Result.err(offline)` / empty |
| `watchSeen` | drift `watchSeen()` | drift `watchSeen()` (same) |
| `markSegmentSeen` | drift persist | drift persist |
| `likeSegment` | in-memory toggle | provisional no-op |

The real impl is a **documented follow-up** (targets a future backend stories endpoint); never
exercised while the app runs `fake`.
