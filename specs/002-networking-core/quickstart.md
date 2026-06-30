# Quickstart / Validation: Networking, Cache & Realtime Core (#002)

How to prove #002 works end-to-end. There is **no UI** — validation is via tests + DI wiring, all
**offline** (no live backend). Detail lives in [contracts/](contracts/) and [data-model.md](data-model.md).

## Prerequisites

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed/json/injectable/drift codegen
```

New packages (pinned, pub.dev 2026-06-30): `dio ^5.10.0`, `socket_io_client ^3.1.6`,
`drift ^2.34.0`, `drift_flutter ^0.3.0`, `flutter_secure_storage ^10.3.1`, `uuid ^4.5.3`;
dev: `drift_dev ^2.34.1`.

## Pre-commit gate (must stay green)

```bash
dart format .
flutter analyze                  # zero warnings
flutter test                     # all pass, no network
dart run bloc_tools:bloc lint .  # zero violations
```

## Validation scenarios (map to Success Criteria)

| # | Scenario | How to validate | SC |
|---|---|---|---|
| V1 | App builds + tests pass with zero network | `flutter test` green; grep tests for real hosts → none | SC-001 |
| V2 | Single-flight refresh | Unit test: fire N concurrent requests that all get `401 SESSION_EXPIRED` against a stubbed `dio` + fake `TokenRefresher`; assert refresher called **once**, all N succeed on retry | SC-002 |
| V3 | Refresh failure → one logout signal | Fake refresher returns false; assert all waiters resolve `sessionExpired()` and `AuthEventsSink.onUnauthenticated` fires **once** | SC-002 |
| V4 | Error mapping coverage | Table-driven unit test: each catalog `code` + each `DioExceptionType` → expected `AppFailure`; malformed body → safe failure; 429 carries `retryAfter` | SC-003 |
| V5 | Paginated-list controller | `bloc_test` over `PaginatedListCubit<User>` + fake 3-page source: first-load → load-more (appended, de-duped) → end (no further fetch) → refresh (replaced) | SC-004 |
| V6 | Cache survives restart + reactive | drift test: write users, close+reopen DB → users present; update one → `watchByUsername` emits new value once | SC-005 |
| V7 | Realtime reconnect + round-trip | Fake gateway: connect (auth) → `connected`; induce drop → `reconnecting`→`connected`; round-trip one inbound + one outbound typed event; HTTP read still works with socket down | SC-006 |
| V8 | Repo real/fake interchangeable | Resolve `UserRepository` under `fake` env and under `dev` env (stubbed client) → same interface, consumer unchanged | SC-007 |
| V9 | No secrets in logs | Unit test the redacting logger: a request with `Authorization`/token/password → output has them redacted; grep `lib/` for `print(`/`debugPrint(` → none | SC-008 |

## Expected outcome

All of V1–V9 pass via `flutter test` with no backend running. The spine is then ready for #003
(auth wires the real `TokenStore`/`TokenRefresher`/secure storage) and #004 (feed builds its
repository + cache table on this base).

## Note on the realtime transport

`socket_io_client` is the realtime transport because the backend gateway is Socket.IO (incompatible
with raw WebSocket). The constitution was amended to `socket_io_client` in **v1.0.2** to match, so
this is fully aligned (no outstanding deviation).
