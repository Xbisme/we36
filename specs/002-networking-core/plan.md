# Implementation Plan: Networking, Cache & Realtime Core

**Branch**: `002-networking-core` | **Date**: 2026-06-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/002-networking-core/spec.md`

## Summary

Build the client-side data spine — one HTTP API client (auth attach + single-flight refresh +
centralized error→`AppFailure` mapping + idempotency + redacted logging), a generic cursor
pagination model + reusable 4-state paginated-list controller, a Socket.IO realtime client
scaffold (typed events, reconnect/backoff, connection-state stream), a drift local cache
(base + reactive reads + migrations), and a repository pattern with in-memory fakes — proven by
**one reference vertical slice** (`User` read) so the whole app builds, runs, and tests with **zero
network**. No screens. Source of truth is the backend contract (`api-context.md` + B#001
`openapi.yaml`/`realtime-events.md`); backend domain endpoints are not yet built, so fakes
synthesize contract-shaped payloads.

## Technical Context

**Language/Version**: Dart 3.11.5 / Flutter 3.41.7 (stable floor, per CLAUDE.md).

**Primary Dependencies** (new, pinned from pub.dev 2026-06-30): `dio ^5.10.0`,
`socket_io_client ^3.1.6` (Socket.IO v4 — see Complexity Tracking), `drift ^2.34.0` +
`drift_flutter ^0.3.0` (+ `drift_dev ^2.34.1` dev), `flutter_secure_storage ^10.3.1`,
`uuid ^4.5.3` (UUIDv7). Existing: `flutter_bloc`, `get_it`+`injectable`, `freezed`+
`json_serializable`+`build_runner`.

**Storage**: drift (SQLite) — base + one reference table (`UsersTable`); secure storage of tokens
is wired in #003 (interface seam only here).

**Testing**: `flutter test` + `bloc_test` + `mocktail`; stubbed `dio` for the client/mapper, fake
drift DB, fake `RealtimeClient`/`TokenRefresher`. No live backend in CI (Constitution XII).

**Target Platform**: iOS + Android (phones; tablets adapt) — no platform UI in this spec.

**Project Type**: Mobile app (Flutter), Clean Architecture feature-first; this spec is all `lib/core/`.

**Performance Goals**: N/A (no UI); deterministic non-flaky tests; single-flight guarantees no
duplicate refreshes.

**Constraints**: offline-buildable (zero network in tests); `lib/core/` MUST NOT import
`lib/features/`; no secrets in logs; cursor pagination only; one canonical cached representation
per item.

**Scale/Scope**: spine + one reference slice. ~6 capability areas (client, mapping, pagination,
cache, realtime scaffold, repo+fakes) + constants/config.

## Constitution Check

*GATE: evaluated against constitution v1.0.1. Re-checked after Phase 1 design.*

| Principle | Status | Notes |
|---|---|---|
| II. Media-Centric Performance | ✅ | Cursor pagination + cache base established here; bounded image decode is a #004 UI concern |
| III. BLoC 4-state | ✅ | `PaginatedListCubit` extends the #001 `AppCubit`; extended `loadedPaginating`/`loadedRefreshing` variants; realtime as shared `@lazySingleton` |
| IV. Code Quality & Dart Safety | ✅ | freezed/json_serializable models; explicit types; `very_good_analysis` zero-warning |
| V. Result\<T\> Error Handling | ✅ | Repos return `Result<T>`; central `AppFailure` mapping; `rateLimited` gains `retryAfter` (additive) |
| VIII. API & Realtime Architecture | ✅ | One `dio` client + repositories + single-flight refresh + one-place error mapping + per-flavor config + one realtime connection ALL satisfied. Realtime transport = `socket_io_client` (Socket.IO-compatible) — **now aligned**: constitution amended to `socket_io_client` in **v1.0.2** (was `web_socket_channel`), matching the backend Socket.IO gateway. No remaining conflict |
| IX. Data Integrity & Caching | ✅ | drift cache, reactive single-canonical reads, non-destructive migrations + test, idempotency keys, malformed-item tolerance |
| XI. Feature-First Modularity | ✅ | All in `lib/core/` (config/constants/data/domain/services); `core/` imports no features; repos don't depend on repos |
| XII. Testing Discipline | ✅ | Fake for every repository + fake socket + stubbed HTTP; deterministic, `mocktail` |
| XIII. Simplicity & YAGNI | ✅ | One reference slice (not 9 repos); no transient retry; no connectivity service — all deferred per clarifications |
| XIV. i18n | ✅ | `AppFailure`→localized messages already exist; new `rateLimited` reuses existing key |
| XV. Dependency Hygiene | ✅ | All versions sourced from pub.dev 2026-06-30 with caret pins; Socket.IO v4 compatibility verified; lockfile committed |

**Gate result**: PASS. The former realtime-transport deviation was **resolved** by amending the
constitution to `socket_io_client` (v1.0.2); no remaining violations.

## Project Structure

### Documentation (this feature)

```text
specs/002-networking-core/
├── plan.md              # This file
├── research.md          # Phase 0 — decisions + versions + deviation
├── data-model.md        # Phase 1 — transport/state types + reference slice
├── quickstart.md        # Phase 1 — validation scenarios (V1–V9)
├── contracts/           # Phase 1 — client contracts
│   ├── README.md
│   ├── error-mapping.md
│   ├── pagination.md
│   ├── socket-events.md
│   └── repositories.md
└── tasks.md             # Phase 2 — /speckit.tasks (NOT created here)
```

### Source Code (repository root)

```text
lib/core/
├── config/
│   └── app_config.dart            # fill apiBaseUrl/realtimeUrl per flavor (placeholders)
├── constants/
│   ├── api_endpoints.dart         # NEW — /v1 path constants
│   └── socket_events.dart         # NEW — realtime event-name constants
├── data/
│   ├── api/
│   │   ├── api_client.dart        # NEW — single Dio wrapper
│   │   ├── interceptors/          # NEW — auth_token, refresh, idempotency, logging
│   │   └── failure_mapper.dart    # NEW — DioException → AppFailure
│   ├── pagination/
│   │   ├── cursor_page.dart       # NEW — CursorPage<T> + PageRequest
│   │   └── paginated_list_cubit.dart  # NEW — reusable 4-state controller
│   ├── cache/
│   │   ├── app_database.dart      # NEW — drift DB + migration strategy
│   │   ├── daos/                  # NEW — DAO base + UsersDao
│   │   └── tables/users_table.dart# NEW — reference table
│   ├── realtime/
│   │   ├── realtime_client.dart   # NEW — Socket.IO client + ConnectionState
│   │   ├── realtime_event.dart    # NEW — typed event sealed types
│   │   └── fake_realtime_client.dart  # NEW — in-memory bus for tests/fake env
│   └── user/                      # reference slice
│       ├── user.dart              # NEW — domain model (freezed/json)
│       ├── user_remote_data_source.dart
│       ├── user_repository.dart   # interface
│       ├── user_repository_impl.dart
│       └── fake_user_repository.dart
├── domain/
│   └── app_failure.dart           # MODIFY — rateLimited({Duration? retryAfter})
├── services/
│   └── session/                   # NEW — TokenStore/TokenRefresher/AuthEventsSink interfaces + fakes
└── di/                            # injectable registrations (+ @Environment fake/dev/prod)

