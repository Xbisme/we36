# Phase 0 Research: Networking, Cache & Realtime Core (#002)

**Date**: 2026-06-30 · **Spec**: [spec.md](spec.md) · **Branch**: `002-networking-core`

All package versions sourced from pub.dev on 2026-06-30 (Constitution XV). The backend
contract is the source of truth: [`api-context.md`](../../backend/.claude/claude-app/api-context.md)
+ [`openapi.yaml`](../../backend/specs/001-service-foundation/contracts/openapi.yaml) +
`realtime-events.md`.

---

## R1. HTTP client — `dio`

- **Decision**: `dio ^5.10.0`, one `Dio` instance behind `ApiClient`, configured per flavor
  (base URL rooted at `/v1`). Interceptors (ordered): correlation/idempotency → auth-token
  attach → refresh-on-401 → logging (redacted) → error→`AppFailure` mapping.
- **Rationale**: Constitution VIII names `dio`; interceptors are the idiomatic place for
  token attach, single-flight refresh, and centralized error mapping. One instance keeps
  base URL + timeouts + interceptor order in a single place.
- **Alternatives**: `http` (no interceptor pipeline — would hand-roll refresh/mapping);
  `chopper`/`retrofit` codegen (extra abstraction, YAGNI for #002). Rejected.

## R2. Single-flight token refresh

- **Decision**: A `QueuedInterceptor` that, on `401` with body code `SESSION_EXPIRED`, calls a
  `TokenRefresher` callback guarded by a shared `Future` (`Completer`): the first 401 starts
  the refresh; concurrent 401s `await` the same future; on success all retry once with the new
  token; on failure all resolve to `AppFailure.sessionExpired()` and **one** `unauthenticatedSignal`
  is emitted (a broadcast `Stream`/callback the session layer #003 listens to). A re-entrancy
  guard prevents the refresh request itself from triggering refresh.
- **Rationale**: Constitution VIII mandates single-flight (never N parallel refreshes). The
  shared-future pattern is the standard, testable way; the signal/refresher are **interfaces**
  so #002 owns the *mechanism* and #003 owns the *credentials* (clarified boundary).
- **#002 provides**: `TokenStore` (read access token), `TokenRefresher` (perform refresh),
  `AuthEventsSink` (emit unauthenticated) — all as interfaces, with **fakes** for tests. Real
  secure-storage-backed implementations land in #003.
- **Alternatives**: `dio` retry packages (don't model single-flight); per-request mutex
  (allows N refreshes). Rejected.

## R3. Error envelope → `AppFailure` mapping

- **Decision**: One `FailureMapper` maps `DioException` → existing `AppFailure` (already fully
  declared in [`app_failure.dart`](../../lib/core/domain/app_failure.dart)). Response errors
  parse `{ error: { code, message, details? } }` and map the stable code catalog; transport
  errors map by `DioExceptionType`.
- **Code → AppFailure table** (contract codes are stable — never renamed):

  | Backend `code` / fault | HTTP | `AppFailure` |
  |---|---|---|
  | `UNAUTHENTICATED` | 401 | `unauthenticated()` |
  | `INVALID_CREDENTIALS` | 401 | `invalidCredentials()` |
  | `SESSION_EXPIRED` | 401 | `sessionExpired()` (after refresh fails) |
  | `OAUTH_FAILED` | 401 | `oauthFailed()` |
  | `FORBIDDEN` | 403 | `forbidden()` |
  | `NOT_FOUND` | 404 | `notFound()` |
  | `CONFLICT` | 409 | `conflict()` |
  | `VALIDATION` | 422 | `validation(fields: details)` |
  | `RATE_LIMITED` | 429 | `rateLimited(retryAfter:)` |
  | `MEDIA_TOO_LARGE` | 413 | `mediaTooLarge()` |
  | `UNSUPPORTED_MEDIA` | 415 | `unsupportedMedia()` |
  | `UPLOAD_FAILED` | 422 | `uploadFailed()` |
  | `SERVER_ERROR` | 500 | `serverError()` |
  | connectTimeout/receiveTimeout/sendTimeout | — | `timeout()` |
  | connectionError / no host | — | `networkError()` (offline inferred) |
  | cancel | — | `unknown(message:'cancelled')` |
  | unparseable / non-envelope body | any | `serverError()` (4xx/5xx) or `unknown()` |
  | unknown `code` not in catalog | any | `unknown(message: message)` |

- **Required change**: extend `AppFailure.rateLimited()` to `rateLimited({Duration? retryAfter})`
  so the 429 `Retry-After` header is carried (FR-010). Optional param → the existing
  `app_failure_messages.dart` switch and #001 call sites stay valid. Re-run `build_runner`.
- **Rationale**: Constitution V/VIII — mapping centralized in the client; call sites never see
  HTTP. The vocabulary already exists from #001; only `rateLimited` gains a field.
- **Alternatives**: a separate `NetworkFailure` type (duplicates `AppFailure`). Rejected.

## R4. Cursor pagination + reusable paginated-list controller

- **Decision**: `CursorPage<T>` model (`items`, `String? nextCursor`, `bool hasMore`) with a
  generic `fromJson(json, itemParser)`. A `PaginatedListCubit<T>` extends the #001 4-state
  `AppCubit` (Constitution III): `loaded` carries items + `nextCursor` + `hasMore` +
  `isLoadingMore`/`endReached` sub-flags (extended states `loadedPaginating`,
  `loadedRefreshing`). De-dupe by an `idSelector`. Requests send `?cursor=&limit=` (default 20,
  max 30).
- **Rationale**: Constitution II/III/VIII require cursor pagination modeled in `loaded` with an
  explicit cursor + `hasMore` (no boolean soup) and a shared envelope reused by feed/search/comments.
- **Alternatives**: `infinite_scroll_pagination` package (its own controller/state — conflicts
  with the mandated 4-state Cubit). Rejected; we reuse `AppCubit`.

## R5. Realtime transport — **`socket_io_client` (constitution aligned, v1.0.2)**

- **Decision**: `socket_io_client ^3.1.6` (supports Socket.IO server protocol v4.x), **not**
  `web_socket_channel`. The backend gateway is `@nestjs/platform-socket.io` (v11 → Socket.IO
  v4) with `@socket.io/redis-adapter`; a raw WebSocket client cannot speak the Socket.IO
  handshake/framing, so `web_socket_channel` is technically incompatible.
- **Constitution alignment**: Principle VIII + Technical Standards previously named
  `web_socket_channel`. Since the backend Socket.IO gateway is shipped/locked and a raw WebSocket
  client cannot speak it, the constitution was **amended to `socket_io_client` in v1.0.2** (PATCH,
  no principle added/removed) and the backend `api-context.md` consumer line corrected to match.
  No remaining conflict.
- **Shape**: one `RealtimeClient` owning a single connection, auth token sent in the connect
  `auth` payload; typed event surface per `realtime-events.md`; `ConnectionState` stream
  (connecting/connected/reconnecting/disconnected). Socket.IO provides built-in reconnection +
  backoff + heartbeat (ping/pong) — configure (don't reimplement) `reconnection`,
  `reconnectionDelay`, `reconnectionDelayMax`, `randomizationFactor`. **Scaffold-only**: no
  feature subscriptions wired (#012/#013). A **fake** `RealtimeClient` (in-memory event bus)
  backs all #002 tests — no live socket (Constitution XII).
- **Alternatives**: `web_socket_channel` (incompatible with Socket.IO — would require the
  backend to drop Socket.IO; rejected as it contradicts the shipped backend B#001);
  hand-rolled Engine.IO (huge, fragile). Rejected.

## R6. Local cache — `drift` (decided at clarification)

- **Decision**: `drift ^2.34.0` + `drift_flutter ^0.3.0` (bundles the Flutter SQLite setup) +
  `drift_dev ^2.34.1` (dev, codegen via the existing `build_runner`). One `AppDatabase` with a
  `daos/` base; reactive reads via drift `.watch()` streams give the single-canonical-representation
  guarantee (Constitution IX). Migrations via drift's `MigrationStrategy` (schema version bump),
  with a migration test harness.
- **#002 scope** (clarified — base + one reference slice): the database scaffold + one reference
  table (`UsersTable`) to prove restart-persistence + reactive reads. Other tables land per
  feature.
- **Rationale**: Constitution IX lists drift|hive; drift chosen for relational feed/DM/profile +
  reactive streams + type-safe migrations (api-context entity map is relational). `drift_flutter`
  removes the `NativeDatabase`/`path_provider`/`sqlite3_flutter_libs` boilerplate.
- **Alternatives**: `hive` (KV — weak for relational pagination/joins, manual indexing for DM);
  raw `sqflite` (no reactive streams, no type-safe queries). Rejected.

## R7. Repository base + fakes + reference vertical slice

- **Decision**: A repository pattern where each repository interface returns `Result<T>` and has
  a real (remote + cache) and a **fake** implementation, selected via injectable
  `@Environment` (e.g. `prod`/`dev` vs `test`/`fake`). The **one reference slice** is `User`
  (read-only public profile): `UserRemoteDataSource.getByUsername` → `GET /v1/users/{username}`,
  `UsersDao` (drift), `UserRepositoryImpl` (cache-first + background refresh) and `FakeUserRepository`
  (synthesized contract-shaped users). The generic `PaginatedListCubit` is proven against a fake
  paged user source.
- **Rationale**: `User` is a real contract entity, read-only (doesn't preempt #003's auth-owned
  writes), reused later by profile #010 — it exercises the full spine (HTTP→map→cache→reactive→fake)
  without inventing throwaway domain. Other entities' repos are built by their features.
- **Alternatives**: a throwaway `Demo` entity against `/_demo/page` (proves nothing reusable);
  building all 9 entity repos now (rejected at clarification — scope bloat, fakes drift from an
  unbuilt backend). Rejected.

## R8. Idempotency keys

- **Decision**: `uuid ^4.5.3` (supports UUID v7, matching the backend id scheme). Content-creating
  mutations attach an `Idempotency-Key` header generated once per logical mutation and **reused**
  across the single post-refresh retry (FR-006). A small `IdempotencyKey` helper + a request
  `extra` flag mark which requests are idempotent.
- **Rationale**: Constitution IX requires idempotent create/send/like; reusing the key across the
  retry is what makes the retry safe.
- **Alternatives**: server-only dedupe (can't — client must send a stable key). Rejected.

## R9. Config & constants

- **Decision**: Fill the existing `AppConfig.apiBaseUrl`/`realtimeUrl` per flavor with **placeholder**
  values (dev `https://api.we36.dev` + `wss://rt.we36.dev`; prod `https://api.we36.app` +
  `wss://rt.we36.app`) — real values wired when the backend deploys. Add `core/constants/api_endpoints.dart`
  (path constants under `/v1`) and `core/constants/socket_events.dart` (event-name constants), mirroring
  the existing `app_routes.dart` pattern.
- **Rationale**: Constitution VIII — endpoint paths + socket event names in one constants location,
  per-flavor base URL centralized. #001 already reserved the config slots.
- **Alternatives**: inline literals at call sites (forbidden). Rejected.

## R10. No transient auto-retry; offline inferred (clarifications)

- **Decision**: The HTTP client performs **no** automatic retry for 5xx/timeout/no-connectivity;
  the only auto-retry is the single post-refresh retry (R2). "Offline" is inferred from a failed
  request → `networkError()`/`offline()`; no dedicated connectivity service in #002 (clarified).
  Repositories implement cache-fallback on read failure.
- **Rationale**: Avoids retry storms, keeps the client simple and deterministic to test; matches
  both clarifications.
- **Alternatives**: retry interceptor with backoff (deferred — adds idempotency risk + test
  complexity); `connectivity_plus` service (deferred until a feature needs an offline banner).

## Resolved unknowns

All Technical Context unknowns are resolved; no remaining `NEEDS CLARIFICATION`. Deferred items
(connectivity service, transient retry, per-entity repos) are explicitly out of #002 scope.
