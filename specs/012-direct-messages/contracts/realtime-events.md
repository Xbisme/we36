# Realtime Events Contract (Socket.IO — #012)

> ✅ **VERIFIED against the backend source (2026-07-08)** — `backend/src/modules/messaging/{messaging.gateway.ts,ws/events.ts,messaging.service.ts}`. Authoritative facts:
> - **`message.new` payload = the flat `MessageDto` itself** (no `{conversationId, message}` wrapper). Emitted to **both** participants (`emitToUsers([self, other], …)`) — so the sender **receives an echo of their own send**; the client dedups by `serverId` and skips echoes whose `senderId == me`.
> - **No `message.delivered` event** — delivery is `sent` (POST/ack) → `read` only.
> - **`message.read`** payload = `{conversationId, userId, upToMessageId, readAt}` (emitted to the *other* user); the client marks its own sent messages in that thread `read`.
> - **`typing`** payload = `{conversationId, userId, isTyping}` (honor the `isTyping` flag — stop clears immediately).
> - **`presence.update`** = `{userId, online, lastActiveAt}`. Backend also emits `message.deleted` + `conversation.request` (message-requests) + `error` — **not consumed in v1.0**.
> - Client→server names + payloads (`message.send`/`typing.start|stop`/`conversation.read`/`presence.ping`) match the client `SocketEvents`/`OutboundEvent` exactly. (v1.0 sends via REST, not `message.send`.)
>
> One connection (`RealtimeClient`), owned by `RealtimeConnectionManager`; the sole subscriber is `MessagingRealtimeService` (Constitution VIII — Cubits never touch the socket). The rest of this file is the earlier derived draft, kept for history.

## Connection

- **Handshake**: `RealtimeClient.connect(accessToken)` — auth `{token}` on the Socket.IO handshake (already implemented in `SocketIoRealtimeClient`). Connected on session-authenticated; disconnected on logout (R2).
- **Lifecycle**: `connectionState` stream (`RtConnecting`/`RtConnected`/`RtReconnecting`/`RtDisconnected`). Reconnect/backoff/heartbeat are Socket.IO built-ins. On reconnect: re-attach the (possibly refreshed) token + flush the outbox (R4).
- **Degradation**: while not `RtConnected`, the app is **read-only-usable** from cache; a quiet "connecting…/offline" affordance shows; `realtimeDisconnected` surfaced softly (never a blocking error).

## Outbound (client → server) — used by #012

| Event (`SocketEvents`) | Typed (`OutboundEvent`) | Payload | When |
|---|---|---|---|
| `typing.start` | `TypingStart(conversationId)` | `{conversationId}` | first keystroke in the composer (debounced). |
| `typing.stop` | `TypingStop(conversationId)` | `{conversationId}` | ~3 s idle or on send. |
| `conversation.read` | `ConversationRead(conversationId, upToMessageId)` | `{conversationId, upToMessageId}` | thread viewed / new message seen while open. |
| `presence.ping` | `PresencePing()` | `{}` | heartbeat to keep the viewer "online" (as needed). |
| ~~`message.send`~~ | `MessageSend(…)` | — | **NOT used for send** in v1.0 (R1: send is REST). Kept defined for a future ack-capable backend. |

## Inbound (server → client) — consumed by `MessagingRealtimeService`

| Event (`SocketEvents`) | Typed (`InboundEvent`) | Payload | Client action |
|---|---|---|---|
| `message.new` | `MessageNew(conversationId, message)` | `{conversationId, message:MessageDto}` | Parse `MessageDto` → **upsert** `Messages` (dedupe by `serverId`/`clientKey`) → bump the `Conversations` row (preview, lastActivityAt, `unreadCount` if not the open thread). Malformed payload → skip + redacted warn. |
| `message.delivered` | `MessageDelivered(conversationId, messageId)` | `{conversationId, messageId}` | Advance the matching sent message → `delivered`. (No-op if the backend omits *delivered*.) |
| `message.read` | `MessageReadEvent(conversationId, messageId)` | `{conversationId, messageId}` | Advance my sent messages up to `messageId` → `read`. |
| `typing` | `TypingInbound(conversationId, userId)` | `{conversationId, userId}` | Push onto the transient **typing stream** (auto-expire ~4 s) → decorates the row/header. Not persisted. |
| `presence.update` | `PresenceUpdate(userId, online)` | `{userId, online}` | Update the transient **presence map/stream** → online dot + "Active now". Not persisted. |
| `notification.new` | `NotificationNew(…)` | — | **Ignored by #012** (consumed by #013). |

## Testing (Constitution XII)

- `FakeRealtimeClient` (shipped #002) scripts inbound events: emit `MessageNew`/`MessageDelivered`/`MessageReadEvent`/`TypingInbound`/`PresenceUpdate` into `events`, assert the resulting **cache/stream** state (message upserted once, delivery advanced, typing/presence decorated) — never a live socket.
- Dedupe test: emit the same `message.new` twice → the thread holds exactly one message (SC-004).
- Reconnect test: with outbox rows `sending`/`failed`, drive `RtConnected` → assert a flush re-POSTs each once (SC-006).
