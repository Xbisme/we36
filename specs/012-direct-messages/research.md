# Phase 0 Research: Direct Messages (Realtime) (#012)

Resolves the design unknowns before Phase 1. Format per decision: **Decision · Rationale · Alternatives rejected**. No new pub dependency is introduced (`socket_io_client` shipped #002; media pipeline #007; sticker tray + two-pane #001).

---

## R1 — Message send path: REST-send with an inbound-authoritative socket

**Decision**: All outbound messages (text, photo, shared-post, sticker) are sent via **REST** `POST /conversations/:id/messages` (carrying the client `clientKey` as the Idempotency-Key), which returns the **persisted message** (server id + `sent` state). The realtime socket is **inbound-authoritative**: it delivers `message.new` (messages from the other participant, and optionally the server's echo of mine), `message.delivered` / `message.read` receipts, `typing`, and `presence.update`. Outbound **`typing.start`/`typing.stop`** and **`conversation.read`** still go over the socket (fire-and-forget is fine for these — they are advisory, non-durable). The reconcile key is `clientKey`: the optimistic row is inserted with `clientKey` + `deliveryState=sending`; the POST response (or an echoed `message.new` carrying the same `clientKey`) updates that same row in place to `sent` with its server id — so a message never appears twice.

**Rationale**: The shipped `RealtimeClient.send()` is **fire-and-forget with no ack** (`void send(OutboundEvent)` → `socket.emit`), so a socket-only send cannot return the server message id needed to (a) advance the optimistic row past `sending` and (b) dedupe the echoed `message.new`. REST reuses the already-shipped **idempotency interceptor** (retry = exactly one message, SC-003), **single-flight refresh**, and centralized **`FailureMapper`** → `AppFailure` → Toast. This is the least-code, most-consistent path and keeps Cubits off the socket.

**Alternatives rejected**:
- *Socket-only send via the shipped `MessageSend` outbound event* — no ack to reconcile the optimistic row or dedupe the echo; bypasses centralized idempotency/error mapping. (`MessageSend` stays defined for a future ack-capable backend.)
- *Socket-send + a separate ack event* — would require extending the scaffold's send signature to return a Future and adding an ack event to the catalog; more surface for no benefit over REST, which already acks with the persisted resource.

---

## R2 — Realtime connection lifecycle: a SessionController-driven `RealtimeConnectionManager`

**Decision**: A new `@lazySingleton RealtimeConnectionManager` owns the socket lifecycle: on the session becoming **authenticated** it calls `RealtimeClient.connect(accessToken)`; on **logout / forced-logout** it calls `disconnect()`. It reads the token from the existing `TokenStore` and is invoked from `SessionController` at the same points that today wipe the cache. Reconnect + exponential backoff + heartbeat are Socket.IO built-ins already configured in `SocketIoRealtimeClient`; the manager only maps session state → connect/disconnect and re-attaches the (possibly refreshed) token on reconnect. Connection state (`RtConnected`/`RtReconnecting`/`RtDisconnected`) is surfaced quietly (a thin "connecting…"/offline affordance), never a blocking error — the app stays read-only-usable when down (Constitution VIII).

**Rationale**: #002 shipped the socket inert; DM is its first consumer and must centralize connect-on-auth/disconnect-on-logout exactly once. Tying it to `SessionController` reuses the single source of session truth and guarantees the socket never outlives a session (privacy — no cross-account event leakage).

**Alternatives rejected**: *Connect lazily when the Messages tab opens* — would drop live notifications/receipts while elsewhere in the app and re-handshake on every tab visit; a persistent session-scoped connection matches how DM/notifications (#013) both need it. *Each Cubit connects* — violates VIII and duplicates lifecycle.

---

## R3 — Presence & typing propagation: `MessagingRealtimeService` transient streams

**Decision**: A new `@lazySingleton MessagingRealtimeService` subscribes to `RealtimeClient.events` and **folds** each inbound event into the right place:
- `message.new` → parse `MessageDto` → **upsert** into the `Messages` cache + bump the `Conversations` row (preview, lastActivityAt, unreadCount if not the open thread) — deduped by `clientKey`/serverId.
- `message.delivered` / `message.read` → advance the matching message's `deliveryState` in the cache.
- `typing` → push `(conversationId, userId)` onto a transient **typing stream** with a short auto-expire (e.g. clear after ~4 s of no repeat) — **not persisted**.
- `presence.update` → update a transient **presence map/stream** (`userId → online`) — **not persisted**.

Cubits read the reactive drift cache (`watchConversations`/`watchThread`) **plus** these two transient streams; the service is the only socket subscriber. Outbound typing is debounced (emit `typing.start` on first keystroke, `typing.stop` after ~3 s idle or on send).

**Rationale**: Keeps Cubits off the socket (VIII), makes inbound handling one testable unit (`FakeRealtimeClient` event in → cache/stream out), and keeps ephemeral presence/typing out of the durable store (they must not survive a restart or leak into offline cache).

**Alternatives rejected**: *Persist presence/typing in drift* — ephemeral, high-churn, and privacy-sensitive; would dirty the cache and could render stale "online" offline. *A `PresenceCubit`/`TypingCubit`* — unnecessary; a service + streams consumed by the two page Cubits is simpler.

---

## R4 — Persistence & outbox: two drift tables, `Messages` is the outbox

**Decision**: Add **`Conversations`** and **`Messages`** tables (drift **v8→v9**, additive). The `Messages` table is also the **outbox**: an outgoing message is written **first** with `deliveryState=sending` and its `clientKey` as the local primary key (serverId null); on POST success the row is updated in place (serverId + `sent`); on failure it becomes `failed` (retryable). On reconnect, `RealtimeConnectionManager`/`MessagingRealtimeService` triggers a **flush** of `sending`/`failed` rows (re-POST with the same `clientKey` → idempotent). Both tables are user-scoped and cleared by `clearUserScoped()` (wired into `SessionController`). Message history is a cursor page **backed by** the cache: `LoadHistory` fetches older pages from REST and upserts them; the thread view watches the cache (one canonical copy, dedupe by `clientKey`/serverId).

**Rationale**: FR-007 + FR-014 require offline render of both the list and open threads, and SC-006 requires queued sends to flush on reconnect with no loss/dup. Making the `Messages` table the outbox means a killed app resumes unsent messages, and there is exactly one canonical representation per message (IX). Additive migration matches the #004/#009 precedent.

**Alternatives rejected**: *Separate outbox table* — duplicates message shape and reconcile logic; a `deliveryState` column on `Messages` is sufficient. *In-memory conversations (like #010)* — cannot cold-start threads offline or survive app-kill with unsent messages.

---

## R5 — Delivery-state model: 4-state with graceful collapse

**Decision**: `DeliveryState = sending → sent → delivered → read` (+ `failed` for a rejected/timed-out send). Reached by: `sending` (optimistic insert) → `sent` (POST response) → `delivered` (`message.delivered` socket event) → `read` (`message.read` socket event or the peer's `conversation.read`). If B#012 does not distinguish *delivered* from *sent*, the client **collapses** `delivered → sent` (never emits `delivered`); the UI/data model are unchanged (per clarification). Incoming (other-authored) messages have no sender-facing delivery state; the local viewer marks them read on view (emits `conversation.read` up to the newest message id).

**Rationale**: Matches the clarified decision and the shipped `SocketEvents` catalog (`message.delivered`/`message.read` already defined). One enum drives both the per-message indicator and the conversation unread logic.

**Alternatives rejected**: *Booleans (`isSent`/`isRead`)* — don't model the ordered progression or `failed`; an enum is clearer and testable.

---

## R6 — Adaptive two-pane: reuse the #001 primitive + a shared shell Cubit

**Decision**: `MessagingShell` chooses by width (`AppBreakpoints`/`LayoutBuilder`): `<700` → phone push (`ConversationsPage`, tapping a row `context.push('/messages/:id')` → `ChatPage`); `≥700` → `TwoPaneScaffold(master: ConversationsPage, detail: ChatPage)` where a `MessagingShellCubit` holds the **selected conversation id**; selecting a row sets the id and swaps the detail pane **in place** (no push). Both layouts bind the **same** `ConversationsCubit` + `ChatCubit` (keyed by conversation id), so state/behaviour are identical (FR-022). New-message + sticker tray use the centered-mobile fallback on wide layouts (design §Responsive).

**Rationale**: Reuses the shipped `TwoPaneScaffold` (built #001, used by #006) exactly as the constitution intends; a tiny shell Cubit is the minimal state to coordinate selection without a route push.

**Alternatives rejected**: *A bespoke tablet layout* — forbidden by VI/VII (no forked screen set). *Route-driven selection on tablet* (`/messages/:id` even in two-pane) — a push would replace the pane instead of swapping and lose the master; selection-as-state is the master/detail idiom.

---

## R7 — Rich content: reuse #007 pipeline, `ExploreItem` ref, sticker tray

**Decision**:
- **Photo**: quick `pick → compress → upload → send` reusing `PhotoLibraryService` (single-pick) + `MediaUploadService` (#007). The uploaded `mediaId` is sent as a `photo` message (POST body `{kind:'photo', mediaId}`); the optimistic bubble shows local bytes + upload progress, then the server media on success. **No crop/filter editor** (clarified) — one photo per message.
- **Shared post/reel**: carried as a lightweight **post/reel reference** (reuse the `ExploreItem` kind-tag or a slim `PostRef {id, kind}`); the card renders a thumbnail + author from the reference and deep-links to `AppRoutes.postDetail` (#006) / the reel (#008); an **unavailable** state renders if the target 404s. The "share to DM" entry from a post/reel and the "Message" entry from a profile (#010) route in via `core/router`/DI seams.
- **Sticker**: the shipped **sticker tray** (Screen 28) selects a `StickerGlyph`; sent as a `sticker` message (POST body `{kind:'sticker', sticker}`), rendered as a large glyph bubble.

**Rationale**: Every rich type reuses an already-shipped seam (VII/XIII); nothing new is built for media/stickers/deep-links.

**Alternatives rejected**: *Full post editor for DM photos* — rejected at clarify (chat expectation is quick send). *Embedding a full `Post` copy in the message* — bloats the payload/cache and can drift; a reference + on-tap fetch is the single-source-of-truth path (IX).

---

## R8 — Idempotency & inbound dedupe

**Decision**: Every send generates a `clientKey` (UUIDv7 via the shipped `uuid`), used as (a) the REST **Idempotency-Key**, (b) the local `Messages` primary key, and (c) the reconcile key when the server echoes `message.new`. Inbound messages are deduped by `serverId` (already-seen id → ignore) and, for echoes of my own sends, by `clientKey`. A retried failed send re-POSTs the same `clientKey` (SC-003 → exactly one). A duplicate `message.new` (reconnect replay) upserts the same row (SC-004 → exactly once).

**Rationale**: One key threads optimism, idempotency, and dedupe — the constitution's IX pattern, already proven by #004 like/#007 create/#011 file.

**Alternatives rejected**: *Server-id-only dedupe* — can't reconcile the optimistic row (which has no server id yet). *Timestamp/content hashing* — fragile; explicit client keys are deterministic.

---

## R9 — People search for new-message compose

**Decision**: Reuse the shipped profile/discovery **people search** (#009 `DiscoveryRepository`/#010 `ProfileRepository`) for the "To:" field; default **suggestions** = people the viewer follows + recent DM contacts (recents derived from the `Conversations` cache). `OpenOrStartConversation(userId)` calls `POST /conversations {participantUserId}` which is **idempotent** — returns the existing conversation if one exists (no duplicate, SC-007).

**Rationale**: No new search surface; the follow graph + recents are the natural suggestion source; server-side open-or-create guarantees no duplicate thread.

**Alternatives rejected**: *A dedicated DM user-search endpoint* — the existing user search already returns the needed `UserSummary`; reuse over rebuild.

---

## Summary of decisions

| # | Area | Decision |
|---|---|---|
| R1 | Send path | REST-send (idempotent) + inbound-authoritative socket |
| R2 | Connection | `RealtimeConnectionManager` connect-on-auth / disconnect-on-logout |
| R3 | Presence/typing | `MessagingRealtimeService` transient streams (not persisted) |
| R4 | Persistence | drift v8→v9: `Conversations` + `Messages` (Messages = outbox) |
| R5 | Delivery state | 4-state enum + graceful collapse of *delivered* |
| R6 | Two-pane | reuse `TwoPaneScaffold` + `MessagingShellCubit` selection |
| R7 | Rich content | #007 photo pipeline · `ExploreItem`/PostRef card · sticker tray |
| R8 | Idempotency | one `clientKey` = idempotency + local PK + dedupe key |
| R9 | Compose search | reuse profile/discovery people search + server open-or-create |

**No NEEDS CLARIFICATION remain.** No new pub dependency. Backend B#012 REST/socket shapes are **derived** in `contracts/` and reconciled at dev-backend cutover (the client runs `env:['fake']` until then).
