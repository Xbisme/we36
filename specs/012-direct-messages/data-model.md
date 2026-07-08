# Phase 1 Data Model: Direct Messages (#012)

Client-side domain models for `core/data/messaging/` (+ reused shipped models). All new models are freezed; DTOs deserialize from the B#012 envelope (`contracts/messaging-api.md`). **Two drift tables are added** (`Conversations` + `Messages`, schema **v8→v9**) as the one canonical cached copy per conversation/message; `Messages` doubles as the offline outbox. Presence + typing are **transient** (in-memory streams, never persisted).

## Reused (shipped — unchanged)

| Model | Source | Role in #012 |
|---|---|---|
| `UserSummary` | `core/data` (#002/#010) | Conversation participant + compose-search rows (avatar/name/handle). |
| `ExploreItem` / `PostRef` | `core/data/discovery` (#009) | Shared-post/reel reference carried by a `sharedPost` message; deep-links to #006/#008. |
| `CursorPage<T>` | `core/domain` (#002) | Envelope for conversation list + message history pages. |
| `PaginatedListCubit<T>` | `core/domain` (#002) | Base for message-history back-paging in `ChatCubit`. |
| `Result<T>` / `AppFailure` | `core/domain` (#002) | Repo returns; `realtimeDisconnected`/`messageFailed`/`uploadFailed` map → Toast. |
| `RealtimeClient` + `OutboundEvent`/`InboundEvent` + `SocketEvents` | `core/data/realtime` (#002) | The socket surface, wired live (`MessageSend` unused for send per R1; `TypingStart/Stop`, `ConversationRead` used; inbound `MessageNew`/`MessageDelivered`/`MessageReadEvent`/`TypingInbound`/`PresenceUpdate` consumed). |
| `MediaUploadService` / `PhotoLibraryService` | `core/services` (#007) | Photo-message pick + compress + upload. |
| `TwoPaneScaffold` / sticker tray / `Avatar` / `TopBar` / `SearchBar` | `core/presentation` (#001) | Two-pane, stickers, rows, headers. |

## New models (`core/data/messaging/`)

### Conversation

One 1-1 thread in the list.

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Server conversation id. |
| `participant` | `UserSummary` | The other person (avatar/name/handle). 1-1 only. |
| `lastMessagePreview` | `String?` | One-line preview of the last message (text, or "Photo"/"Sticker"/"Shared a post" for rich). Null for a brand-new empty thread. |
| `lastActivityAt` | `DateTime` | UTC; list ordering key (newest first). |
| `unreadCount` | `int` | ≥0; drives the row unread marker + the tab badge (count of conversations with `unreadCount>0`). |
| `isTyping` | `bool` | **Transient** (from the typing stream) — not persisted; defaults false on load. |
| `participantOnline` | `bool` | **Transient** (from the presence stream) — not persisted; defaults false on load. |

Derivations: `hasUnread => unreadCount > 0`; `previewOrTyping` (row shows "typing…" when `isTyping`, else `lastMessagePreview`).

### Message

One item in a thread. Also the outbox row.

| Field | Type | Notes |
|---|---|---|
| `clientKey` | `String` | UUIDv7; local primary key + Idempotency-Key + reconcile/dedupe key. Present for both mine and (synthesized for) inbound. |
| `serverId` | `String?` | Null until the server persists it (own sends start null). |
| `conversationId` | `String` | Owning conversation. |
| `authorId` | `String` | Sender user id. |
| `isMine` | `bool` | Author == current user. |
| `kind` | `MessageKind` | `text` \| `photo` \| `sharedPost` \| `sticker`. |
| `content` | `MessageContent` | Kind-specific payload (below). |
| `createdAt` | `DateTime` | UTC; thread ordering (oldest→newest). |
| `deliveryState` | `DeliveryState` | `sending` \| `sent` \| `delivered` \| `read` \| `failed`. Meaningful for `isMine`; inbound are effectively `read` on view. |

Validation: `text` body non-empty, ≤ a max length (server-config; assume ~2,000 for parity with comments); `photo` requires a `mediaId` (post-upload) or a local pending ref (pre-upload); `sharedPost` requires a valid `PostRef`; `sticker` requires a glyph id.

### MessageKind + MessageContent (sealed payloads)

- `TextContent { String body }`
- `PhotoContent { String? mediaId; String? localPath; String? url; double? uploadProgress }` — `localPath`+`uploadProgress` while sending; `url`/`mediaId` once uploaded.
- `SharedPostContent { PostRef ref }` — `PostRef { String id; PostKind kind (post|reel); String? thumbUrl; String? authorName; bool unavailable }`.
- `StickerContent { String glyphId }`.

### DeliveryState (enum)

`sending → sent → delivered → read`, plus `failed`. Client collapses `delivered → sent` if the backend omits *delivered* (R5). Transitions:

```
(optimistic insert) → sending
POST 2xx             → sent   (+ serverId)
message.delivered    → delivered   (skipped if backend omits → stays sent)
message.read / peer conversation.read → read
POST error / timeout → failed  (retry re-POSTs same clientKey → back to sending)
```

### PresenceSignal / TypingSignal (transient — not persisted)

- `PresenceSignal { String userId; bool online }` — folded into a `userId→online` map/stream by `MessagingRealtimeService`.
- `TypingSignal { String conversationId; String userId; }` — pushed to a typing stream with a short auto-expire.

## Drift tables (schema v8 → v9, additive)

### `Conversations`

| Column | Type | Notes |
|---|---|---|
| `id` | text PK | Server conversation id. |
| `participantJson` | text | Serialized `UserSummary`. |
| `lastMessagePreview` | text nullable | |
| `lastActivityAt` | datetime | Order key (desc). |
| `unreadCount` | int | Default 0. |

`isTyping`/`participantOnline` are **not** columns (transient). DAO `watchConversations()` orders by `lastActivityAt` desc.

### `Messages` (also the outbox)

| Column | Type | Notes |
|---|---|---|
| `clientKey` | text PK | Local id + idempotency + reconcile key. |
| `serverId` | text nullable | Null while pending. |
| `conversationId` | text (indexed) | FK-ish; DAO `watchThread(id)` filters + orders by `createdAt` asc. |
| `authorId` | text | |
| `isMine` | bool | |
| `kind` | text | `MessageKind` name. |
| `contentJson` | text | Serialized `MessageContent`. |
| `createdAt` | datetime | |
| `deliveryState` | text | `DeliveryState` name; `sending`/`failed` rows = the outbox. |

DAO: `watchThread(conversationId)`, `upsertMessage`, `upsertMessages`, `pendingOutbox()` (rows in `sending`/`failed`), `advanceDelivery(clientKey|serverId, state)`, `upsertConversation(s)`, `markConversationRead(id)`, `clearUserScoped()` (both tables). Registered in `app_database.dart`; `schemaVersion 8→9`; migration `m.createTable(conversations); m.createTable(messages)`; DAO added to `AppDatabase.clearUserScoped()` and thus to the `SessionController` logout wipe.

## Canonical-copy & consistency rules

- **One conversation copy** (the `Conversations` row) read by the list, the tab badge, and the two-pane master — updated in one place by `MessagingRealtimeService` and by send/mark-read.
- **One message copy** (the `Messages` row, keyed by `clientKey`, carrying `serverId`) read by the thread — optimistic insert, POST reconcile, and inbound echo all target the **same** row (dedupe by `clientKey`/`serverId`).
- **Transient presence/typing** never touch drift — they decorate the in-memory `Conversation`/`Message` view models at read time via the service streams.
- **Unread/read**: opening a thread marks its `Conversations.unreadCount = 0` and emits `conversation.read(upToMessageId)`; the peer's `message.read` advances my sent messages to `read`.
- **Malformed inbound** (`MessageNew` with an unparseable payload) is skipped with a redacted warn — one bad message never crashes the thread (Constitution IX).
