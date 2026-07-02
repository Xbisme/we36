# Phase 1 Data Model: Reels (#008)

Client-side models + cache. Reuses shared types from `lib/core/data/feed/post.dart` (`UserSummary`, `Media`, `Place`, `EngagementState`) — core→core import, no feature coupling. All models `@freezed` + generated JSON (Constitution IV).

## Domain models (`lib/core/data/reels/`)

### Reel (`reel.dart`)
Mirrors `Post` but carries a **single video** (not a carousel) + `isVideoReady`. Maps from B#007 `ReelDto`.

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUIDv7 |
| `author` | `UserSummary` | reused from feed |
| `caption` | `String?` | may contain @mentions / #hashtags (styled, non-tappable) |
| `video` | `Media` | reused `Media` (kind=video, status, `durationMs`, `variants{renditions, poster, thumbnail}`) |
| `location` | `Place?` | reused |
| `hashtags` | `List<String>` | parsed from caption (server) |
| `taggedUsers` | `List<UserSummary>` | |
| `commentsDisabled` | `bool` | |
| `likeCount` | `int` | ≥ 0 |
| `saveCount` | `int` | ≥ 0 |
| `commentCount` | `int` | ≥ 0; canonical count owned here (see comment seam) |
| `viewerHasLiked` | `bool` | |
| `viewerHasSaved` | `bool` | |
| `isVideoReady` | `bool` | `true` ⇒ playable/feed-eligible; `false` ⇒ processing |
| `createdAt` | `DateTime` | reverse-chron ordering key |

Derived (not stored): `posterUrl => video.variants.poster`, `videoUrl => video.variants.renditions.first`, `isProcessing => !isVideoReady`.

### Reuse (no new model)
- `EngagementState` — returned by like/save toggles (postId/likeCount/saveCount/viewerHasLiked/viewerHasSaved). Reused verbatim.
- `CursorPage<Reel>` / `PageRequest` — the #002 envelope for the feed.
- `Comment` / `CommentEngagement` — #006, reused unchanged for reel comments.

### ReelDraft (`lib/features/reels/domain/reel_draft.dart`)
In-progress create (mirrors `ComposeDraft`, single video, no editing).

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUIDv7 |
| `idempotencyKey` | `String` | UUIDv7, **stable across retries** (FR-020) |
| `videoAssetId` | `String` | picked `AssetRef` id |
| `videoDurationMs` | `int` | validated ≤ 90_000 (FR-017) |
| `posterThumb` | (bounded `ImageProvider` / bytes) | preview + optimistic-card poster |
| `caption` | `String?` | |
| `metadata` | `PostMetadata` | reused: `commentsDisabled`, `location`, `taggedUserIds` |

> **Not persisted to drift** in MVP (unlike #007's `ComposeDraft`): a single-video reel draft is short-lived; the discard-confirm (FR-022) covers accidental exit. (If cross-kill restore is later wanted, add a `ReelDrafts` table — deferred, YAGNI.)

## Cache (drift) — schema v4 → v5

### `Reels` table (`lib/core/data/cache/tables` + `daos/reels_dao.dart`)
Mirrors the `Posts` table mapping (flatten to a row; single video URL + poster + dims cached, not the full variants map).

Columns: `id` (PK), `authorJson` (UserSummary), `caption?`, `videoUrl?`, `posterUrl?`, `thumbnailUrl?`, `width?`, `height?`, `durationMs?`, `mediaStatus`, `isVideoReady` (bool), `locationJson?`, `hashtagsJson`, `taggedUsersJson`, `commentsDisabled`, `likeCount`, `saveCount`, `commentCount`, `viewerHasLiked`, `viewerHasSaved`, `createdAt` (indexed desc for feed order).

### `ReelsDao` methods (mirror `PostsDao`)
- `watchReelsFeed({int limit})` → `Stream<List<Reel>>` — reverse-chron; single render source.
- `watchReel(String id)` → `Stream<Reel?>` — reactive single-reel read (comments count, ready flip).
- `upsertAll(List<Reel>)` / `upsert(Reel)` — page write / optimistic insert (top for a new reel).
- `clearFeed()` — pull-to-refresh reset (so removed reels drop).
- `applyEngagement(EngagementState)` — reconcile server like/save counts + flags.
- `adjustCommentCount(String id, int delta)` — clamped; used by the comment seam.
- `getById(String id)` → `Reel?`.

### Migration & lifecycle
- `AppDatabase.schemaVersion` 4 → **5**; `onUpgrade` adds `Reels` (non-destructive).
- `clearUserScoped()` extended to `delete(reels)` on logout (Constitution IX).
- Migration test covers v4→v5 (Constitution IX: every prior version).

## State transitions

### Reel readiness
```
(create) POST /reels → Reel{isVideoReady:false}  ── optimistic insert at feed top (processing badge)
        │  reconcile (re-fetch reel / next feed refresh; fake: simulated delay)
        ▼
Reel{isVideoReady:true} ── playable; playback controller may initialize it
```
Playback controller **skips** any reel with `isVideoReady=false` (shows poster + badge, no `VideoPlayerController`).

### Engagement (optimistic, target-state, last-intent — reuse #004 pattern)
```
tap like → write optimistic Reel{viewerHasLiked:target, likeCount±1} to ReelsDao (stream repaints)
         → ReelsRepository.toggleLike(id, like: target) → EngagementState
         → applyEngagement(reconcile)  |  on failure: revert to prior snapshot + Toast
```
Idempotent: repeated taps resolve to last intent; server edge is unique per (user, reel) (backend B#007).

### Comment count (canonical seam — generalizes #006 F1)
```
AddComment/DeleteComment use case (target = reel)
   → CommentsRepository.add/delete (fake target-agnostic by id)
   → ReelsRepository.applyCommentCountDelta(reelId, ±n)  → ReelsDao.adjustCommentCount
```
`CommentsRepository` never touches the reel cache directly (parity with #006: repo doesn't own the count).

## Validation rules (from spec)
- Create: exactly one video; `video.kind == video`; `videoDurationMs ≤ 90_000` else reject with a clear message (FR-017); file-size cap aligned with the upload pipeline (plan-time constant).
- Feed render: only `isVideoReady == true` reels play; the viewer's own just-published processing reel may appear (FR-006/FR-021).
- Malformed reel item in a page → skipped (`CursorPage.fromJson` already skips; Constitution IX), never crashes the feed.

## Key entities → requirements traceability
| Entity | Requirements |
|---|---|
| `Reel` | FR-001..010, FR-014, FR-024 |
| `EngagementState` | FR-011..014 |
| `ReelDraft` | FR-017..023 |
| `Reels` table / `ReelsDao` | FR-004, FR-007, FR-014, FR-021, FR-023 |
| `Comment` (reused) | FR-015 |
