# Feature Specification: Notifications & Push

**Feature Branch**: `013-notifications-push`

**Created**: 2026-07-08

**Status**: Draft

**Input**: User description: "Spec #013 — Notifications & Push. The Activity surface (Screen 29) plus real push delivery; the second live wiring of the realtime channel. Backend notifications module already shipped and verified against source — build the client contract-first."

## Clarifications

### Session 2026-07-08

- Q: Can a "requested to follow you" entry be approved/declined inline in the Activity feed this release? → A: No — defer request **approval** to #014 (Settings, Privacy & Safety). The row shows the activity and deep-links to the actor's profile / where requests are handled; no inline approve/decline here.
- Q: What ships for real push delivery on this branch — real wiring, or seam + fake only? → A: Real wiring now, credentials deferred. Build the real permission + token-receive + device register/unregister flow behind a swappable push seam (with an in-memory fake driving hermetic tests); the platform push credentials/native config and on-device receipt land at real-backend cutover / #015.
- Q: When does the app prompt for push permission (the "contextually appropriate moment")? → A: The first time the Activity screen is opened — show a value explainer then the system prompt; if skipped, don't renag, re-offer only via a subtle in-screen affordance.
- Q: When a live activity event arrives while the app is foregrounded on another screen, is there an in-app cue? → A: No banner/toast — silent update only. The event updates the canonical unread badge and folds into the feed; the badge is the cue. (No cross-screen banner surface is built.)
- Q: How is the Activity feed sectioned? → A: Time-sectioned — New (today) / This week (last 7 days) / Earlier, newest-first within each section; unread rows carry an unread accent driven by the server read state (independent of the time bucket).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See my activity feed (Priority: P1)

