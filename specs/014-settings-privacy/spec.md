# Feature Specification: Settings, Privacy & Safety

**Feature Branch**: `014-settings-privacy`

**Created**: 2026-07-10

**Status**: Draft

**Input**: User description: "Settings, Privacy & Safety (Spec #014) — the We36 settings surface + the privacy/safety controls that other features enforce (Screens 30–32). Settings hub, private account, follow-request approval inbox, close friends, blocking, report, activity status, two-factor entry, language, theme, download-your-data, about."

## Clarifications

### Session 2026-07-10

- Q: Does turning on "Private account" retroactively affect existing followers? → A: Non-retroactive — existing followers are retained; only new follow attempts from non-followers become pending requests.
- Q: Does blocking sever the follow relationship, and does unblocking restore it? → A: Mutual-severing — block removes follow in both directions and cancels pending requests; unblocking does NOT auto-restore the follow (the other party must follow again).
- Q: When a user turns off Activity status, is presence visibility reciprocal? → A: Reciprocal — while off, others cannot see the user as active AND the user cannot see others' active-now/typing status.
- Q: What report reason set, and is free-text allowed? → A: Fixed reason set, no free-text — Spam · Nudity/sexual content · Hate speech/symbols · Violence · Harassment/bullying · False information · Scam/fraud · Self-harm · Other.
- Q: Are language and theme device-scoped or account-scoped? → A: Device-scoped — persisted locally on the device, survive logout and account switch, not synced to the server, and exempt from the FR-033 logout wipe.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reach and navigate my Settings (Priority: P1)

As a signed-in person, I open Settings from my profile and see a clearly grouped list of everything I can control — Account, Privacy, Notifications, Language, Theme, and About — so I can find and reach any control in one place, and I can sign out from here.

**Why this priority**: Settings is the container every other control in this feature lives inside. Without a navigable, grouped hub there is no surface to hang privacy or safety controls on. It is the minimum viable slice: even with only the hub + About + sign-out, the feature delivers a coherent, shippable settings experience.

**Independent Test**: Open Settings from the profile; confirm the grouped sections render, each row navigates to the right destination (or shows its toggle), the app version/build is shown under About, and sign-out returns to the auth gate and clears the local session.

**Acceptance Scenarios**:

1. **Given** I am on my own profile, **When** I tap the Settings entry point, **Then** the Settings hub opens showing grouped sections (Account, Privacy, Notifications, Language, Theme, About).
2. **Given** I am on the Settings hub, **When** I tap "Edit profile", **Then** I am taken to the existing Edit-profile screen.
3. **Given** I am on the Settings hub, **When** I scroll to About, **Then** I see the app name, version, and build number.
4. **Given** I am on the Settings hub, **When** I tap "Log out" and confirm, **Then** my session is cleared and I land on the pre-auth (sign-in) surface.

---

### User Story 2 - Make my account private and approve who follows me (Priority: P1)

As a person who wants control over my audience, I switch my account to private so that new people must request to follow me, and I review pending requests in an approval inbox where I can Approve or Decline each one.

**Why this priority**: Private account + follow-request approval is the core privacy promise of this feature and the carry-over deferred from #010/#013. Approval is the missing half of the private-account model already partially shipped (viewer-side gating exists; the owner-side approval inbox does not).

**Independent Test**: Toggle the account to private; have a test account request to follow; confirm the request appears in the inbox; Approve it and confirm the requester becomes a follower and the follower count increases by exactly one; Decline another and confirm it is removed with no follower added.

**Acceptance Scenarios**:

