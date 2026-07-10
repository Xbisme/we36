# Phase 1 Data Model — Notifications & Push (#013)

Client models + drift cache. All models `@freezed`, immutable, generated JSON (Constitution IV). DTO field names are **source-verified** against `backend/src/modules/notifications/dto` (see [contracts/notifications-api.md](contracts/notifications-api.md)). The client renders server-owned grouping/read state; it computes neither.

---

## Client models — `lib/core/data/notifications/notification_entry.dart`

### `NotificationType` (enum)
```
like, comment, reply, mention, follow, followRequest, followAccepted
```
- Wire values are the exact backend `NotificationType` names (camelCase: `followRequest`, `followAccepted`). No `message` type — DM activity is push-only and never appears here.
- Unknown/future wire values → decode to a safe `unknown` sentinel and render a generic row (never crash — Constitution IX). *(Add an `unknown` fallback member for forward-compat.)*

### `ActorCard`
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID. |
| `username` | `String?` | Nullable per DTO. |
| `displayName` | `String?` | Nullable per DTO. |
| `avatarUrl` | `String?` | **Currently always null** server-side — render name/initial fallback (FR-003); adopt automatically when populated. |

### `TargetKind` (enum): `post, reel, comment, user`

### `NotificationTarget`
| Field | Type | Notes |
|---|---|---|
| `kind` | `TargetKind` | Drives deep-link destination. |
| `id` | `String` | Target UUID. |
| `postId` | `String?` | Owning post for a `comment` target (deep-link to post detail focused on the comment). |
| `thumbnailUrl` | `String?` | Row thumbnail; null → no thumb. |
- The whole object is **nullable** on `NotificationEntry` — null ⇒ target deleted / no longer visible ⇒ **degraded, non-tappable row** (FR-006).

### `NotificationEntry` (the one canonical item)
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Group id (PK, dedupe key). |
| `type` | `NotificationType` | Summary-text + destination selector. |
| `actors` | `List<ActorCard>` | Most-recent distinct actors, newest first (server-capped). |
| `actorCount` | `int` | Total distinct actors; "and N others" = `actorCount - 1` (≥1). |
| `target` | `NotificationTarget?` | Null when deleted/hidden. |
| `isRead` | `bool` | Latest activity newer than server `lastReadAt` ⇒ false. Drives the unread accent (independent of the time section). |
| `createdAt` | `DateTime` | First activity. |
| `updatedAt` | `DateTime` | **Latest activity** — feed ordering + unread key + time-section bucketing. |

Derived (client, not persisted): `summaryKey` (per-type l10n template), `section` (New/This week/Earlier from `updatedAt` vs the injectable clock — R6), `isActionable` (`type ∈ {follow, followAccepted, followRequest}` → follow-back/route; `followRequest` route-only per Q1).

### Live-event wrapper — `NotificationLiveEvent`
`{ entry: NotificationEntry, unreadCount: int }` — the parsed `notification.new` payload (R3). Folded by `NotificationsRealtimeService`: upsert `entry` (dedupe by id), push `unreadCount` to the badge.

### Push value objects — `lib/core/services/push/`
- `PushPermissionStatus` enum: `notDetermined, granted, denied`.
- `PushTapData`: `{ kind: String, notificationId: String? }` (thin payload; coarse routing — R7).
- `PushForegroundData`: `{ title: String, body: String, data: Map<String,String> }` (foreground presentation).
- `RegisteredDevice` (response of `POST /devices`): `{ id, platform, createdAt }` — **not cached** (token withheld; credential hygiene).

---

## DTO mapping (`notifications_dto.dart`)

`notificationEntryFromDto(Map)` ← `NotificationEntryDto`; `actorCardFromDto`, `notificationTargetFromDto` (null-safe). Enum decode tolerant (unknown → `unknown`). `registerDeviceBody(platform, token)` → `{platform, token}`; platform ∈ `ios|android` (from `Platform.isIOS`). No hand-rolled `dynamic` digging at call sites (Constitution IV).

---

## Drift cache — schema **v9 → v10** (additive, `lib/core/data/cache/`)

### New table `Notifications`
| Column | Type | Notes |
|---|---|---|
| `id` | `text` PK | Group id. |
| `type` | `text` | `NotificationType` wire name. |
| `actorsJson` | `text` | Serialized `List<ActorCard>`. |
| `actorCount` | `int` | |
| `targetJson` | `text?` | Serialized `NotificationTarget`, null when absent. |
| `isRead` | `bool` | Server read flag at fetch/fold time. |
| `createdAt` | `datetime` | |
| `updatedAt` | `datetime` | Indexed desc — feed keyset ordering. |

- **Index**: `(updatedAt DESC, id DESC)` — mirrors the backend feed keyset; supports cursor pagination + section ordering.
- **Canonical copy**: one row per `id`; `upsertEntry` dedupes/overwrites (a re-delivered `notification.new` or a refresh page updates in place — exactly once, SC-004).
- **User-scoped**: added to `clearUserScoped()` (wiped on logout, FR-025). Registered device tokens are **not** stored (credential hygiene).

### `NotificationsDao`
`watchFeed()` (reactive, ordered) · `page(cursor, limit)` (keyset, for `PaginatedListCubit`) · `upsertEntry(entry)` / `upsertAll(entries)` (dedupe by id) · `markAllReadLocal(lastReadAt)` (flip cached `isRead` for entries ≤ marker — optimistic mirror of `POST /notifications/read`) · `clearUserScoped()`.

**Unread count is NOT derived from this table** (read state is a server marker, not per-row — R5). The count lives in `NotificationsBadge`/`NotificationsRealtimeService` (last-known from `GET /unread-count` + `notification.new`, reset to 0 on open).

### Migration
`schemaVersion 9 → 10`: additive `create table Notifications` + index. Non-destructive (Constitution IX); migration test covers **v9 → v10** (add to the existing migration harness). No change to existing tables.

---

## State shape (feature Cubits)

- `NotificationsState` (freezed 4-state, feed over `PaginatedListCubit`): `initial | loading | loaded(sections: List<Section>, hasMore, loadingMore, isOffline) | error(AppFailure)`. `Section = {label: New|ThisWeek|Earlier, entries: List<NotificationEntry>}`. Live folds and follow-back optimistic updates flow through the canonical drift `watchFeed()` (one source).
- `PushPermissionState` (freezed): `initial | asked(status: PushPermissionStatus) | ...` — drives the explainer/prompt/affordance; backed by a `LocalFlags` "asked" bit so it fires once (R7).
