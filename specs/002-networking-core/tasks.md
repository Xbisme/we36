---
description: "Task list for #002 Networking, Cache & Realtime Core"
---

# Tasks: Networking, Cache & Realtime Core

**Input**: Design documents from `specs/002-networking-core/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: INCLUDED — Constitution XII mandates unit + BLoC tests for mapping/pagination/cache/realtime, and every Success Criterion (V1–V9 in [quickstart.md](quickstart.md)) is test-verified. Write each test with (or just before) its implementation; all run offline (no live backend).

**Organization**: Grouped by user story (priority order from spec.md). No UI — all work is in `lib/core/`.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: parallelizable (different files, no incomplete-task dependency)
- **[Story]**: US1–US6 maps to spec user stories; Setup/Foundational/Polish have no story label

## Path Conventions

Mobile/Flutter, Clean Architecture: all paths under `lib/core/` and `test/core/` (per [plan.md](plan.md) → Project Structure).

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Dependencies + codegen wiring

- [x] T001 Add pinned deps to `pubspec.yaml`: `dio: ^5.10.0`, `socket_io_client: ^3.1.6`, `drift: ^2.34.0`, `drift_flutter: ^0.3.0`, `flutter_secure_storage: ^10.3.1`, `uuid: ^4.5.3`; dev_dependencies: `drift_dev: ^2.34.1` (versions per [research.md](research.md), pub.dev 2026-06-30; caret pins, Constitution XV).
- [x] T002 Run `flutter pub get`; confirm clean resolution and commit `pubspec.lock` (review transitive churn, Constitution XV).
- [x] T003 [P] Confirm `build.yaml`/`build_runner` picks up drift codegen (add drift builder config if needed); run `dart run build_runner build --delete-conflicting-outputs` once to verify the toolchain is green.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared seams every story depends on

**⚠️ CRITICAL**: No user story work begins until this phase is complete

- [x] T004 Modify `AppFailure.rateLimited()` → `rateLimited({Duration? retryAfter})` in `lib/core/domain/app_failure.dart`; keep `app_failure_messages.dart` switch valid (variant unchanged); regen via `dart run build_runner build --delete-conflicting-outputs`.
- [x] T005 [P] Create `lib/core/constants/api_endpoints.dart` — `/v1` path constants (`users(username)`, `me`, `authRefresh`, `feed`, demo `page`) per [contracts/error-mapping.md](contracts/error-mapping.md) + api-context (mirror `app_routes.dart` style).
- [x] T006 [P] Create `lib/core/constants/socket_events.dart` — event-name constants for every `RealtimeEvent` per [contracts/socket-events.md](contracts/socket-events.md).
- [x] T007 Fill per-flavor placeholders in `lib/core/config/app_config.dart` — dev `apiBaseUrl=https://api.we36.dev`, `realtimeUrl=wss://rt.we36.dev`; prod `https://api.we36.app` / `wss://rt.we36.app` (both rooted for `/v1`).
- [x] T008 [P] Create session boundary interfaces + in-memory fakes in `lib/core/services/session/`: `TokenStore`, `TokenRefresher`, `AuthEventsSink` (+ `FakeTokenStore`, `FakeTokenRefresher`, `FakeAuthEventsSink`) per [data-model.md](data-model.md) §4.
- [x] T009 Set up injectable `@Environment` constants (`fake`/`dev`/`prod`) and register the Phase-2 fakes; run injectable codegen (`injection.config.dart`).

**Checkpoint**: Shared seams ready — user stories can begin.

---

## Phase 3: User Story 1 — Resilient HTTP client (Priority: P1) 🎯 MVP

**Goal**: One `dio` client that attaches the token, does single-flight refresh on `401 SESSION_EXPIRED`, maps every error to a typed `AppFailure`, sends idempotency keys, and logs with secrets redacted.

**Independent Test**: Against a stubbed `dio` + fake session seams: token attaches; concurrent 401s trigger exactly one refresh + retry; every error code maps to its failure; logs are redacted. (quickstart V2–V4, V9)

### Tests for User Story 1

- [x] T010 [P] [US1] Table-driven `FailureMapper` test (every catalog `code` + each `DioExceptionType` + 429 `retryAfter` + malformed/non-envelope body + unknown code) in `test/core/data/api/failure_mapper_test.dart`.
- [x] T011 [P] [US1] Single-flight refresh test (N concurrent `401 SESSION_EXPIRED` → refresher called once, all retry & succeed; refresh failure → all `sessionExpired()` + `onUnauthenticated` fired once, no loop) in `test/core/data/api/single_flight_refresh_test.dart`.
- [x] T012 [P] [US1] Redacting-logger test (Authorization/token/password redacted in output) in `test/core/data/api/redacting_logger_test.dart`.

