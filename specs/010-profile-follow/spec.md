# Feature Specification: Profile & Follow

**Feature Branch**: `010-profile-follow`

**Created**: 2026-07-03

**Status**: Draft

**Input**: User description: "Build #010 Profile & Follow for the We36 Flutter client — the profile surface (my profile + other-user profile + followers/following lists + edit profile) and the follow graph — over the already-shipped backend B#010, reusing shipped models: MeProfile (#003), User (#002), ViewerRelationship (#009), the feed Post/grid (#004), and the #007 media-upload pipeline (avatar). US1 my profile; US2 other-user profile + optimistic follow; US3 followers/following lists; US4 private accounts (viewer-side); US5 edit profile + change photo; US6 inclusive & adaptive. Out of scope: collections (#011), DM/chat (#012), approving follow-requests (#013/#014), professional/category/contact fields, ranked content."

## Clarifications

### Session 2026-07-03

- Q: Is the profile/follow backend shipped, or is this provisional? → A: **B#010 is shipped** — the spec is contract-driven (the real repository can land alongside the fake; the app still runs `environment: 'fake'` for hermetic tests). Endpoint shapes are pinned at `/speckit.plan`.
- Q: Does Edit profile include changing the avatar in #010, or is that deferred (as in #003)? → A: **Included** — pick → crop → upload via the #007 media pipeline, writing `avatarMediaId` on the profile. This completes the avatar that #003 deferred.
- Q: Which tabs does the profile grid expose? → A: **Posts + Tagged** (both cursor-paginated). Saved is deferred to #011.
- Q: What is the private-account scope in #010? → A: **Viewer-side only** — a viewer can Follow a private account (→ Requested) and sees a gated "This account is private" grid; **approving incoming follow requests is out of scope** (deferred to #013/#014).
- Q: Does unfollow (and withdrawing a request) require a confirmation? → A: **Confirm on unfollow only** — Follow is instant/optimistic; **Unfollow** and **withdraw-request** show a confirmation dialog first (guards against accidental taps). Confirming then applies the optimistic change.
- Q: For a private account the viewer is not approved to see, how far do counts and the followers/following lists show? → A: **Counts shown, lists gated** — the header and posts/followers/following counts render, but tapping followers/following is blocked with a "private" notice (the lists are gated alongside the content grid).
- Q: When the viewer follows/unfollows someone, does their OWN "following" count update optimistically? → A: **Yes — canonical + optimistic** — the mutation updates the one canonical relationship AND the viewer's own following count (on their own profile) immediately, reconciled by the server (matches SC-004).

## User Scenarios & Testing *(mandatory)*

