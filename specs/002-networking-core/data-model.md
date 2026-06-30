# Phase 1 Data Model: Networking, Cache & Realtime Core (#002)

**Date**: 2026-06-30 · **Spec**: [spec.md](spec.md)

This spec is infrastructure: most "entities" are typed transport/state objects, not persisted
domain records. The only persisted table in #002 is the **reference slice** (`User`). All ids are
**string UUIDv7**, timestamps **ISO-8601 UTC strings**, JSON fields **camelCase**, counts **int**
(Constitution / contract).

---

## 1. Transport & failure types (core/data, core/domain)

### `ApiErrorEnvelope` (parsed, not stored)
Mirror of the backend error body.
| Field | Type | Notes |
|---|---|---|
| `code` | `String` | one of the stable catalog (see [contracts/error-mapping.md](contracts/error-mapping.md)) |
| `message` | `String` | human-readable, non-leaking |
| `details` | `Map<String,String>?` | present for `VALIDATION` (field → message) |

### `AppFailure` (existing — one change)
Already declared in [`lib/core/domain/app_failure.dart`](../../lib/core/domain/app_failure.dart).
**Change for #002**: `rateLimited()` → `rateLimited({Duration? retryAfter})` (carry `Retry-After`).
No other variant changes; full catalog already covers the contract codes + transport faults.

### `CursorPage<T>` (core/data/pagination)
| Field | Type | Notes |
|---|---|---|
| `items` | `List<T>` | page in stable order |
| `nextCursor` | `String?` | opaque base64url; `null` ⇒ end |
| `hasMore` | `bool` | server-reported |

- `factory CursorPage.fromJson(Map json, T Function(Map) itemFromJson)`.
- Invariant: `hasMore == false` ⇒ `nextCursor == null` (tolerated if server disagrees: treat null
  cursor as end regardless).

### `PageRequest` (core/data/pagination)
| Field | Type | Default |
|---|---|---|
| `cursor` | `String?` | `null` (first page) |
| `limit` | `int` | 20 (max 30, clamped) |

---

## 2. Paginated-list controller state (core/presentation or core/domain)

### `PaginatedListCubit<T>` — extends `AppCubit<List<T>>` (4-state, Constitution III)
Drives a `CursorPage<T>` source. `loaded` state carries pagination metadata via extended variants:

| State | Meaning |
|---|---|
| `initial` | nothing loaded |
| `loading` | first page in flight |
| `loaded(items, nextCursor, hasMore)` | page(s) present, idle |
| `loadedPaginating(...)` | load-more in flight (items retained) |
| `loadedRefreshing(...)` | refresh in flight (items retained) |
| `error(failure)` | first-page load failed (no items) |

- **Operations**: `loadFirst()`, `loadMore()` (no-op when `!hasMore` or already paginating),
  `refresh()` (reload from first page, replace items).
- **De-dupe**: items merged by `String Function(T) idSelector`; duplicates across pages dropped.
- **Load-more failure**: stays `loaded` with prior items + surfaces a soft failure (toast at call
  site) — does not clobber the list.

---

## 3. Realtime types (core/data/realtime)

### `RealtimeConnectionState` (enum/sealed)
`connecting · connected · reconnecting · disconnected({AppFailure? cause})`. Exposed as a
broadcast `Stream<RealtimeConnectionState>`.

### `RealtimeEvent` (typed, sealed) — per [contracts/socket-events.md](contracts/socket-events.md)
Outbound (client→server): `messageSend`, `typingStart`, `typingStop`, `conversationRead`,
`presencePing`. Inbound (server→client): `messageNew`, `messageDelivered`, `messageRead`,
`typing`, `presenceUpdate`, `notificationNew`.
- #002 ships the **typed envelope + (de)serialization + a fake bus**; payload bodies are minimal
  shells (ids + the fields the catalog names). Rich payloads are filled by #012/#013.

---

## 4. Auth/session boundary interfaces (core/services contracts; impls in #003)

| Interface | Responsibility (#002 = interface + fake; #003 = real) |
|---|---|
| `TokenStore` | `String? get accessToken` — read current token for the auth interceptor |
| `TokenRefresher` | `Future<bool> refresh()` — perform `POST /v1/auth/refresh`; true on success |
| `AuthEventsSink` | `void onUnauthenticated()` + `Stream<void> unauthenticated` — emitted once on refresh failure |

- #002 provides in-memory **fakes** for all three (drive single-flight tests). #002 does **not**
  persist credentials (secure storage is #003).

---

## 5. Reference slice entity — `User` (the ONE persisted + repository slice)

Minimal public-profile shape from the contract (`GET /v1/users/{username}`), enough to prove the
spine; profile #010 extends it.

### `User` (domain model — freezed + json_serializable)
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUIDv7 |
| `username` | `String` | unique handle |
| `displayName` | `String` | |
| `avatarUrl` | `String?` | CDN URL (nullable) |
| `bio` | `String?` | |
| `isPrivate` | `bool` | |
| `isVerified` | `bool` | |
| `followersCount` | `int` | aggregate |
| `followingCount` | `int` | aggregate |
| `postsCount` | `int` | aggregate |

### `UsersTable` (drift — the one reference cache table)
Columns mirror `User` (id `TEXT` PK, username `TEXT` unique, … counts `INTEGER`), plus
`cachedAt` (`TEXT` ISO-8601) for staleness. Reactive read via `.watch()`.

### `UserRepository` (interface) → `Result<User>`
| Method | Behavior |
|---|---|
| `getByUsername(String)` | cache-first emit, background refresh from remote, reconcile into `UsersTable`; on remote failure with cached value → return cached + soft failure |
| `watchByUsername(String)` | `Stream<User?>` reactive read from `UsersDao` |

- **Impls**: `UserRepositoryImpl` (remote `UserRemoteDataSource` + `UsersDao`) and
  `FakeUserRepository` (in-memory synthesized users; deterministic, no network).

---

## 6. Config & constants (core/config, core/constants)

| Artifact | Content |
|---|---|
| `AppConfig.apiBaseUrl` / `realtimeUrl` | filled per flavor with placeholders (dev/prod) |
| `ApiEndpoints` | path constants under `/v1` (e.g. `users(username)`, `authRefresh`, `me`, `feed`) |
| `SocketEvents` | event-name constants for every `RealtimeEvent` |

---

## Relationships (this spec)

```
ApiClient ──uses──▶ {TokenStore, TokenRefresher, AuthEventsSink}  (interfaces; fakes in #002)
ApiClient ──maps errors via──▶ FailureMapper ──▶ AppFailure
UserRemoteDataSource ──via──▶ ApiClient ──▶ CursorPage<T> / User json
UserRepositoryImpl ──reads/writes──▶ UsersDao ──▶ AppDatabase (drift)
PaginatedListCubit<T> ──pages from──▶ (any CursorPage<T> source; proven with fake user source)
RealtimeClient ──emits──▶ Stream<RealtimeConnectionState> + Stream<RealtimeEvent>
```

All consumers depend on **interfaces** (`ApiClient`, `UserRepository`, `RealtimeClient`,
`AppDatabase`); real and fake implementations are interchangeable via injectable DI.
