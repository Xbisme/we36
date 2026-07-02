# Spec #005 — Create Story & Story Tools · Alignment Decisions

> **✅ Shipped 2026-07-02 — merged into `main` via PR #6** (47/47 tasks). See [`../changelog.md`](../changelog.md) §2026-07-02 and [`../../specs/005-create-story/tasks.md`](../../specs/005-create-story/tasks.md).

> Pre-`/speckit.specify` alignment session (2026-07-01). Depends on #004 (StoriesRail + Story viewer) ✅ and #007 (media pipeline) ✅. **No backend stories contract exists yet** (`StoriesRepository` real seam is a stub, `lib/core/data/stories/stories_repository.dart`) — #005 builds on **fakes + a provisional client contract**, writing the created story into the in-memory reel list so it appears immediately in the #004 rail/viewer (same zero-network `environment:'fake'` pattern as #002/#007).

## Context
- **Design**: Screen 9 (Create story) — full image, `x` + tools (camera/plus/more/settings) corner, sticker/text overlay preview, footer "Your story" / "Close friends" + gradient share button. Tablet = CenteredMobile fallback (§ui-design-context Screen 9 / 233).
- **Reuses #007 pipeline**: `PhotoLibraryService` (pick), `ImageProcessingService` (bake-on-isolate — preview == export), `MediaUploadService` (real/fake, idempotency key, progress/cancel).
- **Reuses #004 story model**: `StorySegment` (image-only) + `StoryReel` in `lib/core/data/stories/story.dart`; the `isYou` "Your story" reel is where a published segment lands. Seen-state persists in drift (`StorySeenSegments`).

## Decisions (confirmed with user)

| # | Topic | Decision | Rationale |
|---|---|---|---|
| 1 | **Media source** | **Pick-only from gallery** — reuse #007 `PhotoLibraryService`. **No in-app camera** in #005. | No new dependency; consistent with #007. Screen 9's camera tool → deferred (later spec / #015). |
| 2 | **Media type** | **Photo only.** No video story in #005. | Consistent with #004 (`StorySegment` image-only) + #007. Video story waits for the reels #008 video lifecycle + compress pipeline. |
| 3 | **Sticker/text overlay** | **Baked into the exported image** on a background isolate (reuse the `ImageProcessingService` pattern) — what-you-see == what's uploaded. | Simplest MVP; needs no overlay-metadata contract and no viewer changes to render overlays. Editable/re-render overlays = deferred. |
| 4 | **Audience** | Story carries a binary **audience flag (Your story / Close friends)** at publish; the **close-friends list management belongs to #014** (no list data yet). | Keeps Screen 9 intact; #005 stores the flag without needing the list. When #014 lands, the toggle already exists. |
| 5 | **Backend contract** | **Provisional client contract + fakes** (`env:['fake']`, runs). Created story writes into the in-memory reel list (author = fake `Me`) at the head of the rail; a `env:['real']` seam is registered for graph completeness, awaiting a future backend stories spec. | No backend stories contract exists (per #004 note). Same approach #002 used for the `RealtimeClient` scaffold. |
| 6 | **24h expiry** | **Client-side expiry model** — a segment older than 24h is filtered from reels; the composer/publish records `createdAt`. | Matches the roadmap scope ("24h expiry model client-side"). No server TTL to consult. |

## Scope (v1.0 #005)
- Pick a photo → optional crop (reuse #007 4:5 / or story-ratio, decide at plan) → **sticker + text overlay** editor (baked) → choose audience (Your story / Close friends) → **publish** via the media-upload pipeline (progress/cancel, idempotent).
- Published segment appears immediately in the #004 StoriesRail ("Your story" reel) + is viewable in the Story viewer.
- Empty/permission/upload-failure states; Toast for all messages; a11y + light/dark + text-scaling.

## Deferred (NOT in #005)
- In-app camera capture (Decision 1) · video stories (Decision 2) · editable/metadata overlays + viewer overlay rendering (Decision 3) · close-friends **list** management (→ #014) · music sticker, polls, mentions/location stickers with links, story replies-beyond-#004, story highlights/archive, real backend stories contract.

## To confirm at `/speckit.plan`
- Story aspect ratio (9:16 full-bleed vs #007's 4:5 crop reuse).
- Overlay editor scope: text (font/color) + a fixed sticker set vs. freeform — keep MVP small.
- drift schema bump if any local persistence beyond the existing `StorySeenSegments` is needed (e.g. draft story) — likely none for #005.
