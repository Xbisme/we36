# Phase 1 Data Model: Home Feed & Stories

Field names are **camelCase** matching the backend JSON (B#004 posts-feed contract). Ids are
string UUIDv7. Timestamps are ISO-8601 UTC → `DateTime` (UTC). All models are `@freezed` with
generated JSON. No business logic on models.

---

## Domain models — Feed (`core/data/feed/`)

### Post  (`core/data/feed/post.dart`)

Canonical feed item + the viewer's own engagement state. Mirrors backend `Post`.

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID, PK / dedupe key |
| `author` | `UserSummary` | compact author projection |
| `caption` | `String?` | ≤2200; hashtags/mentions parsed server-side |
| `media` | `List<PostMedia>` | ordered carousel; **#004 renders `media[0]` only** |
| `location` | `Place?` | nullable (not surfaced in #004 card beyond label) |
| `hashtags` | `List<String>` | normalized tags |
| `taggedUsers` | `List<UserSummary>` | may be empty |
| `commentsDisabled` | `bool` | honored later (#006) |
| `likeCount` | `int` | ≥0 |
| `saveCount` | `int` | ≥0 |
| `commentCount` | `int` | ≥0 (shown as "View all N comments" text; entry deferred #006) |
| `viewerHasLiked` | `bool` | drives filled like state |
| `viewerHasSaved` | `bool` | drives filled save state |
| `createdAt` | `DateTime` | UTC; feed order key (DESC) |

### UserSummary  (`core/data/feed/post.dart`)

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID |
| `username` | `String?` | nullable per contract |
| `displayName` | `String?` | nullable |
| `avatarUrl` | `String?` | thumb variant delivery URL |
| `isVerified` | `bool` | badge |

### PostMedia / Media  (`core/data/feed/post.dart`)

`PostMedia { int position; Media media; }` — one ordered carousel item.

`Media { String id; MediaKind kind; MediaStatus status; int? width; int? height; int? durationMs;
Map<String,dynamic>? variants; }` where `MediaKind = { image, video }`,
`MediaStatus = { pending, processing, ready, failed }`. `variants` holds delivery renditions
(thumb/display) when `ready`. #004 uses the display/thumb image variant of `media[0]`; a not-yet
`ready` item renders a placeholder (progressive).

### EngagementState  (`core/data/feed/post.dart`)

Returned by like/unlike/save/unsave so the client reconciles optimistic UI. Mirrors backend.

| Field | Type |
|---|---|
| `postId` | `String` |
| `likeCount` | `int` |
| `saveCount` | `int` |
| `viewerHasLiked` | `bool` |
| `viewerHasSaved` | `bool` |

`Place { String id; String name; double? lat; double? lng; String? externalId; }` (minimal;
label only in #004).

---

## Domain models — Stories (`core/data/stories/`)

Client-defined (no backend contract). Synthesized by the fake; deterministic per launch.

### StoryReel  (`core/data/stories/story.dart`)

One account's set of active story segments.

| Field | Type | Notes |
|---|---|---|
| `authorId` | `String` | UUID |
| `username` | `String` | display handle |
| `avatarUrl` | `String?` | ring center |
| `isYou` | `bool` | the current user's own reel ("Your story") |
| `segments` | `List<StorySegment>` | ordered, ≥1 |
| `hasUnseen` | `bool` | derived: any segment not in seen-set (drives ring: unseen vs seen) |
| `latestAt` | `DateTime` | newest segment time; rail ordering within unseen/seen groups |

### StorySegment  (`core/data/stories/story.dart`)

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID; seen-state key |
| `authorId` | `String` | parent reel |
| `imageUrl` | `String` | image segment (no video in #004) |
| `durationMs` | `int` | display duration (default 5000) |
| `createdAt` | `DateTime` | relative-time label |
| `viewerHasLiked` | `bool` | in-memory (fake); story-like optimistic |
| `position` | `int` | 0-based order in the reel |

Rail ordering: unseen reels first (by `latestAt` desc), then seen reels; the `isYou` "Your story"
entry always leads (FR-017). `hasUnseen` is computed by merging reels with the persisted seen-set.

---

## drift cache (schema v2 → **v3**)

### Posts table  (`core/data/cache/tables/posts_table.dart`)

Canonical cached post. `@DataClassName('CachedPost')`, PK `id`. Nested media flattened to the
first image (contract array is not stored column-wise in #004; carousel storage arrives with #007).

| Column | Type | Null | Notes |
|---|---|---|---|
| `id` | text | no | PK |
| `authorId` | text | no | |
| `authorUsername` | text | yes | |
| `authorDisplayName` | text | yes | |
| `authorAvatarUrl` | text | yes | |
| `authorIsVerified` | bool | no | |
| `caption` | text | yes | |
| `mediaImageUrl` | text | yes | `media[0]` display URL (null while processing) |
| `mediaWidth` | int | yes | for `cacheWidth` sizing |
| `mediaHeight` | int | yes | |
| `locationName` | text | yes | |
| `likeCount` | int | no | |
| `saveCount` | int | no | |
| `commentCount` | int | no | |
| `viewerHasLiked` | bool | no | |
| `viewerHasSaved` | bool | no | |
| `commentsDisabled` | bool | no | |
| `createdAt` | dateTime | no | feed order (DESC) |
| `cachedAt` | dateTime | no | staleness marker |

**PostsDao** (`core/data/cache/daos/posts_dao.dart`):
- `Future<void> upsertAll(List<Post>)` — insertOnConflictUpdate (dedupe by id).
- `Stream<List<Post>> watchHomeFeed({int limit})` — reactive, `ORDER BY createdAt DESC`.
- `Future<Post?> getById(String id)`.
- `Future<void> applyEngagement(EngagementState)` — updates counts + viewer flags for one post.
- `Future<void> clearFeed()` — used by `refresh()` before repopulating from page 1.

### StorySeenSegments table  (`core/data/cache/tables/story_seen_table.dart`)

Persisted seen-state (only). `@DataClassName('SeenSegment')`, PK `segmentId`.

| Column | Type | Null |
|---|---|---|
| `segmentId` | text | no |
| `authorId` | text | no |
| `seenAt` | dateTime | no |

**StorySeenDao** (`core/data/cache/daos/story_seen_dao.dart`):
- `Future<void> markSeen(String segmentId, String authorId)`.
- `Stream<Set<String>> watchSeen()` — reactive set of seen segment ids (rail ring recompute).
- `Future<Set<String>> getSeen()`.

### AppDatabase changes  (`core/data/cache/app_database.dart`)

- Register `Posts` + `PostsDao`, `StorySeenSegments` + `StorySeenDao`.
- `schemaVersion` 2 → **3**; `onUpgrade`: `if (from < 3) { m.createTable(posts);
  m.createTable(storySeenSegments); }` (keep the existing `from < 2` branch).
- `clearUserScoped()` extended: also `delete(posts)` + `delete(storySeenSegments)` (feed + seen are
  user-scoped; wiped on logout/forced-logout — Constitution I).
- Migration test: v1→v2 (existing) **and** v2→v3 (new) — Constitution IX.

---

## Repository interfaces

### FeedRepository  (`core/data/feed/feed_repository.dart`)

```
Stream<List<Post>> watchHomeFeed();                          // reactive canonical read (drift)
Future<Result<CursorPage<Post>>> loadFirstPage();            // GET /feed → upsertAll (after clearFeed)
Future<Result<CursorPage<Post>>> loadNextPage(String cursor);// GET /feed?cursor → upsertAll (append)
Future<Result<EngagementState>> toggleLike(String postId, {required bool like});   // POST|DELETE /posts/{id}/like
Future<Result<EngagementState>> toggleSave(String postId, {required bool save});   // POST|DELETE /posts/{id}/save
```

**Real impl** (`env:['real']`): `feed_remote_data_source` marshals `ApiClient` calls (idempotent
like/save), maps DTO→`Post`, upserts drift, returns `Result`. Reconcile applies `EngagementState`
to the cached post.
**Fake impl** (`env:['fake']`, runs): holds a deterministic list of ~30 synthesized posts
(single-image, contract-shaped) in memory + writes them to drift for the reactive read; `toggleLike/
Save` mutate the in-memory + drift copy and echo an `EngagementState`; supports an injectable
"fail next mutation" hook for rollback tests.

### StoriesRepository  (`core/data/stories/stories_repository.dart`)

```
Future<Result<List<StoryReel>>> loadReels();                 // synthesized (fake) / provisional (real)
Stream<Set<String>> watchSeen();                             // drift-backed seen ids
Future<Result<void>> markSegmentSeen(String segmentId, String authorId);   // persist seen
Future<Result<void>> likeSegment(String segmentId, {required bool like});  // fake in-memory (#004)
```

**Fake impl** (`env:['fake']`, runs): deterministic reels for followed accounts + a "Your story"
entry (present iff the fake seeds a self-reel); merges `watchSeen()` to compute `hasUnseen`;
`likeSegment` toggles in-memory.
**Real impl** (`env:['real']` seam): provisional — `loadReels`/`likeSegment` return
`Result.err(offline)` / empty and `markSegmentSeen` persists locally, pending a backend stories
spec (documented follow-up; never hit while app runs `fake`).

---

## State shapes (cubits)

Screen cubits extend `AppCubit<T>` (4-state; extended variants prefix the base name).

### FeedCubit  (`features/feed/presentation/feed_cubit.dart`) — `T = List<Post>`

Drift-reactive list + cursor controller.

```
subscribes: FeedRepository.watchHomeFeed()  → drives loaded(data: posts)
internal:   String? nextCursor; bool hasMore; bool _loadingMore
states:     initial → loading (first cold load, empty cache)
            loaded(List<Post>)                       // from the watch stream
            loadedPaginating(List<Post>)             // loadMore in flight (retain items)
            loadedRefreshing(List<Post>)             // pull-to-refresh in flight (retain items)
            error(AppFailure)                        // only when no cache to show
methods:    loadInitial()  // seed from cache instantly; background loadFirstPage() reconcile
            loadMore()      // guard on hasMore && !_loadingMore; loadNextPage(cursor)
            refresh()       // clearFeed + loadFirstPage; soft-fail keeps cache
            toggleLike(postId) / toggleSave(postId)  // optimistic: drift write → server → reconcile/rollback+Toast
```

Malformed item → skipped at DTO decode (soft), never emits `error` for one bad post (FR-006).

### StoriesRailCubit  (`features/stories/presentation/stories_rail_cubit.dart`) — `T = List<StoryReel>`

```
combines: loadReels() + watchSeen() → reels with hasUnseen; ordered (isYou, then unseen desc, then seen)
states:   initial → loading → loaded(List<StoryReel>) → error(AppFailure)
```

### StoryViewerCubit  (`features/stories/presentation/story_viewer_cubit.dart`)

Playback state (not the generic list shape).

```
state: loaded({ reels, reelIndex, segmentIndex, progress(0..1), paused })
timer: advances progress; on complete → next segment/reel or close
methods: openAt(reelIndex) · next() · previous() · pauseHold() · resumeRelease()
         likeCurrent()   // optimistic via StoriesRepository.likeSegment
         onSegmentShown(segmentId) → markSegmentSeen (persist) → rail ring updates via watchSeen()
reduceMotion: true → keep progress/advance, drop decorative transitions (FR-033)
```

---

## State transitions

**Feed**

```
open Home → FeedCubit.loadInitial:
  cache non-empty → loaded(cachedPosts) immediately (SC-001)     [+ background loadFirstPage reconcile]
  cache empty     → loading → loadFirstPage → loaded / error(retry)
scroll near end (hasMore) → loadedPaginating → loadNextPage(cursor) → append (soft-fail keeps items)
pull-to-refresh          → loadedRefreshing → clearFeed + loadFirstPage → loaded (new top)
like/save tap → optimistic drift write (instant) → server:
  ok   → applyEngagement(EngagementState) (adopt server counts)
  err  → re-upsert prior Post + Toast (rollback)                 // idempotent retry safe
```

**Stories**

```
open Home → StoriesRailCubit.loaded(reels)   // isYou first; unseen ringed; seen desaturated
tap reel → push StoryViewer(reelIndex):
  segment auto-advances (durationMs) → onSegmentShown → markSeen (persist)
  tap right → next · tap left → previous · hold → pause · release → resume
  like → optimistic segment like
  last segment of last reel → close
close → rail ring recomputes from watchSeen() (seen persists across restart, FR-027)
"Your story" tap → open own reel if isYou reel exists; else inert (no create in #004, FR-017)
expired/removed segment between rail render and open → skip/close with soft message (FR-028)
```
