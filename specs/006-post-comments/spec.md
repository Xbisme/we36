# Feature Specification: Post Detail & Comments

**Feature Branch**: `006-post-comments`

**Created**: 2026-07-02

**Status**: Draft

**Input**: User description: "Post Detail & Comments (#006) — the last sibling of the content-creation trio. Open a full-screen Post detail from the feed and read/write comments (paginated list, one-level replies, quick-emoji, optimistic add, like, delete/report), offline in fake mode; tablet renders a two-pane single-post master/detail."

## Clarifications

### Session 2026-07-02

- Q: Comment display order (affects optimistic insert position + pagination direction) → A: Oldest-first (chronological); new comments/replies append at the end of their group.
- Q: Maximum comment length → A: 2,200 characters (Instagram-standard).
- Q: What does the post comment count include, and how does deleting a parent with replies change it? → A: Count includes all comments + replies; deleting a top-level comment cascade-removes its replies and decrements the count by (1 + number of replies), keeping count == number of visible entries.
- Q: Quick-emoji row behavior → A: Tapping a quick-emoji inserts it into the comment input (does not post immediately); the person still taps Post.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Open a post and read its comments (Priority: P1)

A person tapping a post in the feed (or its "View all N comments" affordance) opens a full-screen post detail showing the full post, then reads the conversation: a scrollable, paginated list of comments — each with the author's avatar, name, text, relative time, like count, and any one level of replies.

**Why this priority**: This is the readable surface the whole feature hangs on — a person must be able to reach and read the conversation before any writing matters. It delivers standalone value (deeper engagement with a post) and is the MVP.

**Independent Test**: From the feed, open a post → the detail renders the post + a paginated comment list → scroll loads more → replies appear nested one level under their parent. Fully testable on fakes with no network.

**Acceptance Scenarios**:

1. **Given** a feed post with comments, **When** the person taps the post (or "View all N comments"), **Then** a full-screen post detail opens (no bottom nav) showing the post and its first page of comments.
2. **Given** a comment list longer than one page, **When** the person scrolls to the end, **Then** the next page loads and appends without losing scroll position.
3. **Given** a comment that has replies, **When** the list renders, **Then** replies show indented one level directly under their parent comment.
4. **Given** a post with zero comments, **When** the detail opens, **Then** a friendly empty state invites the first comment.
5. **Given** the first load fails, **When** the detail opens, **Then** an error state with a retry action is shown; retry re-attempts the load.

---

### User Story 2 - Add a comment (Priority: P2)

A person types a comment into the input row and posts it; it appears instantly at the end of the conversation and the post's comment count increases — even before the server confirms.

**Why this priority**: Writing is the core engagement action of the feature; it follows directly from being able to read (P1) and is the primary reason people open comments.

**Independent Test**: Type text → Post → the comment appears immediately in the list and the post's comment count increments; on a simulated failure it rolls back with a message; a retry that reuses the same request produces exactly one comment.

**Acceptance Scenarios**:

1. **Given** the input row with text, **When** the person taps Post, **Then** the comment appears immediately at the end of the list, the input clears, and the post's comment count increments — with no manual refresh.
2. **Given** an optimistic comment whose submission fails, **When** the failure is known, **Then** the comment is rolled back, the count is restored, and a message explains the failure with a way to try again.
3. **Given** a submission is retried after a transient failure, **When** it succeeds, **Then** exactly one comment exists (no duplicate).
4. **Given** a post whose commenting is turned off, **When** the detail opens, **Then** the input row is hidden (read-only) while existing comments still render.
5. **Given** an empty or whitespace-only input, **When** the person tries to Post, **Then** posting is disabled.

---

### User Story 3 - Reply to a comment (Priority: P2)

A person replies to an existing comment; the reply appears indented one level under that comment. Replies to a reply still attach to the same top-level comment (one level only).

**Why this priority**: Replies turn a flat list into a conversation and are expected of a comments surface, but they build on the add-comment flow (P2) rather than standing alone.

**Independent Test**: Tap Reply on a comment → a reply-to context appears → post → the reply shows indented under the target top-level comment; replying to a reply still lands under the same top-level parent.

**Acceptance Scenarios**:

1. **Given** a comment, **When** the person taps Reply and posts text, **Then** the reply appears indented one level under that comment (optimistically), and the count increments.
2. **Given** the person taps Reply on a reply (not a top-level comment), **When** they post, **Then** the reply attaches to the same top-level comment (never a second level of nesting).
3. **Given** a reply-to context is active, **When** the person cancels it, **Then** the input returns to posting a top-level comment.

---

### User Story 4 - Like a comment (Priority: P3)

A person taps the small like glyph on a comment; the liked state and like count update instantly and revert on failure.

**Why this priority**: A lightweight appreciation signal that enriches the list but is not required for the conversation to function.

**Acceptance Scenarios**:

