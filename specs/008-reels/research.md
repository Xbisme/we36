# Phase 0 Research: Reels (#008)

All NEEDS CLARIFICATION items resolved. Versions verified on pub.dev 2026-07-02 (Constitution XV).

## R1. Video playback package

- **Decision**: `video_player ^2.11.1` (flutter.dev, Flutter Favorite). No `chewie`.
- **Rationale**: Reels use a minimal, chrome-less playback model (tap = pause/resume, auto-loop); `chewie` bundles a scrubber/fullscreen chrome that contradicts the design (Screen 10) and adds weight. `video_player` gives exactly the primitives needed (`initialize`, `play`, `pause`, `setLooping`, `dispose`, `value.isInitialized/position`).
- **Native prereqs (already satisfied)**: iOS ≥ 13.0 (project at 13.0 since #003), Android `minSdk` ≥ 24 (project at 24 since #003). Android needs `<uses-permission android:name="android.permission.INTERNET"/>` — **T-native task** to confirm/add in `AndroidManifest.xml`. Video is served over HTTPS CDN → no `NSAppTransportSecurity` change needed.
- **Alternatives rejected**: `chewie` (wrong chrome, heavier), `better_player`/`fvp` (larger native surface, unneeded features).

## R2. Active-reel detection & video lifecycle (Constitution II)

- **Decision**: Use a vertical `PageView` (`scrollDirection: Axis.vertical`) driven by a `PageController`; the active index comes from `onPageChanged`. **Do NOT add `visibility_detector`.**
- **Rationale**: For a full-screen, one-reel-at-a-time pager, the active page is known directly from the controller — `visibility_detector` (0.4.0+2, last published ~3 years ago) adds a stale dependency for zero benefit here. Fewer deps satisfies Constitution XIII/XV.
- **Lifecycle manager**: a `ReelPlaybackController` (plain Dart, owned by the page) keeps a bounded map of `VideoPlayerController` keyed by feed index within the window `[active-1 … active+1]` (preload window = **±1**, bounded by SC-002 ≤ 3 simultaneous). On `onPageChanged(i)`: initialize `i` (if absent) and `i±1`; `play` + `setLooping(true)` on `i`; `pause` all others; `dispose` and drop any controller outside the window. Every controller is disposed on page dispose (Constitution II: "A controller MUST always be disposed").
- **Alternatives rejected**: `visibility_detector` (stale, unnecessary for a full-screen pager); "initialize all" (violates the memory ceiling).

## R3. Audio behavior (honor device silent switch)

- **Decision**: Active reel autoplays with sound; `video_player` default volume. To honor the iOS hardware silent switch, configure the audio session to a mute-switch-respecting category (`ambient`) at reels-screen entry.
- **Rationale**: By default iOS `video_player` uses a playback category that plays through the silent switch. The clarification requires honoring the silent switch. `video_player` alone does not expose the AVAudioSession category, so this needs either (a) a tiny platform channel or (b) the `audio_session` package.
- **Open (deferred to implementation, not blocking)**: prefer **no new package** — evaluate setting the session via a minimal channel first; only add `audio_session ^0.x` if the channel proves fragile. Reduce-Motion path (R6) shows a poster with no audio anyway. On-device silent-switch verification → release gate (#015). Android has no silent-switch semantic for media; plays per stream volume.
- **Alternatives rejected**: forcing sound regardless (contradicts clarification); muted-by-default (rejected by user in clarify).

## R4. Create-reel media pick + upload (reuse #007 pipeline)

- **Decision**: Reuse `MediaUploadService` (bytes + `idempotencyKey` + progress + cancel — already transport/kind-agnostic) and extend `PhotoLibraryService` to support video pick.
- **PhotoLibraryService extension**: currently `RequestType.image` only. Add video support: a `RequestType.video` (or `.common`) asset query path plus accessors for the picked video's **file/bytes**, **`videoDuration`**, and a **poster thumbnail** (all available from `photo_manager`'s `AssetEntity`). Duration enforces the **≤ 90s** cap (FR-017) and the poster feeds the create preview + the optimistic feed card.
- **Upload path**: create-reel calls `MediaUploadService.upload(bytes, idempotencyKey, …)` → `MediaRef` (a `videoMediaId`) → `ReelsRepository.createReel(videoMediaId, caption, metadata, idempotencyKey)`. Idempotency key is generated once per draft (UUIDv7) and reused on retry ⇒ exactly one reel (FR-020), mirroring `ComposeCubit`/`PublishPost`.
- **Large-video note (Constitution II)**: a 90s video as a single `Uint8List` is large. For the **fake** (zero-network) path this is simulated (progress/cancel only). The **real** impl should stream from a file path (resumable/chunked) rather than fully buffering — flagged as a real-impl detail for backend cutover (parity with how #007 kept chunking behind the real seam). Prefer file-path streaming for the real video upload.
- **No image-editing reuse**: `ImageProcessingService` (crop/filter/warmth) is image-only and NOT used — reels create is pick → caption → upload (no trim/cover/filter per spec Out of Scope).
- **Alternatives rejected**: a separate video-pick package (`image_picker`) — `photo_manager` is already integrated and gives duration + poster; adding another picker duplicates the seam.

## R5. Data source, cache & canonical consistency

- **Decision**: New `ReelsRepository` (real `env:['real']` + fake `env:['fake']`) on the B#007 contract, backed by a **new drift table `Reels` (schema v4 → v5)** + `ReelsDao`, mirroring `Posts`/`PostsDao`.
- **Rationale**: A drift-cached canonical `Reel` gives (a) one source of truth for like/save counts + viewer flags (Constitution IX), (b) reactive `watchReelsFeed()` / `watchReel(id)` for optimistic like/save reconciliation and the processing→ready auto-update, and (c) offline-from-cache render (FR-007). This is the exact #004 pattern; the alternative (in-memory transient like #006 comments) can't deliver offline render or cross-screen count consistency for reels.
- **Migration**: v5 adds `Reels` + registers `ReelsDao`; `clearUserScoped()` extended to wipe reels on logout. Non-destructive, step-wise; migration test covers v4→v5 (Constitution IX).
- **Alternatives rejected**: in-memory-only reels (loses offline + canonical consistency); reusing the `Posts` table with a `kind` column (reels carry a single video + `isVideoReady`; overloading the posts row/feed query risks regressing #004 — keep tables separate on the client even though the backend stores both as `Post`).

## R6. Reduce Motion

- **Decision**: When `MediaQuery.disableAnimations` (Reduce Motion) is on, reels do **not** autoplay-loop. Show the video **poster** (`Media.variants.poster`) as a static image with a play affordance; playback (and audio) starts only on explicit tap (FR-026, SC-007). No looping.
- **Rationale**: Constitution VI ("no infinite decorative loops"; Reduce Motion degrades to static) + accessibility.

## R7. Comments surface reuse (#006)

- **Decision**: Reuse the #006 comment **widgets** (`CommentTile`/`CommentText`/`CommentInput`/`QuickEmojiRow`) and `CommentsCubit` machinery, presented as a **modal bottom sheet** over the reel (not a pushed `PostDetailPage`), opened keyed by the reel id.
- **Rationale**: A reel has no cached `Post`, and `PostDetailPage` renders a `Post` via `watchPost`; a bottom sheet is the Instagram-Reels pattern and keeps the reel playing behind it. Backend confirms reel comments delegate to the **same** comments surface (`/reels/:id/comments` → B#005), so the comment models/list are identical.
- **Canonical comment-count seam (generalizes #006 analyze-F1)**: #006 has the `AddComment`/`DeleteComment` use cases own the `commentCount` delta on the canonical `Post` via `FeedRepository.applyCommentCountDelta`. For reels the same delta must land on the canonical **`Reel`** via `ReelsRepository.applyCommentCountDelta`. Introduce a minimal **`CommentTarget`** abstraction (post vs reel) so the add/delete use cases route the count delta and the canonical-count watch to the right repository, keeping the comment list code 100% shared.
- **Endpoints**: add reel comment endpoints (`/reels/:id/comments`) to `ApiEndpoints`; the fake `CommentsRepository` is target-agnostic (keyed by id) so fake mode works unchanged. Real reel-comments wiring finalizes at backend cutover.
- **Alternatives rejected**: pushing `PostDetailPage` (needs a `Post`; wrong presentation for a playing reel); duplicating comment widgets (violates Constitution VI).

## R8. Just-published processing reel (clarify Q3)

- **Decision**: On successful `POST /reels`, optimistically **insert the returned reel at the top of the local reels cache** in a processing state (badge), then reconcile to playable when its video is ready.
- **Rationale**: Parity with #004/#007 ("published content appears without manual refresh"). Backend feed is ready-only, but `POST /reels` returns the author-visible `ReelDto` (possibly `isVideoReady=false`), and `GET /reels/:id` is author-visible while processing. Client caches it at top; readiness reconciles via a re-fetch of that reel (or next feed refresh). In **fake** mode the fake flips `isVideoReady` after a short simulated delay to demonstrate the transition. A processing reel is skipped by the playback controller (no controller until ready) and shows its poster + a "processing" badge.
- **Alternatives rejected**: not showing until ready (rejected by user in clarify; worse feedback).

## R9. Follow & share (surface-only)

- **Decision**: Author-rail **follow** and action-rail **share** show a Toast acknowledgement only (no follow-graph write, no share sheet/DM). Real follow → #010; share-to-DM → #012.
- **Rationale**: Social graph and Messages aren't built; a throwaway call would drift. Mirrors #006's defer-to-#010.

## R10. Routing

- **Decision**: Reels feed stays at the existing `/reels` tab branch (replace the #001 placeholder `ReelsPage`). Create-reel is a **nav-less pushed flow** — add `AppRoutes.reelCompose` (e.g. `/reel/compose`) reached from the contextual Create action (Constitution VI/X: Create is contextual, not a tab). Comments are a bottom sheet (no route). Optionally add `AppRoutes.reelDetailPath(id)` = `/reel/:id` for a deep-linkable single reel (used by share later) — **defer** unless needed; not required for MVP.
- **Rationale**: Matches the IA (5 tabs; Create contextual; full-screen flows nav-less).

## Resolved unknowns summary

| Unknown | Resolution |
|---|---|
| Video package + version | `video_player ^2.11.1`; no chewie |
| Active-item detection | `PageController.onPageChanged`; no `visibility_detector` |
| Preload window | ±1 (≤ 3 controllers live) |
| Audio / silent switch | sound on; ambient audio session (channel-first, `audio_session` only if needed) |
| Max video duration | ≤ 90s (enforced at pick via `videoDuration`) |
| Video upload | reuse `MediaUploadService`; extend `PhotoLibraryService` for video; real path streams from file |
| Cache | drift `Reels` table, schema v4→v5 |
| Comments | reuse #006 widgets in a bottom sheet; `CommentTarget` seam for count delta |
| Processing reel | optimistic top-of-feed insert + reconcile to ready |
| Routing | `/reels` tab (replace placeholder) + `/reel/compose` nav-less create |
