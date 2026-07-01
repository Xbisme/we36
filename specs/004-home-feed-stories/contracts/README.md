# Contracts: Home Feed & Stories (#004)

Client-facing contracts for this feature. The **feed** contracts mirror the shipped backend
**B#004 posts-feed** OpenAPI (`backend/specs/004-posts-feed/contracts/openapi.yaml`) — the source
of truth; this folder documents how the Flutter client consumes it. **Stories** have no backend
contract yet, so their contract is client-defined (fake-driven) with a documented real seam.

| File | Scope |
|---|---|
| [feed-repository.md](feed-repository.md) | `FeedRepository` interface, endpoints, DTO→domain mapping, pagination |
| [stories-repository.md](stories-repository.md) | `StoriesRepository` interface (fake-only; provisional real seam) |
| [optimistic-engagement.md](optimistic-engagement.md) | Like/save optimistic + idempotency + rollback reconcile rules |

**Reused #002 primitives**: `CursorPage<T>` / `PageRequest` (envelope), `ApiClient` (auth attach +
single-flight refresh + idempotency + redacted logging + `FailureMapper`), `AppDatabase` (drift),
repository+fake DI pattern (`@LazySingleton(as:, env:['real'|'fake'])`).

**Environment**: the app runs DI `environment: 'fake'` — the fake repositories are what execute in
#004; the `env:['real']` seams exist for graph completeness and the future dev-backend cutover.
