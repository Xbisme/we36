# Feature Specification: Reels

**Feature Branch**: `008-reels`

**Created**: 2026-07-02

**Status**: Draft

**Input**: User description: Spec #008 — Reels. A full-screen vertical short-video feed and a minimal create-reel flow for the We36 client, built on the existing B#007 backend reels contract (real repository seam + in-memory fake; app runs zero-network on fakes).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Watch the reels feed (Priority: P1)

A signed-in person opens the Reels tab and is dropped into a full-screen, vertical, one-video-at-a-time feed of short videos, newest first. Swiping up advances to the next reel; swiping down returns to the previous one. The video currently on screen plays automatically and loops; a single tap pauses it, another tap resumes. As the person scrolls, more reels load seamlessly. Videos that are off screen stop playing so the app stays smooth and doesn't drain the device.

**Why this priority**: This is the core value of the feature — a consumable video feed. It is the smallest slice that delivers a usable, demonstrable Reels experience on its own, even before any engagement or creation exists.

**Independent Test**: Load the reels feed on fakes and verify: reels appear newest-first, only the on-screen reel plays and loops, tap toggles pause/resume, swiping advances/rewinds, additional reels load on scroll, and scrolling through many reels does not accumulate simultaneously-playing videos.

**Acceptance Scenarios**:

1. **Given** the reels feed has reels available, **When** the person opens the Reels tab, **Then** the first (newest) reel is shown full-screen and begins playing automatically on a loop.
2. **Given** a reel is playing, **When** the person taps it once, **Then** playback pauses; **When** they tap again, **Then** playback resumes from where it stopped.
3. **Given** the person is viewing a reel, **When** they swipe up, **Then** the next reel is shown and starts playing while the previous reel stops playing.
4. **Given** the person nears the end of the currently loaded reels, **When** they keep swiping, **Then** the next page of reels loads and appends without interrupting playback.
5. **Given** a reel scrolls off screen, **When** it is no longer the active reel, **Then** its playback stops and its resources are released.
6. **Given** the feed is empty, loading, or failed to load, **When** the person is on the Reels tab, **Then** a clear empty / loading / error-with-retry state is shown respectively.

---

### User Story 2 - Engage with a reel (Priority: P2)