test/core/
├── data/api/        (failure_mapper_test, single_flight_refresh_test, redacting_logger_test)
├── data/pagination/ (paginated_list_cubit_test, cursor_page_test)
├── data/cache/      (app_database_test, users_dao_reactive_test, migration_test)
├── data/realtime/   (realtime_client_reconnect_test, realtime_event_test)
└── data/user/       (user_repository_test — real vs fake)
```

**Structure Decision**: Pure `lib/core/` work under the existing Clean-Architecture tree
(Constitution XI). No `lib/features/` changes; the reference slice lives in `core/data/user/`
(shared infra proof), to be replaced/extended by the real profile feature (#010) without rework.

## Complexity Tracking

No outstanding violations. (The former realtime-transport item — constitution literally named
`web_socket_channel` while the backend is Socket.IO — was **resolved by amending the constitution to
`socket_io_client` in v1.0.2**, since the backend `@nestjs/platform-socket.io` + Redis-adapter
gateway is shipped/locked and a raw WebSocket client cannot speak Socket.IO. Architecture intent is
unchanged: one connection behind one `RealtimeClient`, typed events, reconnect/backoff/heartbeat,
graceful degradation.)

## Post-Design Constitution Re-Check

Re-evaluated after Phase 1: design keeps all networking behind `core/` repositories returning
`Result<T>`, one client, one socket, single-flight refresh, central mapping, cursor pagination,
drift cache with reactive single-source reads, and fakes for every seam. With the v1.0.2 amendment,
the realtime transport now matches the constitution. **PASS — no deviations.**
