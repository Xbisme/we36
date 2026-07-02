# Spec #008 — Reels · Alignment Decisions

> Pre-`/speckit.specify` alignment session (2026-07-02). Depends on #002 (networking/cache/realtime + `PaginatedListCubit`/`CursorPage`), #004 (feed pattern + optimistic like/save + one canonical cached item), #007 (media pick + `MediaUploadService` + resilient/idempotent upload pipeline). First spec after the content trio (#005/#006/#007) shipped.
>
> **✅ SDD cycle run 2026-07-02**: specify → clarify (3 Qs: audio-on-honoring-silent-switch · ≤90s · optimistic top-of-feed processing reel) → plan → tasks (55→57) → analyze. `specs/008-reels/` holds spec/plan/research/data-model/contracts/quickstart/tasks. Analyze surfaced 1 CRITICAL (**report affordance** missing — Constitution I; now FR-024a + task T034a) + fixes below. Ready for `/speckit.implement`.

## Context
- **Design**: Screen 10 (Reels) — full-screen vertical video feed (`PageView`), right-side action rail (like / comment / share / save), author + follow, caption. See [`ui-design-context.md`](../ui-design-context.md) Screen 10.
- **Backend contract EXISTS** (B#007 — verified in [`../../backend/src/modules/reels/`](../../backend/src/modules/reels/)). Unlike stories (#005, provisional), reels has a full real contract on `/v1`. So #008 builds a **real `ReelsRepository` seam on the actual contract + an in-memory fake**, matching the #002/#004/#006 pattern. App still runs `environment:'fake'` (zero-network) until real cutover.
- **Reuses**: #004 optimistic like/save + rollback + one-canonical-cached-item, `PaginatedListCubit<T>` + `CursorPage<T>` (#002), #007 `MediaUploadService` + `PhotoLibraryService` + idempotent-upload + progress/cancel, #006 comments surface (reels comments delegate to the same B#005 comments endpoints), `AppFailure`/`Result<T>`, Toast.

## Backend contract (B#007 — source of truth, all under `/v1`)
- `POST /reels` — create; body `CreateReelDto` { `videoMediaId` (uuid, required), `caption?`, `location?`, `taggedUserIds?`, `commentsDisabled?` } + `Idempotency-Key` header → `ReelDto` (201). **Video is uploaded first via the B#003 media pipeline to get `videoMediaId`; a reel may publish while its video is still `processing` — it just won't enter the feed until `ready`.**
- `GET /reels` — global feed, **reverse-chronological, ready videos only**, cursor pagination (`cursor?`, `limit` default 20 / max 30) → `ReelPageDto` { items, nextCursor, hasMore }.
- `GET /reels/:id` — single reel (visibility-gated; restricted/deleted/non-reel → 404).
- `DELETE /reels/:id` — soft-delete own reel (204; releases media).
- `POST|DELETE /reels/:id/like` → `EngagementStateDto` { postId, likeCount, saveCount, viewerHasLiked, viewerHasSaved } — idempotent.
- `POST|DELETE /reels/:id/save` → `EngagementStateDto` — idempotent.
- `GET|POST /reels/:id/comments` — **delegate to the B#005 comments surface** (newest-first, cursor); reuse #006 client comments slice.
- **`ReelDto`**: mirrors `PostDto` but carries a single **`video: MediaDto`** (not a carousel) + **`isVideoReady`** flag. Fields: id, author (`UserSummaryDto`), caption?, video, location?, hashtags[], taggedUsers[], commentsDisabled, likeCount, saveCount, commentCount, viewerHasLiked, viewerHasSaved, isVideoReady, createdAt.
- **`MediaDto`** (video): kind, status (`ready`/`processing`/`failed`), width/height, `durationMs`, `variants` { renditions[] (single video rendition), `poster` (still-frame), `thumbnail` } — variants present only when `status=ready`; `failureReason` when failed.

## Decisions (confirmed with user)

| # | Topic | Decision | Rationale |
|---|-------|----------|-----------|
| 1 | **Data source** | **Real `ReelsRepository` seam on the B#007 contract + in-memory fake** (`env:['real']` / `env:['fake']`). App runs `fake` (zero-network). New reel endpoint constants in `api_endpoints.dart`. | Backend contract exists (verified in `backend/src/modules/reels/`). No provisional-contract debt (unlike #005 stories). |
| 2 | **Create Reel scope** | **Minimal: pick → caption → upload.** Pick one video from gallery, add caption/hashtag/tag-people/location + turn-off-comments, upload the video via the #007 pipeline (→ `videoMediaId`), then `POST /reels` (idempotent). **No in-app trim / cover-frame editor** (deferred). | Ship the feed + a working create fast. In-app video editing is a large lift; backend derives poster/thumbnail from the video (`variants.poster`). |
| 3 | **Playback controls** | **Minimal, self-built.** `video_player` + `visibility_detector` only. Tap = pause/play, no scrubber/chrome (Instagram-Reels-style). Loop playback, muted-state honoring. | Matches Screen 10 (near-chrome-less). Fewer deps; `chewie` chrome is wrong for reels. |
| 4 | **Video lifecycle (Constitution II)** | Only the **on-screen** reel plays; off-screen reels **pause + dispose** their controller; a **small preload window** (e.g. ±1) pre-initializes neighbors. Enforced via `visibility_detector` + `PageView`. | Constitution II (disciplined video lifecycle) — long-scroll memory ceiling is a hard requirement; profiled at #015. |
| 5 | **Comments** | Reuse the **#006 comments slice** — reels comments hit `GET/POST /reels/:id/comments` (delegate to B#005). Open the existing `PostDetailPage`/`CommentsCubit` comments surface (sheet or push) keyed by reel id. | Backend explicitly aliases reel comments to the comments surface; no new comments code. |
| 6 | **Like / save** | **Optimistic + idempotent** via `EngagementStateDto` (target-state, revert on failure, last-intent) — identical pattern to #004 post like/save. One canonical cached `Reel`. | Constitution — optimistic + idempotent; consistent with #004. |
| 7 | **`isVideoReady` / processing** | Feed only returns `ready` videos (backend-filtered). A **freshly-created** reel may be `processing` → surface an "uploading/processing" state on the author's own just-posted reel; do **not** block the create flow on transcode. | Contract: create succeeds pre-transcode; feed is ready-only. Avoids a spinner-lock on publish. |
| 8 | **Follow from rail** | Author + **follow** button on the rail. Follow action is **surface-only ack (Toast)** for #008 — real follow lands in **#010 Profile & Follow**. | Social graph (follow) is #010; a throwaway follow call now would drift. Mirrors #006's defer-to-#010 for mention→profile. |
| 9 | **Share** | Action-rail **share** = surface-only (share-sheet stub / Toast) for #008; deep-link share into DM is #012. | Share-to-DM needs Messages (#012). Keep #008 to the feed + create + engagement. |
| 10 | **Cache** | ✅ Resolved at plan: own drift **`Reels` table (schema v4→v5)** — one canonical cached `Reel` (reactive) like #004 posts. | Enables offline render + cross-screen like/count consistency + processing→ready flip; transient stream rejected (loses those). |
| 11 | **Report / block** | ✅ Added at analyze: **report reel** surface-only (Toast, overflow) reachable from every reel; blocking + enforcement → #014. | Constitution I requires reporting reachable from every reel; mirrors #006 report-other. |

## Scope (v1.0 #008)
- Reels tab (5-tab nav slot already reserved) → vertical `PageView` video feed (reverse-chron, cursor-paginated) over `PaginatedListCubit`.
- Disciplined **video lifecycle**: visible-only play, off-screen pause+dispose, small preload window; loop; tap-to-pause.
- Action rail: **optimistic like/save** (idempotent), comment (opens #006 comments surface), share (surface-only), author + follow (surface-only → #010).
- **Create reel** (minimal): pick video → caption/hashtag/tag-people/location/turn-off-comments → resilient idempotent upload (progress/cancel, reuse #007 pipeline) → `POST /reels`; own just-posted reel shows processing state until `ready`.
- Empty / loading / error (retry) / offline-from-cache states; Toast for all messages; a11y (Reduce-Motion → no autoplay loop / static), light/dark, text-scaling; adaptive (tablet layout per §Responsive).

## Deferred (NOT in #008)
- **In-app video trim / cover-frame editor / filters** (create is pick→caption→upload only).
- **Ranked / recommendation reels feed** (roadmap out-of-scope v1.0 — MVP is reverse-chron).
- Real **follow** enforcement (→ #010); **share-to-DM** deep link (→ #012); reel moderation / blocked-state (→ #014); reactions beyond a single like; audio/music picker.

## Resolved at `/speckit.plan` + `/speckit.analyze` (2026-07-02)
- **Packages**: `video_player ^2.11.1` only (flutter.dev, Flutter Favorite; iOS 13 / Android minSdk 24 already met; needs Android `INTERNET`). **Dropped `visibility_detector`** (3-yr stale + unnecessary — a full-screen `PageView` gives the active index via `PageController.onPageChanged`) and **`chewie`** (wrong chrome). Preload window = **±1** (≤3 controllers live).
- **`PhotoLibraryService`** extended for video (`RequestType.video` + `videoDuration` + bytes/file + poster). **`MediaUploadService`** is already kind-agnostic (bytes + idempotency) — reused; real path streams from a file (chunked) at cutover, fake buffers bytes.
- **Cache** = own drift **`Reels` table, schema v4→v5** (decision #10 resolved: canonical cached `Reel` like #004 posts — enables offline render + cross-screen count/like consistency + processing→ready reactive flip).
- **Reels comments** = **bottom sheet** reusing #006 comment widgets + `CommentsCubit` keyed by reel id (not a pushed `PostDetailPage`, which needs a `Post`); a `CommentTarget` seam routes the comment-count delta to `ReelsRepository.applyCommentCountDelta`.
- **Video limits pinned** to the backend media config: **≤ 90s** and **≤ 150 MB** (`MEDIA_VIDEO_MAX_DURATION_SECONDS=90`, `MEDIA_VIDEO_MAX_BYTES=157286400`).
- **Report (Constitution I)** — added `report reel` **surface-only** (Toast ack, overflow/ActionSheet), mirroring #006 report-other; enforcement + **blocking** stay deferred to #014. Closes the analyze CRITICAL.

## Carried to `/speckit.implement` (non-blocking)
- **Audio silent-switch**: honor via a minimal iOS `ambient` audio-session channel; add `audio_session` package only if the channel proves fragile (then it's a Constitution-XV dependency add).
- **Comment ordering (I1)**: reused #006 cubit is oldest-first; backend reel-comments alias is newest-first — resolve at real cutover (invisible in fake mode).
- **Real chunked video upload** + real reel-comments wiring finalize at backend cutover; sample video assets bundled for fake/goldens (task T003a).
- Video **memory ceiling** strategy + preload-window size; Reduce-Motion behavior (poster-only, tap-to-play).
- Tablet/iPad reels layout (centered max-width video column vs full-bleed) per §Responsive.
