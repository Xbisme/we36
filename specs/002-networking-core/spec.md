# Feature Specification: Networking, Cache & Realtime Core

**Feature Branch**: `002-networking-core`

**Created**: 2026-06-30

**Status**: Draft

**Input**: User description: "Networking, Cache & Realtime Core (#002) — the client-side spine that every data feature sits on. No UI/screens. Build the single HTTP API client, the realtime client, the local cache engine, and the repository+fakes layer that later features (feed, auth, DM…) consume. Source of truth for all shapes is the backend contract at `backend/.claude/claude-app/api-context.md` + `backend/specs/001-service-foundation/contracts/` (openapi.yaml + realtime-events.md)."

## Overview

This feature builds the **data spine** of the We36 client: the one HTTP API client, the one realtime connection, the local cache, and the repository-with-fakes layer that every later feature (auth #003, feed #004, DM #012, …) consumes. It ships **no screens** — its "users" are the **feature teams** that build on top of it and the **app itself**, which must build, run, and pass its full test suite **without any live backend**.

The contract this spine speaks is already defined by the backend: the human-readable contract lives in [`backend/.claude/claude-app/api-context.md`](../../backend/.claude/claude-app/api-context.md) and the machine-readable B#001 slice in [`backend/specs/001-service-foundation/contracts/openapi.yaml`](../../backend/specs/001-service-foundation/contracts/openapi.yaml) (envelopes + error catalog) and `realtime-events.md` (socket event catalog). Backend domain endpoints are **not built yet** (only the B#001 envelope/error/health/pagination conventions are concrete), so this spec mirrors the **conventions** exactly and **synthesizes domain payloads in fakes** from the contract's entity map.

## Clarifications

### Session 2026-06-30

- Q: What does #002 actually build for repositories/cache/fakes? → A: Build only the repository **base/pattern** + cache **base** + **one reference vertical slice** (a single entity, e.g. User or a demo) that proves the whole spine end-to-end; the other entities' repositories and cache tables land with their own features, not in #002.
- Q: Does #002 include a dedicated online/offline connectivity service? → A: No. "Offline" is **inferred from request failures** (a `noConnectivity` transport `AppFailure` + repository cache-fallback); a shared connectivity detector is deferred to whenever a feature needs it.
- Q: Does the HTTP client auto-retry transient failures (5xx / timeout)? → A: No. The **only** automatic retry is the single retry after a single-flight refresh on `401`. Transient 5xx/timeout/no-connectivity return an `AppFailure` immediately; the caller decides whether to retry or fall back to cache. (The realtime client's own reconnect/backoff is separate and unaffected.)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Talk to the backend through one resilient HTTP client (Priority: P1)

A feature team makes an authenticated request through the shared HTTP client. The client attaches the current access token, and when the token has expired the client transparently refreshes it once and retries, so the feature code never sees a spurious failure. When the request genuinely fails, the feature receives a single, typed, localizable failure — never a raw transport exception.

**Why this priority**: Every authenticated data feature in the app depends on this. Without a single client that handles token attachment, refresh, and error normalization, every feature would re-implement (and diverge on) the hardest parts of networking.

**Independent Test**: Drive the client against a stubbed transport: a normal call attaches the bearer token; a call that returns `401 SESSION_EXPIRED` triggers exactly one refresh then a retry; a call that returns each error-catalog code surfaces the matching typed failure. No UI and no live server required.

**Acceptance Scenarios**:

1. **Given** a valid access token, **When** a feature issues an authenticated request, **Then** the request carries `Authorization: Bearer <accessToken>` and the response body is returned as success.
2. **Given** an expired access token, **When** a request returns `401 SESSION_EXPIRED`, **Then** the client performs one token refresh, retries the original request once, and returns its result without the caller observing the 401.
3. **Given** several authenticated requests in flight that all receive `401 SESSION_EXPIRED` at once, **When** they fail, **Then** exactly **one** refresh occurs (single-flight) and all in-flight requests retry against the new token.
4. **Given** a refresh that itself fails (second 401), **When** the client cannot recover, **Then** the client emits a single **unauthenticated signal** (consumed by the session layer in #003) and the original call resolves to a `sessionExpired` failure — without entering a refresh loop.
5. **Given** a content-creating request, **When** it is issued, **Then** it carries a client-generated `Idempotency-Key` so a retry cannot create a duplicate.
6. **Given** any request or response, **When** it is logged, **Then** tokens, passwords, and other secrets/PII are redacted from the log output.

---

### User Story 2 - Build, run, and test the whole app with zero network (Priority: P1)

A developer runs the app and the full test suite with no backend reachable. Every repository resolves through an in-memory fake that returns realistic, contract-shaped data, so screens (built later) render, flows exercise, and tests pass deterministically offline.

**Why this priority**: The constitution requires the app to be buildable and testable without a live server. This is the guarantee that lets all later feature work proceed in parallel before — and independently of — the backend being deployed.

**Independent Test**: With networking pointed at no real host, swap in fake repositories via DI and confirm a representative read returns synthesized, contract-shaped entities and `flutter test` is green.

**Acceptance Scenarios**:

1. **Given** the app configured with fake repositories, **When** it boots and a consumer requests data, **Then** it receives a typed `Result` carrying contract-shaped entities (string UUIDv7 ids, ISO-8601 UTC timestamps, camelCase fields, integer counts) with no network call.
2. **Given** a repository operation, **When** it succeeds or fails, **Then** the caller receives a `Result<T>` (success value or typed `AppFailure`) and the repository **never throws** to the caller.
3. **Given** the full test suite, **When** it runs with no backend, **Then** every test passes and no test performs real network I/O.
4. **Given** a fake repository, **When** a feature later needs a real implementation, **Then** the real and fake implementations satisfy the **same repository contract** and are interchangeable via DI.

---

### User Story 3 - Page through long lists with one reusable controller (Priority: P2)

A feature team renders a long, server-paginated list (feed, search results, comments). They reuse one paginated-list controller that loads the first page, loads more as the user scrolls, knows when there are no more pages, and supports pull-to-refresh — all with consistent loading/loaded/error states and no duplicate items.

**Why this priority**: Pagination is needed by many later features but only once they have screens. The controller must exist and be proven now so those features don't each reinvent cursor handling, but it is not part of the absolute MVP spine.

**Independent Test**: Drive the controller against a fake multi-page source: first load returns page one with a next cursor; load-more appends page two and de-dupes; when the source reports no more, the controller stops requesting; refresh restarts from the first page.

**Acceptance Scenarios**:

1. **Given** a fake source of 3 pages, **When** the controller loads the first page, **Then** it exposes the first page of items, a non-null next cursor, and `hasMore = true`.
2. **Given** a loaded first page, **When** load-more is requested, **Then** the next page is appended using the prior `nextCursor`, duplicates are removed, and state stays `loaded`.
3. **Given** the last page (no next cursor), **When** load-more is requested, **Then** `hasMore = false` and no further request is made.
4. **Given** a loaded list, **When** refresh is requested, **Then** the controller reloads from the first page and replaces the items.
5. **Given** a failing page request, **When** it errors, **Then** the controller exposes an `error` state carrying a typed `AppFailure` and already-loaded items are preserved.

---

### User Story 4 - Open instantly from a local cache that survives restarts (Priority: P2)

A feature team reads content that was cached on a previous run. The app shows cached content immediately on open and reconciles it with a background refresh. Each content item has exactly one canonical cached representation, and updates to it are observed reactively by every reader.

**Why this priority**: Instant-open and offline-from-cache are core product qualities, and "one canonical representation per item" is a constitutional rule. The cache base must exist now; per-feature tables are added with their features.

**Independent Test**: Write entities into the cache, restart the cache (simulating an app relaunch), and confirm the entities are still present; update one entity and confirm an open reactive reader emits the new value exactly once.

**Acceptance Scenarios**:

1. **Given** entities written to the local cache, **When** the cache is reopened (app relaunch), **Then** the previously written entities are still readable.
2. **Given** a reactive read of a cached item, **When** the item is updated, **Then** the reader emits the updated value and there is a single canonical copy (no diverging per-consumer copies).
3. **Given** a cache schema change between versions, **When** the app starts on the new version, **Then** a migration path upgrades existing data without loss or crash.

---

### User Story 5 - Stand up a realtime connection scaffold (Priority: P3)

A feature team (later #012 DM / #013 notifications) connects to the realtime gateway, authenticated on connect, and subscribes to typed events. The connection reconnects with backoff after drops and exposes its connection state; while realtime is down, the rest of the app keeps working over HTTP (read-only realtime degradation).

**Why this priority**: Realtime is only consumed by later specs, so this is scaffold-only here — the connection lifecycle and typed event surface must exist and be proven, but no feature wiring happens yet.

**Independent Test**: Against a fake/loopback gateway, connect with a token, observe connection-state transitions, simulate a drop and observe reconnect-with-backoff, and round-trip one typed event in each direction.

**Acceptance Scenarios**:

1. **Given** an access token, **When** the realtime client connects, **Then** it authenticates on connect and exposes a `connected` state.
2. **Given** a connected client, **When** the connection drops, **Then** the client retries with exponential backoff and surfaces `reconnecting` → `connected` (or `disconnected`) states, with a heartbeat detecting silent drops.
3. **Given** a connected client, **When** a server event from the catalog arrives, **Then** it is delivered to subscribers as a typed event; and a client event can be sent as a typed message.
4. **Given** realtime is unavailable, **When** the app continues, **Then** HTTP-backed reads still function (the app is usable read-only without realtime).

---

### User Story 6 - One place for endpoints, event names, and per-flavor config (Priority: P3)

A developer finds every endpoint path, socket event name, and per-flavor setting (API base URL + realtime endpoint) defined in one central place, with dev and prod resolving to their own placeholder values until the backend is deployed.

**Why this priority**: Cross-cutting hygiene that prevents scattered magic strings; low risk but should be established with the spine.

**Independent Test**: Resolve config under the dev flavor and the prod flavor and confirm each yields its own base URL + realtime endpoint; confirm endpoint paths and event names are referenced from constants, not string literals at call sites.

**Acceptance Scenarios**:

1. **Given** the dev flavor, **When** config resolves, **Then** the dev API base URL (under `/v1`) and dev realtime endpoint are returned; **Given** prod, the prod values are returned.
2. **Given** any request or subscription, **When** it names an endpoint or event, **Then** the name comes from a central constant, not an inline literal.

### Edge Cases

- **Refresh storm**: many concurrent 401s must collapse to one refresh; a refresh already in flight must not start another.
- **Refresh failure mid-flight**: requests waiting on a failing refresh must all resolve to `sessionExpired` and trigger one unauthenticated signal, not one per request.
- **Malformed / non-envelope error body**: a 4xx/5xx without the standard envelope (or with a body that fails to parse) must still map to a sane typed failure (e.g. `server` / `unknown`), never crash.
- **Unknown error `code`**: a code outside the known catalog maps to a safe default failure without dropping the message.
- **`429` without `Retry-After`**: rate-limited failure is still produced; missing retry hint is tolerated.
- **Transport faults**: connect timeout, receive timeout, no-connectivity, and request-cancelled each map to distinct typed failures.
- **Cursor exhaustion / null cursor**: load-more after `hasMore = false` is a no-op; a null next cursor ends pagination.
- **Duplicate items across pages**: overlapping items between consecutive pages are de-duplicated by id.
- **Idempotency-key reuse on retry**: the retried request reuses the **same** key so the backend can dedupe.
- **Cache open failure / corruption**: a cache that cannot open degrades to network-only rather than crashing the app.
- **Realtime token expiry on connect**: a connect rejected for auth surfaces a disconnected/unauthenticated state without a tight reconnect loop.

## Requirements *(mandatory)*

### Functional Requirements

**HTTP API client & auth (US1)**

- **FR-001**: The system MUST expose a **single** HTTP API client instance that all repositories use; widgets and cubits MUST NOT issue HTTP calls directly.
- **FR-002**: The client MUST resolve its base URL from the active flavor's config, rooted at the versioned `/v1` path.
- **FR-003**: The client MUST attach `Authorization: Bearer <accessToken>` to authenticated requests from the current session token source.
- **FR-004**: On a `401 SESSION_EXPIRED` response, the client MUST perform a **single-flight** token refresh (concurrent 401s share one refresh) via the refresh endpoint, then retry each affected request **once**.
- **FR-005**: If refresh fails (or the retried request again returns 401), the client MUST emit exactly one **unauthenticated signal** for the session layer (#003) and resolve the affected calls to a `sessionExpired` failure, without looping.
- **FR-006**: The client MUST support an `Idempotency-Key` header (client-generated) on content-creating mutations, reusing the same key across the (single) post-refresh retry of that request.
- **FR-006a**: The HTTP client MUST NOT auto-retry transient failures (5xx, timeout, no-connectivity); the **only** automatic retry is the single post-refresh retry in FR-004. Transient faults resolve to an `AppFailure` for the caller to handle.
- **FR-007**: The client MUST log requests/responses through `AppLogger` with tokens, credentials, and PII redacted; it MUST NEVER use `print`/`debugPrint` or log secrets.

**Error mapping → AppFailure (US1)**

- **FR-008**: The system MUST map the backend error envelope `{ error: { code, message, details? } }` to a typed `AppFailure`, preserving the human-readable `message` and the optional `details` field map.
- **FR-009**: The system MUST recognize the contract's stable error-code catalog (`UNAUTHENTICATED`, `INVALID_CREDENTIALS`, `SESSION_EXPIRED`, `OAUTH_FAILED`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`, `VALIDATION`, `RATE_LIMITED`, `MEDIA_TOO_LARGE`, `UNSUPPORTED_MEDIA`, `UPLOAD_FAILED`, `SERVER_ERROR`) and map each to a distinct `AppFailure` variant; these codes are contract-stable and MUST NOT be renamed or invented.
- **FR-010**: The system MUST map transport-level faults (connect/receive timeout, no connectivity, request cancelled, malformed/unparseable body) to distinct typed failures, and MUST map a `429` to a rate-limited failure that carries the `Retry-After` value when present. "No connectivity" is **inferred from the failed request** — #002 does NOT add a dedicated online/offline connectivity service.
- **FR-011**: Repositories MUST return `Result<T>` (success or `AppFailure`) and MUST NOT throw transport or mapping exceptions to their callers.

**Cursor pagination (US3)**

- **FR-012**: The system MUST provide a generic, typed model of the pagination envelope `{ items, nextCursor, hasMore }`, where the cursor is opaque and ordering is stable (no offset paging).
- **FR-013**: The system MUST send pagination requests as `?cursor=<opaque>&limit=<n>` with a default limit of 20 and a maximum of 30.
- **FR-014**: The system MUST provide a **reusable paginated-list controller** exposing four states (loading / loaded / error and an initial state) supporting: load first page, load-more (using the prior `nextCursor`), `hasMore` awareness, refresh-from-first-page, and de-duplication of items by id.

**Local cache (US4)**

- **FR-015**: The system MUST provide a **persistent local cache** with a base data-access layer and schema/migration tooling.
- **FR-016**: The cache MUST retain data across app restarts and MUST support a reactive read pattern so updates to a cached item are observed by all readers.
- **FR-017**: There MUST be exactly **one canonical cached representation per content item** (no per-consumer copies that can diverge).
- **FR-018**: The system MUST establish the cache foundation plus the **one reference slice's table** (to prove restart-persistence + reactive reads); all other per-feature tables/entities are added by their respective features (the cache must be extensible without rework).

**Repository base & fakes (US2)**

- **FR-019**: The system MUST define a repository contract pattern (returning `Result<T>`) and prove it with **one reference vertical slice** — a single reference entity wired end-to-end through HTTP client → mapping → cache → repository — shipping **both** a real (network/cache-backed) and an **in-memory fake** implementation of that one repository. Per-feature repositories for the other entities are built by their own features, not in #002.
- **FR-020**: The app MUST build, run, and pass its entire test suite with **no live backend**, selecting the fake repository (reference slice) via DI; the base + fake pattern MUST be directly reusable by later features without rework.
- **FR-021**: The reference fake MUST synthesize **contract-shaped** payloads using string UUIDv7 ids, ISO-8601 UTC timestamps, camelCase fields, and integer counts; the api-context entity map (User, Post, Media, Story, Comment, Follow, Conversation, Message, Notification, …) is the **reference for those later fakes**, not a list of repositories to build now.

**Realtime client scaffold (US5)**

- **FR-022**: The system MUST provide a single realtime client that authenticates on connect using the access token and exposes a typed event surface for the catalog events (client→server: `message.send`, `typing.start`/`typing.stop`, `conversation.read`, `presence.ping`; server→client: `message.new`, `message.delivered`/`message.read`, `typing`, `presence.update`, `notification.new`).
- **FR-023**: The realtime client MUST reconnect with exponential backoff after a drop, use a heartbeat to detect silent drops, and expose a connection-state stream (e.g. connecting / connected / reconnecting / disconnected).
- **FR-024**: The app MUST remain usable **read-only over HTTP** when realtime is unavailable; loss of realtime MUST NOT break HTTP-backed reads.
- **FR-025**: The realtime client is **scaffold-only** in this spec — no feature subscriptions are wired (that happens in #012/#013) — but each subscription MUST be isolated to the connecting user.

**Constants & config (US6)**

- **FR-026**: The system MUST centralize endpoint paths and socket event names as constants (no inline string literals at call sites).
- **FR-027**: The system MUST resolve per-flavor config (API base URL + realtime endpoint) for dev and prod, using placeholder values until the backend is deployed.

**Architecture constraints (cross-cutting)**

- **FR-028**: `lib/core/` MUST NOT import from `lib/features/`; the spine is consumed by features, never the reverse.
- **FR-029**: All data-typing conventions MUST follow the contract: ids are strings (UUIDv7), timestamps are ISO-8601 UTC strings, JSON fields are camelCase, counts are integers.

### Key Entities *(include if feature involves data)*

- **ApiResult / Result<T>**: the success-or-failure wrapper every repository returns (from #001); carries either a typed value or an `AppFailure`.
- **AppFailure**: a typed failure carrying an error category (mapped from the contract code catalog), a human-readable message, optional field-level `details`, and (for rate limiting) a retry hint.
- **CursorPage<T>**: a page of results — `items`, opaque `nextCursor` (nullable), `hasMore`.
- **PaginatedListState<T>**: the reusable controller's state — accumulated items, current cursor, `hasMore`, and lifecycle (initial/loading/loaded/error).
- **CachedItem (per content type)**: the single canonical local representation of a content item, keyed by id, observed reactively.
- **RealtimeConnectionState**: the realtime lifecycle state (connecting/connected/reconnecting/disconnected).
- **RealtimeEvent (typed)**: the typed envelope for each catalog event in either direction.
- **AppConfig (per flavor)**: API base URL + realtime endpoint + flavor identity.
- **Domain entities (contract-shaped, used by fakes)**: User, Post, Media, Story, Comment, Follow, Conversation, Message, Notification — per the api-context entity map; full per-feature fields are filled in by their features.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The entire app builds and `flutter test` passes with **zero** real network calls (offline-buildable guarantee).
- **SC-002**: Under N concurrent requests that all receive `401 SESSION_EXPIRED`, **exactly one** refresh occurs and all N requests succeed on retry (single-flight proven by test).
- **SC-003**: **100%** of the contract error-code catalog maps to a distinct typed failure, and a malformed/unknown error body still yields a safe typed failure (no crash); the `429` path surfaces the `Retry-After` value.
- **SC-004**: The reusable paginated-list controller drives a multi-page fake through first-load → load-more (de-duped) → end-of-list (no further requests) → refresh, entirely from a fake source.
- **SC-005**: Cached data written in one run is readable after a simulated relaunch, and a reactive reader emits an updated item exactly once after it changes.
- **SC-006**: The realtime client, against a fake gateway, connects authenticated, recovers from an induced drop via backoff, and round-trips one typed event in each direction — while HTTP reads remain functional with realtime down.
- **SC-007**: The reference repository slice has both a real and a fake implementation behind one contract, interchangeable via DI with no consumer code change, demonstrating the pattern later features replicate.
- **SC-008**: No secret/token/PII appears in any log output, and no `print`/`debugPrint` exists in the spine (enforced by the existing lint/CI gate).

## Assumptions

- **Contract source of truth**: the backend contract files (`api-context.md`, `openapi.yaml`, `realtime-events.md`) are authoritative for envelope, error, pagination, and event shapes. Backend **domain** endpoints are not yet implemented, so fakes synthesize domain payloads from the entity map and will be reconciled as backend specs (B#002+) ship.
- **Stack already decided** (constitution + CLAUDE.md): the HTTP client, realtime transport, local cache engine (**drift/SQLite**, decided for this spec), secure storage, and DI/codegen tooling are fixed by project standards; concrete package/version selection (including the **Socket.IO-compatible** Dart realtime client — the backend gateway is Socket.IO, so a raw WebSocket client cannot speak it) is confirmed at `/speckit.plan`.
- **Session ownership**: token **storage**, login/logout, and the OAuth/refresh **credential** flows are owned by Auth #003. This spec only exposes the *mechanism* (token attachment, single-flight refresh hook, and the unauthenticated signal); it consumes a token source and emits the signal but does not persist credentials.
- **Endpoints are placeholders**: dev/prod base URLs + realtime endpoints use placeholder values (e.g. `https://api.we36.dev`) wired to real values once the backend is deployed; #002 runs entirely on fakes regardless.
- **No UI**: this spec delivers no screens, widgets, or navigation; demonstrability is via tests and DI wiring, plus optional reuse by the existing dev/states harness from #001.
- **Out of scope**: auth UI and session persistence (#003), media upload pipeline (#007), feature-specific domain logic and tables (their own specs), and any real backend endpoint behavior.
