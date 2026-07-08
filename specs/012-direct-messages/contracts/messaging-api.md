# Messaging API Contract (client-consumed subset of B#012 — DERIVED)

> ⚠️ **DERIVED draft — reconcile with the shipped backend B#012 at dev-backend cutover** (like #011's contract was reconciled). The app runs `env:['fake']` until then; `messaging_remote_data_source.dart` + `messaging_repository_impl.dart` target these shapes and are corrected against the real controller after end-to-end testing. Endpoint paths, query keys, and event names live in `core/constants/{api_endpoints,socket_events}.dart` — never inline literals.

All routes under `/v1`. Auth via the shipped bearer interceptor; mutations carry an **Idempotency-Key** (the message `clientKey`). Cursor envelope = the shipped `CursorPage<T>` (`{ items, nextCursor, hasMore }`). Success bodies are returned bare (matching the reconciled #011 convention — no `{data:…}` wrapper). Errors use the shipped envelope `{error:{code,message,details}}` → `FailureMapper` → `AppFailure`.

## Shared DTO fragments

- `UserSummaryDto` → `UserSummary` (shipped) — `{ id, username, displayName, avatarUrl, ... }`.
- `MediaDto` → `Media` (shipped) — for photo messages.
- `PostRefDto` → `PostRef` — `{ id, kind:"post"|"reel", thumbUrl?, authorName? }` for shared-post messages.
- `MessageDto` → `Message` — `{ id, clientKey?, conversationId, authorId, kind:"text"|"photo"|"sharedPost"|"sticker", content:{…}, createdAt, deliveryState:"sent"|"delivered"|"read" }` where `content` is one of `{body}` / `{media:MediaDto}` / `{post:PostRefDto}` / `{sticker:glyphId}`.
- `ConversationDto` → `Conversation` — `{ id, participant:UserSummaryDto, lastMessage:{preview,createdAt}|null, unreadCount }`.

## Endpoints

| # | Capability | Route | Notes |
|---|---|---|---|
| 1 | List conversations | `GET /me/conversations` | `CursorPage<ConversationDto>`, newest-activity first. Client caches into `Conversations` (offline render). |
| 2 | Get one conversation | `GET /conversations/:id` | `ConversationDto`. |
| 3 | Open-or-start a conversation | `POST /conversations` `{participantUserId}` | **Idempotent**: returns the existing `ConversationDto` if one exists, else creates (SC-007, no duplicate). |
| 4 | Message history | `GET /conversations/:id/messages?cursor=` | `CursorPage<MessageDto>` (back-paging, newest→older); client upserts into `Messages`. |
| 5 | Send a message | `POST /conversations/:id/messages` `{clientKey, kind, …content}` | Idempotency-Key = `clientKey`. Returns the persisted `MessageDto` (= `sent` + server id). `content` per kind: text `{body}`, photo `{mediaId}` (after upload), sharedPost `{postId, postKind}`, sticker `{glyphId}`. Retry with same key → the same message (SC-003). |
| 6 | Mark read | `POST /conversations/:id/read` `{upToMessageId}` | Clears server unread; also emitted over the socket as `conversation.read` (R1). Either transport is acceptable; client uses the socket event primarily, REST as the durable fallback. |
| 7 | People search (compose) | *reuse* `GET /users/search?q=` (#009) + `GET /me/following` (#010) | Suggestions = follows + recent DM contacts (recents derived client-side from the `Conversations` cache). No new endpoint. |
| 8 | Photo upload | *reuse* the #007 media-upload pipeline | Yields a `mediaId` used in endpoint 5's photo `content`. |

## Client responsibilities

- **Optimistic + idempotent send** (endpoint 5): write the `Messages` outbox row (`sending`) → POST → reconcile the same `clientKey` row to `sent`(+serverId) / `failed`.
- **Offline queue**: `sending`/`failed` rows are re-POSTed on reconnect (same `clientKey`).
- **Dedupe**: ignore an inbound/echoed message whose `serverId` (or `clientKey`) is already present.
- **No client-side visibility rules**: block/who-can-message verdicts come from the backend (a forbidden send → `forbidden` `AppFailure` → Toast); the client adds none (FR-027).

## Open questions for backend reconcile (B#012)

1. Does the server **echo my own sends** as `message.new` (needs `clientKey` in the echo to dedupe), or only the POST response? (Client handles both via `clientKey`.)
2. Is *delivered* a real state, or does the server only emit *read*? (Client collapses `delivered → sent` if absent — R5.)
3. Are conversations paginated (`CursorPage`) or a bounded list? (Client assumes `CursorPage`; degrades to a single page if not.)
4. Exact send `content` field names + the text max length (server config).
5. Is `POST /conversations` the open-or-create route, or is a conversation created implicitly on first message? (Client assumes explicit open-or-create for SC-007; can switch to first-message-creates.)