1. **Given** an un-liked comment, **When** the person taps its like glyph, **Then** it shows liked and the like count increases immediately.
2. **Given** the like submission fails, **When** the failure is known, **Then** the liked state and count revert and a message is shown.
3. **Given** a rapid double-tap on like/unlike, **When** submissions settle, **Then** the final state matches the last intended action (target-state, no drift).

---

### User Story 5 - Manage a comment: delete own / report others' (Priority: P3)

From a comment's action sheet, a person can delete their own comment (with confirmation) or report someone else's.

**Why this priority**: Basic hygiene and safety affordances; valuable but secondary to reading and writing.

**Acceptance Scenarios**:

1. **Given** the person's own comment, **When** they open its action sheet and confirm Delete, **Then** the comment is removed immediately and the post's comment count decrements.
2. **Given** a delete that fails, **When** the failure is known, **Then** the comment is restored and a message is shown.
3. **Given** another person's comment, **When** they open its action sheet and choose Report, **Then** the report is acknowledged with a confirming message (no enforcement action taken).
4. **Given** a comment with replies is deleted, **When** it is removed, **Then** the list stays consistent (its replies handled per the deletion rule — see Assumptions).

---

### User Story 6 - Comments on a tablet (Priority: P3)

On a tablet/iPad, opening a post shows a two-pane layout — the post media on the left and the author header, comments, and input on the right — instead of a pushed screen; on a phone the pushed full-screen experience is unchanged.

**Why this priority**: Adaptive polish for large screens; the same behavior is fully usable via the phone layout, so it is additive.

**Acceptance Scenarios**:

1. **Given** a wide (tablet) window, **When** a post is opened, **Then** a two-pane layout shows media on the left and comments/input on the right, with no separate pushed navigation.
2. **Given** a narrow (phone) window, **When** a post is opened, **Then** the full-screen pushed detail is shown.
3. **Given** either layout, **When** comments are read/added/liked/deleted, **Then** behavior is identical (presentation differs, logic does not).

---

### Edge Cases

- **Offline / from cache**: opening a post while offline shows the cached post and a clear message that comments cannot load, with retry — never a crash or blank screen.
- **Very long comment / max length**: comment text beyond the allowed length is prevented at input.
- **Rapid submits**: posting several comments quickly keeps ordering stable and each optimistic entry reconciles to its confirmed entry without duplication.
- **Count consistency**: the post's comment count shown here and in the feed stays consistent (one canonical post representation) across add/delete.
- **Deleted-by-other / stale**: attempting to like or reply to a comment that no longer exists surfaces a graceful message, not an error dump.
- **Mentions/hashtags in text**: `@mentions` and `#hashtags` render styled but are non-interactive in this feature.
- **Long comment thread performance**: scrolling a long thread stays smooth (bounded memory, lazy list).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST let a person open a full-screen post detail for a specific post from the feed (tapping the post or its "View all N comments" affordance), presented as a nav-less route on phones.
- **FR-002**: The post detail MUST render the full post (media, author, caption, actions, counts) reusing the existing feed post presentation, plus an entry into the comment conversation.
- **FR-003**: The system MUST display comments as a paginated list, loading additional pages as the person scrolls, showing for each comment: author avatar, author name, text, relative time, like count and liked state, a Reply action, and a like control.
- **FR-004**: The system MUST show replies indented exactly one level beneath their top-level comment; it MUST NOT render or create nesting beyond one level.
- **FR-005**: The system MUST let a person add a top-level comment, appended to the conversation optimistically (before confirmation) with the post's comment count updated accordingly.
- **FR-006**: The system MUST let a person reply to a comment; a reply to any comment or reply attaches to the same top-level comment (one level).
- **FR-007**: Comment and reply submissions MUST be idempotent — a retry of the same submission MUST result in exactly one created comment (no duplicates).
- **FR-008**: On submission failure, the system MUST roll back the optimistic comment/reply, restore the comment count, and show a message with a way to retry.
- **FR-009**: The system MUST let a person like/unlike a comment with an immediate (optimistic) update to liked state and like count, reverting on failure, and settling to the last intended state on rapid toggles.
- **FR-010**: The system MUST let a person delete their own comment via an action sheet with confirmation, removing it immediately and decrementing the post's comment count, reverting on failure.
- **FR-011**: The system MUST let a person report another person's comment via an action sheet, acknowledging the report with a confirming message; no enforcement or content change results (moderation is out of scope).
- **FR-012**: When a post has commenting turned off, the system MUST hide the comment input (read-only) while still displaying any existing comments.
- **FR-013**: The system MUST prevent posting empty/whitespace-only comments and MUST prevent text beyond the maximum allowed comment length of **2,200 characters**.
- **FR-014**: The system MUST render `@mentions` and `#hashtags` within comment text with distinct styling; these MUST be non-interactive in this feature (navigation deferred).
- **FR-015**: The system MUST keep the post's comment count consistent between the post detail and the feed (a single canonical representation of the post), reflecting adds and deletes without a manual refresh. The count includes both top-level comments and replies (count == number of visible entries); deleting a top-level comment with replies cascade-removes its replies and decrements the count by (1 + number of replies).
- **FR-016**: The system MUST present empty, loading, error-with-retry, and offline-from-cache states for the comment list.
- **FR-017**: All user-facing messages (success, failure, report acknowledgement) MUST use the app's standard in-app message affordance (not a system snackbar).
- **FR-018**: On tablet/iPad-width windows, the post detail MUST render as a two-pane layout (media pane + comments/input pane) for a single post; on phone-width windows it MUST use the pushed full-screen layout. Behavior MUST be identical across layouts.
- **FR-019**: The comment experience MUST be fully operable with no live backend (fake data), so the whole flow can be demonstrated and tested offline.
- **FR-020**: The system MUST NOT log comment text, author identity, or other personal data.
- **FR-021**: The comment surface MUST be accessible: screen-reader labels for comments and controls, support for enlarged text, and correct rendering in both light and dark appearance.

