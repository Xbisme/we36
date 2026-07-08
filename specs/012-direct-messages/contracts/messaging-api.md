# Messaging API Contract (client-consumed subset of B#012)

> ✅ **RECONCILED with the shipped dev backend (2026-07-08** via `GET /docs-json`). The client (`api_endpoints.dart`, `messaging_remote_data_source.dart`, `messaging_dto.dart`) was aligned to the actual controller. **Actual routes** (under `/v1`):
> | Capability | Actual route | Notes |
> |---|---|---|
> | Conversation **list** | `GET /conversations` | `ConversationPageDto` (**not** `/me/conversations`) |
> | **Open-or-start** | `POST /conversations` `{userId}` | idempotent → existing thread; body key is `userId` (not `participantUserId`) |
> | Get / delete conversation | `GET`/`DELETE /conversations/:id` | |
> | Message history | `GET /conversations/:id/messages` | `MessagePageDto` |
> | **Send** | `POST /conversations/:id/messages` `{kind, body?, mediaId?, sharedPostId?, stickerId?}` | **flat** body, **no `clientKey`** (idempotency via the `Idempotency-Key` header); returns `MessageDto` |
> | Mark read | `POST /conversations/:id/read` | |
> | Delete a message | `DELETE /messages/:id` | not used in v1.0 |
> | Message requests | `POST /conversations/:id/accept` \| `/decline` | backend has a requests concept; **not used in v1.0** (clarified — no requests-inbox) |
>
> **Four deviations from the derived draft (backend wins)**: (1) list is `GET /conversations`, not `/me/conversations`; (2) the message wire is **flat** — `senderId`/`body`/`media`/`sharedPost`/`stickerId` are top-level, **not** nested under `content`; (3) the message `kind` enum is **`text|media|sharedPost|sticker`** — the client `MessageKind.photo` maps to wire **`media`**; (4) `ConversationDto` carries **`otherUser`** (not `participant`) + `lastMessage`/`isRequest`/`muted`/`otherUserPresence`, and the send body carries **no client key** (idempotency is header-only). The realtime `message.new` payload is the same flat `MessageDto` (no `clientKey` echo → inbound dedup is by **`serverId`**).
>
> The rest of this file is the original **derived** draft, kept for history. **The table above is authoritative.**

> ⚠️ (historical, superseded) DERIVED draft. The app runs `env:['fake']` for hermetic tests; endpoint paths, query keys, and event names live in `core/constants/{api_endpoints,socket_events}.dart` — never inline literals.

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