While watching a reel, the person sees who posted it (avatar + username) with a follow affordance, the caption (with @mentions and #hashtags visually highlighted), and a vertical action rail: like, comment, share, save. Tapping like or save updates instantly and reflects the new count; tapping comment opens the comments surface for that reel; share and follow acknowledge the action for now.

**Why this priority**: Engagement is what makes the feed social, but the feed itself (P1) is viable without it. This layers directly onto P1.

**Independent Test**: On a reel, tap like → the like state and count flip immediately and persist; tap again → it reverts. Repeat for save. Tap comment → the reel's comments open. Tap share and follow → a confirmation message appears. Verify a failed like/save rolls back to the prior state.

**Acceptance Scenarios**:

1. **Given** a reel the person has not liked, **When** they tap like, **Then** the reel shows as liked and the like count increases immediately, before any server confirmation.
2. **Given** the person just liked a reel, **When** the underlying action fails, **Then** the like state and count roll back to their previous values and the person is informed.
3. **Given** a reel, **When** the person taps like rapidly multiple times, **Then** the final state reflects their last intent and the reel is never counted more than once for that person.
4. **Given** a reel, **When** the person taps save / unsave, **Then** the saved state and save count update instantly with rollback on failure (same behavior as like).
5. **Given** a reel that allows comments, **When** the person taps the comment action, **Then** the comments surface for that reel opens and shows its comments.
6. **Given** a reel that has comments disabled, **When** the person views it, **Then** the comment action reflects that commenting is unavailable.
7. **Given** a reel, **When** the person taps share or follow, **Then** an acknowledgement is shown (full share-to-message and follow behavior arrive in later features).
8. **Given** a reel with a caption containing @mentions and #hashtags, **When** it is displayed, **Then** those tokens are visually highlighted (not yet tappable).
9. **Given** any reel, **When** the person opens its overflow/action sheet and taps **Report**, **Then** a surface-only acknowledgement (Toast) is shown; **And** for the person's own reel the overflow instead offers **Delete** (per FR-024).

---

### User Story 3 - Create and publish a reel (Priority: P3)

The person starts creating a reel, picks one video from their device gallery, optionally adds a caption (with hashtags), tags people, adds a location, and can turn off comments. They publish; the video uploads with a visible progress indicator they can cancel, and the reel is created. If publishing is retried after a failure, exactly one reel results. If the video is still being processed after publish, the person's newly created reel shows a "processing" state and appears in the feed once it is ready.

**Why this priority**: Creation is essential for a living feed but depends on the consumption surface (P1) existing to be meaningful, and reuses the established media-upload flow. It is the largest slice, so it follows viewing and engagement.

**Independent Test**: Enter create-reel, pick a video, add a caption, publish. Verify: upload progress is shown and cancellable; on success exactly one reel is created carrying the caption/options; a retry after a simulated failure still yields exactly one reel; a reel whose video is not yet ready shows a processing state.

**Acceptance Scenarios**:

1. **Given** the create-reel flow, **When** the person picks a video from the gallery, **Then** the selected video is shown ready to publish.
2. **Given** a selected video, **When** the person adds a caption, tags people, sets a location, and toggles comments off, **Then** those choices are attached to the reel on publish.
3. **Given** the person taps publish, **When** the video is uploading, **Then** a progress indicator is shown with the ability to cancel; cancelling aborts the publish and creates no reel.
4. **Given** a publish attempt fails mid-upload, **When** the person retries, **Then** exactly one reel is ultimately created (no duplicates).
5. **Given** publish succeeds but the video is still processing, **When** the create flow returns to the feed, **Then** the new reel appears at the top of the reels feed in a processing state and auto-updates to a playable state once its video is ready.
6. **Given** a successful publish with a ready video, **When** the create flow completes, **Then** the new reel is available in the reels feed.
7. **Given** the person is on the create-reel flow, **When** they attempt to leave with unsaved work, **Then** they are asked to confirm discarding.

---

### User Story 4 - Accessible, resilient, adaptive experience (Priority: P4)

Any user, on any supported device, gets clear feedback and an inclusive experience: all messages appear as toasts; empty / loading / error-with-retry / offline-from-cache states are explicit; the interface honors Reduce Motion (no autoplaying looping video — a still poster with tap-to-play instead), supports larger text, works in light and dark, is screen-reader labeled, and adapts its layout between phone and tablet/iPad.

**Why this priority**: These qualities apply across all stories and are required by the project's constitution, but they refine rather than establish the feature, so they are validated last.

**Independent Test**: With Reduce Motion enabled, confirm reels do not autoplay-loop but show a poster with tap-to-play. Verify screen-reader labels on the action rail, correct rendering at large text scale, in both light and dark themes, and an adapted layout at tablet width.

**Acceptance Scenarios**:

1. **Given** Reduce Motion is enabled, **When** the person views a reel, **Then** the video does not autoplay-loop; a still poster is shown and playback starts on tap.
2. **Given** any user-facing message (error, acknowledgement), **When** it occurs, **Then** it is presented as a toast (not a system dialog or banner).
3. **Given** the device is offline, **When** the person opens Reels, **Then** previously cached reels are shown where available and a clear offline indication is given.
4. **Given** a screen reader is active, **When** the person navigates a reel, **Then** the author, caption, and each action-rail control are announced with meaningful labels.
5. **Given** a tablet/iPad, **When** the person views Reels, **Then** the layout adapts appropriately for the larger screen rather than stretching the phone layout.

---

### Edge Cases

- **Empty feed**: No reels available → an explicit empty state (not a blank screen).
- **All videos off-screen during fast scroll**: rapid swiping must not leave multiple videos playing or initialized beyond a small preload window.
- **A reel's video fails to load / is unplayable**: show a per-reel error affordance; the person can still swipe past it.
- **Network drops mid-scroll**: further pages fail gracefully with a retry; already-loaded reels remain viewable.
- **Publish cancelled at various points** (before upload, mid-upload): no partial reel is created.
- **Very long caption / many hashtags / many tagged users**: caption is truncated with an expand affordance; token highlighting still renders.
- **Reel deleted by its author**: the author's own delete removes it from view; a reel that no longer exists resolves to a not-found state rather than a crash.
- **Comments disabled**: the comment action communicates unavailability; existing behavior for disabled comments is honored.
- **Device muted / silent switch**: reels honor the device silent/mute switch (no sound when silenced); see Clarifications.
- **Large or very long video picked for create**: enforce the maximum duration (90 seconds) and a sensible file-size limit, and message the person if exceeded.

## Clarifications

### Session 2026-07-02

- Q: Audio behavior when a reel autoplays in the feed? → A: Autoplay with sound, honoring the device silent/mute switch; a single tap pauses/resumes; no separate mute control in this feature.
- Q: Maximum reel video duration allowed at create? → A: ≤ 90 seconds (Instagram-Reels parity); the file-size cap is aligned with the upload pipeline at planning.
- Q: Where does a just-published reel whose video is still processing appear? → A: Optimistically inserted at the top of the reels feed with a processing badge, auto-updating to playable once the video is ready (parity with the "published content appears without manual refresh" pattern used elsewhere).

## Requirements *(mandatory)*

### Functional Requirements

**Feed & playback**

- **FR-001**: The system MUST present reels in a full-screen, vertically-paged feed showing one reel at a time, ordered newest-first.
- **FR-002**: The system MUST load reels incrementally (paginated) as the person scrolls, without interrupting the currently playing reel.
- **FR-003**: The system MUST autoplay and loop only the reel currently on screen, and MUST stop playback of any reel that is not the active one.
- **FR-004**: The system MUST release the video resources of off-screen reels and keep at most a small, bounded set of videos initialized at once (the active reel plus a small preload window), so that scrolling through many reels does not exhaust device memory.
- **FR-005**: The system MUST let the person pause and resume the active reel with a tap.
- **FR-005a**: The active reel MUST autoplay with sound, honoring the device's silent/mute switch; there is no separate in-app mute control in this feature.
- **FR-006**: The system MUST only display reels whose video is ready for playback in the feed, except the viewer's own just-published reel, which MAY appear in a processing state (see FR-021).
- **FR-007**: The system MUST show distinct empty, loading, and error-with-retry states for the feed, and MUST show previously cached reels when offline.

**Reel presentation**

- **FR-008**: Each reel MUST display its author (avatar + username) with a follow affordance, its caption, and engagement counts.
- **FR-009**: The system MUST visually highlight @mentions and #hashtags within a caption; these tokens are not required to be tappable in this feature.
- **FR-010**: The system MUST display a per-reel action rail offering like, comment, share, and save.

**Engagement**

- **FR-011**: The system MUST apply like and unlike optimistically (update state and count immediately), reconcile with the confirmed result, and roll back with a message on failure.
- **FR-012**: The system MUST apply save and unsave optimistically with the same immediate-update-and-rollback behavior as like.
- **FR-013**: The system MUST ensure like and save actions are idempotent — repeated or retried actions never count a person more than once, and the final state reflects the person's last intent.
- **FR-014**: The system MUST maintain a single canonical representation of a reel so that its like/save state and counts stay consistent everywhere it is shown.
- **FR-015**: The system MUST open the reel's comments surface when the comment action is tapped, and MUST reflect when a reel has comments disabled.
- **FR-016**: The system MUST acknowledge share and follow actions for this feature without performing full share-to-message or follow-graph behavior (those arrive in later features).

**Creation**

- **FR-017**: The system MUST let the person create a reel by selecting exactly one video from the device gallery, and MUST reject a video longer than 90 seconds or larger than 150 MB with a clear message (limits aligned with the backend media pipeline).
- **FR-018**: The system MUST let the person optionally add a caption (with hashtags), tag people, add a location, and turn comments off before publishing.
- **FR-019**: The system MUST upload the selected video with a visible, cancellable progress indicator; cancelling MUST create no reel.
- **FR-020**: The system MUST make publishing resilient and idempotent — a retry after a failure MUST result in exactly one reel, never duplicates, and a failed publish MUST leave no partial reel.
- **FR-021**: The system MUST allow publishing to succeed even if the video is still being processed, and MUST optimistically insert the person's newly created reel at the top of the reels feed in a processing state, auto-updating it to a playable state once its video becomes ready — no manual refresh required.
- **FR-022**: The system MUST prompt for confirmation if the person attempts to abandon the create-reel flow with unsaved work.
- **FR-023**: After a successful publish, the new reel MUST be present in the reels feed without requiring a manual refresh (in a processing state if not yet ready per FR-021, becoming playable once ready).

**Deletion**

- **FR-024**: The system MUST let a person delete their own reel (with confirmation), after which it no longer appears to them.
- **FR-024a**: The system MUST make **report** reachable from every reel (via the reel's overflow/action sheet) — a surface-only acknowledgement in this feature (Toast), with real moderation enforcement deferred to Settings, Privacy & Safety (#014). This satisfies the constitution's requirement that reporting be reachable from every reel; it mirrors the surface-only report shipped for comments (#006).

**Cross-cutting**

- **FR-025**: The system MUST present all user-facing messages as toasts.
- **FR-026**: The system MUST honor Reduce Motion by not autoplaying looping video — showing a still poster with tap-to-play instead.
- **FR-027**: The system MUST be usable with a screen reader (meaningful labels on the author, caption, and every action-rail control), support enlarged text, and render correctly in both light and dark themes.
- **FR-028**: The system MUST adapt its layout between phone and tablet/iPad widths rather than stretching a single fixed layout.
- **FR-029**: The system MUST operate fully against in-memory fakes with no network dependency, while exposing a real backend-backed path for later cutover.

### Key Entities *(include if feature involves data)*

- **Reel**: A single short video posted by an author. Carries: author summary, optional caption, the single video (with its playback readiness, poster/thumbnail, duration), optional location, parsed hashtags, tagged users, whether comments are disabled, like/save/comment counts, the viewer's own liked/saved state, a video-ready flag, and a creation time. There is one canonical representation per reel.
- **Reel video**: The video asset for a reel, with a readiness status (ready / processing / failed), a still poster image, a thumbnail, dimensions, and duration; playable renditions exist only once it is ready.
- **Reels feed page**: A cursor-based page of reels (a set of reels plus whether more exist and a pointer to the next page).
- **Engagement state**: The like/save counts and the viewer's liked/saved flags for a reel, returned when a like/save action is applied.
- **Reel draft (create)**: The in-progress creation: the selected video, optional caption, tagged people, location, and comments-off toggle, plus upload progress and an identity that makes retries safe.
- **Comment**: Reused from the existing comments feature; a reel's comments are the same kind of comments used elsewhere.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can open Reels and begin watching the first reel within 2 seconds on a normal connection.
- **SC-002**: While scrolling through at least 50 reels, no more than a small bounded number of videos (the active reel plus its preload neighbors — at most 3) are ever initialized simultaneously, and memory does not grow unbounded.
- **SC-003**: At most one reel plays at any moment; when the active reel changes, the previous reel stops within a fraction of a second.
- **SC-004**: Tapping like or save reflects visually in under 100 milliseconds (before any server round-trip), and a failed action visibly rolls back.
- **SC-005**: Retrying a failed publish never produces more than one reel — duplicate-free in 100% of retry cases.
- **SC-006**: A person can create and publish a reel (pick → caption → publish) in under 90 seconds excluding upload time.
- **SC-007**: With Reduce Motion enabled, 0% of reels autoplay-loop; all show a tap-to-play poster instead.
- **SC-008**: The feature is fully exercisable end-to-end with no network available (on fakes), with automated coverage of feed, engagement, and create flows all passing.
- **SC-009**: Every action-rail control and the author/caption are announced by a screen reader with a meaningful label (100% of interactive controls labeled).

## Assumptions

- **Video-editing scope**: Create is pick → (caption/options) → upload only. In-app trimming, cover-frame selection, and filters are out of scope for this feature (deferred).
- **Playback controls**: Reels use a minimal, chrome-less playback model (tap to pause/resume, auto-loop) matching the design — no scrubber, timeline, or fullscreen chrome.
- **Feed ordering**: The feed is reverse-chronological (newest-first). No ranked/personalized recommendation algorithm is in scope (MVP is chronological).
- **Follow & share**: Follow and share are acknowledgement-only in this feature; real follow behavior is delivered in the Profile & Follow feature and share-to-message in the Direct Messages feature.
- **Comments**: A reel's comments reuse the existing comments experience and its backend surface; no new comment model is introduced here.
- **Preload window**: A small preload window of one neighbor in each direction is assumed as the default; the exact size is confirmed at planning (bounded by SC-002).
- **Audio behavior**: The active reel autoplays with sound, honoring the device's silent/mute switch; a tap pauses/resumes. There is no separate in-app mute control in this feature (clarified 2026-07-02).
- **Backend contract**: The reels backend contract already exists and is the basis for the real data path; the app nonetheless runs entirely on in-memory fakes until a later real-backend cutover.
- **Video limits**: Reel videos are capped at **90 seconds** and **150 MB** at create time — values taken from the backend media pipeline config (`MEDIA_VIDEO_MAX_DURATION_SECONDS=90`, `MEDIA_VIDEO_MAX_BYTES=157286400`).
- **Connectivity**: Users may be intermittently offline; cached reels remain viewable and actions degrade gracefully.

## Dependencies

- Depends on the existing home-feed engagement pattern (optimistic like/save with rollback, one canonical cached item).
- Depends on the existing paginated-list/cursor mechanism for the feed.
- Depends on the existing media-pick and resilient/idempotent upload pipeline for create.
- Depends on the existing comments experience for the comment action.
- Depends on the existing app shell / navigation (Reels tab), toast, and design-token system.

## Out of Scope

- In-app video trimming, cover-frame selection, and filters/effects.
- Ranked or personalized reels recommendation (feed is reverse-chronological only).
- Real follow enforcement (delivered in Profile & Follow).
- Share-to-message deep-linking (delivered in Direct Messages).
- Reel moderation enforcement, user **blocking**, and blocked-state hiding (delivered in Settings, Privacy & Safety #014). Note: the **report affordance** itself IS in scope here (surface-only, FR-024a) — only its server-side enforcement is deferred.
- Reactions beyond a single like; audio/music picker for reels.
