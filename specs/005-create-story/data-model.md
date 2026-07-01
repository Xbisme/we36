# Phase 1 Data Model — Create Story & Story Tools (#005)

Feature-first types for `lib/features/stories/` (compose) + shared story types in
`lib/core/data/stories/`. All state is freezed/immutable. No drift schema change (see plan §Storage).

---

## 1. Domain models (feature: `features/stories/domain/models/`)

### `StoryAudience` (enum)
```
enum StoryAudience { yourStory, closeFriends }   // default: yourStory (FR-006)
```
- Recorded on the published segment; drives the "Close friends" marker shown to the creator (AS-3.2).
- Publishing to `closeFriends` is allowed even with no close-friends list (FR-007).

### `StoryTextOverlay`
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | local uuid (list stability / removal) |
| `text` | `String` | ≤ ~100 chars, enforced by input formatter (FR-004, AS-2.6) |
| `styleId` | `String` | one of a small fixed token-driven style/color set |
| `dx`, `dy` | `double` | normalized 0..1 position within the 9:16 canvas |

### `StoryStickerOverlay`
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | local uuid |
| `assetKey` | `String` | key into the bundled fixed sticker set (`assets/stickers/…`) |
| `dx`, `dy` | `double` | normalized 0..1 position |

> No rotate/scale for MVP (R5). Overlays are baked at publish (R1) — never persisted as metadata.

### `StoryComposeDraft` (in-composer working state — transient, NOT persisted)
| Field | Type | Notes |
|---|---|---|
| `assetId` | `String` | selected photo (via `PhotoLibraryService`) |
| `textOverlays` | `List<StoryTextOverlay>` | |
| `stickerOverlays` | `List<StoryStickerOverlay>` | |
| `audience` | `StoryAudience` | default `yourStory` |
| `idempotencyKey` | `String` | uuid, generated once per compose session; reused on retry (FR-009) |

- Lives only while the composer is open; abandoning discards it after a confirm (FR-015). No drift row.

---

## 2. Shared story types (`core/data/stories/story.dart`) — extended

