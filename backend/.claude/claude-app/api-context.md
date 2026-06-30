# We36 Backend — API & Data Contract Context

> **Vai trò file này**: single source of truth cho **contract** mà backend cung cấp và app Flutter tiêu thụ — REST resource map, WebSocket event catalog, auth model, error & pagination envelope, và data model cốt lõi. Đây là bản backend tương đương của [`ui-design-context.md`](../../../.claude/claude-app/ui-design-context.md) bên app. Mọi spec backend có phần API phải bám file này; mọi thay đổi shape phải cập nhật ở đây + OpenAPI + contract test.
>
> Last updated: 2026-06-30 (Initial contract draft from the product brief + the client roadmap. No endpoints implemented yet.)

## Boundary & sync

- **Producer**: we36-api (NestJS). **Consumer**: We36 Flutter client (`dio` REST + `web_socket_channel`).
- Bản OpenAPI sinh từ decorators là **bản chuẩn máy đọc**; file này là bản người đọc + WS catalog. Khi lệch → sửa code + file này cùng lúc (Constitution I).
- Client map `error.code` → localized copy (client Principle V). **Đừng đổi `code` đã ship.**
- App field naming: **camelCase** trong JSON (khớp Dart models). Ids = **string** (UUID v7 hoặc ULID — sortable; chốt ở B#001). Timestamps = **ISO-8601 UTC string**. Counts = integer.

---

## Conventions

### Versioning
- Mọi route dưới `/v1`. Breaking change → `/v2`, không sửa `/v1` tại chỗ. Additive field = không breaking.

### Auth model
- `Authorization: Bearer <accessToken>` (JWT, ~15 phút). Refresh qua `POST /v1/auth/refresh` với refresh token (rotating, revocable; lưu server-side).
- `401 SESSION_EXPIRED` → client làm **single-flight refresh** rồi retry; refresh fail → `401` lần 2 → logout.
- WebSocket: auth bằng access token lúc connect (query/`auth` payload). Mỗi subscription chỉ nhận stream của chính user.

### Error envelope (mọi lỗi)
```json
{ "error": { "code": "VALIDATION", "message": "Human-readable, non-leaking", "details": { "username": "already taken" } } }
```
- `code` ∈ catalog: `UNAUTHENTICATED` · `INVALID_CREDENTIALS` · `SESSION_EXPIRED` · `OAUTH_FAILED` · `FORBIDDEN` (private/blocked) · `NOT_FOUND` · `CONFLICT` · `VALIDATION` · `RATE_LIMITED` · `MEDIA_TOO_LARGE` · `UNSUPPORTED_MEDIA` · `UPLOAD_FAILED` · `SERVER_ERROR`. Map sang HTTP status ổn định (401/403/404/409/422/429/413/415/500).
- `details` (optional) = map field→message cho `VALIDATION`.

### Pagination envelope (mọi list/feed/search) — cursor-based
```json
{ "items": [ /* … */ ], "nextCursor": "opaque-or-null", "hasMore": true }
```
- Query: `?cursor=<opaque>&limit=<n>` (limit có trần, vd ≤ 30). Ordering ổn định; **không** offset.

### Idempotency
- Mutations tạo nội dung (`POST` post/message/like) nhận header `Idempotency-Key` (client-generated uuid) → retry không nhân đôi.

### Rate limiting
- `429 RATE_LIMITED` + header `Retry-After`. Áp cho auth, write, search, upload, message.

---

## REST Resource Map (v1) — chỉ định hướng; shape chi tiết sinh ở từng spec

> Build dần theo roadmap (xem [`sdd-roadmap.md`](sdd-roadmap.md)). Spec đánh dấu ở cột phải.

### auth — *B#002*
- `POST /v1/auth/register` (email/phone + password) · `POST /v1/auth/login` · `POST /v1/auth/oauth/{google|apple}` (verify provider token) · `POST /v1/auth/refresh` · `POST /v1/auth/logout` · `POST /v1/auth/forgot` + `POST /v1/auth/reset` (OTP) · `POST /v1/auth/check-username`.

### users / me — *B#002 (profile setup) · B#008 (public profile) · B#013 (settings)*
- `GET /v1/me` · `PATCH /v1/me` (edit profile) · `POST /v1/me/setup` · `GET /v1/me/settings` · `PATCH /v1/me/settings` (private account, close friends, activity status, theme/lang server-mirror) · `POST /v1/me/data-export` · `DELETE /v1/me`.
- `GET /v1/users/{username}` (public profile + aggregates; respects privacy/block).

### media — *B#003*
- `POST /v1/media/uploads` → trả **presigned PUT URL(s)** + `mediaId` (client PUT thẳng lên storage) · `POST /v1/media/{id}/finalize` (server validate + enqueue processing) · `GET /v1/media/{id}` (CDN URLs + variants/status).

### posts / feed — *B#004*
- `POST /v1/posts` (carousel media ids, caption, hashtags, taggedUsers, location, commentsDisabled) · `GET /v1/feed` (reverse-chron, cursor) · `GET /v1/posts/{id}` · `DELETE /v1/posts/{id}` · `POST /v1/posts/{id}/like` / `DELETE …/like` · `POST /v1/posts/{id}/save` / `DELETE …/save`.

### comments — *B#005*
- `GET /v1/posts/{id}/comments` (cursor) · `POST /v1/posts/{id}/comments` (text, parentId? [1-level], mentions) · `POST /v1/comments/{id}/like` / `DELETE` · `DELETE /v1/comments/{id}`.

### stories — *B#006*
- `POST /v1/stories` (media, audience=everyone|closeFriends) · `GET /v1/stories/feed` (active, grouped by user) · `GET /v1/users/{username}/stories` · `POST /v1/stories/{id}/view`. (Expiry 24h qua worker.)

### reels — *B#007*
- `POST /v1/reels` (video media + caption) · `GET /v1/reels` (vertical feed, cursor) · `POST /v1/reels/{id}/like` etc. (mirror posts).

### social (follow / block) — *B#008*
- `POST /v1/users/{id}/follow` (→ pending nếu private) · `DELETE …/follow` · `GET /v1/users/{id}/followers` / `following` (cursor) · `GET /v1/me/follow-requests` + accept/reject · `POST /v1/users/{id}/block` / `DELETE …/block`.

### collections — *B#010*
- `GET /v1/me/collections` · `POST /v1/me/collections` · `POST /v1/collections/{id}/items` (saved post) · `DELETE …`.

### explore / search — *B#009*
- `GET /v1/explore` (grid, cursor) · `GET /v1/search?q=&type=top|accounts|tags|places` · `GET /v1/hashtags/{tag}` (+ posts) · `GET /v1/places/{id}` · recents (`GET/DELETE /v1/me/search-recents`).

### messaging — *B#011 (REST history; realtime qua WS)*
- `GET /v1/conversations` (cursor) · `POST /v1/conversations` (start, by userId) · `GET /v1/conversations/{id}/messages` (cursor, catch-up) · `POST /v1/conversations/{id}/messages` (text | mediaId | sharedPostId | sticker; idempotency-key) · `POST …/read`.

### notifications — *B#012*
- `GET /v1/notifications` (cursor, grouped New/earlier) · `POST /v1/notifications/read` · `POST /v1/devices` (register FCM/APNs token) · `DELETE /v1/devices/{token}`.

### moderation — *B#013*
- `POST /v1/reports` (targetType=post|comment|user|story, reason) · (admin/moderation queue endpoints — internal).

---

## WebSocket Event Catalog — *B#011/B#012*

Single `wss` gateway, auth on connect. Events typed; payload ids không kèm PII thừa.

**Client → Server**: `message.send` (conversationId, body, idempotencyKey) · `typing.start` / `typing.stop` (conversationId) · `conversation.read` (conversationId, upToMessageId) · `presence.ping`.

**Server → Client**: `message.new` (conversation message) · `message.delivered` / `message.read` · `typing` (conversationId, userId) · `presence.update` (userId, online, lastSeen) · `notification.new` (activity item).

**Semantics**: DM **persist-before-push** (ghi Postgres rồi mới phát). Reconnect → REST catch-up bằng cursor. Redis pub/sub fan-out giữa các instance. Mất realtime → app read-only realtime, REST vẫn chạy.

---

## Core Data Model (Postgres) — entities + key relations

> Chi tiết cột/constraint/index sinh ở `data-model.md` từng spec. Đây là bản đồ thực thể.

- **User** (id, username[unique], displayName, email[unique]/phone, passwordHash, avatarMediaId, bio, website, pronouns, isPrivate, isVerified, createdAt…) — settings tách bảng/cột.
- **AuthCredential / RefreshToken** (userId, tokenHash, rotatedFrom, revokedAt, expiresAt, deviceId) — rotating + revocable.
- **Media** (id, ownerId, kind[image|video], status[pending|processing|ready|failed], originalKey, variants[jsonb: sizes/poster], width/height/durationMs, bytes) — S3-compatible keys.
- **Post** (id, authorId, caption, location, commentsDisabled, createdAt) ──< **PostMedia** (postId, mediaId, position) — carousel.
- **Reel** (id, authorId, videoMediaId, caption…) *(hoặc Post với kind=reel — chốt ở B#007).*
- **Story** (id, authorId, mediaId, audience, expiresAt) + **StoryView** (storyId, viewerId).
- **Comment** (id, postId, authorId, parentId?[1-level], body, createdAt) + **CommentLike**.
- **Like** (userId, postId) [unique] · **Save** (userId, postId, collectionId?).
- **Follow** (followerId, followeeId, status[active|pending]) [unique] — pending cho private.
- **Block** (blockerId, blockedId) [unique] — enforce 2 chiều.
- **Collection** (id, ownerId, name) ──< **CollectionItem**.
- **Hashtag** (tag[unique], postCount) ──< **PostHashtag**; **Place** (id, name, lat/lng).
- **Conversation** (id, isGroup=false v1) ──< **ConversationMember** (userId) ; ──< **Message** (id, conversationId, senderId, kind[text|media|sharedPost|sticker], body/mediaId/sharedPostId, createdAt) + read state.
- **Notification** (id, recipientId, type[like|comment|follow|followRequest|mention], actorId, targetType/targetId, readAt, createdAt).
- **Device** (userId, platform, pushToken) · **Report** (reporterId, targetType/targetId, reason, status) · **Mention** (sourceType/sourceId, mentionedUserId).

**Visibility rule (mọi đọc)**: actor xem được nội dung của owner nếu — owner công khai, HOẶC actor được approve-follow; VÀ không tồn tại Block giữa hai bên. Áp ở repository/policy layer (Constitution II/III), không phụ thuộc client.

---

## Implementation Rules (API)

- Mọi route `/v1`, mọi body = DTO validated (whitelist, forbid unknown).
- Mọi list = cursor envelope; mọi lỗi = error envelope; `code` ổn định.
- Auth rule khai báo tường minh trên mọi endpoint; ownership/visibility check ở server.
- Media: presigned upload, không proxy bytes; xử lý ở worker; trả CDN URL.
- DM: persist-before-push; WS event typed; per-user subscription isolation.
- Privacy/block enforce ở data layer; private media URL access-controlled.
- Cập nhật OpenAPI + file này + contract test khi đổi shape; kiểm tra ngược với Dart models bên app.