1. **Given** my account is public, **When** I turn on "Private account", **Then** subsequent follow attempts from non-followers become pending requests rather than immediate follows.
2. **Given** I have pending follow requests, **When** I open the follow-request inbox, **Then** I see each requester (avatar, name, username) with Approve and Decline actions and a count of pending requests.
3. **Given** a pending request, **When** I tap Approve, **Then** the requester becomes a follower, my follower count increases by exactly one, and the row is removed from the inbox.
4. **Given** a pending request, **When** I tap Decline, **Then** the row is removed, no follower is added, and my follower count is unchanged.
5. **Given** I tapped Approve or Decline, **When** the server request fails, **Then** the row is restored to its pending state and I am told the action could not be completed.
6. **Given** I tap Approve twice quickly (retry), **When** both requests reach the server, **Then** the requester is followed exactly once (no duplicate follower).

---

### User Story 3 - Block and report to stay safe (Priority: P1)

As a person facing an unwanted or abusive account, I block them so they immediately disappear from my feed, search, messages, and profile, and I can report an account, post, comment, or reel with a reason so the platform is aware.

**Why this priority**: Safety controls are non-negotiable for a social product and are the "Safety" half of the feature name. Blocking must take effect in the UI immediately across every surface already shipped (#004 feed, #009 search, #012 DM, #010 profile).

**Independent Test**: Block a user from their profile or an action sheet; confirm their content is gone from feed, search results, and conversations, and their profile shows a blocked state; unblock and confirm content returns. Separately, open Report on a user/post/comment/reel, pick a reason, submit, and confirm an acknowledgement.

**Acceptance Scenarios**:

1. **Given** I am viewing another account (profile, feed post, comment, reel, or conversation), **When** I choose Block and confirm, **Then** that account's content is immediately removed from my feed, search results, and conversation list, and their profile shows a blocked state.
2. **Given** I have blocked someone, **When** I open my block list in Settings and unblock them, **Then** their content becomes visible again on subsequent loads.
3. **Given** blocking succeeded, **When** I had a mutual follow with that account, **Then** the follow relationship is removed in both directions.
4. **Given** any account, post, comment, or reel, **When** I choose Report, **Then** I am shown a list of reasons to pick from.
5. **Given** the report reason picker, **When** I select a reason and submit, **Then** I see a confirmation acknowledgement and the sheet closes.
6. **Given** I tap Block twice quickly (retry), **When** both requests reach the server, **Then** the account is blocked exactly once.

---

### User Story 4 - Curate my Close Friends list (Priority: P2)

As someone who shares selectively, I manage a Close Friends list — adding and removing people — so that content I mark for Close Friends (e.g. stories from #005) reaches only them.

**Why this priority**: The Close Friends audience option already ships in stories (#005) but there is no way to manage who is on the list. It is valuable but secondary to the private/block/report core.

**Independent Test**: Open Close Friends from Settings; add several accounts and confirm they appear on the list; remove one and confirm it drops; reopen the list and confirm membership persisted.

**Acceptance Scenarios**:

1. **Given** I open Close Friends, **When** the screen loads, **Then** I see my current Close Friends and a way to add more.
2. **Given** I am adding people, **When** I select an account, **Then** it is added to the list and marked as a Close Friend.
3. **Given** an account is on my Close Friends list, **When** I remove it, **Then** it is no longer marked and no longer receives Close-Friends-only content.
4. **Given** I add and then remove the same account, **When** I reopen the list, **Then** membership reflects the final state (idempotent, no duplicates).

---

### User Story 5 - Set my language and theme (Priority: P2)

As a bilingual user, I choose the app language (English, Vietnamese, or follow the system) and the appearance (light, dark, or follow the system) so the app matches my preference, and the choice persists across launches.

**Why this priority**: Language and theme are expected settings and low-risk, but the app is already usable without them, so they rank below privacy and safety.

**Independent Test**: Change language to Vietnamese and confirm UI copy switches; change theme to dark and confirm the palette switches; relaunch the app and confirm both preferences persisted; set each back to "System" and confirm it follows the device.

**Acceptance Scenarios**:

1. **Given** the language selector, **When** I choose Vietnamese, **Then** the app UI copy switches to Vietnamese immediately.
2. **Given** the language selector, **When** I choose "System", **Then** the app follows the device language (falling back to English if the device language is unsupported).
3. **Given** the theme selector, **When** I choose Dark (or Light, or System), **Then** the app appearance switches accordingly.
4. **Given** I set language and theme, **When** I close and relaunch the app, **Then** both preferences are still applied.

---

### User Story 6 - Manage secondary account, privacy & data controls (Priority: P2)

As a privacy-conscious user, I control my activity status visibility, reach the two-factor authentication and download-your-data entry points, and understand what each does, so I can tune my account beyond the core toggles.

**Why this priority**: These are expected but lower-frequency controls; two-factor and download-your-data are surface/entry points in this release, so they add polish rather than core value.

**Independent Test**: Toggle activity status off and confirm the preference is stored (and that presence-dependent surfaces respect it); open the two-factor and download-your-data entries and confirm each presents its (entry-only) screen without error.

**Acceptance Scenarios**:

1. **Given** activity status is on, **When** I turn it off, **Then** the preference is saved and surfaces that show my presence (e.g. active-now in messages) stop showing me as active.
2. **Given** the Privacy section, **When** I open "Two-factor authentication", **Then** I see the two-factor entry screen (surface only; full enrolment is out of scope).
3. **Given** the Account section, **When** I open "Download your data", **Then** I see the download-your-data entry screen (surface only).

---

### User Story 7 - Accessible and adaptive across devices (Priority: P3)

As a user on a phone or a tablet, with large text or a screen reader, I can use every Settings, Privacy, and Safety control comfortably in both light and dark themes.

**Why this priority**: Inclusive/adaptive hardening is required by the constitution and is applied as a final pass once the surfaces exist.

**Independent Test**: Run the Settings surfaces at 2× text scale, in light and dark, on phone and tablet widths, and with a screen reader; confirm no truncation, correct reflow (tablet uses the sidebar/two-pane chrome), and meaningful labels on every control.

**Acceptance Scenarios**:

1. **Given** any Settings surface, **When** I enable a screen reader, **Then** every row, toggle, and action announces a meaningful label and state.
2. **Given** any Settings surface, **When** I set text scale to 2×, **Then** content remains readable with no clipped labels.
3. **Given** a tablet/iPad width, **When** I open Settings, **Then** it uses the sidebar/adaptive chrome consistent with the rest of the app.

---

### Edge Cases

- **Going private with existing followers**: current followers remain followers; only *new* follow attempts become pending requests (going private is not retroactive).
- **Requester withdraws / already followed**: a pending request that is withdrawn, or whose requester was approved on another device, disappears from the inbox without error (the inbox reconciles to server truth).
- **Blocking someone with a pending follow request**: blocking removes any pending request and any follow relationship in both directions.
- **Blocking within an open conversation**: the conversation is removed/hidden and further messages from the blocked account are not delivered in the UI.
- **Reporting a target that was deleted**: report still submits (or degrades gracefully with an acknowledgement) rather than erroring.
- **Unsupported device language with "System" selected**: the app falls back to English.
- **Offline**: privacy/safety toggles and approvals fail gracefully with rollback and a message; language/theme (local preferences) still apply.
- **Logout**: all locally cached privacy/safety state and preferences that are account-scoped are cleared on logout (theme/language may be device-scoped — see Assumptions).

## Requirements *(mandatory)*

### Functional Requirements

#### Settings hub (US1)

- **FR-001**: The system MUST provide a Settings surface reachable from the person's own profile, organized into labelled groups: Account, Privacy, Notifications, Language, Theme, and About.
- **FR-002**: The Settings hub MUST provide entry points to the existing Edit-profile surface and to sign out.
- **FR-003**: Signing out MUST clear the local session and return the user to the pre-auth surface, consistent with the existing session-logout behaviour.
- **FR-004**: The About section MUST display the app name, version, and build number.

#### Private account & follow requests (US2)

- **FR-005**: Users MUST be able to toggle their account between public and private.
- **FR-006**: While private, a follow attempt from someone who is not already an approved follower MUST become a pending follow request instead of an immediate follow.
- **FR-007**: Turning on private MUST NOT retroactively convert existing followers into pending requests.
- **FR-008**: Users MUST be able to view a list of pending incoming follow requests, each showing the requester's avatar, name, and username, plus a count of pending requests.
- **FR-009**: Users MUST be able to Approve a pending request, which adds the requester as a follower and increases the owner's follower count by exactly one.
- **FR-010**: Users MUST be able to Decline a pending request, which removes it with no follower added and no count change.
- **FR-011**: Approve/Decline MUST be optimistic (immediate UI update) with rollback and a user-facing message on failure.
- **FR-012**: Approve/Decline MUST be idempotent — a retried Approve results in the requester being followed exactly once.

#### Blocking (US3)

- **FR-013**: Users MUST be able to block another account from that account's profile and from a shared action sheet available on posts, comments, reels, **stories**, and **conversations (DM)** — i.e. every content surface (Constitution I).
- **FR-014**: Blocking MUST take effect immediately in the UI: the blocked account's content is removed from the blocker's feed, search results, and conversation list, and the blocked profile shows a blocked state.
- **FR-015**: Blocking MUST remove any existing follow relationship between the two accounts in both directions and cancel any pending follow request between them.
- **FR-016**: Users MUST be able to view a list of accounts they have blocked and unblock any of them; unblocking restores visibility of that account's content on subsequent loads but MUST NOT auto-restore the previously-severed follow relationship (either party must follow again).
- **FR-017**: Block and unblock MUST be idempotent (a retried block yields exactly one blocked relationship).

#### Report (US3)

- **FR-018**: Users MUST be able to report an account, post, comment, reel, **story**, or **conversation/message** via the shared action sheet (Constitution I — report reachable from every surface). Target types map to the backend `ReportTargetType` enum (`post·reel·comment·story·user·message`).
- **FR-019**: The report flow MUST present a fixed list of selectable reasons (no free-text), aligned to the backend `ReportReason` enum: Spam, Nudity or sexual content, Harassment or bullying, Hate speech, Violence, Self-harm, False information, Intellectual-property violation, Other. Exactly one reason is selected per report. (Reconciled at plan against the real backend `POST /reports` contract — the earlier "Scam or fraud" wording is replaced by "Intellectual-property violation".)
- **FR-020**: Submitting a report MUST show a confirmation acknowledgement; the report outcome is surface-only (no moderation result is shown to the reporter in this release).

#### Close friends (US4)

- **FR-021**: Users MUST be able to view, add to, and remove from a Close Friends list.
- **FR-022**: Close Friends membership MUST persist and be idempotent (no duplicate members).
- **FR-023**: The Close Friends list MUST be the same audience consumed by the stories "Close friends" option already shipped.

#### Language & theme (US5)

- **FR-024**: Users MUST be able to choose the app language among English, Vietnamese, and System.
- **FR-025**: Choosing a language MUST switch the in-app copy immediately; "System" MUST follow the device language and fall back to English when unsupported.
- **FR-026**: Users MUST be able to choose the appearance among Light, Dark, and System; the colour palette itself is fixed (no scheme/colour picker).
- **FR-027**: Language and theme selections MUST persist across app launches. They are **device-scoped**: stored locally on the device, kept across logout and account switch, and not synced to the server.

#### Secondary controls (US6)

- **FR-028**: Users MUST be able to toggle Activity status. Visibility is **reciprocal**: while off, surfaces that display the user's presence MUST stop showing them as active to others, AND the user MUST NOT see others' active-now/typing status (e.g. in messages).
- **FR-029**: The system MUST provide entry-point screens for Two-factor authentication and Download-your-data (surface only; full enrolment/export backend is out of scope).

#### Cross-cutting (US7 + constitution)

- **FR-030**: Every Settings/Privacy/Safety surface MUST provide meaningful screen-reader labels and states, remain legible at 2× text scale, and render correctly in both light and dark themes.
- **FR-031**: Settings surfaces MUST adapt between phone and tablet/iPad chrome consistent with the rest of the app.
- **FR-032**: All new user-facing copy MUST be provided in both English and Vietnamese.
- **FR-033**: All account-scoped privacy/safety state cached locally MUST be cleared on logout. Device-scoped app preferences (language, theme — FR-027) are exempt and MUST survive logout.
- **FR-034**: No privacy/safety action MUST log secrets or personal identifiers beyond what existing logging conventions allow.

### Key Entities *(include if feature involves data)*

- **Privacy settings**: the account-level flags a user controls — private-account on/off, activity-status on/off — and their persisted state.
- **App preferences**: device/user-level UI choices — language (English/Vietnamese/System) and theme (Light/Dark/System).
- **Follow request**: a pending incoming request to follow a private account — requester summary (avatar, name, username), plus its pending/approved/declined state.
- **Block relationship**: the fact that one account has blocked another — used to hide content across surfaces and to enforce mutual unfollow.
- **Close friend membership**: the set of accounts a user has designated as close friends.
- **Report**: a user-submitted flag against a target (account, post, comment, or reel) with a selected reason.
- **App info**: the app name, version, and build number surfaced under About.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can reach any control in this feature (privacy toggle, block list, report, close friends, language, theme) from the profile in at most 3 taps.
- **SC-002**: After turning on private account, 100% of new follow attempts from non-followers arrive as pending requests rather than immediate follows.
- **SC-003**: Approving a follow request increases the owner's follower count by exactly one; declining changes it by zero — verified with no drift after repeated (retried) actions.
- **SC-004**: After blocking an account, that account's content is absent from the blocker's feed, search, and conversation list within the same session (no reload of the app required).
- **SC-005**: A blocked-then-unblocked account's content reappears on the next load, and blocking is exactly-once under retries (no duplicate block state).
- **SC-006**: Language and theme selections survive an app restart 100% of the time.
- **SC-007**: Every interactive control on every Settings surface exposes a non-empty accessibility label and remains legible at 2× text scale in both themes (automated coverage green).
- **SC-008**: No secret or access credential appears in logs produced by any privacy/safety action (automated redaction check green).

## Assumptions

- **Backend contract exists (B#014)**: the client is contract-driven over the versioned REST API for private-account, follow-request approve/decline, block/unblock + block list, report, close-friends, and activity-status; each repository ships with an in-memory fake so the app builds and tests without a live server (app continues to run DI `environment: 'fake'`).
- **Going private is not retroactive** (FR-007): existing followers are retained; only new follow attempts become requests. (Flag for `/speckit.clarify` if product wants retroactive conversion.)
- **Blocking is mutual-severing** (FR-015): consistent with common social-app behaviour, a block removes the follow relationship both ways and cancels pending requests.
- **Report is surface-only**: the fixed reason set is locked (FR-019, no free-text); the reporter sees only an acknowledgement, no moderation outcome.
- **Two-factor and download-your-data are entry points only** in this release; full enrolment and data-export backends are out of scope (deferred to a later spec).
- **Theme and language are device-scoped preferences** (persist locally, survive logout); account-scoped privacy/safety state is cleared on logout (FR-033).
- **Reuse**: relationship/follow store + optimistic toggle (#010) for follow requests and mutual unfollow; presence/activity-status seam (#012) for activity status; close-friends audience already consumed by stories (#005); existing session-logout; shared settings-row / switch / action-sheet / dialog widgets (#001); the 4-state cubit pattern.
- **Design source**: Screens 30–32 (Settings, Privacy & security, Report/block) from the We36 design system are the UI reference.

## Out of Scope

- Full account-deletion backend flow (a delete-account entry may be surfaced, but the deletion pipeline is out of scope).
- Notification-preference granularity beyond the on/off toggles reachable here (per-type notification tuning is deferred).
- Full two-factor enrolment (OTP/authenticator/backup codes) and full personal-data export — entry points only this release.
- Any ranking, recommendation, or moderation-decision surfacing.