`StorySegment` (from #004) gains an optional audience marker so an own published segment can be shown
as close-friends to the creator; default keeps existing behavior:

```
@freezed
StorySegment {
  String id;
  String authorId;
  String imageUrl;      // own published (fake): a `memory://<id>` ref; the flattened JPEG bytes
                        //   live in OwnStoryStore and the story image rendering resolves memory://
                        //   via MemoryImage(OwnStoryStore.bytesFor) (network/asset still work) — U1/T020a
  int durationMs;       // 5000 for published photo stories (clarification Q2)
  int position;
  DateTime createdAt;   // drives 24h expiry (FR-013)
  bool viewerHasLiked;  // (default false)
  @Default(StoryAudience.yourStory) StoryAudience audience;   // NEW (optional; non-breaking)
}
```
`StoryReel` unchanged (own reel is the existing `isYou:'you'` entry).

---

## 3. Shared in-memory store (`core/data/stories/own_story_store.dart`) — NEW

`OwnStoryStore` (`@lazySingleton`) — the one canonical representation of the current user's own
published segments this session (Constitution IX). No drift.

| Member | Shape | Purpose |
|---|---|---|
| `add(StorySegment segment)` | `void` | append a published segment; emit change |
| `activeSegments({DateTime Function() now})` | `List<StorySegment>` | own segments with `createdAt > now-24h`, newest first (FR-013) |
| `changes` | `Stream<void>` / `Listenable` | notify `StoriesRailCubit` to re-read after publish (FR-011) |
| `clear()` | `void` | wiped on logout via `clearUserScoped()` (privacy) |

- `FakeStoriesRepository.loadReels()` merges `activeSegments()` into the `isYou` reel (prepended).
- `changes` reaches the rail via a `WatchOwnStoryChanges` use case; `StoriesRailCubit` re-runs `load()`
  on each emit so a newly published story repaints the rail with no manual refresh (FR-011, finding I1).
- Clock injected (`DateTime Function()`) so expiry is unit-testable (R4).

---

## 4. Presentation state (`features/stories/presentation/cubit/`)

### `StoryGalleryState` (reuse #007 gallery cubit if practical; else thin mirror)
`loading · loaded(assets, hasMore, permission) · loadedPaginating · error` — single-select for stories.

### `StoryComposeState` (freezed 4-state + extended variants)
| Variant | Fields | Meaning |
|---|---|---|
| `initial` | — | before a photo is chosen |
| `loaded` | `draft: StoryComposeDraft` | editing photo + overlays + audience; share enabled |
| `loadedUploading` | `draft`, `progress: double (0..1)` | publish in flight; cancel available (FR-008) |
| `error` | `failure: AppFailure` | publish/permission error surfaced via toast (FR-014) |

- Success is a one-shot side effect (toast + haptic + pop + rail repaint) via `BlocListener`, not a
  lingering state (Constitution III).
- `publish()` disabled while `loadedUploading` (no double-submit, FR-017).

---

## 5. Repositories & services

### `CreateStoryRepository` (feature `data/`) — backend seam
```
Future<Result<StorySegment>> publish({
  required Uint8List imageBytes,     // flattened 9:16 JPEG (from StoryImageComposer)
  required StoryAudience audience,
  required String idempotencyKey,
  UploadCancelToken? cancelToken,
  void Function(double progress)? onProgress,
});
```
- **Fake** (`env:['fake']`, runs): drives `MediaUploadService` (fake) progress → synthesizes a
  `StorySegment` (author = fake `Me`, `durationMs:5000`, `createdAt:now`, `audience`) → writes to
  `OwnStoryStore`. Returns the segment.
- **Real** (`env:['real']`, inert): documented `ApiClient` multipart seam; throws/returns
  `unsupported` until a backend stories contract exists (mirrors #002 scaffolds).

> Orchestration is by the `PublishStory` **use case** (flatten → upload → create), never repo→repo
> (Constitution XI). The repo owns upload+persist; the composer flatten is a separate service.

### `StoryImageComposer` (`core/services/story_image_composer.dart`) — NEW
```
Future<Result<Uint8List>> flatten({
  required GlobalKey boundaryKey,    // RepaintBoundary around the 9:16 canvas
  int targetWidth = 1080,            // → 1080x1920, deterministic (R1)
});
```
- `toImage(pixelRatio)` → PNG bytes → isolate re-encode/resize to JPEG via `image` (#007 pattern).
- Test stub returns fixed bytes synchronously (no real raster) for widget/cubit tests.

### Reused as-is (#007)
- `PhotoLibraryService` — permission, paged Recents, bounded thumbnails, `originBytes`, `openSettings`.
- `MediaUploadService` — `upload({bytes, idempotencyKey, cancelToken})` progress stream.

---

## 6. Validation & rules summary

| Rule | Source |
|---|---|
| Exactly one photo required before share enabled | FR-003 |
| Text overlay ≤ ~100 chars, blocked at limit | FR-004 / AS-2.6 |
| Export is 9:16, pixel-identical to preview | FR-005 / SC-002 |
| Audience default `yourStory`; `closeFriends` allowed w/o list | FR-006 / FR-007 |
| Idempotent create; retry ⇒ exactly one story | FR-009 / SC-004 |
| No partial/orphan story on cancel/fail | FR-010 / SC-005 |
| Prepend to own reel; rail repaints, no manual refresh | FR-011 / FR-012 / SC-003 |
| 24h expiry filter (own + future reels) | FR-013 / SC-006 |
| No persisted draft; discard-confirm on abandon | FR-015 |
| No media bytes/paths/PII in logs | FR-019 |
| `OwnStoryStore` cleared on logout | Constitution I/IX |
