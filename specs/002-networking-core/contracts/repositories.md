# Contract: Repository Pattern, Fakes & Reference Slice

Every repository returns `Result<T>` (Constitution V/VIII), never throws. Each has a **real**
(remote + cache) and an **in-memory fake** implementation, interchangeable via injectable DI
(`@Environment`). #002 ships the **base/pattern + one reference slice** (`User`); other entities'
repositories are built by their features.

## Base seams

| Seam | Role |
|---|---|
| `ApiClient` | wraps the single `Dio`; exposes typed `get/post/...` returning decoded json or throwing into the mapper; injects auth/refresh/idempotency/logging interceptors |
| `FailureMapper` | `DioException` → `AppFailure` (see [error-mapping.md](error-mapping.md)) |
| `AppDatabase` (drift) | one DB; `daos/` base; reactive `.watch()` reads; migration strategy |
| `RealtimeClient` | one connection; typed events; connection-state stream (see [socket-events.md](socket-events.md)) |
| `TokenStore` / `TokenRefresher` / `AuthEventsSink` | session boundary interfaces (impls in #003; fakes in #002) |

## Reference slice — `User` (read-only public profile)

```
abstract interface class UserRepository {
  Future<Result<User>> getByUsername(String username);   // cache-first + background refresh
  Stream<User?> watchByUsername(String username);          // reactive cache read
}
```

| Impl | Backed by | Notes |
|---|---|---|
| `UserRepositoryImpl` | `UserRemoteDataSource` (`GET /v1/users/{username}`) + `UsersDao` (drift) | cache-first emit; reconcile on refresh; on remote failure with cached value → return cached |
| `FakeUserRepository` | in-memory map | deterministic synthesized contract-shaped users; no network; used by app (fake env) + tests |

- `UserRemoteDataSource.getByUsername` decodes the contract user shape (string UUIDv7 id, camelCase,
  int counts) via generated json_serializable.
- `UsersDao` persists `UsersTable`; `watchByUsername` streams updates (single canonical copy).

## Pagination proof

`PaginatedListCubit<User>` is exercised against a **fake paged user source** (multi-page
`CursorPage<User>`) — proving first-load / load-more / de-dupe / end / refresh without a real
endpoint.

## DI / environments

- Real impls: `@Environment('prod')` + `@Environment('dev')`.
- Fakes: `@Environment('fake')` (used by the running app when no backend) + selected directly in tests.
- Consumers depend only on the interface; swapping env changes nothing at call sites (SC-007).
