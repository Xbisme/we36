# Phase 0 Research — Create Story & Story Tools (#005)

All decisions are fake-first and reuse the #002/#004/#007 spine. No backend stories contract exists;
this feature builds the client + a documented (inert) real seam. Package versions referenced from
pub.dev as of 2026-07-01.

---

## R1 — Overlay flatten strategy (preview == export)

**Decision**: Flatten the composed 9:16 canvas with Flutter's built-in
`RepaintBoundary` → `RenderRepaintBoundary.toImage(pixelRatio:)` → `dart:ui` PNG bytes, then
re-encode/compress to JPEG on a background isolate using the existing `image` package. The captured
bytes are the exact pixels the user arranged (photo + text + stickers), so the published story is
guaranteed pixel-identical to the preview (FR-005, SC-002).

**Rationale**: The overlays are arbitrary positioned widgets (styled text, sticker images). Redrawing
them programmatically with the `image` package would risk font/metrics drift and re-implement layout.
Capturing the actual render tree is the canonical Flutter WYSIWYG approach and needs no new dependency.
`#007` guaranteed preview==export for *filters* by sharing one color matrix; for *free-form overlays*
a render capture is the equivalent guarantee.

**Alternatives considered**:
- *Programmatic compositing via `image`* (draw text/stickers onto decoded pixels) — rejected: font
  rendering/positioning won't match Flutter's text layout; high complexity.
- *Store overlays as metadata, render in viewer* — rejected by spec clarification (baked only; no
  viewer overlay rendering, no editable metadata).