### Implementation for User Story 1

- [x] T013 [US1] Implement `FailureMapper` (`DioException` → `AppFailure`, parse error envelope + 429 `Retry-After`) in `lib/core/data/api/failure_mapper.dart`.
- [x] T014 [P] [US1] Implement idempotency-key helper (uuid v7 + request `extra` flag for content mutations) in `lib/core/data/api/idempotency.dart`.
- [x] T015 [P] [US1] Implement redacting log interceptor (AppLogger, no secrets/PII) in `lib/core/data/api/interceptors/logging_interceptor.dart`.
- [x] T016 [US1] Implement auth-token attach interceptor (reads `TokenStore`) in `lib/core/data/api/interceptors/auth_token_interceptor.dart`.
- [x] T017 [US1] Implement single-flight refresh interceptor (shared `Future`/`Completer`, re-entrancy guard, `TokenRefresher` + `AuthEventsSink`) in `lib/core/data/api/interceptors/refresh_interceptor.dart`.
- [x] T018 [US1] Implement `ApiClient` (single `Dio`, per-flavor base URL `/v1`, timeouts, interceptor order: idempotency → auth → refresh → logging → mapping) in `lib/core/data/api/api_client.dart`.
- [x] T019 [US1] Register `ApiClient` + interceptors in DI (`@lazySingleton`) and wire `AppConfig` base URL; regen injectable.

**Checkpoint**: HTTP client fully functional + tested against stubs (no network).

---

## Phase 4: User Story 2 — Repository pattern + fakes (reference slice) (Priority: P1)

**Goal**: A `Result<T>` repository pattern with a real + in-memory fake, proven by the `User` reference slice, so the app builds/tests with zero network.

**Independent Test**: Resolve `UserRepository` under the `fake` env → returns synthesized contract-shaped users with no network; `flutter test` green offline. (quickstart V1, V8 fake side)

### Tests for User Story 2

- [x] T020 [P] [US2] `FakeUserRepository` test (returns `Result.ok(User)` with UUIDv7/camelCase/int-count shape; deterministic; no network) in `test/core/data/user/fake_user_repository_test.dart`.

### Implementation for User Story 2

- [x] T021 [P] [US2] Create `User` domain model (freezed + json_serializable, fields per [data-model.md](data-model.md) §5) in `lib/core/data/user/user.dart`; regen.
- [x] T022 [US2] Implement `UserRemoteDataSource.getByUsername` (`GET /v1/users/{username}` via `ApiClient`, decode `User`) in `lib/core/data/user/user_remote_data_source.dart`.
- [x] T023 [US2] Define `UserRepository` interface (`getByUsername`/`watchByUsername` → `Result<User>`/`Stream<User?>`) in `lib/core/data/user/user_repository.dart`.
- [x] T024 [P] [US2] Implement `FakeUserRepository` (in-memory synthesized users) in `lib/core/data/user/fake_user_repository.dart`.
- [x] T025 [US2] DI: register `UserRepository` → `FakeUserRepository` under `@Environment('fake')`; confirm a consumer resolves it with zero network; regen injectable.

**Checkpoint**: Repository pattern + fake proven; app builds/tests offline. (Real cache-backed impl lands in US4.)

---

## Phase 5: User Story 3 — Cursor pagination controller (Priority: P2)

**Goal**: A generic `CursorPage<T>` + reusable 4-state `PaginatedListCubit<T>` (load-first / load-more / de-dupe / end / refresh).

**Independent Test**: `bloc_test` over `PaginatedListCubit<User>` + a fake 3-page source proves the full lifecycle. (quickstart V5)

### Tests for User Story 3

- [x] T026 [P] [US3] `CursorPage.fromJson` test (parse envelope, null cursor = end, malformed item skipped) in `test/core/data/pagination/cursor_page_test.dart`.
- [x] T027 [P] [US3] `PaginatedListCubit` `bloc_test` (first-load → load-more append+de-dupe → end no-op → refresh replace; load-more failure keeps items) in `test/core/data/pagination/paginated_list_cubit_test.dart`.

### Implementation for User Story 3

