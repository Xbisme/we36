# Feature Specification: Direct Messages (Realtime)

**Feature Branch**: `012-direct-messages`

**Created**: 2026-07-07

**Status**: Draft

**Input**: User description: "Direct Messages (Realtime) — the private 1-1 messaging surface for We36, the Messages bottom tab (Screens 25–28). First spec to wire the live realtime channel (RealtimeClient / SocketEvents scaffolded inert in #002). Conversation list, 1-1 chat with optimistic+idempotent send and delivery/typing/presence, rich content (photo / shared post / stickers), new-message compose, tablet two-pane master/detail, inclusive & adaptive. App stays on DI fake for hermetic tests; real Socket.IO behind env:['real']."

## Clarifications

### Session 2026-07-07

- Q: Who may start a conversation, and where do messages from strangers go? → A: Any non-blocked user may be messaged; all conversations land directly in the list — **no message-requests inbox in v1.0** (deferred to #014).
- Q: How deep is the per-message delivery state? → A: Model all four (`sending → sent → delivered → read`); if the backend does not distinguish *delivered*, the client collapses *delivered* → *sent* without changing the surface.
- Q: How granular is presence? → A: Coarse only — online/offline dot + "Active now" + typing; **no "last seen" timestamp** in v1.0 (deferred).
- Q: Does sending a photo go through the full post editor or a quick pick-and-send? → A: Quick **pick → upload → send** (reuse #007 pick/compress/upload only; no crop/filter); one photo per message.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Conversation list (Priority: P1)

A signed-in person opens the **Messages** tab and immediately sees their private 1-1 conversations, most-recently-active first. Each row shows the other person's avatar (with an online indicator when they are active), their name (emphasised while there are unread messages), a one-line preview of the last message — replaced by a live "typing…" cue when the other person is composing — a relative timestamp, and an unread marker. A horizontal "active now" rail at the top surfaces contacts who are currently online. The person can search within their conversations/people and tap **+** to start a new message. The number of conversations with unread messages is reflected on the Messages tab badge. The list appears instantly from local cache on open and quietly reconciles with the server in the background; when there is no connection it still shows the last known conversations.

**Why this priority**: The list is the entry point to the entire messaging surface and is independently valuable — a person can triage who has written to them and see who is online even before opening a thread. It is the smallest slice that makes the Messages tab useful.

**Independent Test**: Seed a set of conversations (some unread, one with an active "typing" state, one with an online participant); open the Messages tab and verify ordering (newest activity first), unread emphasis + badge, last-message/typing preview, the active-now rail, in-list search filtering, the **+** entry point, and that the list renders from cache with no network and reconciles when the backend responds.

**Acceptance Scenarios**:

1. **Given** the person has several 1-1 conversations with differing last-activity times, **When** they open the Messages tab, **Then** conversations are listed newest-activity-first with avatar, name, last-message preview, timestamp, and an unread marker on those with unread messages.
2. **Given** a conversation has unread messages, **When** the list renders, **Then** its row is visually emphasised and the Messages tab shows an unread badge reflecting the count of conversations with unread messages.
3. **Given** the other participant in a visible conversation is currently typing, **When** the list is on screen, **Then** that row shows a live "typing…" cue in place of the last-message preview.
4. **Given** the device is offline, **When** the person opens the Messages tab, **Then** the last cached conversation list is shown, and when connectivity returns the list reconciles without a manual refresh.
5. **Given** the person types into the in-list search, **When** the query matches conversation participants, **Then** the list filters to matching conversations/people.

---

### User Story 2 - 1-1 chat with realtime send & receive (Priority: P1)

A person opens a conversation and sees the message thread — their own messages aligned right in the brand style, the other person's aligned left, grouped by author and time. They type a text message and send it: it appears immediately (optimistic) and shows its own progress from *sending* to *sent*, then *delivered*, then *read*. Messages the other person sends arrive live and append to the thread without a refresh. While the other person types, a typing indicator shows; their presence ("Active now") is reflected in the header. Opening/viewing the conversation marks it read, clearing its unread marker and badge. The thread remains readable from cache when realtime is unavailable, and any messages sent while disconnected are queued and flushed automatically on reconnect. A retried send never produces a duplicate message.

**Why this priority**: Sending and receiving text in real time is the core purpose of the feature; without it there is no messaging. Together with US1 it is the MVP.

**Independent Test**: Open a seeded conversation; send a text message and verify it appears optimistically and advances through delivery states; drive an inbound message via the fake realtime channel and verify it appends live; drive a typing/presence event and verify the indicator/header update; verify viewing marks the conversation read (badge clears); simulate a dropped connection and verify the thread still reads from cache, a queued send flushes on reconnect, and a retried send yields exactly one message.

**Acceptance Scenarios**:

1. **Given** an open conversation, **When** the person sends a text message, **Then** it appears immediately in the thread marked *sending* and updates to *sent* once accepted, *delivered* when the recipient's device receives it, and *read* when the recipient views it.
2. **Given** an open conversation, **When** the other participant sends a message, **Then** it appends to the thread live without a manual refresh.
3. **Given** an open conversation, **When** the other participant is typing, **Then** a typing indicator appears in the thread and their presence is reflected in the header.
4. **Given** an unread conversation, **When** the person opens/views it, **Then** it is marked read, its unread marker and the tab badge clear, and the other participant's copy reflects the read state.
5. **Given** the realtime connection drops, **When** the person is in a conversation, **Then** the thread still shows cached messages, a message sent while offline is queued and delivered automatically on reconnect, and retrying a failed send does not create a duplicate.
6. **Given** a message failed to send, **When** the person retries it, **Then** the system delivers exactly one message (idempotent send).

---

### User Story 3 - Rich message content: photo, shared post, stickers (Priority: P2)

Beyond text, a person can send a **photo** (picked and uploaded through the existing media pipeline), a **shared post or reel** as a tappable card that deep-links to that post/reel (the "Message" action from a profile or a content share sheet lands a shared-post message into the conversation), and **stickers/emoji** from the existing sticker tray. Received rich messages render as the appropriate bubble — a photo bubble, a shared-post/reel card, or a sticker — and the shared-post/reel card opens its destination when tapped.

**Why this priority**: Rich content is what makes messaging social rather than plain texting and is the primary way content circulates privately, but text messaging (US2) already delivers the core value, so this layers on top.

**Independent Test**: From an open conversation, send a photo and verify it uploads and renders as a photo bubble with progress/failure handling; trigger a shared-post/reel message (from a profile "Message" action or a content share) and verify it renders as a card that deep-links to the post/reel; open the sticker tray and send a sticker and verify it renders as a sticker bubble; verify inbound rich messages render correctly.

**Acceptance Scenarios**:

1. **Given** an open conversation, **When** the person picks and sends a photo, **Then** it uploads through the media pipeline and appears as a photo message (with send progress and a retry path on failure).
2. **Given** a post or reel elsewhere in the app, **When** the person shares it to a conversation (via the profile "Message" action or a content share sheet), **Then** a shared-post/reel card message appears in that conversation and tapping it opens the corresponding post/reel.
3. **Given** an open conversation, **When** the person opens the sticker tray and selects a sticker, **Then** the sticker is sent and renders as a sticker bubble.
4. **Given** the other participant sends a photo, shared post, or sticker, **When** it arrives, **Then** it renders as the matching bubble type in the thread.

---

### User Story 4 - New message / start a conversation (Priority: P2)

A person taps **+** and reaches a compose screen with a "To:" search over people (suggested = people they follow and recent contacts). They pick one person to start (or open) a 1-1 conversation. If a conversation with that person already exists, it opens the existing thread rather than creating a duplicate.

**Why this priority**: Needed to initiate new conversations, but existing conversations (US1/US2) already deliver value, so it is a fast follow rather than part of the minimal core.

**Independent Test**: Tap **+**; search people and confirm suggestions (followed/recent); select a person with no existing conversation and verify a new thread opens; select a person who already has a conversation and verify the existing thread opens (no duplicate created).

**Acceptance Scenarios**:

1. **Given** the compose screen, **When** the person searches for a name, **Then** matching people appear (with followed/recent people suggested by default) and one can be selected.
2. **Given** a selected person with no existing conversation, **When** the person confirms, **Then** a new 1-1 conversation opens ready to send the first message.
3. **Given** a selected person the user already has a conversation with, **When** the person confirms, **Then** the existing conversation opens and no duplicate conversation is created.

---

### User Story 5 - Tablet / iPad two-pane (Priority: P2)

On a tablet or iPad (wide layout), Messages renders as a master/detail split: the conversation list on the left and the full chat on the right. Selecting a conversation swaps the right pane in place without navigating to a new screen. On a phone (narrow layout) the same conversations and chat are reached by push navigation. The new-message and sticker surfaces render as a centered-mobile layout on wide screens.

**Why this priority**: Adaptive tablet layout is a constitutional requirement and a major usability win on iPad, but the feature is fully usable on phones first, so it hardens the experience rather than gating it.

**Independent Test**: Render Messages at a wide width and verify the list + chat appear side by side, selecting a row swaps the right pane without a push, and the selected row is highlighted; render at a narrow width and verify push navigation; verify new-message/sticker use the centered-mobile fallback on wide screens — all sharing the same conversation/chat state as the phone flow.

**Acceptance Scenarios**:

1. **Given** a wide (tablet/iPad) layout, **When** Messages is shown, **Then** the conversation list and an open chat appear side by side and the selected conversation is highlighted.
2. **Given** the two-pane layout, **When** the person selects a different conversation, **Then** the right pane swaps to that chat in place without a new screen being pushed.
3. **Given** a narrow (phone) layout, **When** the person opens a conversation, **Then** the chat is shown via push navigation, preserving the same behaviour and state.

---

### User Story 6 - Inclusive & adaptive hardening (Priority: P2)

The messaging surface is usable with a screen reader (meaningful labels on conversation rows, message bubbles, send/attach controls, and presence), tolerates 2× text scaling without clipping, renders correctly in both light and dark themes, and reflows correctly between phone and tablet. All user-facing feedback is delivered through the app's standard message surface (never a default snackbar), and logging never records message contents, tokens, or media references.

**Why this priority**: Accessibility and adaptive correctness are constitutional non-negotiables applied as a hardening pass once the surfaces exist.

**Independent Test**: With a screen reader, verify labels on rows/bubbles/actions/presence; at 2× text scale verify no clipping in list and chat (light + dark); verify phone↔tablet reflow; confirm all feedback uses the standard toast surface and no sensitive content appears in logs.

**Acceptance Scenarios**:

1. **Given** a screen reader is active, **When** the person navigates the conversation list and a chat, **Then** rows, bubbles, send/attach controls, and presence expose meaningful labels.
2. **Given** the system text size is set to 2×, **When** the list and chat render, **Then** content remains legible with no clipping in light or dark theme.
3. **Given** any success or failure outcome (send, upload, mark-read, etc.), **When** it is surfaced to the person, **Then** it appears via the standard toast surface, and no message body, token, or media reference is written to logs.

---

### Edge Cases

- **Send failure**: a text/photo/sticker send that is rejected or times out is shown in a failed state with a retry affordance; retrying reuses the original client request id so at most one message is ever delivered.
- **Duplicate inbound**: if the same server message is received more than once (e.g. reconnect replay), it appears exactly once in the thread.
- **Realtime drop mid-session**: the header/typing/presence degrade gracefully (presence goes stale, typing clears) and the thread stays readable; queued outbound messages flush on reconnect in original order.
- **Conversation with a now-unavailable participant** (deactivated/blocked): the conversation still renders from cache; new sends surface a clear failure rather than silently dropping.
- **Blocked user**: a person cannot start or continue a conversation with someone they have blocked or who has blocked them (enforced by the backend; the client reflects the block).
- **Empty states**: no conversations yet (empty Messages tab with a prompt to start one); a brand-new conversation with no messages yet; no search results.
- **Very long thread**: older messages load in pages on scroll-back without duplicating or reordering visible messages.
- **Photo upload cancelled/failed**: the pending photo message reflects cancel/fail and can be removed or retried; no partial message persists.
- **Shared post/reel that was later deleted**: the shared card shows an unavailable state rather than a broken tap target.
- **Rapid open/close of a conversation**: marking-read is not double-counted and does not thrash the unread badge.
- **Self / same-person new message**: selecting a person with an existing conversation opens it rather than creating a second one.

## Requirements *(mandatory)*

### Functional Requirements

**Conversation list (US1)**

- **FR-001**: The Messages tab MUST display the signed-in person's 1-1 conversations ordered by most-recent activity (newest first).
- **FR-002**: Each conversation row MUST show the other participant's avatar with an online indicator when they are active, their name, a last-message preview, a relative timestamp, and an unread marker when unread messages exist.
- **FR-003**: A conversation with unread messages MUST be visually emphasised, and the Messages tab MUST show an unread badge reflecting the number of conversations with unread messages.
- **FR-004**: When the other participant is typing, the corresponding conversation row MUST show a live "typing…" cue in place of the last-message preview.
- **FR-005**: The list MUST show an "active now" rail of currently-online contacts.
- **FR-006**: The person MUST be able to search within their conversations/people from the list.
- **FR-007**: The conversation list MUST render immediately from local cache and reconcile with the server in the background; it MUST remain viewable (read-only) with no connectivity.

**1-1 chat & realtime (US2)**

- **FR-008**: Opening a conversation MUST display its messages grouped by author and time, with the signed-in person's messages and the other participant's messages visually distinguished (own = brand style, other = neutral).
- **FR-009**: Sending a text message MUST append it optimistically and MUST carry a client-generated request id so that retries are idempotent (a retried send delivers exactly one message).
- **FR-010**: Each outgoing message MUST surface its delivery state as it progresses through the full model `sending → sent → delivered → read`. If the backend contract does not distinguish *delivered* from *sent*, the client MUST collapse *delivered* → *sent* without any change to the message surface or data model.
- **FR-011**: Inbound messages MUST append to the open thread live via the realtime channel without a manual refresh, and MUST appear exactly once even if the same server message is received more than once.
- **FR-012**: The chat MUST show a live typing indicator and reflect the other participant's coarse presence — online / "Active now" — in the header. No precise "last seen" timestamp is shown in v1.0.
- **FR-013**: Viewing/opening a conversation MUST mark it read, clearing its unread marker and the tab badge and signalling read state to the other participant.
- **FR-014**: The chat MUST remain readable from cache when realtime is unavailable; messages composed while offline MUST be queued and delivered automatically on reconnect in original order.
- **FR-015**: Older messages MUST load in pages as the person scrolls back, without duplicating or reordering already-visible messages.

**Rich content (US3)**

- **FR-016**: The person MUST be able to send a photo in a conversation via a quick **pick → upload → send** flow reusing only the existing media pick/compress/upload pipeline (no crop/filter/adjust editor), one photo per message, with send progress and a retry path on failure.
- **FR-017**: The person MUST be able to share a post or reel into a conversation (from a profile "Message" action or a content share surface); it MUST render as a card that deep-links to the corresponding post/reel, and MUST show an unavailable state if the referenced content no longer exists.
- **FR-018**: The person MUST be able to send stickers/emoji from the existing sticker tray, rendered as sticker bubbles.
- **FR-019**: Received photo, shared-post/reel, and sticker messages MUST render as their matching bubble types.

**New message (US4)**

- **FR-020**: The person MUST be able to start a new message via a **+** entry that opens a compose screen with a "To:" people search, suggesting people they follow and recent contacts.
- **FR-021**: Selecting a person MUST open a 1-1 conversation with them; if one already exists it MUST open the existing thread and MUST NOT create a duplicate conversation.

**Adaptive & tablet (US5)**

- **FR-022**: On wide (tablet/iPad) layouts Messages MUST render as a master/detail split (list + chat side by side) where selecting a conversation swaps the detail pane in place without a screen push and highlights the selected row; on narrow (phone) layouts the same flows MUST use push navigation, sharing the same underlying conversation/chat state.
- **FR-023**: New-message and sticker surfaces MUST use the centered-mobile fallback on wide layouts.

**Inclusive, safety & cross-cutting (US6 + constitution)**

- **FR-024**: Conversation rows, message bubbles, send/attach controls, and presence MUST expose meaningful screen-reader labels, tolerate 2× text scaling without clipping, and render correctly in light and dark themes.
- **FR-025**: All user-facing feedback (send/upload/mark-read successes and failures, surface acks) MUST be delivered through the app's standard toast surface, never a default snackbar.
- **FR-026**: Logging MUST NOT record message contents, authentication tokens, or media references.
- **FR-027**: A person MUST NOT be able to start or continue a conversation with a participant they have blocked or who has blocked them; the client MUST reflect block/visibility decisions made by the backend and MUST NOT enforce any rule the backend has not.
- **FR-030**: Any signed-in person MAY start a 1-1 conversation with any user who has not blocked them (and whom they have not blocked), regardless of follow relationship; all conversations — including those started by non-connections — arrive directly in the conversation list. There is NO message-requests inbox in v1.0 (gating who may message a person is deferred to #014 Settings & Privacy).
- **FR-028**: Conversation and message data MUST be cleared from local cache on logout, alongside other user-scoped data.
- **FR-029**: The realtime connection MUST recover from drops (reconnect with backoff/heartbeat) and the surface MUST degrade gracefully to read-only while disconnected, with no data loss of queued sends.

### Key Entities *(include if feature involves data)*

- **Conversation**: a private 1-1 thread between the signed-in person and one other participant. Attributes: participant summary (avatar/name/online state), last-message preview, last-activity time, unread count/flag, and a live typing/presence state. One canonical cached copy per conversation.
- **Message**: a single item in a conversation. Attributes: author, kind (text, photo, shared-post/reel, sticker), content payload appropriate to the kind, created time, delivery state (sending/sent/delivered/read), and a client request id for idempotency. Ordered within a conversation by time; one canonical cached copy per message.
- **Participant / Person summary**: the reusable lightweight representation of a user (avatar, name, handle, online/presence) shown in rows, headers, and the compose search — sourced from the existing shared user model.
- **Shared-post reference**: the pointer a shared-post/reel message carries so its card can render a preview and deep-link to the underlying post/reel, plus an unavailable state if the target was removed.
- **Presence / typing signal**: transient realtime state (a participant is online / is typing) that decorates conversations and chat headers but is not durable content.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can open the Messages tab and, from a seeded set of conversations, identify unread conversations and who is online without any manual refresh — the list appears from cache in under 1 second on open.
- **SC-002**: A sent text message appears in the thread instantly (optimistically) and reaches a delivered/read state visible to the sender; the recipient sees it appear live without refreshing.
- **SC-003**: Retrying a failed send never produces a duplicate — after any number of retries of the same message, exactly one message exists in the conversation.
- **SC-004**: An inbound message delivered more than once by the realtime channel appears exactly once in the thread.
- **SC-005**: Opening an unread conversation clears its unread marker and updates the Messages tab badge to reflect the remaining unread conversations.
- **SC-006**: With the realtime connection down, a person can still read cached conversations and threads, and a message composed while offline is delivered automatically once the connection returns — with no lost or duplicated messages.
- **SC-007**: A person can start a new conversation from search and, if a conversation with that person already exists, is taken to the existing thread (zero duplicate conversations created).
- **SC-008**: On a tablet/iPad, selecting conversations swaps the chat pane in place (no screen push) while sharing the same state as the phone flow; on a phone the same conversations open via push.
- **SC-009**: The full messaging surface passes accessibility checks (screen-reader labels, 2× text scale with no clipping, light/dark) and no message body, token, or media reference appears in application logs.

## Assumptions

- **Contract-driven on a shipped backend (B#012)**: like every prior feature, this depends on a versioned REST + realtime contract; the client enforces no visibility/block rule the backend has not. The app continues to run in the in-memory fake DI environment for hermetic tests, with a real Socket.IO-backed implementation behind the `real` environment for dev-backend cutover. The realtime event catalog for messaging (message send/new/delivered/read, typing start/stop, conversation read, presence) was already reserved in the networking core and is wired live for the first time here.
- **Delivery-state fidelity** *(clarified)*: the client models the full sending → sent → delivered → read progression; if B#012 does not distinguish *delivered* from *sent*, the client collapses *delivered* → *sent* without changing the surface or data model.
- **Presence granularity**: presence is a coarse online / "Active now" signal plus typing; precise "last seen at HH:MM" timestamps are out of scope for v1.0.
- **Who can be messaged** *(clarified)*: a person can start a 1-1 conversation with any non-blocked user; messages from non-connections arrive directly in the conversation list. A separate **message-requests inbox** is **not** in scope for v1.0 (deferred to #014). Blocking is enforced by the backend.
- **1-1 only**: conversations are strictly two-party; group conversations are out of scope for v1.0.
- **Reuse of shipped surfaces**: the media pick/upload pipeline (Create Post), the shared-post/reel deep-link targets (Post detail / Reels), the "Message" entry point and lightweight user summary (Profile & Follow), the sticker tray, cursor pagination + list controller, and the two-pane primitive all already exist and are reused rather than rebuilt.
- **Persistence**: conversations and messages are cached locally as the one canonical representation per item (additive local-cache schema change), reconciled with the server, and wiped on logout with the other user-scoped data.
- **Push notifications** for new messages are **not** part of this feature — messaging emits the events; delivering out-of-app push is the Notifications & Push feature (#013).

## Out of Scope (v1.0)

- Group conversations; audio/video calls.
- Message reactions beyond stickers; message edit / unsend / delete-for-everyone; voice notes.
- A message-requests inbox for messages from non-connections.
- A read-receipts on/off privacy toggle (a Settings & Privacy concern, #014).
- Out-of-app push notifications for new messages (Notifications & Push, #013).
- Any personalised ranking of conversations (ordering is strictly by recent activity).

## Dependencies

- **#002 Networking, Cache & Realtime Core** — the realtime client scaffold + reserved messaging event catalog + cursor pagination + list controller + local-cache base (wired live here for the first time).
- **#003 Auth & Onboarding** — session/identity and logout cache-wipe path.
- **#007 Create Post** — the media pick/compress/upload pipeline reused for photo messages.
- **#006 Post Detail & #008 Reels** — deep-link destinations for shared-post/reel messages.
- **#010 Profile & Follow** — the "Message" entry point, the follow graph feeding compose suggestions, and the shared user summary.
- **#001 Foundation** — the two-pane master/detail primitive, sticker tray, toast surface, and adaptive shell.