As a signed-in person, I open the Activity screen and see a reverse-chronological list of who engaged with me — who liked or commented on my posts/reels, replied to or @mentioned me in a comment, followed me, or requested/accepted a follow. Related activity is collapsed into a single entry ("Alice and 4 others liked your post"). Tapping an entry takes me straight to what it points at (the post, the comment thread, or the person's profile). Opening the screen clears my "new activity" indicator.

**Why this priority**: This is the core value of the spec and the MVP — a person can see and act on their social activity even before push exists. It is independently shippable: the feed reads from the backend (or the in-memory fake), renders, paginates, and navigates on its own.

**Independent Test**: Seed a set of notifications of every type (including a grouped one and one whose target was deleted), open the Activity screen, and verify: entries render newest-first with the right summary text, grouped entries show "and N others", tapping navigates to the correct destination, a deleted-target entry renders in a degraded non-tappable state, scrolling loads more pages, and the unread indicator clears after opening.

**Acceptance Scenarios**:

1. **Given** I have unread notifications of several types, **When** I open the Activity screen, **Then** I see them sectioned New (today) / This week / Earlier, newest-activity-first within each, with per-type summary text, actor avatars, a target thumbnail where applicable, relative timestamps, and an unread accent on rows I haven't seen.
2. **Given** several people liked the same post within the grouping window, **When** the feed renders, **Then** they appear as one entry showing the most-recent actors plus "and N others".
3. **Given** a like/comment entry, **When** I tap it, **Then** I land on that post's detail (comment entries scroll to the comment); **Given** a follow entry, **When** I tap it, **Then** I land on that person's profile.
4. **Given** an entry whose target post/comment was deleted or is no longer visible, **When** it renders, **Then** it shows a degraded, non-tappable row rather than crashing or navigating to a dead end.
5. **Given** I have a "new activity" indicator, **When** I open the Activity screen, **Then** the indicator clears (all notifications are marked read) and stays cleared on return until new activity arrives.
6. **Given** I have no notifications, **When** I open the Activity screen, **Then** I see a friendly empty state; **Given** the feed fails to load, **Then** I see an error state with a retry action.

---

### User Story 2 - Get notified when the app is closed (Priority: P2)

As a person who is not currently in the app, I receive a system push notification when someone engages with me or messages me, so I know to come back. The first time it is contextually appropriate, the app asks my permission to send notifications; if I grant it, my device is registered to receive pushes, and it is unregistered when I sign out.

**Why this priority**: Push is the second headline of the spec and the re-engagement driver, but the Activity feed (US1) already delivers standalone value, so push is P2.

**Independent Test**: With push permission granted and a device registered, simulate a backend push for each kind and verify a system notification appears with non-sensitive copy; revoke/skip permission and verify the app degrades gracefully (no registration, no crash); sign out and verify the device token is unregistered.

**Acceptance Scenarios**:

1. **Given** I have not been asked for notification permission, **When** I reach a contextually appropriate moment (not cold app start), **Then** the app explains the value and requests permission.
2. **Given** I grant permission, **When** registration runs, **Then** my device push token is registered with the backend; **Given** the token later rotates, **Then** the new token replaces the old one.
3. **Given** someone engages with me while the app is backgrounded or closed, **When** the backend pushes, **Then** I see a system notification with generic, non-sensitive copy (no message body, no private detail).
4. **Given** I deny or skip permission, **When** I use the app, **Then** everything else works and no push registration is attempted.
5. **Given** I sign out, **When** the session ends, **Then** my device push token is unregistered so I stop receiving pushes for that account.

---

### User Story 3 - Unread badge (Priority: P2)

As a person using the app, I see a badge on the Activity entry point (bottom nav on phone, sidebar rail on tablet) whenever I have new activity, so I know to check without opening the screen. The badge reflects a single authoritative unread count and updates live.

**Why this priority**: The badge is what makes the feature ambient and is a small, well-bounded slice on top of US1; P2 because it depends on the feed/count surface being present.

**Independent Test**: Set an unread count via the backend/fake, verify the badge shows it; push a live activity event and verify the badge increments without a manual refresh; open the Activity screen and verify the badge clears.

**Acceptance Scenarios**:

1. **Given** I have N unread notifications, **When** the app loads, **Then** the Activity entry point shows an unread badge.
2. **Given** new activity arrives while the app is open, **When** the live event is received, **Then** the badge updates immediately without a manual refresh.
3. **Given** I open the Activity screen (marking all read), **When** I return to another tab, **Then** the badge is cleared.

---

### User Story 4 - Live in-app notifications (Priority: P3)

As a person with the app open, when new activity happens I see it appear at the top of my Activity feed and get a lightweight in-app cue, without pulling to refresh — the app's realtime channel keeps the feed and badge current.

**Why this priority**: Realtime liveness is a polish layer over US1/US3; the feed is fully usable from cache and manual refresh without it, so it is P3.

**Independent Test**: With the Activity screen open, deliver a live activity event over the realtime channel and verify a new entry folds into the top of the list and the badge updates; drop the realtime connection and verify the feed still renders from cache and recovers on reconnect.

**Acceptance Scenarios**:

1. **Given** the Activity screen is open, **When** a live activity event arrives, **Then** a corresponding entry appears/updates at the top of the feed with no manual refresh.
2. **Given** the realtime channel is disconnected, **When** I open the Activity screen, **Then** it renders from the last cached state and reconciles when the connection returns.
3. **Given** a live event arrives while I am on another screen, **When** it is received, **Then** it silently updates the canonical unread count/badge with no banner or toast — the badge is the only cue.

---

### User Story 5 - Act on a notification (follow back / respond) (Priority: P3)

As a person reviewing my activity, I can follow back a new follower or respond to a follow request directly from its row, without leaving the Activity screen.

**Why this priority**: A convenience that increases engagement; the underlying relationship actions already exist elsewhere, so this is additive and P3.

**Independent Test**: With a "started following you" entry and a "requested to follow you" entry present, use the inline control on each and verify the relationship state updates optimistically and reconciles, reusing the existing follow behavior.

**Acceptance Scenarios**:

1. **Given** a "started following you" entry for someone I don't follow, **When** I tap the inline follow-back control, **Then** I follow them and the control reflects the new state immediately, rolling back on failure.
2. **Given** a "requested to follow you" entry, **When** I tap it, **Then** I land on the requester's profile (where the request is handled); inline approve/decline is deferred to #014.

---

### User Story 6 - Inclusive & adaptive (Priority: P3)

As a person using assistive technology, a large text size, or a tablet, the Activity surface is fully usable — every row and control is screen-reader labelled, text scales without truncation or overlap, light and dark render correctly, and the layout reflows between phone (bottom nav) and tablet (sidebar rail) form factors.

**Why this priority**: A release-quality requirement that hardens all prior stories; P3 because it layers onto working screens.

**Independent Test**: Run the Activity surface under a screen reader, at 2× text scale, in light and dark, and at phone and tablet widths, verifying labels, no clipping, correct contrast, and correct chrome per width.

**Acceptance Scenarios**:

1. **Given** a screen reader, **When** I traverse the Activity feed, **Then** each entry announces its actor(s), activity type, target, and time, and each action announces its purpose.
2. **Given** a 2× text scale, **When** entries render, **Then** text wraps without clipping or overlap.
3. **Given** a tablet width, **When** I view Activity, **Then** the Activity entry point and badge appear on the sidebar rail and the screen reflows appropriately; **Given** a phone width, **Then** they appear on the bottom nav.

### Edge Cases

- **Deleted / no-longer-visible target**: an entry whose post, reel, or comment was removed (or is now hidden by a block/privacy change) renders as a degraded, non-tappable row.
- **Missing actor avatar**: actor avatars may be absent; rows render with a name/initial fallback and never break layout.
- **Cold push tap with only a coarse hint**: a push carries only a kind (and, for feed activity, an opaque notification reference) — not the full target — so tapping a push from a cold start opens the Activity screen for feed activity and opens Messages for a direct-message push, rather than jumping to a specific post/profile. In-app live entries (which carry full detail) still deep-link directly.
- **Permission denied or later revoked in system settings**: the app continues to function; no push is received; the app does not nag repeatedly.
- **Realtime down**: the feed and badge fall back to cached state and the last fetched count; they reconcile on reconnect and on next foreground refresh.
- **Duplicate / re-delivered live event**: the same activity delivered twice (e.g., live event plus a later refresh) collapses to one entry — no duplicates in the feed or double-counting in the badge.
- **Direct-message activity**: DM engagement never appears in the Activity feed (it lives in Messages); it may still produce a push.
- **Signed out on another device / token invalid**: an invalid device token is pruned server-side and does not cause client errors.

## Requirements *(mandatory)*

### Functional Requirements

**Activity feed (US1)**

- **FR-001**: The app MUST present an Activity screen listing the signed-in person's notifications, ordered by most-recent activity first, covering these types: like, comment, reply, mention, follow, follow-request, and follow-accepted.
- **FR-001a**: The Activity feed MUST be sectioned by recency — **New** (today) / **This week** (last 7 days) / **Earlier** — newest-first within each section; rows the person has not yet seen (per the server read state) MUST carry an unread accent independent of the time section.
- **FR-002**: The app MUST render notifications as already grouped by the backend (e.g., "Alice and N others…"), showing the most-recent distinct actors and a total actor count; the app MUST NOT compute its own grouping.
- **FR-003**: Each entry MUST show per-type human-readable summary text, actor identity (avatar with a name/initial fallback when the avatar is absent), a target thumbnail where the type has one, and a relative timestamp.
- **FR-004**: The Activity feed MUST paginate (load additional pages on scroll) using the shared cursor-pagination mechanism, and MUST support pull-to-refresh.
- **FR-005**: Tapping an entry MUST navigate to its target: post/reel → the post detail; comment/reply/mention → the post detail focused on that comment; follow/follow-request/follow-accepted → the actor's profile.
- **FR-006**: An entry whose target is deleted or no longer visible MUST render in a degraded, non-tappable state and MUST NOT navigate to a broken destination.
- **FR-007**: The app MUST provide empty, loading, and error-with-retry states for the Activity feed.
- **FR-008**: Opening the Activity screen MUST mark all notifications read (a single mark-all-read action; there is no per-notification read toggle) and clear the unread indicator.

**Unread badge (US3)**

- **FR-009**: The app MUST display an unread-activity badge on the Activity entry point driven by a single authoritative unread count.
- **FR-010**: The badge MUST clear when the person opens the Activity screen (all read) and MUST reflect new activity when it arrives.

**Live / realtime (US4)**

- **FR-011**: The app MUST subscribe to the realtime activity channel and fold an incoming live activity event into the one canonical cached notifications representation, updating both the feed (when visible) and the unread count/badge, without a manual refresh and without any banner/toast cue (the badge is the sole cue).
- **FR-012**: The app MUST remain usable when the realtime channel is unavailable — the Activity feed renders from cached state and the last known count and reconciles on reconnect.
- **FR-013**: A live event that duplicates an already-known notification MUST NOT create a duplicate entry or double-count the badge.

**Push (US2, US5-deep-link)**

- **FR-014**: The app MUST request notification permission the first time the person opens the Activity screen (never on cold app start), showing a value explainer before the system prompt. If the person skips/denies, the app MUST NOT re-prompt automatically and MUST re-offer opt-in only via a subtle in-screen affordance.
- **FR-015**: On permission grant, the app MUST register the device's push token with the backend, and MUST re-register when the token rotates.
- **FR-016**: On sign-out, the app MUST unregister the device's push token (idempotently).
- **FR-017**: The app MUST receive backend pushes and surface a system notification whose copy is generic and free of private content or secrets.
- **FR-018**: Tapping a push MUST route the person: direct-message pushes → Messages; all other (feed-activity) pushes → the Activity screen. (A cold push carries only a coarse hint, so it does not deep-link to a specific post/profile; in-app live entries deep-link directly per FR-005.)
- **FR-019**: If permission is denied or unavailable, the app MUST continue to function with no push registration and MUST NOT prompt repeatedly.

**Follow-back / respond (US5)**

- **FR-020**: A "started following you" entry MUST offer an inline follow-back control that updates optimistically (instant reflect, rollback on failure) and reuses the app's existing follow behavior.
- **FR-021**: A "requested to follow you" entry MUST render the activity and, on tap, route to the requester's profile; inline approve/decline of the request is out of scope this release (deferred to #014).

**Cross-cutting (US6 + platform discipline)**

- **FR-022**: Every Activity row and control MUST be screen-reader labelled, support large text scaling without clipping, render correctly in light and dark, and reflow between phone (bottom nav) and tablet (sidebar rail) widths.
- **FR-023**: The app MUST NOT log push tokens or any secret/private content; all user-facing messaging MUST use the app's standard in-app message surface.
- **FR-024**: The whole notifications surface (feed, badge, device registration) MUST be exercisable without a live backend via the in-memory fakes, so it is testable in a hermetic, zero-network configuration.
- **FR-025**: On sign-out, all locally cached notification data MUST be cleared along with the rest of the user-scoped cache.

### Key Entities *(include if feature involves data)*

- **Notification entry**: one grouped activity item for the signed-in person — a type (like/comment/reply/mention/follow/follow-request/follow-accepted), a set of recent actors plus a total actor count, an optional target it points at, a read flag, and created/updated (latest-activity) timestamps. Grouping and read state are determined server-side.
- **Actor**: a minimal identity for rendering an entry — id, username, display name, and an optional avatar (may be absent).
- **Notification target**: what an entry points at — a kind (post/reel/comment/user), an id, an optional owning-post id (for comment targets), and an optional thumbnail. May be absent when the object was deleted or is no longer visible.
- **Unread count**: the single authoritative number of unread notifications for the signed-in person, used for the badge.
- **Registered device**: an association between the signed-in account and a platform push token (treated as a credential — never displayed or logged), used to deliver pushes; removed on sign-out or when found invalid.
- **Live activity event**: a realtime payload carrying a full notification entry plus the current unread count, folded into the canonical cache.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can open the Activity screen and, within 1 second on a warm cache, see their most recent activity grouped and ordered newest-first.
- **SC-002**: 100% of notification types (like, comment, reply, mention, follow, follow-request, follow-accepted) render with correct summary text and navigate to the correct destination when tapped; direct-message activity never appears in the feed.
- **SC-003**: Opening the Activity screen clears the unread badge, and the badge does not reappear until genuinely new activity arrives.
- **SC-004**: New activity received while the app is open updates the badge (and the feed when visible) within 2 seconds without any manual refresh.
- **SC-005**: With the realtime channel forced offline, the Activity feed and badge still render from cache and fully recover once the connection returns — no crash, no permanent stale state.
- **SC-006**: A granted device receives a system push for backend activity events, and a signed-out device stops receiving them; a denied/skipped device experiences no functional regression elsewhere.
- **SC-007**: No push token or private content ever appears in logs (verified by an automated redaction check).
- **SC-008**: The entire notifications surface passes automated tests in a zero-network (fake) configuration, including grouped entries, deleted targets, pagination, mark-all-read, live-event folding, duplicate suppression, and device register/unregister.
- **SC-009**: The Activity surface passes accessibility and adaptive checks — screen-reader labels present, no clipping at 2× text, correct light/dark, and correct chrome at phone vs tablet widths.

## Assumptions

- **Backend contract is fixed and already shipped**: the notifications, unread-count, mark-all-read, and device register/unregister capabilities plus the realtime activity event exist server-side and are treated as the source of truth; the client is built contract-first against them and adds no server-side behavior.
- **Grouping and read state are server-owned**: the client renders backend-grouped entries and drives read state through the single mark-all-read action; there is no per-notification read/unread toggle and no fetch-one-notification capability.
- **Mark-all-read on open**: opening the Activity screen is treated as "I've seen my activity" and marks everything read (Instagram-style). No separate manual "mark read" control is assumed.
- **Coarse push deep-linking is acceptable for v1**: because a push carries only a kind (and an opaque reference for feed activity, none for DM), a cold push tap opens the Activity screen (feed activity) or Messages (DM) rather than a specific post/profile. In-app live entries carry full detail and deep-link precisely. A future release may add precise cold-push deep-linking if the backend later exposes the needed lookup.
- **Follow-request approval scope** (resolved): approving/declining incoming follow requests is **deferred to #014** (Settings, Privacy & Safety). In this release a follow-request entry renders the activity and, on tap, routes to the requester's profile — no inline approve/decline.
- **Notification preferences are out of scope**: per-category muting, quiet hours, and other notification-preference controls are enforced server-side and surfaced as user-facing settings in a later release (Settings, Privacy & Safety); this release only registers/unregisters the device and requests permission.
- **Real push wiring ships now; credentials deferred** (resolved): this release builds the real push binding — permission request, token receipt/rotation, and device register/unregister — behind a swappable push seam, with an in-memory fake driving hermetic tests. The platform push credentials/native config and on-device push-receipt verification are supplied at real-backend cutover / #015; the app continues to run in the zero-network fake configuration until then.
- **Actor avatars may be absent**: the backend currently omits actor avatar URLs; rows must render gracefully with a fallback and adopt avatars automatically when the backend later provides them.
- **Direct-message pushes reuse the existing DM/Messages surface**: DM engagement is push-only for this feature and never enters the Activity feed; the DM unread experience remains owned by the Messages feature.
