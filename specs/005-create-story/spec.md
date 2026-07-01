# Feature Specification: Create Story & Story Tools

**Feature Branch**: `005-create-story`

**Created**: 2026-07-01

**Status**: Draft

**Input**: User description: "Create Story & Story Tools (Spec #005). A logged-in user creates and publishes an ephemeral photo story that appears immediately in the Home StoriesRail and is viewable in the full-screen Story viewer built in #004. Pick a single photo from the gallery; add baked text + sticker overlays; choose audience (Your story / Close friends); publish via the shared upload pipeline (progress/cancel, idempotent); 24h client-side expiry. Photo-only, pick-only (no in-app camera), fake-first (no backend stories contract yet)."

## Clarifications

> Resolved in the pre-`/speckit.specify` alignment session (2026-07-01) — see [`.claude/claude-app/decisions/spec-005-create-story.md`](../../.claude/claude-app/decisions/spec-005-create-story.md).

### Session 2026-07-01

- Q: Media source for a story — gallery pick or in-app camera capture? → A: **Pick-only from the gallery** (reuse the existing photo-library picker). In-app camera is out of scope for this spec.
- Q: Media type — photo only, or also video? → A: **Photo only.** Video stories are deferred (they follow the reels video pipeline).
- Q: How are text/sticker overlays handled — baked into the image or stored as editable metadata? → A: **Baked into the exported image** so what the creator sees is exactly what is published; no editable/metadata overlays and no viewer-side overlay rendering.
- Q: Is the "Close friends" audience option in scope for this spec? → A: **Yes — the binary audience toggle (Your story / Close friends) is in scope**, but managing the close-friends *list* itself belongs to a later spec (privacy & safety); this spec only records which audience a story was published to.
- Q: Backend — is there a stories contract to build against? → A: **No backend stories contract exists yet.** Build fake-first (fully offline): a published story is written into the current user's own reel so it appears immediately in the rail and viewer; a real backend seam is registered but inert, awaiting a future backend stories spec.
- Q: Is a draft/resume flow (like Create Post) needed for stories? → A: **No.** Stories are quick and ephemeral; there is no persisted draft — abandoning the composer discards in-progress work (with a confirm on unsaved overlays).
- Q: Story canvas / exported-image aspect ratio? → A: **9:16 full-bleed** — the composer canvas and the published image are 9:16 (portrait); a picked photo is fit/cropped to 9:16 (not the 4:5 crop used by Create Post).
- Q: How long does each photo story segment display in the viewer? → A: **5 seconds** per segment.
- Q: Maximum length of a text overlay? → A: **~100 characters**; input is prevented at the limit.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Publish a photo to your story (Priority: P1) 🎯 MVP

A signed-in person taps the contextual Create → Story action, picks one photo from their gallery, and taps share. The composer closes, and their new story appears immediately at the front of the stories rail as their own "Your story" entry with an unseen ring; opening it plays the photo full-screen in the story viewer. No manual refresh is needed.

**Why this priority**: This is the minimum viable story — a person can put a photo on their story and see it live. Everything else (overlays, audience, resilience) enriches this one flow. Without it there is no create-story feature.

**Independent Test**: From the Home stories rail or Profile create action, open the story composer, pick a photo, tap share, and confirm the story appears at the head of the rail and plays in the full-screen viewer — fully offline. Delivers a usable "post a photo story" experience on its own.

**Acceptance Scenarios**:

1. **Given** a signed-in person with photos in their gallery, **When** they open the story composer, **Then** they see their recent photos in a pickable grid and a share action that is disabled until a photo is selected.
2. **Given** a photo is selected in the composer, **When** they tap share, **Then** the composer closes and their photo is added as a new segment at the front of their own "Your story" reel in the stories rail, shown with an unseen ring.
3. **Given** the person has just published a story, **When** they open their own story from the rail, **Then** the photo plays full-screen in the story viewer using the same viewing experience as other people's stories.
4. **Given** the person already has an active story, **When** they publish another photo, **Then** the new segment is appended to their existing "Your story" reel (newest segment reachable) rather than creating a duplicate rail entry.
5. **Given** a published story, **When** the person returns to the Home feed, **Then** the rail reflects the new story without a manual pull-to-refresh.