Profile & Follow is the app's **identity and social-graph** surface: the fifth tab (my own profile) plus the destination every avatar/username elsewhere in the app navigates to (another person's profile), the **followers/following** lists, and the **edit-profile** form. It sits on top of the shipped backend contract (B#010) and reuses the shipped identity models. The follow graph is the connective tissue that later features (Direct Messages #012, Notifications #013) build on. The client renders exactly what the API returns and enforces no visibility rule the backend hasn't already enforced.

### User Story 1 - View my own profile (Priority: P1)

A signed-in person opens the **Profile** tab and sees their own identity: avatar, display name, username, bio, website link, and their **posts / followers / following** counts, plus a scrollable grid of their own content. They can move from here to edit their profile, share it, open settings, or start creating.

**Why this priority**: The person's own profile is the anchor of the identity surface and the tab's landing screen; it is independently valuable (a person can review their presence and reach their own content) and is the foundation every other story extends.

**Independent Test**: With the current user's profile and posts seeded, open the Profile tab; verify the header renders avatar/name/username/bio/website and the three counts, that the Posts grid renders their content (reels marked) and paginates, that switching to the Tagged tab shows tagged content, and that Edit profile / Share / Settings / Create entry points are present and routed. Confirm empty/loading/error/offline-from-cache states.

**Acceptance Scenarios**:

1. **Given** the signed-in person has a completed profile, **When** they open the Profile tab, **Then** the header shows their avatar, display name, username, bio, and website (as a violet link), plus posts/followers/following counts.
2. **Given** their profile has posts, **When** the Profile tab renders, **Then** the **Posts** tab shows a 3-column grid of their posts and reels (reels carry a marker) and loads more as they scroll.
3. **Given** they switch to the **Tagged** tab, **When** the tab activates, **Then** a grid of posts they are tagged in renders (or an explicit empty state if none).
4. **Given** the header controls, **When** the person taps Edit profile / Settings / Create / Share profile, **Then** each opens its destination (Edit profile form / Settings / create flow / a surface-only share acknowledgement).
5. **Given** the person taps their **followers** or **following** count, **When** the tap completes, **Then** the corresponding list opens.
6. **Given** no cached profile and the network is unreachable, **When** the person opens Profile, **Then** an error state with retry is shown; **and Given** a cached profile exists, **Then** it renders from cache with an unobtrusive offline indication.

---

### User Story 2 - View another person's profile and follow them (Priority: P1)

A signed-in person opens **another person's profile** (from a search result, a post author, a comment, a followers list, etc.), sees their identity and stats, and can **follow or unfollow** them. The follow control responds instantly and reconciles with the server.

**Why this priority**: Following is the single most important action of the social graph — it is what makes the feed, messages, and notifications meaningful — and viewing another profile is the most common navigation destination in the app. It is independently shippable on top of US1's header.

**Independent Test**: With other accounts seeded (public, private, verified, blocked, follows-you), open a public account's profile; verify the header + stats + bio render, that Follow flips to Following instantly and a failed request rolls back, that Unfollow reverses it, that a "Follows you" indication shows when applicable, that Message and the overflow (report/block) are present as surface-only actions, and that a retried follow never produces a double-follow.

**Acceptance Scenarios**:

1. **Given** a public account "alice", **When** the person opens alice's profile, **Then** the header shows alice's avatar/name/username/bio and her posts/followers/following counts, plus a **Follow** primary action, a **Message** action, and an overflow menu.
2. **Given** the person is not following alice, **When** they tap **Follow**, **Then** the control flips to **Following** immediately and alice's follower count increments; **and When** the server request fails, **Then** the control and count roll back and a toast explains the failure.
3. **Given** the person is following alice, **When** they tap **Following** (and confirm if prompted), **Then** it reverts to **Follow** optimistically and reconciles with the server.
4. **Given** alice already follows the viewer, **When** the profile renders, **Then** a **"Follows you"** indication is shown.
5. **Given** a transient failure causes a retry, **When** the follow request is retried, **Then** exactly one follow relationship results (idempotent — no double-count).
6. **Given** the **Message** action or the overflow **Report** / **Block**, **When** the person taps it, **Then** a surface-only acknowledgement is shown (Message defers to #012; report/block acknowledge without a full flow in #010).

---

### User Story 3 - Followers & following lists (Priority: P2)

A signed-in person opens the **followers** or **following** list of a profile (their own or another's), searches within it, and can follow/unfollow people directly from the rows.

**Why this priority**: The lists make the social graph browsable and are a primary discovery path for people you already have a connection to, but they layer on top of the profile header (US1/US2) and the follow action (US2).

**Independent Test**: With a profile's followers and following seeded, open the lists; verify the two tabs show the correct people with counts, that the search field filters the rows, that each row shows the viewer's relationship and a working Follow/Following control, that tapping a row opens that profile, that the list paginates, and that blocked accounts never appear.

**Acceptance Scenarios**:

1. **Given** a profile with followers and following, **When** the person opens the lists, **Then** two tabs (**N followers** / **N following**) render, each listing accounts with avatar, name, and the viewer's relationship control; the active tab is indicated.
2. **Given** a long list, **When** the person scrolls, **Then** the next page appends without duplicates; **and When** they type in the search field, **Then** the rows narrow to matches.
3. **Given** a row's Follow/Following control, **When** the person taps it, **Then** it toggles optimistically (identical behavior to US2) and reconciles.
4. **Given** a row, **When** the person taps it, **Then** that account's profile opens.
5. **Given** the viewer has a block with someone, **When** either list renders, **Then** that person never appears.

---

### User Story 4 - Private accounts, viewer-side (Priority: P2)

A signed-in person interacts with a **private** account: they can find it and request to follow it, but its content stays gated until the request is approved.

**Why this priority**: Private accounts are a core privacy expectation of a social app and must be honored the moment following exists, but the viewer-side handling is a focused extension of US2's follow action.

**Independent Test**: With a private account seeded, open its profile; verify the grid is replaced by a "This account is private" gate (counts still visible), that Follow becomes **Requested** (pending) instead of Following, that tapping Requested cancels the pending request, and that an approved follower sees the real grid. Confirm blocked accounts never surface anywhere.

**Acceptance Scenarios**:

1. **Given** a private account the viewer does not follow, **When** its profile opens, **Then** the header/stats render but the content grid is replaced by an explicit **"This account is private"** gate (no posts/tagged content shown).
2. **Given** a private account, **When** the viewer taps **Follow**, **Then** the control becomes **Requested** (a pending state, not Following) and no gated content is revealed.
3. **Given** a pending request, **When** the viewer taps **Requested**, **Then** the request is withdrawn and the control returns to **Follow**.
4. **Given** the viewer is an approved follower of a private account, **When** its profile opens, **Then** its content grid renders normally.
5. **Given** any account with a block relationship (either direction), **When** the viewer looks for it, **Then** it never appears in profiles reachable via lists/search and its profile is not viewable.

---

### User Story 5 - Edit my profile (Priority: P2)

A signed-in person edits their own profile — display name, username, pronouns, website, bio — and changes their profile photo, then saves.

**Why this priority**: Editing lets a person shape their identity and complete the avatar that #003 deferred; it is important but depends on US1's profile existing and is used less frequently than viewing/following.

**Independent Test**: Open Edit profile from the own-profile header; verify each field is editable and pre-filled, that username shows live availability feedback and blocks an unavailable/invalid handle, that Change profile photo runs the pick→crop→upload pipeline and previews the new avatar, that Save persists optimistically and the own-profile header reflects the changes, and that a failed save rolls back with a toast. Confirm discard-confirm on backing out with unsaved edits.

**Acceptance Scenarios**:

1. **Given** the own-profile header, **When** the person taps **Edit profile**, **Then** a form opens pre-filled with their current display name, username, pronouns, website, and bio.
2. **Given** the person changes their **username**, **When** they type, **Then** live availability feedback is shown and Save is blocked while the handle is taken or invalid.
3. **Given** the person taps **Change profile photo**, **When** they pick and crop an image, **Then** it uploads via the media pipeline and the new avatar previews before save.
4. **Given** valid edits, **When** the person taps **Save**, **Then** the changes persist, the own-profile header updates without a manual refresh, and a success toast is shown; **and When** the save fails, **Then** the edits roll back with an explanatory toast.
5. **Given** unsaved edits, **When** the person backs out, **Then** a discard confirmation is shown before leaving.
6. **Given** required identity constraints (e.g. empty display name or invalid website), **When** the person attempts to save, **Then** inline validation blocks the save with a clear message.

---

### User Story 6 - Inclusive & adaptive profile experience (Priority: P3)

Any person, on any supported device, gets an inclusive, adaptive profile experience: all messages are toasts; empty / loading / error-with-retry / offline-from-cache states are explicit; the interface supports larger text, works in light and dark, is screen-reader labeled, and adapts between phone and tablet/iPad.

**Why this priority**: A cross-cutting quality bar that hardens US1–US5 for release; it assumes the earlier stories exist to harden.

**Independent Test**: Across my profile, another profile, the lists, and edit profile, verify screen-reader labels on avatars/stats/rows/controls, correct rendering at large text scale in light and dark, that all feedback appears as toasts, and that the profile header reflows to a wide tablet layout (larger avatar, inline actions, centered content, responsive grid).

**Acceptance Scenarios**:

1. **Given** a screen reader, **When** the person traverses the header stats, a grid tile, or a follow control, **Then** each announces meaningful content and its state (e.g. "Following, button"; "Reel" vs "Photo").
2. **Given** a large system text scale, **When** any profile screen is shown, **Then** text scales without clipping or overflow.
3. **Given** tablet/iPad width, **When** the person views a profile, **Then** the header reflows to a wide layout (larger avatar, stats and actions inline, content centered to a comfortable max width, grid reflowed to more columns) rather than stretching the phone layout.
4. **Given** any recoverable error, **When** it occurs, **Then** it is surfaced as a toast and (for a whole-screen failure) an inline retry.

### Edge Cases

- **Own profile via follow paths**: the viewer's own account never shows a Follow control (shows Edit profile instead) and never appears as a followable row in their own lists.
- **Count vs. state drift**: an optimistic follow updates both the control and the follower count; a rollback reverts both together, and a later server reconcile is the source of truth.
- **Rapid toggling**: tapping Follow/Unfollow repeatedly resolves to the latest intent with exactly one net relationship; superseded in-flight requests are ignored. (Unfollow/withdraw pass through the confirmation dialog first.)
- **Private list access**: tapping the followers/following count on a private account the viewer is not approved for is blocked with a "private" notice rather than opening the list.
- **Private → public mid-session (or vice-versa)**: a profile that changes privacy surfaces the correct gated/ungated grid on next load without a crash or leaked content.
- **Requested then approved**: a pending request the account approves out-of-band resolves to Following on next reconcile.
- **Deep-link to a profile**: opening a profile by handle directly (not via an in-app tap) works and does not require a prior screen.
- **Removed / suspended account**: navigating to a profile that no longer exists shows an explicit empty/error state, never a crash.
- **Username taken between check and save**: a handle that becomes unavailable between the availability check and save is rejected at save with a clear message (no silent overwrite).
- **Avatar upload cancel/fail**: cancelling or failing the photo upload leaves the previous avatar intact; save is not blocked on an abandoned upload.
- **Empty states**: no posts, no tagged content, no followers, no following, and an empty search-within-list each show their own explicit empty state.
- **Large counts**: follower/following/post counts render in an abbreviated form (e.g. 12.3k, 1.2M) without overflow.

## Requirements *(mandatory)*

### Functional Requirements

**My profile (US1)**

- **FR-001**: The system MUST show the signed-in person's own profile on the Profile tab: avatar, display name, username, bio, website (rendered as a link), and posts / followers / following counts.
- **FR-002**: The system MUST render the person's own content in a paginated 3-column grid under a **Posts** tab, with reels visually marked, and load additional content on demand as they scroll.
- **FR-003**: The system MUST provide a **Tagged** tab showing a paginated grid of posts the person is tagged in, with its own empty state when there are none.
- **FR-004**: The own-profile header MUST expose entry points to **Edit profile**, **Share profile** (surface-only), **Settings**, and the contextual **Create** action; and tapping the **followers** or **following** count MUST open the corresponding list.
- **FR-005**: The system MUST open the own-profile **header/identity** from cache on a cold start (name/handle/bio/website/avatar) and reconcile with a background refresh; the content grids reconcile live (they are not persisted). When no cached identity exists and the network is unavailable, it MUST show an error state with retry; when the identity is cached but the grid cannot load offline, the header renders with an unobtrusive offline indication and the grid shows its offline/empty state.

**Another person's profile & follow (US2)**

- **FR-006**: The system MUST let a person view any account they are permitted to see, showing avatar, display name, username, bio, verification indicator, and posts / followers / following counts.
- **FR-007**: The system MUST present a **Follow** control on another person's profile reflecting the viewer's current relationship (Follow / Following / Requested) and MUST toggle it **optimistically** with rollback on failure. **Follow** applies instantly, but **Unfollow** and **withdraw-request** MUST first show a confirmation dialog and apply the optimistic change only on confirm.
- **FR-008**: A follow/unfollow mutation MUST be **idempotent** (carry a client request key) so a retry results in exactly one net relationship and no double-counting.
- **FR-009**: A follow/unfollow MUST update the **one canonical** relationship representation for that account, so every surface showing it (profile, search results, lists) reflects the change without a manual refresh; it MUST also update the viewer's own **following** count on their own profile optimistically (reconciled by the server), and the viewed account's **follower** count.
- **FR-010**: The system MUST show a **"Follows you"** indication when the viewed account already follows the viewer.
- **FR-011**: The system MUST present a **Message** action (surface-only acknowledgement, deferring to #012) and an overflow with **Report** and **Block** as surface-only acknowledgements in this feature.
- **FR-012**: The system MUST NOT present a Follow control on the viewer's own profile (it shows Edit profile instead).

**Followers & following lists (US3)**

- **FR-013**: The system MUST provide **followers** and **following** lists (for the viewer's own and other permitted profiles) as two labeled, count-bearing tabs with the active tab indicated.
- **FR-014**: Each list row MUST show the account's avatar, display name/username, and a read-write Follow/Following control behaving identically to FR-007/FR-008; tapping a row MUST open that account's profile.
- **FR-015**: Each list MUST paginate on demand without duplicates and MUST provide a **search** field that filters the list to matching accounts.
- **FR-016**: The system MUST never show an account the viewer has blocked or been blocked by, in either direction, anywhere in the lists.

**Private accounts, viewer-side (US4)**

- **FR-017**: For a **private** account the viewer is not an approved follower of, the system MUST replace the content grid(s) with an explicit **"This account is private"** gate while still showing the header and counts; the **followers/following lists are also gated** — the counts render but are not navigable through (tapping shows a "private" notice) until the viewer is approved.
- **FR-018**: Tapping **Follow** on a private account MUST set the relationship to **Requested** (a pending state) rather than Following, and MUST NOT reveal any gated content.
- **FR-019**: Tapping **Requested** MUST (after the confirmation of FR-007) withdraw the pending follow request and return the control to **Follow**.
- **FR-020**: The system MUST render the full content grid for a private account only when the viewer is an approved follower (or the account is public); approving incoming requests is out of scope.

**Edit profile (US5)**

- **FR-021**: The system MUST provide an **Edit profile** form pre-filled with the person's current display name, username, pronouns, website, and bio, each editable.
- **FR-022**: The system MUST validate the **username** with live availability feedback and MUST block saving while the handle is unavailable or invalid; a handle that becomes unavailable by save time MUST be rejected with a clear message.
- **FR-023**: The system MUST let the person **change their profile photo** via pick → crop → upload (reusing the shipped media pipeline), previewing the new avatar before save and leaving the previous avatar intact if the upload is cancelled or fails.
- **FR-024**: The system MUST persist edits **optimistically**, update the own-profile header without a manual refresh on success, and roll back with an explanatory toast on failure.
- **FR-025**: The system MUST validate identity constraints (e.g. non-empty display name, well-formed website) inline and MUST confirm discarding unsaved edits when the person backs out.

**Inclusive & adaptive (US6)**

- **FR-026**: All user-facing messages MUST be toasts; every profile surface MUST provide explicit empty, loading, error-with-retry, and offline-from-cache states.
- **FR-027**: Every profile surface MUST be screen-reader labeled (stats, grid tiles by type, follow controls by state), support large text scaling without overflow, and render correctly in light and dark.
- **FR-028**: Profile surfaces MUST adapt by width — phone push navigation vs. a **wide tablet/iPad header** (larger avatar, inline stats/actions, content centered to a comfortable max width, grid reflowed to more columns).
- **FR-029**: Counts (posts/followers/following) MUST render in an abbreviated, locale-aware form that does not overflow at large values or text scales.

### Key Entities *(include if feature involves data)*

- **My profile**: the signed-in person's own editable identity — display name, username, avatar reference, bio, website, pronouns, privacy flag, verification flag, and the posts/followers/following counts. (Reuses the shipped `MeProfile`.)
- **Account (other user)**: a viewable person — username, display name, avatar, verification, privacy flag, and posts/followers/following counts. (Reuses the shipped `User`.)
- **Viewer relationship**: the directional state between the viewer and an account — following, requested (pending), follows-you, blocking — and the derived follow-control label. This is the entity the follow action mutates and the one canonical copy every surface reads. (Reuses the shipped `ViewerRelationship`.)
- **Profile grid item**: one cell of a profile's Posts or Tagged grid — a post or reel projection (reel marked), reusing the shipped feed/reel content models.
- **Account row**: one entry in a followers/following list — an account plus the viewer's relationship control.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can reach their own profile and their content, another person's profile, the edit form, and their followers/following lists — each within a single tap from its entry point.
- **SC-002**: A follow or unfollow reflects in the UI **instantly** (optimistic), and a failed request restores the exact prior control state and count with an explanatory message 100% of the time.
- **SC-003**: A follow/unfollow retried after a transient failure results in **exactly one** net relationship (no double-follow, no double-count) in 100% of retry cases.
- **SC-004**: A change made on one surface (follow from search, unfollow from a list, edit avatar) is reflected on every other surface showing that account or profile **without a manual refresh**.
- **SC-005**: A private account never exposes gated content to a non-approved viewer, and a blocked account never appears in any list, profile, or navigable destination — 0 leaks across the test matrix.
- **SC-006**: Every profile surface renders a correct empty / loading / error-with-retry / offline-from-cache state, is screen-reader labeled, holds layout at 2× text scale in light and dark, and reflows to the wide tablet layout — verified across the full screen set.
- **SC-007**: Editing the profile (including changing the photo) persists and is reflected on the own-profile header without a manual refresh; a failed save leaves the prior profile intact.

## Assumptions

- **Backend contract**: B#010 is shipped and exposes profile-by-handle (with the viewer relationship), follow/unfollow, followers/following (cursor-paginated), a profile posts/tagged grid (cursor-paginated), profile update, and avatar via the media pipeline. Exact endpoint/DTO shapes are pinned at `/speckit.plan` (`contracts/profile-api.md`), consistent with how B#009 was consumed.
- **Reused models**: `MeProfile` (#003), `User` (#002), `ViewerRelationship` (#009), the feed `Post`/grid (#004) and reel projection (#008), and the #007 media-upload/crop pipeline are reused as-is; no new content model is introduced.
- **Share profile** is surface-only in #010 — it acknowledges (e.g. copies/announces the profile link) without a full native share integration; a richer share lands later.
- **Report / Block** are surface-only acknowledgements in #010; full block enforcement and reporting flows land in Settings/Safety (#014). Blocked accounts are already excluded by the backend from lists/search.
- **Approving incoming follow requests** (the account owner's inbox) is out of scope — deferred to #013/#014; #010 covers only the requesting viewer's side.
- **Professional / Category / Contact** fields shown in the design are out of scope (not backed by the profile model), matching how #003 trimmed unavailable fields.
- **Tagged content** is read-only in #010 (viewing posts a person is tagged in); managing/removing tags is out of scope.
- The app continues to run DI `environment: 'fake'` for hermetic tests; the real profile/follow repository is annotated `env: ['real']` and cut over at dev-backend integration.
- Followers/following **search** queries the backend list (server-side) rather than filtering only the already-loaded page, so matches beyond the first page are found.
- One profile spec covers phone and tablet/iPad; the wide layout is a responsive reflow of the same routes/models/tokens, not a separate screen.

## Dependencies

- **#004 Home Feed** (the canonical `Post` + feed grid + `PaginatedListCubit`) and **#008 Reels** (reel projection) for the profile grids.
- **#003 Auth** (`MeProfile`, username-availability seam, session) for my profile + edit.
- **#002 Core** (`User` reference slice, `/users/{username}`, cursor pagination, cache) and **#009 Explore** (`ViewerRelationship` + navigation into profiles).
- **#007 Create Post** (media pick/crop/upload pipeline) for the avatar.
- **Backend B#010** (profile + follow-graph contract).
