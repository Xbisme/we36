# Feature Specification: Home Feed & Stories

**Feature Branch**: `004-home-feed-stories`

**Created**: 2026-07-01

**Status**: Draft

**Input**: User description: "Home Feed & Stories (Spec #004) — the first usable content surface behind the auth gate. Two screens from the We36 design (Screen 7 Home feed, Screen 8 Story viewer)."

## Clarifications

### Session 2026-07-01

- Q: Post media in the feed — single image or multi-image carousel? → A: Single image per post; carousel is deferred to Create Post (#007).
- Q: "Your story" rail entry behavior at #004 (create story is #005)? → A: Opens the person's own active story if one exists in the data; otherwise it is an inert static entry with no create ("+") action.
- Q: Feed refresh triggers beyond pull-to-refresh? → A: Cold-start (cache + one background refresh) and manual pull-to-refresh only; no auto-refresh on tab re-select or staleness timer.
- Q: Does story "seen" state persist across app restart? → A: Yes — seen state is persisted locally and survives relaunch.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse the home feed (Priority: P1)

A signed-in person opens the Home tab and immediately sees the most recent posts from the accounts they follow, newest first. Older posts load automatically as they scroll, and pulling down at the top refreshes the feed with anything new. When they reopen the app, the last-seen feed appears instantly from local cache while a fresh copy loads in the background.

**Why this priority**: The feed is the reason to open the app — it is the first surface that delivers standalone value after login and the foundation every other content feature attaches to. Without it there is nothing to see.

**Independent Test**: Sign in, land on Home, confirm posts render newest-first, scroll to trigger the next page, pull to refresh, then relaunch offline and confirm the cached feed still appears. Delivers a usable browsing experience on its own.

**Acceptance Scenarios**:

1. **Given** a signed-in person with a non-empty following feed, **When** they open the Home tab, **Then** posts are shown in reverse-chronological order (newest first) with author, media, caption, like count, and save state.
2. **Given** the person is viewing the feed, **When** they scroll to the end of the currently loaded posts, **Then** the next page loads and appends without losing scroll position, and a loading indicator shows while it fetches.
3. **Given** the person is at the top of the feed, **When** they pull down to refresh, **Then** the feed reloads from the top and any new posts appear.
4. **Given** the person has opened the feed before, **When** they relaunch the app (including with no network), **Then** the previously cached feed renders immediately, followed by a background refresh when connectivity allows.
5. **Given** the feed request fails and no cache exists, **When** the feed screen loads, **Then** a clear, non-technical error state with a retry affordance is shown.
6. **Given** the following feed has no posts, **When** the feed loads, **Then** a friendly empty state is shown (not a blank screen or spinner).
7. **Given** the feed contains one malformed/partial post, **When** the feed renders, **Then** the bad item is skipped and the rest of the feed still displays.

---

### User Story 2 - Like a post (Priority: P1)

While browsing, a person taps the like control on a post. The heart fills and the like count updates instantly. If the action later fails on the server, the like silently reverts and a brief message explains it didn't go through. Tapping like twice (or retrying after a flaky network) never double-counts.

**Why this priority**: Liking is the single most frequent engagement action and the proof that the feed is interactive, not just a viewer. It exercises the optimistic-update + rollback + idempotency contract that later actions reuse.

**Independent Test**: Tap like on a post, confirm the filled state and incremented count appear immediately; simulate a server failure and confirm the state rolls back with a toast; confirm a repeated/retried like does not increment twice.

**Acceptance Scenarios**:

1. **Given** an unliked post, **When** the person taps like, **Then** the control shows the liked (filled) state and the count increments immediately, before the server confirms.
2. **Given** a liked post, **When** the person taps like again, **Then** it returns to the unliked state and the count decrements immediately.
3. **Given** a like action that fails on the server, **When** the failure is returned, **Then** the like state and count roll back to their prior values and a brief non-blocking message is shown.
4. **Given** the same post is visible in more than one place at once, **When** its like state changes, **Then** every on-screen representation reflects the same canonical value.
5. **Given** a flaky network causes a retry, **When** the like is re-sent, **Then** the server treats it idempotently and the like count is not double-applied.

---

### User Story 3 - Save a post (Priority: P2)

A person taps the save (bookmark) control on a post to keep it for later. The bookmark fills instantly and persists. As with likes, a server failure rolls the state back, and retries never double-apply. Saving here is a simple on/off bookmark — choosing a named collection to save into is a later feature.

**Why this priority**: Saving is a core engagement affordance shown on every post card, but it is secondary to viewing and liking and its richer form (collections) is deferred, so it ranks below the P1 stories.

**Independent Test**: Tap save on a post, confirm the filled bookmark appears immediately and survives a refresh; simulate failure and confirm rollback; confirm the saved flag is consistent wherever the post appears.

**Acceptance Scenarios**:

1. **Given** an unsaved post, **When** the person taps save, **Then** the bookmark shows the saved state immediately.
2. **Given** a saved post, **When** they tap save again, **Then** it returns to the unsaved state immediately.
3. **Given** a save action that fails on the server, **When** the failure is returned, **Then** the saved state rolls back and a brief message is shown.
4. **Given** a post is saved, **When** the feed is refreshed or reopened, **Then** the saved state is preserved from the canonical cached representation.

---

### User Story 4 - Stories rail (Priority: P2)

Above the feed, a horizontal rail shows a "Your story" entry followed by the recent stories of accounts the person follows. Accounts with unseen stories are highlighted with the signature gradient ring; once viewed, the ring desaturates. Tapping an entry opens the full-screen story viewer.

**Why this priority**: Stories are a headline surface of the product and share the same screen as the feed, but the feed itself must work first; the rail is the entry point to the viewer (US5).

**Independent Test**: Open Home, confirm the rail shows "Your story" plus followed accounts with unseen entries ringed and seen entries dimmed, ordered with unseen first; tap an entry and confirm the viewer opens.

**Acceptance Scenarios**:

1. **Given** a signed-in person, **When** the Home screen loads, **Then** a horizontal stories rail appears above the feed leading with "Your story".
2. **Given** followed accounts that have posted stories, **When** the rail renders, **Then** accounts with unseen stories show the unseen gradient ring and accounts whose stories are all seen show a desaturated/flat ring.
3. **Given** both unseen and seen stories exist, **When** the rail renders, **Then** unseen stories are ordered ahead of already-seen ones.
4. **Given** the rail is shown, **When** the person taps a story entry, **Then** the full-screen story viewer opens for that account.
5. **Given** no followed account has an active story, **When** the rail renders, **Then** it still shows the "Your story" entry.

---

### User Story 5 - Story viewer (Priority: P3)

Tapping a story opens a full-screen, edge-to-edge viewer. Segmented progress bars along the top show position within the account's stories; each segment auto-advances after a set duration, then moves to the next account. Tapping the right side skips forward, the left side goes back, and pressing and holding pauses. The author's avatar, name, and how long ago it was posted appear at the top with a close control. The person can like the current story. A "Send message" / reply field and a share control are visible but inactive in this release. Viewing a story marks it seen and updates its ring in the rail.

**Why this priority**: The viewer is the richest interaction of this spec and depends on the rail (US4) to reach it; it delivers the most value once the feed and rail are in place, so it ships last.

**Independent Test**: Open a story from the rail, confirm segments auto-advance and then move to the next account, confirm tap-forward/back and hold-to-pause work, like the current story, close the viewer, and confirm the ring shows as seen.

**Acceptance Scenarios**:

1. **Given** a story is opened, **When** the viewer appears, **Then** it is full-screen/edge-to-edge with segmented progress indicators, the author's avatar, name, relative posting time, and a close control.
2. **Given** a story segment is playing, **When** its duration elapses, **Then** the viewer auto-advances to the next segment, and after the last segment of an account moves to the next account (or closes if it was the last).
3. **Given** the viewer is open, **When** the person taps the right side, **Then** it advances to the next segment; **When** they tap the left side, **Then** it returns to the previous segment.
4. **Given** the viewer is open, **When** the person presses and holds, **Then** playback pauses; **When** they release, **Then** it resumes.
5. **Given** a story is on screen, **When** the person taps like, **Then** the story shows the liked state immediately with rollback on failure.
6. **Given** the viewer shows the "Send message"/reply field and share control, **When** the person taps them, **Then** they are visibly inactive (no navigation or send occurs) in this release.
7. **Given** the person views a story, **When** they close the viewer, **Then** the story is marked seen and its rail ring updates to the seen state.
8. **Given** Reduce Motion is enabled, **When** a story plays, **Then** auto-advance still progresses but decorative/animated transitions are static.

---

### Edge Cases

- **Empty feed**: no posts from followed accounts → friendly empty state, not a spinner or blank.
- **Feed load failure with no cache** → error state with retry; **with cache** → serve cache, surface the refresh failure quietly.
- **Malformed/partial post or story** in a payload → skip the bad item, keep the rest; never crash the list.
- **End of feed reached** → stop paginating and indicate there is nothing more, without an infinite spinner.
- **Optimistic action fails** (like/save/story-like) → roll back to the exact prior value and inform the person.
- **Rapid repeated taps** on like/save → coalesced idempotently; no double-count, no duplicate request effect.
- **Story with a single segment** → progress bar completes then advances/closes correctly.
- **Story tapped that expired/was removed between rail render and open** → viewer handles gracefully (skip/close with a soft message), does not show stale withheld content.
- **Header icons** (Activity bell, Messages) tapped before those features exist → no-op or clearly inactive, never a crash or dead route.
- **Very long caption / large like counts** → caption truncates with a "more" affordance; counts show in abbreviated form.
- **Slow network** → cached content shows first; loading affordances are bounded, not indefinite blocking.

## Requirements *(mandatory)*

### Functional Requirements

**Feed browsing (US1)**

- **FR-001**: The Home tab MUST present posts from the accounts the signed-in person follows in reverse-chronological order (newest first). No ranked/personalized ordering.
- **FR-002**: The feed MUST load incrementally using cursor-based pagination, appending the next page when the person scrolls near the end, without disrupting scroll position.
- **FR-003**: The feed MUST support pull-to-refresh that reloads from the top and surfaces newly available posts.
- **FR-004**: On app open (cold start), the feed MUST render the last-seen posts from local cache immediately, then reconcile with a single background refresh when connectivity allows. Feed refresh is triggered only by cold start and manual pull-to-refresh — there is no auto-refresh on Home-tab re-selection or a staleness timer in this spec.
- **FR-005**: The feed MUST present distinct states for loading (initial), populated, empty (no posts), and error, with a retry affordance in the error state.
- **FR-006**: A malformed or partial post in a response MUST be skipped without breaking the rest of the feed.
- **FR-007**: The feed MUST stop requesting further pages once the end is reached and indicate no more content rather than spinning indefinitely.
- **FR-008**: Each post MUST display author identity (avatar + name), a single image (4:5), caption (with truncation for long text), abbreviated like count, and the current like/save states. Multi-image carousels are out of scope for this spec (deferred to Create Post #007).
- **FR-009**: The Home header MUST show the We36 wordmark plus an Activity (notifications) entry point with an unseen indicator and a Messages entry point; these entry points navigate only where a destination exists and are otherwise inactive placeholders in this release.

**Like a post (US2)**

- **FR-010**: Tapping like MUST update the post's like state and count immediately (optimistically), before server confirmation.
- **FR-011**: A failed like/unlike MUST roll the like state and count back to their prior values and inform the person with a brief non-blocking message.
- **FR-012**: The like mutation MUST be idempotent so a retry after a flaky network does not double-apply the like.
- **FR-013**: A post's like state/count MUST have one canonical representation reflected consistently everywhere the post appears on screen.

**Save a post (US3)**

- **FR-014**: Tapping save MUST toggle a simple saved/bookmarked flag on the post immediately (optimistically), with no collection selection.
- **FR-015**: A failed save/unsave MUST roll back and inform the person.
- **FR-016**: The save mutation MUST be idempotent and the saved state MUST persist across refresh and relaunch via the canonical cached post.

**Stories rail (US4)**

- **FR-017**: A horizontal stories rail MUST appear above the feed, leading with a "Your story" entry followed by followed accounts that have active stories. The "Your story" entry MUST open the person's own active story in the viewer if one exists; if the person has no active story, it MUST be an inert static entry with no create ("+") action (story creation is deferred to #005).
- **FR-018**: Accounts with unseen stories MUST be visually highlighted with the unseen gradient ring; accounts whose stories are all seen MUST show a desaturated/flat ring.
- **FR-019**: The rail MUST order accounts with unseen stories ahead of already-seen ones.
- **FR-020**: Tapping a rail entry MUST open the full-screen story viewer for that account.

**Story viewer (US5)**

- **FR-021**: The story viewer MUST be full-screen/edge-to-edge and show segmented progress indicators, the author's avatar, name, relative posting time, and a close control.
- **FR-022**: Story segments MUST auto-advance after a set per-segment duration and, after an account's last segment, proceed to the next account or close if none remain.
- **FR-023**: Tapping the right region MUST advance to the next segment and tapping the left region MUST return to the previous segment.
- **FR-024**: Press-and-hold MUST pause playback and release MUST resume it.
- **FR-025**: The person MUST be able to like the currently displayed story, optimistically with rollback on failure.
- **FR-026**: The "Send message"/reply field and the share control MUST be displayed but inactive (no send, no navigation) in this release.
- **FR-027**: Viewing a story MUST mark it seen and update its ring state in the rail accordingly. The seen state MUST be persisted locally so it survives app relaunch (a seen story stays desaturated after restart).
- **FR-028**: A story that is expired/removed between rail render and open MUST be handled gracefully (skipped or closed with a soft message), never showing stale withheld content.

**Cross-cutting**

- **FR-029**: The Home feed and stories rail MUST adapt by screen width: a single-column feed under the bottom nav on phones; a centered, width-constrained feed column with sidebar-rail chrome on tablets/iPad; and, on the widest layouts, an additional right rail containing footer links and a static (non-interactive-navigation) search field. The story viewer is full-screen on all widths.
- **FR-030**: All user-facing messages (rollback notices, errors) MUST use the app's standard toast mechanism; no raw system snackbars.
- **FR-031**: All feed/story text MUST be localized (English primary, Vietnamese secondary), and counts/relative times MUST use locale-aware abbreviated formatting ("38.4k", "2h").
- **FR-032**: Media thumbnails in the feed MUST be decoded at a bounded resolution appropriate to their layout size so that long scrolling stays within a bounded memory footprint.
- **FR-033**: When Reduce Motion is enabled, story auto-advance MUST still progress but decorative/looping animations MUST render statically.
- **FR-034**: Every feed/story interaction MUST be operable without a live backend (fake data source), and no personal content, tokens, or message bodies may appear in logs.
- **FR-035**: The feed and stories surfaces MUST honor server-provided visibility/removal states and MUST NOT render content the server has withheld, even from cache.

### Key Entities *(include if feature involves data)*

- **Post**: A single feed item authored by an account — its media, caption, author reference, created timestamp, like count, and the viewer's like/save states. One canonical cached representation shared across all screens.
- **Feed page**: A cursor-delimited slice of posts (items + next cursor + has-more indicator) used to page through the reverse-chronological feed.
- **Story**: A short, time-limited piece of content by an account, composed of one or more ordered **segments**, each with media and a display duration; carries seen/unseen state for the viewer and the viewer's like state.
- **Story rail entry**: An account's aggregated story presence in the rail — the account reference, whether any segment is unseen (drives ring state), and ordering position; includes the special "Your story" self entry.
- **Author / account reference**: The minimal identity (avatar, display name/username) shown on posts and stories; full profile is out of scope here.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A signed-in person reaches a populated Home feed within 2 seconds of opening the app when cached content exists (cache renders first, refresh follows).
- **SC-002**: Scrolling a long feed (at least 200 posts across pages) stays smooth with no crash and a bounded memory footprint (no unbounded growth from decoded images).
- **SC-003**: A like or save reflects on screen within 100 ms of the tap (optimistic), independent of server round-trip.
- **SC-004**: A failed like/save/story-like rolls back to the exact prior state 100% of the time, with a message shown, and no action is ever double-applied on retry.
- **SC-005**: The feed renders correctly across all four states (loading, populated, empty, error) and recovers to a populated feed via retry after a transient failure.
- **SC-006**: A malformed post/story in a batch never prevents the remaining valid items from displaying.
- **SC-007**: 100% of feed/story user-facing strings are localized and render correctly in both English and Vietnamese and in both light and dark themes.
- **SC-008**: The story viewer auto-advances through all segments of an account and transitions to the next account (or closes) with correct progress indication; tap-forward/back and hold-to-pause behave as specified.
- **SC-009**: The entire feed + stories experience is exercisable end-to-end with zero network (fake data), and no personal content or secrets appear in logs.
- **SC-010**: The feed, rail, and viewer render correctly on phone (<700 width), tablet/iPad (≥700), and the widest layout (≥1100, with right rail), including rotation and split-view.

## Assumptions

- **Data source**: This release runs on in-memory fake data (the app's current fake environment); a real backend is wired in a later cutover. The feed contract reuses the existing cursor-pagination envelope and the shared paginated-list behavior from the networking core.
- **Feed scope**: "Feed" means the reverse-chronological following feed only; no ranked, personalized, or "suggested posts" injection.
- **Story auto-advance duration**: Image segments use a standard fixed display duration (assumed ~5 seconds) unless a segment specifies its own; video-segment support is not in scope for this spec (stories here are treated as image segments).
- **Save granularity**: Save is a single on/off bookmark; named collections and the collection picker are deferred to Spec #011.
- **Story reply/share/DM**: The reply field and share control are intentionally inert placeholders; real sending is delivered with Direct Messages (Spec #012).
- **Header entry points**: The Activity bell and Messages icon are placeholders that become live with Notifications (#013) and Messages (#012); the unseen dot on Activity may be driven by fake state.
- **Right rail content**: On the widest layout the right rail shows footer links and a static search field only; suggested users / follow actions arrive with Profile & Follow (#010) and live search with Explore & Search (#009).
- **Out of scope**: creating posts (#007) and stories (#005); comments and post detail (#006); reels (#008); real DM send / story reply (#012); saved collections and the collection picker (#011); suggested users / follow (#010); search behavior (#009); notifications/activity feed (#013); and any ranked/personalized ranking (post-v1.0).
- **Existing foundation reused**: the shared PostCard, Avatar (+ ring), StoriesRail, TopBar, Toast, adaptive shell/sidebar rail, and the auth gate/session routing from Specs #001–#003 are reused rather than rebuilt.