- [x] T028 [P] [US3] Implement `CursorPage<T>` + `PageRequest` (generic `fromJson`, `limit` clamp 20/30) in `lib/core/data/pagination/cursor_page.dart`.
- [x] T029 [US3] Implement `PaginatedListCubit<T>` extending `AppCubit<List<T>>` (extended `loadedPaginating`/`loadedRefreshing`, `idSelector` de-dupe) in `lib/core/data/pagination/paginated_list_cubit.dart` (depends on US2 `User` model for the test source).

**Checkpoint**: Pagination controller reusable + proven against a fake paged source.

---

## Phase 6: User Story 4 — Local cache (drift) + reference slice integration (Priority: P2)

**Goal**: drift DB base + reactive reads + migrations + the `UsersTable` reference table; wire the real cache-first `UserRepositoryImpl`.

**Independent Test**: drift test — write users, close+reopen DB → present; update one → `watch` emits once. (quickstart V6); real `UserRepository` (dev env) interchangeable with fake (V8 real side).

### Tests for User Story 4

- [x] T030 [P] [US4] DB restart + reactive test (write users → reopen DB → present; update → `watchByUsername` emits new value once) in `test/core/data/cache/users_dao_test.dart`.
- [x] T031 [P] [US4] Migration test (schema v1 → vNext non-destructive, data preserved) in `test/core/data/cache/migration_test.dart`.
- [x] T032 [US4] `UserRepositoryImpl` test (cache-first emit + background refresh via stubbed `ApiClient` + in-memory drift; remote failure with cached value → returns cached) in `test/core/data/user/user_repository_impl_test.dart`.

### Implementation for User Story 4

- [x] T033 [US4] Implement `AppDatabase` (drift, `drift_flutter` open, `schemaVersion`, `MigrationStrategy`) in `lib/core/data/cache/app_database.dart`.
- [x] T034 [P] [US4] Define `UsersTable` (columns per [data-model.md](data-model.md) §5 + `cachedAt`) in `lib/core/data/cache/tables/users_table.dart`; regen drift.
- [x] T035 [US4] Implement `UsersDao` (upsert, `watchByUsername`, getByUsername) + DAO base in `lib/core/data/cache/daos/users_dao.dart`.
- [x] T036 [US4] Implement `UserRepositoryImpl` (cache-first emit + reconcile via `UserRemoteDataSource`; cache-fallback on failure) in `lib/core/data/user/user_repository_impl.dart` (depends on US1 client + T035 dao + US2 interface).
- [x] T037 [US4] DI: register `AppDatabase` (`@lazySingleton`), `UsersDao`, and `UserRepository` → `UserRepositoryImpl` under `@Environment('dev')`/`@Environment('prod')`; regen injectable.

**Checkpoint**: Cache persists + reactive; reference slice works real (dev/prod) and fake interchangeably.

---

## Phase 7: User Story 5 — Realtime client scaffold (Priority: P3)

**Goal**: One Socket.IO `RealtimeClient` (auth on connect, typed events, reconnect/backoff/heartbeat, connection-state stream) + a fake bus; scaffold-only.

**Independent Test**: Fake gateway — connect (auth) → `connected`; induce drop → `reconnecting`→`connected`; round-trip one inbound + one outbound typed event; HTTP read works with socket down. (quickstart V7)

### Tests for User Story 5

- [x] T038 [P] [US5] `RealtimeEvent` (de)serialization test (each catalog event ↔ wire name/payload) in `test/core/data/realtime/realtime_event_test.dart`.
- [x] T039 [P] [US5] Reconnect + round-trip test against `FakeRealtimeClient` (connection-state transitions; inbound+outbound typed event; degrade read-only) in `test/core/data/realtime/realtime_client_test.dart`.

### Implementation for User Story 5

- [x] T040 [P] [US5] Implement typed `RealtimeEvent` sealed types + `RealtimeConnectionState` (using `SocketEvents` constants) in `lib/core/data/realtime/realtime_event.dart`.
- [x] T041 [US5] Implement `RealtimeClient` interface + Socket.IO impl (`socket_io_client`, auth payload, configured `reconnection`/backoff/heartbeat, `connectionState` + `events` streams) in `lib/core/data/realtime/realtime_client.dart`.
- [x] T042 [P] [US5] Implement `FakeRealtimeClient` (in-memory event bus + scriptable connection-state) in `lib/core/data/realtime/fake_realtime_client.dart`.
- [x] T043 [US5] DI: register `RealtimeClient` (`@lazySingleton`; real under dev/prod, fake under `fake`/test); regen injectable.

**Checkpoint**: Realtime scaffold connects/reconnects + typed round-trip via fake; ready for #012/#013 wiring.