### Key Entities *(include if feature involves data)*

- **Comment**: one entry in a post's conversation. Attributes: identifier; the post it belongs to; author (avatar, name, verified flag); text; creation time (for relative display); like count and viewer-liked state; whether it is a reply and, if so, the top-level comment it belongs to; and whether it belongs to the current viewer (governs delete-vs-report). A pending optimistic comment additionally carries a client-generated request identity so retries reconcile to a single entry.
- **Post** (existing): the content being discussed. This feature reads and updates its comment count and reads its "commenting turned off" flag; it remains the single canonical representation shared with the feed.
- **Comment page**: a slice of the conversation plus a cursor indicating whether/where more comments follow.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: From the feed, a person can open a post and see its first comments within 1 second in normal conditions (and immediately from cache for the post itself).
- **SC-002**: A posted comment appears in the conversation in under 300 ms of tapping Post (optimistic), with zero manual refresh.
- **SC-003**: Retrying a failed comment submission never creates more than one comment (0% duplicate rate across retries).
- **SC-004**: A failed comment/like/delete always returns the list and counts to their pre-action state (100% rollback correctness) with a message shown.
- **SC-005**: The post's comment count shown in the detail and in the feed match at all times after an add or delete (no divergence).
- **SC-006**: The entire read/add/reply/like/delete/report journey completes with no network access (fake mode).
- **SC-007**: Replies never exceed one level of nesting in any scenario.
- **SC-008**: The comment surface passes accessibility, enlarged-text, and light/dark checks on both phone (pushed) and tablet (two-pane) layouts.

## Assumptions

- **Comment ordering**: comments are shown oldest-first (chronological reading order); a newly added comment/reply appends at the end of its group. (Confirmed — see Clarifications 2026-07-02.)
- **Quick-emoji row**: tapping a quick-emoji inserts that emoji into the comment input (it does not post immediately). (Confirmed — see Clarifications 2026-07-02.)
- **Page size**: comment pages use the app's standard cursor page size (aligned with the feed, ~20).
- **Deleting a parent with replies**: deleting a top-level comment cascade-removes it and its replies from view; the count decrements by (1 + number of replies). (Confirmed — see Clarifications 2026-07-02.)
- **Backend contract**: a real `comments` contract exists (list, add, reply, like, delete, report); this feature builds the real client seam against it plus an in-memory fake, and the app runs on the fake (zero-network) until real cutover — consistent with how posts/feed were built.
- **Comment caching**: the comment list is loaded per detail session (transient pagination) and is not persisted to the local cache; only the post remains the canonically cached item. Offline shows the cached post with an unavailable-comments message.
- **Report handling**: reporting is surface-only (acknowledged, no enforcement); real moderation and blocked-state handling are a later feature.
- **Mention/hashtag navigation**: styling only; tapping does not navigate (profile/tag pages are later features).
- **Auth/session, feed, media, adaptive shell**: the existing session gate, feed post model & card, and the two-pane/master-detail primitive are reused as-is.

## Dependencies

- Home Feed & Stories (#004): the canonical post model & card, and the optimistic like/save pattern reused for comment like.
- Networking, Cache & Realtime Core (#002): the paginated-list mechanism, request/error handling, idempotent-mutation seam, and result/failure types.
- Foundation & Navigation (#001): the two-pane/master-detail primitive, text input, action sheet, and in-app message affordance; the auth-guarded router.
- A backend `comments` contract (list/add/reply/like/delete/report); until real cutover the in-memory fake stands in.

## Out of Scope

- Reply nesting beyond one level.
- Tapping `@mentions`/avatars to open profiles (deferred to Profile & Follow).
- Comment moderation, blocked-state enforcement, and hiding/limiting comments (deferred to Settings, Privacy & Safety).
- Comment stickers/GIFs/images, pinned comments, comment translation, and reactions beyond a single like.
- Persisting the comment list offline.
</content>