---

### User Story 2 - Decorate with text and stickers (Priority: P2)

Before sharing, the person adds a short line of text and one or more stickers from a small built-in set, positioning them on the photo. What they arrange on screen is exactly what gets published — the decorations are burned into the shared image.

**Why this priority**: Overlays are the expressive core of stories and the main reason people post them over plain feed photos, but a photo can be published without them, so they build on top of the MVP.

**Independent Test**: In the composer, add a text overlay and a sticker, reposition them, publish, then view the story and confirm the decorations appear exactly as arranged — pixel-identical to the composer preview.

**Acceptance Scenarios**:

1. **Given** a photo in the composer, **When** the person adds text, **Then** they can type a short caption, pick from the available text styles/colors, and see it rendered on the photo.
2. **Given** a photo in the composer, **When** the person adds a sticker from the built-in set, **Then** it appears on the photo and can be repositioned by dragging.
3. **Given** text or stickers have been placed, **When** the person publishes, **Then** the published story shows the decorations in exactly the same positions and appearance as the composer preview.
4. **Given** a placed overlay, **When** the person removes it before publishing, **Then** it no longer appears in the preview or the published story.
5. **Given** unsaved overlays in the composer, **When** the person tries to close/abandon the composer, **Then** they are asked to confirm discarding before the work is lost.
6. **Given** a very long text entry, **When** the person types beyond ~100 characters, **Then** further input is prevented at the limit (the text stays legible on the photo).

---

### User Story 3 - Choose who can see it (Priority: P2)

At publish time the person chooses whether the story goes to everyone who follows them ("Your story") or only to their close friends. The choice is recorded with the story.

**Why this priority**: Audience control is a core stories expectation and a privacy-relevant choice, but it defaults sensibly to "Your story", so the MVP works without it.

**Independent Test**: In the composer footer, toggle between "Your story" and "Close friends", publish, and confirm the story records the chosen audience (and is visibly marked when published to close friends).

**Acceptance Scenarios**:

1. **Given** the composer is ready to publish, **When** the person views the footer, **Then** they can choose between "Your story" and "Close friends", with "Your story" selected by default.
2. **Given** "Close friends" is chosen, **When** the person publishes, **Then** the story is recorded as a close-friends story and is distinguishable as such where it is shown to the creator.
3. **Given** the close-friends audience is chosen but no close-friends list has been set up yet, **When** the person publishes, **Then** the story still publishes with the close-friends flag (list management is handled elsewhere) and the person is not blocked.

---

### User Story 4 - Resilient publishing (Priority: P2)

When the person shares, they see clear progress while the photo uploads and can cancel. If the upload fails, they get a plain-language message and can retry — and retrying never results in two copies of the same story.

**Why this priority**: Uploads fail on real networks; without visible progress, cancel, and safe retry the feature feels broken and can create duplicates. It hardens the MVP flow rather than adding a new surface.

**Independent Test**: Start a publish, observe progress; cancel mid-upload and confirm nothing is added to the rail; force a failure and confirm a retry affordance; retry and confirm exactly one story appears.

**Acceptance Scenarios**:

1. **Given** a publish is in progress, **When** the upload is running, **Then** the person sees clear progress feedback and a way to cancel.
2. **Given** a publish in progress, **When** the person cancels, **Then** the upload stops, no story is added to the rail, and the composer returns to an editable state.
3. **Given** a publish that fails partway, **When** the failure occurs, **Then** no partial or broken story appears in the rail and a brief non-technical message explains it didn't go through.
4. **Given** a failed publish, **When** the person retries, **Then** the same story is re-sent and exactly one story is created — a retry never produces duplicates.
5. **Given** a successful publish, **When** it completes, **Then** the person gets a brief confirmation and the composer closes.

---

### User Story 5 - Stories expire after 24 hours (Priority: P3)

A story the person posts is visible for 24 hours and then disappears from the stories rail and viewer automatically.

**Why this priority**: Ephemerality is definitional to stories, but it is a background rule rather than an interactive flow, so it can land last.

**Independent Test**: With a story whose creation time is older than 24 hours, confirm it no longer appears in the rail or viewer; with one younger than 24 hours, confirm it still does.

