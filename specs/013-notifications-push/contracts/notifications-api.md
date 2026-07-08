# Contract — Notifications & Devices REST (client-consumed subset of B#013)

**SOURCE-VERIFIED** against `backend/src/modules/notifications` (`notifications.controller.ts`, `devices.controller.ts`, `dto/*`, `notifications.constants.ts`) + `backend/src/jobs` on 2026-07-08. Unlike #012 (shapes were DERIVED then reconciled), these were read from the shipped backend before writing the client — no post-hoc reconcile expected. All routes are under `/v1`, authenticated (Bearer), scoped to the caller. Envelope + cursor + error shapes are the shared B#001 conventions.

## Notifications feed

### `GET /v1/notifications`
Query: `cursor?` (opaque keyset), `limit?` (default 20, max = shared `MAX_LIMIT` 30).
→ `200` cursor page:
```jsonc
{
  "items": [ NotificationEntryDto, ... ],   // grouped, newest-activity-first
  "nextCursor": "…" | null,
  "hasMore": true
}
```

**`NotificationEntryDto`**:
```jsonc
{
  "id": "uuid",
  "type": "like|comment|reply|mention|follow|followRequest|followAccepted",
  "actors": [ { "id":"uuid", "username": string|null, "displayName": string|null, "avatarUrl": string|null } ],
  "actorCount": 3,                 // ≥1; "and N others" = actorCount-1
  "target": {                       // nullable — null when deleted / not visible
    "kind": "post|reel|comment|user",
    "id": "uuid",
    "postId": "uuid" | null,        // owning post for a comment target
    "thumbnailUrl": string | null
  } | null,
  "isRead": false,                  // latest activity newer than lastReadAt marker
  "createdAt": "ISO-8601",
  "updatedAt": "ISO-8601"           // latest activity — ordering + unread key
}
```
- `avatarUrl` is **currently always null** server-side (documented follow-up) — client renders a fallback.
- `type` has **no `message`** member — DM activity is push-only, never in this feed.

### `GET /v1/notifications/unread-count`
→ `200` `{ "count": 7 }` — drives the badge (server-owned; not client-derived).

### `POST /v1/notifications/read`
No body. → `204`. **Mark-ALL-read**: advances the caller's single `lastReadAt` marker to now. Idempotent. Throttled (`mutate`: 60/min). There is **no per-notification read** and **no `GET /notifications/:id`**.

## Device push registry

### `POST /v1/devices`
Body: `{ "platform": "ios"|"android", "token": "<FCM/APNs token>" }` (token ≤ 4096 chars; treated as a credential).
→ `201` `{ "id":"uuid", "platform":"ios|android", "createdAt":"ISO-8601" }` — **token is NOT echoed back**. Throttled (`mutate`). Re-registering the same token refreshes it (a token belongs to exactly one user at a time).

### `DELETE /v1/devices/:token`
→ `204`. Idempotent (`unregistered or already absent`). Called on logout / token rotation.

## Push payload (delivered by the backend `push` worker — for client tap-handling)
FCM/APNs `data` is thin, PII-free: `{ "kind": "<FanoutKind>", "notificationId"?: "<uuid>" }`. Title is generic per kind ("New like", "New comment", …, "New message"); **body is empty**. DM pushes carry `kind: "message"` (or `"messageRequest"`) with **no** `notificationId`. → Client coarse deep-link (feed kinds → Activity; `message` → Messages).

## Client endpoint constants (`core/constants/api_endpoints.dart` — extend)
```
notifications            = '/notifications'
notificationsUnreadCount = '/notifications/unread-count'
notificationsRead        = '/notifications/read'
devices                  = '/devices'
device(token)            = '/devices/$token'
```

## Failure mapping (reuse `FailureMapper`)
`401` → single-flight refresh (shared interceptor) → `sessionExpired` once; `429` → `rateLimited` (throttle); network/5xx → `networkError`/`serverError` → quiet Toast + render-from-cache. No new `AppFailure` members required (push permission denial is surfaced via `PushService`, not an HTTP failure).
