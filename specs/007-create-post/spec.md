# Feature Specification: Create Post (Compose & Upload)

**Feature Branch**: `007-create-post`

**Created**: 2026-07-01

**Status**: Draft

**Input**: User description: "Create Post (Compose & Upload) — the flow that lets a signed-in user compose and publish a new photo post to their feed. First content-creation surface; builds the shared client-side media-upload pipeline that later specs (#005 Create Story, #006 comment media) reuse. Three-step flow (pick → edit → caption), resumable/idempotent upload, optimistic insert atop the Home feed."

## Clarifications

### Session 2026-07-01

- Q: When an upload is interrupted (network loss / app killed mid-upload), what recovery is required for v1.0? → A: In-session retry/resume only — uploads resume/retry while the app is alive (including after backgrounding); if the app is killed mid-upload the draft is preserved and the person re-taps publish (idempotency prevents duplicates). A persistent background upload queue that survives app-kill is out of scope for v1.0.
- Q: How long must an in-progress compose draft persist? → A: A single "in-progress" draft is persisted locally and restored across app kill/restart; it is cleared on successful publish or explicit discard. Multiple simultaneously-saved drafts (a "Drafts" library) are out of scope for v1.0.
- Q: Does v1.0 support in-app camera capture in the Create Post flow? → A: Gallery-only for v1.0 — selection is from the device photo library; the camera affordance is hidden/disabled and in-app capture is deferred (the pipeline stays capture-source-agnostic so it can be added later).
- Q: For a carousel post, how do crop/filter/adjustments apply? → A: Per-photo — each image in the carousel carries its own crop, filter, and brightness/contrast/warmth; the edit step lets the person move between images to edit each.
- Q: How should the "Also share to Stories" toggle behave while Create Story (#005) is not yet built? → A: Hide it in #007 — the toggle is not shown; it will be added when #005 lands. ("Turn off commenting" remains, and "Add music" stays hidden/deferred for the same reason — no music catalog in v1.0.)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Publish a single photo post (Priority: P1)

A signed-in person taps the contextual **Create** action, picks one photo from their device gallery, writes a caption, and taps **Share**. The new post appears at the top of their Home feed.

**Why this priority**: This is the minimum end-to-end content-creation loop — without it the app is read-only. It proves the whole spine (pick → compose → upload → cached-post insert) end to end and is the demoable gate for the feature.

**Independent Test**: From a signed-in state, open Create, select one gallery image, type a caption, tap Share, and confirm the post renders at the top of the Home feed with the chosen image and caption — fully exercisable in fake mode (zero-network).

**Acceptance Scenarios**:

1. **Given** a signed-in person on any main tab, **When** they invoke the Create action, **Then** the pick step opens full-screen with the bottom nav hidden and their recent gallery photos shown in a grid.
2. **Given** the pick step with one photo selected, **When** they tap Next and then Share (after optionally adding a caption), **Then** the post is published and appears at the top of the Home feed.
3. **Given** a caption containing `#hashtags`, **When** the post is published, **Then** the hashtags are preserved and rendered in the brand-violet style consistent with the feed's PostCard.
4. **Given** a successful publish, **When** the person returns to the Home feed, **Then** the flow has been dismissed and the new post is the top-most item without a manual refresh.

---

### User Story 2 - Edit media before publishing (Priority: P2)

Before captioning, the person adjusts the look of their photo: crops it to the post aspect, applies a preset filter, and fine-tunes brightness / contrast / warmth.

**Why this priority**: Editing is core to the Instagram-style value proposition and expected by users, but a post can still be published without it (US1 stands alone), so it ranks below the publish loop.

**Independent Test**: Select a photo, open the edit step, apply a filter and adjust each slider, crop to the post aspect, proceed to caption, and confirm the published post reflects the edited result.

**Acceptance Scenarios**:

1. **Given** a photo in the edit step, **When** the person selects a preset filter (Original / Warm / Lux / Mono / Fade), **Then** the live preview updates immediately and the active filter is visually indicated.
2. **Given** the edit step, **When** the person moves the Brightness, Contrast, or Warmth control, **Then** the preview reflects the adjustment in real time.
3. **Given** an edited photo, **When** the person crops to the post aspect and taps Next, **Then** the edits and crop are carried through to the published post.
4. **Given** a person who applies no edits, **When** they tap Next, **Then** the original photo (cropped to the post aspect) is used unchanged.

---

### User Story 3 - Publish a multi-photo carousel (Priority: P2)

The person selects several photos in one post; the feed shows them as a swipeable carousel.

**Why this priority**: Carousels are a common, high-value post type, but they extend the single-photo path rather than replace it, so they follow the P1 loop.

**Independent Test**: Multi-select several gallery photos, confirm the "Carousel" indicator appears, edit and caption them, publish, and confirm the feed shows a swipeable multi-image post in the chosen order.

**Acceptance Scenarios**:

1. **Given** the pick step, **When** the person selects more than one photo, **Then** a "Carousel" indicator appears and the selection order is tracked and shown.
2. **Given** a multi-photo selection, **When** the person proceeds through edit, **Then** each photo can be edited (or the person may skip editing) before captioning.
3. **Given** a published carousel, **When** it renders in the Home feed, **Then** the images appear as a swipeable set in the selected order.
4. **Given** the maximum allowed number of photos is already selected, **When** the person tries to select another, **Then** selection is blocked with a clear message and no crash.

---

### User Story 4 - Resilient, non-duplicating upload (Priority: P2)

While the post uploads, the person sees progress and can cancel; if the upload fails they can retry, and no matter how many retries occur the post is never duplicated.

**Why this priority**: Uploads happen over unreliable mobile networks; without visible progress, cancel, retry, and de-duplication the feature feels broken and can create duplicate posts. It is essential quality but layered on top of the working publish path.

**Independent Test**: Trigger a publish against a fake that reports progress and can be made to fail; confirm progress is shown, cancel aborts cleanly, a forced failure surfaces a retry affordance, and retrying (or an interrupted-then-resumed upload) results in exactly one post.

**Acceptance Scenarios**:

1. **Given** a publish in progress, **When** the upload is running, **Then** the person sees upload progress and a cancel affordance.
2. **Given** an in-progress upload, **When** the person cancels, **Then** the upload stops, no post is created, and they return to the compose flow with their selection and edits intact.
3. **Given** an upload that fails, **When** the failure occurs, **Then** the person is shown a Toast and offered a retry without re-picking or re-editing.
4. **Given** a publish that is retried (or resumed after interruption), **When** it eventually succeeds, **Then** exactly one post is created — never a duplicate.

---

### User Story 5 - Post options and draft safety (Priority: P3)

On the caption step the person can attach optional metadata (tag people, add location) and set the "Turn off commenting" toggle; if they back out mid-flow their in-progress work is preserved.

**Why this priority**: These enrich a post and prevent lost work, but a post is fully publishable without any of them, so they rank last.

**Independent Test**: On the caption step, add tagged people and a location, toggle the options, back out of the flow and re-enter, and confirm the choices and media selection are restored; then publish and confirm the metadata and toggles are attached to the created post.

**Acceptance Scenarios**:

1. **Given** the caption step, **When** the person tags people or adds a location, **Then** those selections are shown and carried onto the published post.
2. **Given** the caption step, **When** the person toggles "Turn off commenting", **Then** the created post records that comments are disabled.
3. **Given** an in-progress compose flow, **When** the person backs out before publishing, **Then** they are asked to keep or discard the draft, and choosing "keep" restores the selection, edits, and caption on re-entry.
4. **Given** a discarded draft, **When** the person confirms discard, **Then** the in-progress media, edits, and caption are cleared.

---

### Edge Cases

- **Permission denied / not granted**: When gallery (or camera) permission is denied, the pick step shows an explanatory empty state with a way to open system settings — never a crash or blank grid.
- **No media available**: When the device gallery has no photos, the pick step shows an empty state rather than an error.
- **Nothing selected**: The Next action is disabled until at least one photo is selected.
- **Empty caption**: A post may be published with no caption (media alone is sufficient); the caption is optional.
- **Caption too long**: Captions exceeding the maximum length are prevented from being entered (with the limit surfaced), not truncated silently on publish.
- **Backgrounded mid-upload**: If the app is backgrounded or connectivity drops during upload, the upload can resume or be retried on return without creating a duplicate.
- **Session expired mid-flow**: If the session expires during compose or upload, the person is routed to re-authenticate and their draft is preserved.
- **Offline at publish time**: When there is no connectivity, publishing is deferred/retryable with a clear message rather than silently failing.
- **Corrupt or unsupported file**: A selected file that cannot be decoded is rejected with a clear message and excluded from the selection.
- **Duplicate rapid taps on Share**: Repeated Share taps do not create multiple posts.

## Requirements *(mandatory)*

### Functional Requirements

**Entry & navigation**

- **FR-001**: The system MUST expose post creation through the existing contextual **Create** action (not a bottom-nav tab) and open it as a full-screen flow with the main navigation chrome hidden.
- **FR-002**: The system MUST present creation as a three-step flow — Pick → Edit → Caption — with forward ("Next" / "Share") and backward navigation between steps.
- **FR-003**: The system MUST restrict post creation to signed-in people; an unauthenticated person MUST NOT be able to reach the flow.

**Pick step**

- **FR-004**: The system MUST let the person browse recent device photos in a grid and select one or more of them, showing a live preview of the current/first selection. Selection is from the device photo library only for v1.0; in-app camera capture is out of scope (the camera affordance is hidden/disabled), and the pipeline MUST remain capture-source-agnostic so capture can be added later.
- **FR-005**: The system MUST support multi-selection for carousel posts, track and display the selection order, and indicate when the selection is a carousel.
- **FR-006**: The system MUST enforce a maximum number of photos per post and prevent selecting beyond it with a clear message.
- **FR-007**: The system MUST request the necessary media permission contextually and handle the denied/limited state gracefully with an explanatory state and a path to system settings.

**Edit step**

- **FR-008**: The system MUST let the person crop each photo to the standard post aspect and use the crop result in the published post.
- **FR-009**: The system MUST offer a set of named preset filters (Original / Warm / Lux / Mono / Fade) with an immediate live preview and a clear active-filter indication.
- **FR-010**: The system MUST let the person adjust Brightness, Contrast, and Warmth with a live preview.
- **FR-010a**: For carousel posts, crop, filter, and adjustments MUST be applied per-photo — each image carries its own edit state — and the edit step MUST let the person move between the selected images to edit each independently.
- **FR-011**: The system MUST allow the edit step to be skipped, publishing the original (aspect-cropped) media unchanged.

**Caption step & options**

- **FR-012**: The system MUST let the person enter an optional caption, preserving and visually distinguishing hashtags consistent with how the feed renders them.
- **FR-013**: The system MUST let the person optionally tag people and add a location, and carry those onto the published post.
- **FR-014**: The system MUST provide a "Turn off commenting" toggle and record its choice on the created post. The "Also share to Stories" toggle and the "Add music" affordance MUST be hidden for v1.0 (they return when Create Story #005 / a music catalog land) and MUST NOT block publishing.
- **FR-015**: The system MUST enforce a maximum caption length, surfacing the limit as the person types.

**Publish, upload & feed integration**

- **FR-016**: The system MUST compress each selected photo on the device before upload to reduce transfer size while preserving acceptable display quality.
- **FR-017**: The system MUST upload media with visible progress and a cancel affordance; cancelling MUST abort the upload, create no post, and return the person to compose with their selection and edits intact.
- **FR-018**: The system MUST make the create-post operation idempotent so that retries or resumed uploads never produce a duplicate post.
- **FR-018a**: Interrupted uploads MUST resume or be retryable while the app is alive (including after backgrounding and returning). The system is NOT required to continue or auto-resume an upload after the app is killed; in that case the preserved draft (FR-021) lets the person re-initiate publish, with idempotency (FR-018) preventing duplicates. A persistent background upload queue surviving app termination is out of scope for v1.0.
- **FR-019**: The system MUST support retrying a failed upload/publish without requiring the person to re-pick or re-edit media, and MUST surface failures via a Toast.
- **FR-020**: On successful publish the system MUST insert the new post at the top of the person's Home feed via the single canonical cached representation, so every screen showing that post reflects it without a manual refresh.
- **FR-021**: The system MUST preserve a single in-progress compose draft when the person backs out mid-flow (offering keep-or-discard) and MUST persist it locally so it is restored across app kill/restart. The draft MUST be cleared on explicit discard or successful publish. Managing multiple simultaneously-saved drafts is out of scope for v1.0.

**Cross-cutting**

- **FR-022**: The flow MUST be adaptive by width — usable on phones and tablets/iPad — reusing the existing adaptive shell and shared components without introducing a new navigation model.
- **FR-023**: All user-facing messages MUST use the app's Toast mechanism; UI copy MUST be English with Vietnamese translations available; every screen MUST support light/dark, text scaling, and accessibility semantics.
- **FR-024**: The system MUST NOT log media file paths, contents, or other sensitive data.
- **FR-025**: The system MUST behave correctly with no live backend (in-memory fakes), so the full flow is buildable and testable zero-network until the backend media/create-post contract is available.

### Key Entities *(include if feature involves data)*

- **Compose Draft**: The in-progress post being built — the ordered set of selected media, their per-photo edits (crop, filter, adjustments), caption, tagged people, location, and toggle choices. Exists only until publish or discard.
- **Selected Media Item**: One chosen photo plus its edit state (crop rectangle, active filter, brightness/contrast/warmth values) and its position in the carousel order.
- **Post (canonical)**: The published item that reuses the existing single canonical cached Post representation rendered by the feed — author, media set, caption (with hashtags), optional location and tagged people, comments-enabled flag, and creation time.
- **Upload Task**: The transfer of a draft's media and metadata to the backend — carries a stable client-generated request identifier for idempotency, exposes progress, and is cancelable/retryable/resumable.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can publish a single-photo post from opening Create to seeing it in their feed in under 60 seconds on a typical connection.
- **SC-002**: Filter and adjustment previews update within 100 ms of the person's input so editing feels immediate.
- **SC-003**: In 100 out of 100 retried or interrupted-then-resumed uploads, exactly one post is created — zero duplicates.
- **SC-004**: A cancelled upload creates no post and returns the person to compose with their full selection and edits preserved in 100% of cases.
- **SC-005**: After a successful publish, the new post is visible at the top of the Home feed with no manual refresh in 100% of cases.
- **SC-006**: When the person backs out of an in-progress compose and chooses "keep", their selection, edits, and caption are fully restored in 100% of cases.
- **SC-007**: 95% of people who start a post (select at least one photo) successfully publish it without encountering an unrecoverable error.
- **SC-008**: No media path, media content, or other sensitive value appears in application logs across the entire flow.

## Assumptions

- **Photos only for v1.0**: This feature handles photo posts (single and carousel). Video posts are out of scope here; short-video creation is handled by Reels (#008).
- **Carousel cap**: A carousel supports up to **10** photos (industry-standard default); adjustable at planning if the backend contract differs.
- **Caption limit**: Captions are capped at **2,200** characters (industry-standard default); adjustable at planning.
- **"Add music" is deferred**: A music catalog/licensing is out of scope for v1.0; the "Add music" affordance is hidden and does not block publishing (revisit post-v1.0).
- **"Also share to Stories" is hidden**: Creating a story depends on Create Story (#005); the toggle is hidden in #007 (clarified 2026-07-01) and returns when #005 lands.
- **Gallery-only**: Selecting from the device gallery is the only source for v1.0 (clarified 2026-07-01); in-app camera capture is deferred post-v1.0, and the pipeline stays capture-source-agnostic so it can be added without rework.
- **Fake-mode delivery**: The feature ships running the app's fake DI environment (zero-network) until the backend media/create-post contract (B#007) is provisioned; the media-upload service and create-post repository each have an in-memory fake, with the real implementation added behind the real environment when the contract lands.
- **Reuses existing spine**: Networking, error mapping, result types, the adaptive shell, shared components, and the single canonical cached Post from prior specs are reused rather than reinvented; no new navigation model is introduced.
- **Signed-in context**: Only authenticated people reach this flow (the auth gate from the prior auth work is assumed in place).
- **Shared pipeline**: The client-side media-upload pipeline built here is intended for reuse by later features (Create Story #005, comment media #006); its design should not be post-specific in a way that blocks that reuse.

## Dependencies

- **#002 Networking, Cache & Realtime Core** — API client, `Result`/failure mapping, cursor/cache infrastructure (merged).
- **#003 Auth & Onboarding** — signed-in session and auth gate (merged).
- **#004 Home Feed & Stories** — the canonical cached Post and the feed that the new post is inserted into (merged).
- **Backend B#007 (media upload + create post contract)** — required for real-mode delivery; until then the feature runs on in-memory fakes.
- **#005 Create Story** — required to make "Also share to Stories" functional (deferred dependency).