**Acceptance Scenarios**:

1. **Given** a story segment created less than 24 hours ago, **When** the rail and viewer load, **Then** the segment is shown.
2. **Given** a story segment created more than 24 hours ago, **When** the rail and viewer load, **Then** the segment is not shown and does not count toward the creator's active story.
3. **Given** a person's only story segment has expired, **When** the rail loads, **Then** their "Your story" entry shows no active story (no unseen ring).

---

### Edge Cases

- **No photos in the gallery**: the picker shows a friendly empty state rather than a blank grid or spinner.
- **Photo-library permission denied**: the composer shows a clear explanation with a path to open system settings to grant access (consistent with the Create Post flow), and does not crash or show a blank grid.
- **Permission granted "limited"/partial access**: the picker shows whatever photos are accessible and still allows publishing from them.
- **Abandoning the composer with decorations placed**: prompt to confirm discard before losing work (no draft is saved).
- **Extremely large or unusual-aspect photo**: the composer fits it to the 9:16 story canvas and publishes a correctly-oriented, reasonably-sized image (no memory blow-up, no stretched/rotated result).
- **Rapid double-tap on share**: only one publish is started; the share action is disabled while a publish is in progress.
- **Sign-out during or right after composing**: any in-progress compose state is discarded and the story is not attributed to a different account.
- **Offline at publish**: behaves as an upload failure with a retry affordance (the app is fully functional offline in this spec's fake mode; against a real backend the same retry path applies).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST let a signed-in person open a full-screen story composer from the contextual Create action (not a bottom-nav tab), reachable from the stories rail "Your story" entry and the Profile create action; the composer MUST hide the bottom navigation.
- **FR-002**: The system MUST let the person pick exactly one photo from their device gallery using the same in-app photo picker and permission handling as the Create Post flow, and fit/crop it to a **9:16 (portrait) story canvas**. Video and in-app camera capture are out of scope.
- **FR-003**: The system MUST require a selected photo before the share/publish action is enabled.
- **FR-004**: The system MUST let the person add text overlay(s) of up to **~100 characters** each (input prevented at the limit) with a choice of a small set of styles/colors, and add sticker(s) from a small built-in set, and reposition placed overlays on the photo.
- **FR-005**: The system MUST publish the story as a single flattened **9:16** image in which all text and sticker overlays are permanently rendered into the photo, such that the published result is pixel-identical to the composer preview. Overlays MUST NOT be stored as separately editable data.
- **FR-006**: The system MUST let the person choose an audience — "Your story" (followers) or "Close friends" — before publishing, defaulting to "Your story", and MUST record the chosen audience with the published story.
- **FR-007**: The system MUST allow publishing to "Close friends" even when no close-friends list has been configured; configuring/managing the close-friends list is out of scope for this spec.
- **FR-008**: The system MUST upload the story image through the shared media-upload pipeline, showing progress and offering a cancel action while the upload is in flight.
- **FR-009**: The system MUST make story creation idempotent: a retry after a failed or interrupted publish MUST result in exactly one story, never a duplicate.
- **FR-010**: The system MUST NOT leave any partial, broken, or orphaned story in the rail/viewer when a publish is cancelled or fails.
- **FR-011**: On successful publish, the system MUST add the new segment to the front of the current user's own "Your story" reel and reflect it in the stories rail immediately, with no manual refresh, and make it playable in the existing full-screen story viewer.
- **FR-012**: When the person already has an active story, a newly published segment MUST extend their existing "Your story" reel rather than creating a second rail entry for them.
- **FR-013**: The system MUST treat a story segment as expired 24 hours after its creation time and MUST exclude expired segments from the rail and the viewer, client-side.
- **FR-014**: The system MUST show clear, non-blocking, plain-language feedback for success and failure via the app's standard toast mechanism, and MUST NOT surface technical error details to the person.
- **FR-015**: The system MUST prompt for confirmation before discarding a composer session that has placed overlays or a selected photo. No persisted draft is kept between composer sessions.
- **FR-016**: The system MUST show friendly states for an empty gallery and for denied photo-library permission (the latter with a path to open system settings), consistent with the Create Post flow.
- **FR-017**: The system MUST prevent a second publish from starting while one is in progress (no duplicate submissions from rapid taps).
- **FR-018**: The system MUST function fully offline in the app's fake/no-backend mode — a published story appears in the rail and viewer without any network — and MUST register a real backend seam that is inert until a backend stories contract exists.
- **FR-019**: The system MUST NOT log photo bytes, image data, or any secret; logging MUST be limited to non-sensitive metadata (e.g., counts, sizes, status).
- **FR-020**: All composer and story-tool UI MUST meet the project's accessibility, text-scaling, and light/dark requirements, use only design-system tokens and shared components, present English copy (with Vietnamese translations available), and render on tablet/iPad via the centered-mobile fallback for the create-story screen.

### Key Entities *(include if feature involves data)*

- **Story draft (in-composer)**: the transient working state of a story being created — the selected photo, the set of placed overlays (text and stickers with their positions/styles), and the chosen audience. Exists only while the composer is open; not persisted between sessions.
- **Text overlay**: a short line of text placed on the photo, with a style/color and a position. Burned into the final image at publish.
- **Sticker overlay**: a graphic from the built-in set placed on the photo, with a position. Burned into the final image at publish.
- **Audience**: the visibility choice for a published story — "Your story" (followers) or "Close friends".
- **Published story segment**: the resulting ephemeral 9:16 story image attributed to the creator, with a creation time (drives the 24-hour expiry), a 5-second display duration in the viewer, and an audience. Reuses the existing story-segment representation shown in the rail and viewer; author is the current user.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can go from opening the composer to a published plain-photo story visible in their rail in under 30 seconds and with no more than three deliberate actions (pick, share, done).
- **SC-002**: 100% of published stories render in the viewer pixel-identical to the composer preview, including all text and sticker overlays.
- **SC-003**: A published story appears in the stories rail with zero manual refreshes (no pull-to-refresh or app restart required) in 100% of successful publishes.
- **SC-004**: Retrying any number of times after failed or interrupted publishes never creates more than one story for a single compose session (0% duplicate rate).
- **SC-005**: A cancelled or failed publish leaves 0 partial/broken entries in the rail or viewer.
- **SC-006**: 100% of story segments older than 24 hours are absent from the rail and viewer; segments younger than 24 hours remain present.
- **SC-007**: The entire create-and-view-story journey is completable end-to-end with no network connection in the app's fake mode.
- **SC-008**: Every composer and story-tool screen passes the project's automated accessibility, text-scaling, and light/dark checks, on both phone and tablet layouts.

## Assumptions

- **Depends on #004 (Home Feed & Stories)** for the stories rail, the "Your story" own-reel entry, the full-screen story viewer, and the story-segment representation — this spec adds creation on top of them and reuses the existing viewer for playback.
- **Depends on #007 (Create Post)** for the reusable media pipeline: the in-app photo picker + permission handling, the background-isolate image flattening used to bake overlays, and the resumable/cancelable idempotent upload service.
- **No backend stories contract exists yet.** The feature is built fake-first and fully offline; a published story is written into the current user's own reel in memory. A real backend seam is registered for architectural completeness but remains inert until a backend stories spec lands (mirrors the networking-core scaffold approach).
- **Close-friends list management is out of scope** (belongs to the later privacy & safety spec). This spec only records the audience choice on the story; publishing to "Close friends" is allowed even with an empty/absent list.
- **Photo only, single segment per publish, pick-only.** No video, no multi-photo story in one action, no in-app camera capture in this spec.
- **No persisted draft.** Unlike Create Post, an abandoned story composer discards its work (after a confirm); stories are quick and ephemeral.
- **The 24-hour expiry is enforced client-side** by comparing each segment's creation time against the current time; there is no server TTL to consult in this spec.
- **Overlay set is intentionally small** for this spec (a handful of text styles/colors and a fixed sticker set); interactive stickers (music, polls, mentions, location links) are out of scope.
- **Story format is 9:16 portrait** (full-bleed), distinct from Create Post's 4:5 crop; each published photo segment displays for **5 seconds** in the viewer.
- Standard mobile-app expectations apply for performance and error handling (fit-to-canvas image handling, friendly messages, no memory blow-ups on large photos).