---

## Phase 8: User Story 6 — Constants & per-flavor config verification (Priority: P3)

**Goal**: Verify endpoints/events resolve from constants and per-flavor config returns distinct values (building blocks created in Foundational T005–T007).

**Independent Test**: Resolve config under dev vs prod → distinct base URL + realtime endpoint; endpoint/event references come from constants, not literals.

### Tests for User Story 6

- [x] T044 [P] [US6] Config test (dev vs prod `AppConfig` → distinct `apiBaseUrl`/`realtimeUrl`) in `test/core/config/app_config_test.dart`.
- [x] T045 [P] [US6] Guard test/script asserting no inline endpoint/event literals in `lib/core/data/` (grep `/v1/` + raw `message.`/`typing.` outside constants) — extend the existing hardcoded-value CI guard.

**Checkpoint**: Constants/config centralized + verified.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Validation, gates, docs

- [x] T046 Run full quickstart V1–V9 ([quickstart.md](quickstart.md)) and fix any gaps.
- [x] T047 Run the pre-commit gate: `dart format .`, `flutter analyze` (zero warnings), `flutter test` (all pass), `dart run bloc_tools:bloc lint .` (zero violations).
- [x] T048 [P] Confirm `flutter test` performs zero real network I/O (grep tests for real hosts; all seams use fakes/stubs) — SC-001.
- [x] T049 [P] Update [CLAUDE.md](../../CLAUDE.md) (new deps dio/socket_io_client/drift/secure_storage/uuid; networking conventions) + `.claude/claude-app/` (project-context #002 in progress, changelog when merged).
- [x] T050 [P] Constitution PATCH applied (v1.0.2): Principle VIII + Technical Standards realtime transport corrected `web_socket_channel` → `socket_io_client`; backend `api-context.md` consumer line corrected to match. Deviation resolved before implementation.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (P1)**: no deps — start immediately.
- **Foundational (P2)**: depends on Setup — **BLOCKS all user stories**.
- **User Stories (P3–P8)**: depend on Foundational. Recommended order = priority: US1 → US2 → US3 → US4 → US5 → US6. Cross-story notes below.
- **Polish (P9)**: depends on all targeted stories.

### Cross-Story Dependencies (infrastructure reality)

- **US2** (model + fake) is independently testable (fake path, no cache).
- **US3** test source uses the US2 `User` model → sequence US2 before US3 (or stub the model).
- **US4** `UserRepositoryImpl` (T036) integrates **US1** client + **US4** cache + **US2** interface → sequence US1, US2, US4 before T036.
- **US5** and **US6** are independent of US2–US4.

### Within Each User Story

- Tests written with/just before implementation (Constitution XII); models before services before DI wiring.

### Parallel Opportunities

- Setup: T003 parallel after T001/T002.
- Foundational: T005, T006, T008 parallel (T004, T007, T009 touch shared/generated files).
- US1 tests T010–T012 parallel; impl T014/T015 parallel (distinct files).
- US5 T040/T042 parallel; tests T038/T039 parallel.
- After Foundational, US5 and US6 can proceed in parallel with the US1→US4 chain (different files).

---

## Parallel Example: User Story 1

```text
# Tests together:
T010 FailureMapper test · T011 single-flight refresh test · T012 redacting-logger test
# Then independent impl files together:
T014 idempotency helper · T015 logging interceptor
```

---

## Implementation Strategy

### MVP First (US1 + US2)

1. Phase 1 Setup → Phase 2 Foundational.
2. Phase 3 US1 (HTTP client) → validate single-flight + mapping against stubs.
3. Phase 4 US2 (repo + fake) → app builds/tests offline.
4. **STOP & VALIDATE**: quickstart V1–V4, V8(fake), V9. This is the usable spine MVP for #003 to build auth on.

### Incremental Delivery

US1 → US2 (MVP) → US3 pagination → US4 cache (completes reference slice real path) → US5 realtime scaffold → US6 config verify → Polish. Each story adds value without breaking prior ones.

---

## Notes

- [P] = different files, no incomplete-task dependency.
- All tests offline (stubbed `dio`, in-memory drift, `FakeRealtimeClient`) — Constitution XII.
- Run `build_runner` after any freezed/json/drift/injectable change (T004, T009, T019, T021, T025, T029?, T034, T037, T043).
- The realtime transport uses `socket_io_client`, now aligned with the constitution (amended to v1.0.2; T050 done).
- Commit after each task or logical group; keep `pubspec.lock` churn reviewed (Constitution XV).