**Notes / risks**: capture the boundary at a fixed target pixel size (e.g. 1080×1920) via `pixelRatio`
so output is deterministic regardless of device DPR (keeps goldens/tests stable and bounds memory).
`toImage` runs on the UI isolate (fast raster copy); the heavier JPEG encode/resize runs off-main via
`image` (reuse the #007 isolate pattern). Fallback if encode is slow on mid-range devices: adopt
`flutter_image_compress` (documented, not added now).

## R2 — Story canvas & aspect ratio (9:16)

**Decision**: Composer canvas and exported image are **9:16 portrait** (target 1080×1920). A picked
photo is fit/cropped to 9:16 (cover-fit with the safe area respected); overlays are positioned within
the 9:16 canvas.

**Rationale**: Clarification Q1 (9:16 full-bleed). Matches the #004 story viewer, which already renders
full-bleed portrait, and the fake seed images already use `720/1280` (9:16). Distinct from #007's 4:5
Create-Post crop, so the story flow does **not** reuse `crop_your_image`'s 4:5 config — a simple
cover-fit into the 9:16 canvas is sufficient (no free crop UI required for MVP).

**Alternatives considered**: reuse #007 4:5 crop — rejected by clarification (not full-bleed).

## R3 — Own-story persistence & how a published story reaches the rail

**Decision**: Introduce a shared in-memory **`OwnStoryStore`** (`@lazySingleton`) holding the current
user's published segments for the session. `FakeStoriesRepository.loadReels()` merges `OwnStoryStore`
segments into the `isYou:'you'` reel (prepended, newest first, expired filtered). `PublishStory` writes
the new segment into `OwnStoryStore`. **No drift schema bump.**

**Rationale**: #004 already re-synthesizes reels each launch and persists only seen-state; own stories
being session-scoped is consistent and honors YAGNI (Constitution XIII). A shared singleton is the
minimal way for the write path and the #004 read path to agree on one canonical own-reel
representation (Constitution IX) without a new table or a repo→repo dependency.

**Alternatives considered**:
- *Persist own stories to a new drift table (schema v4→v5)* — rejected for MVP: adds migration +
  test surface for behavior a real backend will own; session-scope is acceptable with no backend.
  Revisit when the backend stories contract lands.
- *Have the create repo call the stories repo* — rejected (repo→repo forbidden). The use case
  orchestrates; both repos touch the shared `OwnStoryStore`.

**Notes**: `OwnStoryStore` exposes a `changes` signal (`Stream`/`Listenable`); a `WatchOwnStoryChanges`
use case surfaces it to the #004 `StoriesRailCubit`, which re-runs `load()` after a publish → rail
repaints with no manual refresh (FR-011, resolves finding I1). Cleared on logout via `clearUserScoped()`.

**Rendering the offline-published image (finding U1)**: the #004 story viewer/rail render
`StorySegment.imageUrl` as a network image, but an offline-published own story has only local bytes.
Decision: keep the flattened bytes **in `OwnStoryStore`** (no disk, no new dependency — `path_provider`
is not a current dep, so a `file://` approach is rejected) and set `imageUrl` to a `memory://<segmentId>`
ref; the story image rendering gains a small resolver that maps `memory://` →
`MemoryImage(OwnStoryStore.bytesFor(id))` (network/asset paths unchanged). Session-scoped, consistent
with the store. When the real backend lands, the seam returns a real media URL and the resolver's
network path applies with no viewer change.

## R4 — 24-hour expiry (client-side)

**Decision**: Expiry is a pure filter: a segment with `createdAt` older than `now - 24h` is excluded
from `loadReels()` and from the own-reel merge. Centralize the rule in `OwnStoryStore`/a small helper
so both the own reel and (future) fetched reels share it.

**Rationale**: FR-013 / clarification; no server TTL exists. Deterministic and unit-testable by
injecting a clock (pass `DateTime.now` via a seam so tests can set "25h ago").

**Alternatives considered**: a timer that actively removes segments — rejected: unnecessary; filtering
on read is simpler and correct.

## R5 — Text & sticker overlay editor scope

**Decision**: Text overlay = a single editable line up to **~100 chars** (input blocked at limit,
clarification Q3) with a small fixed set of **text styles/colors** (token-driven swatches). Stickers =
a small **bundled fixed set** (a handful of PNG/SVG assets under `assets/stickers/`), tap-to-add and
drag-to-position. Both are draggable within the 9:16 canvas; no rotate/scale gestures for MVP (keep
minimal, Constitution XIII). Removing an overlay = drag-to-trash or a delete affordance.

**Rationale**: Matches Screen 9's "sticker preview" + text; keeps the editor small and testable. No
drawing/gesture package needed — `GestureDetector` + `Positioned` inside the `RepaintBoundary` suffice.

**Alternatives considered**: full interactive-sticker suite (music/poll/mention/location) — out of
scope by spec; freeform draw — deferred.

**Notes**: sticker assets are declared in `pubspec.yaml` under `flutter/assets`; keep the set tiny for
v1.0. Text limit enforced by the field's input formatter and asserted in a widget test (AS-2.6).

## R6 — Upload, idempotency, cancel (reuse #007)

**Decision**: Reuse `MediaUploadService.upload({bytes, idempotencyKey, cancelToken})` (progress stream
+ `UploadCancelToken`) verbatim. `PublishStory` generates one `uuid` idempotency key per compose
session and reuses it on retry so a retry yields exactly one story (FR-009). Cancel stops the stream
and writes nothing to `OwnStoryStore`; failure leaves no partial segment (FR-010).

**Rationale**: The #007 pipeline was explicitly built "reusable by #005/#006". No new upload code.

**Alternatives considered**: a story-specific upload path — rejected (duplication).

## R7 — Composer navigation & entry points

**Decision**: A full-screen nav-less pushed route `AppRoutes.storyCompose`, entered from the
stories-rail "Your story" tap (when the user has no active story / via a create affordance) and the
Profile create action. Bottom nav hidden. Tablet/iPad = #001 centered-mobile fallback. Back-out with a
selected photo or placed overlays shows a discard-confirm `AppDialog` (FR-015).

**Rationale**: Constitution X + IA (Create is contextual, not a tab); mirrors #007 compose routing.

**Open confirm at tasks time**: exact rail entry gesture (dedicated `+` on "Your story" vs. tap when no
active story) — a small UX detail resolved against `ui-design-context.md` Screen 7/9 during tasks; does
not affect architecture.

## R8 — Dependencies

**Decision**: **No new package** is planned. Reuse `image` (#007) for re-encode/compress; overlays use
Flutter built-ins; stickers are bundled assets. If mid-range profiling shows the isolate JPEG encode
janks, adopt `flutter_image_compress` (documented fallback only).

**Rationale**: Constitution XV (dependency hygiene) + XIII (YAGNI). Everything needed already exists in
the toolchain or was added in #007.

---

### Resolved unknowns

| Unknown | Resolution |
|---|---|
| How to guarantee preview==export for free-form overlays | `RepaintBoundary.toImage` capture (R1) |
| Story aspect ratio / crop reuse | 9:16 cover-fit, not #007 4:5 (R2) |
| How a published story appears in the rail without a backend | shared in-memory `OwnStoryStore`, no drift bump (R3) |
| 24h expiry mechanism | read-time filter with injectable clock (R4) |
| Overlay editor scope | 1 text line ≤100 chars + fixed sticker set, drag-position only (R5) |
| Upload/idempotency/cancel | reuse #007 `MediaUploadService` (R6) |
| New dependencies | none planned (R8) |

No NEEDS CLARIFICATION markers remain.
