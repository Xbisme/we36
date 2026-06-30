<!--
================================================================================
SYNC IMPACT REPORT
================================================================================
Version Change: (none) → 1.0.0 (initial ratification)

This is the first ratified constitution for the We36 Backend — the server side of
the We36 Instagram-style social app. It is the counterpart to the We36 (Flutter)
client constitution v1.0.0 at `../../.specify/memory/constitution.md`. The client
constitution declared the app "backend-agnostic, depending on a versioned
REST/JSON + WebSocket CONTRACT"; THIS constitution governs the service that
implements that contract.

Stack decisions taken at ratification (confirmed with the product owner):
  - Language/framework: NestJS (TypeScript).
  - Datastore + infra: PostgreSQL (relational + full-text search) + Redis
    (cache / presence / pub-sub) + S3-COMPATIBLE object storage. No AWS account
    required: code targets the S3 API via a configurable endpoint —
    MinIO (local/dev/self-host) and Cloudflare R2 (managed prod; free tier,
    zero egress) are the chosen drivers; swapping drivers requires no code change.
  - Architecture: modular monolith (one deployable, module boundaries) + a
    background worker process. Microservice extraction is deferred.

Principles (15):
  I.    API Contract & Versioning (source of truth, shared with the client)
  II.   Security, Privacy & Data Protection
  III.  Authentication & Authorization
  IV.   Module-First Architecture (NestJS modular monolith)
  V.    Type Safety & Code Quality
  VI.   Consistent Errors & Input Validation
  VII.  PostgreSQL & Data Integrity
  VIII. Media Pipeline & Object Storage (S3-compatible)
  IX.   Realtime Architecture (WebSocket + Redis pub/sub)
  X.    Caching, Feed Strategy & Performance
  XI.   Background Jobs & Async Processing
  XII.  Observability & Operability
  XIII. Testing Discipline
  XIV.  Simplicity & YAGNI
  XV.   Configuration, Secrets & Dependency Hygiene

Templates Requiring Updates:
- .specify/templates/* ✅ (generic; no inline principle references)
- AGENTS.md / CLAUDE.md ⚠ pending — created during Backend Spec #001
- .claude/claude-app/api-context.md ✅ (Principle I defers contract detail to it)

Follow-up TODOs: None
================================================================================
-->

# We36 Backend Constitution

> Service: "we36-api" — the backend for **We36**, a cross-platform
> Instagram-style social app (feed · stories · reels · direct messages · explore
> · profiles). It exposes a **versioned REST/JSON API + a WebSocket realtime
> channel** consumed by the We36 Flutter client. **Stack**: NestJS (TypeScript),
> PostgreSQL, Redis, S3-compatible object storage (MinIO / Cloudflare R2), a
> BullMQ worker. **Shape**: modular monolith + worker. **Out of scope (v1.0)**:
> monetization/commerce, livestreaming, ranked-recommendation feeds (MVP feed is
> reverse-chronological). API/data-contract source of truth:
> `.claude/claude-app/api-context.md`.

## Core Principles

### I. API Contract & Versioning

The REST/JSON + WebSocket **contract is the product** this service ships; it is
the binding agreement with the Flutter client and MUST be treated as a
first-class, versioned artifact — distilled in
`.claude/claude-app/api-context.md`.

- All HTTP routes MUST live under a version prefix (`/v1/...`); a breaking change
  to a shape MUST ship under a new version, never mutate `/v1` in place.
- Every request/response body MUST be a typed **DTO** validated at the boundary;
  the wire shape MUST NOT be an ad-hoc object assembled inline.
- The contract MUST be documented via **OpenAPI/Swagger** generated from the
  code (decorators), and the WebSocket **event catalog** maintained in
  `api-context.md`; both MUST stay in sync with the client's expectations.
- **Standard envelopes**: a single **error envelope** and a single **cursor
  pagination envelope** MUST be used everywhere — feeds, lists, and search reuse
  the same page shape (Principle VI / X).
- Response field naming, date/number encodings, id formats, and enum values MUST
  be consistent across resources and MUST match what the client deserializes.
- Backward compatibility within a version: additive fields are allowed; removing
  or renaming a field, or tightening a type, is a breaking change.

**Rationale**: Two codebases (app + server) evolve against this boundary. A
versioned, validated, documented contract is the only thing that keeps them from
silently diverging and shipping a client that can't parse the server.

### II. Security, Privacy & Data Protection

The service holds people's identities, photos, conversations, and social graph.
Security and privacy MUST be designed into every layer.

- **Passwords** MUST be hashed with a memory-hard algorithm (argon2id preferred,
  bcrypt acceptable) — NEVER stored or logged in plaintext or reversibly.
- **Secrets** (JWT signing keys, OAuth secrets, DB/Redis/storage credentials)
  MUST come from validated environment configuration / a secret manager — NEVER
  committed, hardcoded, or logged.
- **PII** (email, phone, tokens, message bodies, precise location, IP) MUST NOT
  appear in logs, traces, metrics labels, or error payloads.
- **Transport** MUST be TLS in every non-local environment; the WebSocket MUST be
  `wss`.
- **Privacy enforcement at the data layer**: a private account's content,
  followers, and following MUST be withheld by the query/authorization layer —
  visibility MUST NOT depend on the client choosing not to ask. **Blocking** MUST
  be enforced bidirectionally on the server (blocked users cannot fetch, follow,
  message, comment, or see each other).
- **Rate limiting** and abuse protection MUST guard auth, write, search, upload,
  and message endpoints; brute-force on login MUST be throttled/locked.
- **Data subject rights**: account **data export** and **deletion** MUST be
  supported (the client surfaces them in Settings); deletion MUST cascade or
  anonymize per policy.
- All user-generated text MUST be treated as untrusted (stored raw, encoded on
  output by the client; the server rejects oversized/malicious payloads).

**Rationale**: A single leaked private story, an unenforced block, a plaintext
password, or a secret in a log breaks user trust irreparably and is far costlier
than the feature that caused it.

### III. Authentication & Authorization

Identity and access MUST be centralized, explicit, and enforced on every
protected operation — never assumed from the client.

- **Tokens**: short-lived **JWT access tokens** + longer-lived **refresh
  tokens**; refresh tokens MUST be **rotated** on use and **revocable** (stored/
  tracked server-side, e.g. in Redis/DB) so logout and compromise are
  enforceable. Access-token claims MUST be minimal.
- **OAuth** (Google/Apple) MUST be verified server-side (validate the provider
  token/identity) before issuing We36 tokens.
- **AuthZ**: every endpoint MUST declare its access rule (public / authenticated
  / owner / role). **Ownership and visibility checks** (can this user act on/see
  this resource?) MUST happen server-side via guards/policies — NEVER trust a
  client-supplied user id or a hidden field.
- The WebSocket connection MUST authenticate on connect and re-authorize
  per-subscription (a user only receives their own DM/notification streams).
- Sensitive actions (password change, email change, 2FA, account deletion) MUST
  re-verify identity.

**Rationale**: Authorization bugs are the most common and most damaging class of
social-app vulnerability. Centralizing token lifecycle and forcing an explicit,
server-side access rule on every operation is what prevents horizontal-privilege
escalation (reading someone else's DMs, acting as another user).

### IV. Module-First Architecture (NestJS Modular Monolith)

The codebase MUST be a **modular monolith**: one deployable, organized into
cohesive NestJS modules with clean boundaries, plus a separate worker process for
async work.

- Each domain is a **module** (`auth`, `users`, `posts`, `feed`, `stories`,
  `reels`, `media`, `comments`, `social` [follow/block], `collections`,
  `messaging`, `notifications`, `search`, `moderation`) with its own
  controller(s), service(s), repository/data-access, and DTOs.
- A module MUST expose a service interface to other modules; cross-module access
  goes through that provider — a module MUST NOT reach into another module's
  repositories or tables directly.
- **Layering** within a module: controller (HTTP/WS + DTO) → service (business
  logic, returns domain types) → repository (DB access). Controllers MUST contain
  no business logic; repositories MUST contain no business logic.
- Shared cross-cutting concerns (config, logging, auth guards, error filter,
  pagination, storage, queue, redis) live in `common`/`core` modules and are
  injected — never re-implemented per module.
- Extraction to a separate microservice is allowed later **only** when a module's
  scaling or team boundary demands it; until then, modularity is enforced in-code,
  not over the network (YAGNI, Principle XIV).

**Rationale**: A modular monolith gives a solo/small team microservice-grade
boundaries without the operational tax of a distributed system. Disciplined
module edges are what make a later extraction cheap if it's ever needed.

### V. Type Safety & Code Quality

TypeScript strictness and consistent quality gates are mandatory.

- `tsconfig` MUST enable `strict` (incl. `strictNullChecks`, `noImplicitAny`);
  `any` is FORBIDDEN except at a justified, commented boundary.
- DTOs MUST be validated at runtime (`class-validator`/`class-transformer` or
  Zod) — compile-time types alone do NOT validate untrusted input.
- ESLint (typescript-eslint) + Prettier MUST pass with zero warnings; the build
  MUST fail on lint/type errors.
- Domain types, DTOs, and DB models MUST be explicit; public service methods MUST
  have explicit return types.
- Code MUST be self-documenting; comments only where logic is non-obvious.
- Naming: files `kebab-case.ts`; classes `PascalCase`; providers
  `{Domain}Service`/`{Domain}Controller`/`{Domain}Repository`.

**Rationale**: Decoding untrusted JSON into typed domain objects is the server's
core risk surface; strict types + runtime validation prevent whole categories of
injection and shape bugs.

### VI. Consistent Errors & Input Validation

Every failure MUST be an explicit, typed, consistently-shaped response — never a
leaked stack trace or an ad-hoc string.

- A **single error envelope** (e.g. `{ error: { code, message, details? } }`)
  MUST be returned for all failures via a global exception filter; raw
  exceptions MUST NEVER reach the client.
- A **typed domain-error catalog** (e.g. `INVALID_CREDENTIALS`,
  `SESSION_EXPIRED`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT` [username taken],
  `VALIDATION`, `RATE_LIMITED`, `MEDIA_TOO_LARGE`, `UPLOAD_FAILED`) MUST map to
  stable HTTP statuses + machine-readable `code`s the client maps to localized
  copy (client Principle V).
- **Validation errors** MUST identify the offending field(s) so the client can
  attach messages to inputs.
- Input validation (type, size, format, enum) MUST occur at the controller
  boundary via a global `ValidationPipe` (whitelist + forbid unknown fields);
  no endpoint trusts raw input.
- Error messages MUST be actionable and MUST NOT leak internals (SQL, stack,
  secrets, other users' data).

**Rationale**: The client maps `code`s to user-facing copy and form fields. A
stable, machine-readable error contract is what makes the app's error handling
(Principle V over there) possible instead of brittle string-matching.

### VII. PostgreSQL & Data Integrity

PostgreSQL is the system of record; its integrity MUST be protected at the schema
and transaction level, not just in application code.

- Schema changes MUST go through **versioned migrations** (Prisma Migrate or
  TypeORM migrations); migrations MUST be **non-destructive and
  backward-compatible** where the running app expects the old shape (expand →
  migrate → contract). Migration history MUST be committed and reviewed.
- **Foreign keys, unique constraints, NOT NULL, and check constraints** MUST
  encode invariants in the DB — application code MUST NOT be the only guard.
- Multi-row writes that must be atomic (e.g. create post + media rows + feed
  fanout marker) MUST run in a **transaction**.
- **Idempotency**: create-post / send-message / like MUST accept a client
  idempotency key (or natural unique constraint) so a retried request does not
  duplicate.
- Queries on hot paths (feed, follow graph, notifications, search) MUST be
  **indexed**; N+1 access MUST be avoided (joins / dataloader / batched queries).
- Counters (likes/followers) MUST stay consistent (atomic increments or derived/
  cached with reconciliation) — never drift.
- Soft-delete vs hard-delete policy MUST be explicit per entity (e.g.
  block/report/audit needs retention).

**Rationale**: The social graph and engagement counts are the data users see and
trust. DB-level constraints + transactions + idempotency are what keep them
correct under concurrency and retries, where application checks alone fail.

### VIII. Media Pipeline & Object Storage (S3-Compatible)

Photos and video are the heaviest payloads; they MUST NOT flow through the API
process and MUST be stored in portable, S3-compatible object storage.

- **Object storage MUST be S3-compatible**, accessed via the S3 API with a
  **configurable endpoint** — **MinIO** (local dev / self-host) and **Cloudflare
  R2** (managed prod; free tier, zero egress) are the supported drivers; no AWS
  account is required and swapping drivers MUST require no code change.
- **Uploads MUST use presigned URLs**: the client requests a presigned PUT, then
  uploads bytes **directly** to storage — raw media MUST NOT be proxied through
  the API server. The server validates declared type/size and finalizes the
  media record on completion.
- **Processing** (image resize/variants, video transcode + thumbnail/poster)
  MUST run in the **background worker** (Principle XI), not inline on the request;
  the original is validated (real MIME, dimensions, duration, size caps) before
  it is made public.
- **Delivery** MUST be via a **CDN** in front of the bucket (Cloudflare CDN for
  R2; a CDN/reverse-proxy for MinIO); the API returns CDN URLs, never streams
  media itself.
- Media keys MUST be unguessable; private-content URLs MUST be access-controlled
  (signed/short-lived) so a private post's media is not world-readable by URL.
- Type/size/duration limits and malware/format validation MUST be enforced server
  side; rejected uploads MUST be cleaned up.

**Rationale**: Routing gigabytes of media through the app process would melt it.
Presigned direct-to-storage uploads, worker-side processing, and CDN delivery are
what make a media app affordable and fast — and the S3-compatible abstraction is
what keeps it free of vendor lock-in.

### IX. Realtime Architecture (WebSocket + Redis Pub/Sub)

Realtime (DM, typing, presence, live notifications) MUST run through one
authenticated WebSocket layer backed by Redis so it can scale horizontally.

- A single **WebSocket gateway** (NestJS gateway over Socket.IO or `ws`) owns the
  realtime surface; events MUST be **typed** and listed in the contract
  (`api-context.md`) — no stringly-typed ad-hoc events.
- **Redis pub/sub** MUST back cross-instance delivery and **presence** so any API
  instance can reach any connected socket (the monolith may run N replicas).
- Sockets MUST **authenticate on connect** and be **authorized per subscription**
  (a user receives only their own conversations/notifications — Principle III).
- **Message delivery** MUST be **persisted first** (a DM is written to Postgres,
  then pushed) so realtime is a delivery optimization, not the source of truth;
  reconnect MUST allow catch-up via REST history + a cursor.
- The gateway MUST handle reconnect, heartbeats, and backpressure; a realtime
  outage MUST NOT take down REST (the app degrades to read-only realtime).
- Delivery/read receipts and typing MUST be lightweight and MUST NOT be persisted
  as durable per-keystroke writes.

**Rationale**: DM is the feature users notice when it breaks. Persisting before
pushing + Redis-backed fan-out gives at-least-once delivery and horizontal scale,
while keeping Postgres the single source of truth.

### X. Caching, Feed Strategy & Performance

The service MUST stay fast under load via Redis caching, a clear feed strategy,
and disciplined pagination.

- **Feed (v1.0) is reverse-chronological** (time-based) — a **fan-out-on-read**
  (pull) model over the followee set is the default; a ranked/fan-out-on-write
  model is deferred (YAGNI, matches the client's MVP).
- **Pagination MUST be cursor-based** (opaque cursor, stable ordering, no
  offset), using the shared page envelope (Principle I); endpoints MUST cap page
  size.
- **Redis caching** MUST front hot reads (session/refresh tokens, profile
  aggregates, feed pages, counts) with explicit TTLs and invalidation on write;
  cache MUST be a reconciled optimization, never the source of truth.
- Hot endpoints MUST have rate limits (per user + per IP).
- DB connection pooling MUST be configured; slow queries MUST be found and
  indexed (Principle VII).
- Expensive work (notification fanout, media processing, counts) MUST be
  offloaded to the queue (Principle XI), not done on the request path.

**Rationale**: A social feed's read volume dwarfs writes. Cursor pagination +
Redis caching + a deliberately simple time-based feed keep p95 latency sane for
v1.0 without prematurely building a recommendation pipeline.

### XI. Background Jobs & Async Processing

Anything slow, retryable, scheduled, or fan-out-heavy MUST run as a background job
in a dedicated worker — never on the HTTP request path.

- A **queue** (BullMQ on Redis) MUST own: media processing (resize/transcode/
  thumbnail), **push-notification fan-out**, notification/activity fan-out,
  **story 24h expiry**, feed/cache warming, email/OTP send, and cleanup of
  orphaned uploads/expired tokens.
- Workers MUST be **idempotent** (a re-run does not double-send/double-process)
  and MUST use **retry with backoff** + a **dead-letter** path for poison jobs.
- Scheduled jobs (story expiry, cleanup, token sweep) MUST be defined centrally
  (a scheduler) and be safe to run on exactly one instance (locking).
- Job payloads MUST carry ids, not large blobs; no PII beyond what's necessary;
  job logs follow the no-PII rule.
- The worker is part of the same codebase/deployable family (modular monolith)
  but runs as a separate **process**, scalable independently.

**Rationale**: Pushing transcode and notification fan-out onto the request would
make posting feel broken. An idempotent, retrying queue is what makes async work
reliable and keeps the API responsive.

### XII. Observability & Operability

The service MUST be debuggable and operable in production from day one.

- **Structured logging** (pino/nestjs-pino, JSON) with a **correlation/request
  id** propagated through HTTP, WS, and jobs; **no PII/secrets** in logs
  (Principle II).
- **Health checks** (liveness/readiness incl. DB/Redis/storage) MUST exist for
  orchestration.
- **Metrics** (request rate/latency/errors, queue depth, WS connections, DB pool)
  SHOULD be exported (Prometheus-style) and **error tracking** (e.g. Sentry)
  wired with PII scrubbing.
- Errors MUST be logged with enough context (codes, ids) to diagnose without
  leaking user data.
- Runbooks for common incidents (DB down, Redis down, storage down, queue
  backlog) SHOULD be maintained from the release spec onward.

**Rationale**: A social backend fails in production in ways tests can't predict.
Correlation-id tracing across REST/WS/jobs + health/metrics are what turn a 2 a.m.
incident into a 10-minute fix instead of a guessing game.

### XIII. Testing Discipline

Automated tests are REQUIRED across unit, integration, and contract levels;
critical paths MUST be covered.

- **Unit tests** MUST cover service business logic (auth/token rotation, feed
  assembly, visibility/block rules, idempotency, counters) with mocked
  repositories.
- **Integration tests** MUST exercise controllers + a **real Postgres + Redis**
  (Testcontainers / ephemeral instances) — auth flows, pagination, ownership/
  visibility enforcement, migrations apply cleanly.
- **Contract tests** MUST assert responses match the documented OpenAPI/WS shapes
  the client depends on (so a server change that breaks the app fails CI).
- External deps (object storage, push, OAuth providers, email) MUST have fakes/
  stubs so CI needs no live third-party.
- Tests MUST be deterministic (no flakiness, no shared mutable state, seeded
  data) and run in CI on every PR.
- Coverage is not gated by a hard threshold; reviewers judge by critical-path
  coverage (auth, privacy/block enforcement, media finalize, DM delivery).

**Rationale**: The highest-risk logic (authz, privacy, idempotency) is exactly
what a contract + integration test can pin down. Fakes for third-parties keep CI
hermetic and fast.

### XIV. Simplicity & YAGNI

The service MUST stay focused on the v1.0 scope and the simplest design that
meets it.

- **Modular monolith, not microservices**; **time-based feed, not ranked**;
  **fan-out-on-read, not write** — until measured load proves otherwise.
- **Out of scope v1.0** (per brief): monetization/commerce, livestreaming,
  recommendation algorithms — do NOT build them.
- Prefer Postgres features (FTS, JSONB, constraints) over adding infrastructure;
  add a new datastore/search engine/service ONLY when a concrete need is proven
  and documented.
- No premature abstraction, no speculative config/flags, no generic "platform"
  layers without a second real consumer.
- Three similar lines beat a premature abstraction.

**Rationale**: An Instagram-class backend can sprawl infinitely. The brief drew
the lines (time-based feed, no commerce, no livestream); honoring them — and
resisting premature distributed-systems complexity — is how v1.0 actually ships.

### XV. Configuration, Secrets & Dependency Hygiene

Configuration, secrets, and third-party dependencies MUST be handled
deliberately and verifiably.

- **Config** MUST come from the environment and be **validated at boot** (Zod/Joi
  schema); the process MUST refuse to start on missing/invalid config. No magic
  constants scattered in code.
- **Secrets** MUST never be committed; `.env.example` documents keys without
  values; production secrets come from the platform/secret manager.
- **Per-environment** config (dev/staging/prod) MUST be explicit (DB, Redis,
  storage endpoint+bucket, JWT keys, OAuth, push, CDN base URL).
- **Dependencies**: every npm package MUST be added at a pinned version sourced
  from the official registry, with its docs/changelog reviewed for breaking
  changes and security advisories (`npm audit`); the **lockfile MUST be
  committed**; unexpected lockfile churn MUST be reviewed. No fictional/typo-squat
  packages — if a name isn't found, stop and ask.
- Native/heavy deps (image/video processing libs, ffmpeg, crypto) MUST have their
  runtime requirements (system libs) documented and containerized.

**Rationale**: A backend's blast radius for a leaked secret or a malicious
transitive dependency is the whole user base. Boot-time config validation + a
committed lockfile + audited, pinned deps make the surface verifiable.

## Technical Standards

### Platform & Stack

- **Runtime / language**: Node.js LTS + **TypeScript** (strict).
- **Framework**: **NestJS** (modular monolith) + a **BullMQ** worker process.
- **Database**: **PostgreSQL** (system of record; FTS + JSONB), accessed via
  Prisma (or TypeORM) with versioned migrations.
- **Cache / realtime backplane / queue**: **Redis** (caching, presence, pub/sub,
  BullMQ).
- **Object storage**: **S3-compatible** via the S3 SDK with configurable endpoint
  — **MinIO** (dev/self-host) / **Cloudflare R2** (prod). **CDN** in front.
- **Realtime**: **WebSocket** gateway (Socket.IO or `ws`) backed by Redis pub/sub.
- **Auth**: JWT access + rotating refresh tokens; OAuth (Google/Apple) verified
  server-side; argon2id password hashing.
- **Push**: FCM (Android) + APNs (iOS) via the worker.
- **Search (v1.0)**: PostgreSQL full-text search (a dedicated engine is deferred).
- **API docs**: OpenAPI/Swagger generated from decorators.
- **Validation**: `class-validator`/`class-transformer` (or Zod) + global
  `ValidationPipe`.
- **Observability**: pino structured logs + correlation ids; health checks;
  Prometheus metrics; Sentry (PII-scrubbed).
- **Testing**: Jest (unit) + Supertest + Testcontainers (integration) + contract
  tests.
- **Tooling**: ESLint + Prettier; Docker + docker-compose (postgres/redis/minio)
  for local; CI on every PR.
- **Environments**: development, staging, production (per-env config + secrets).

### Core Domains (modules)

- **auth** — register/login (email/phone/password), OAuth, tokens, session.
- **users** — profile, profile setup, settings, privacy flags, data export/delete.
- **media** — presigned uploads, finalize, processing handoff, variants/CDN.
- **posts / feed** — create post (carousel), reverse-chron feed, like, save.
- **comments** — comments + one-level replies + mentions + comment likes.
- **stories** — create, 24h expiry, story viewer, close friends.
- **reels** — short-video posts + reels feed.
- **social** — follow/unfollow, follow requests (private), followers/following,
  block.
- **collections** — saved collections.
- **explore / search** — explore grid, search users/hashtags/places, hashtag pages.
- **messaging** — conversations, messages, typing/presence, share post (realtime).
- **notifications** — activity feed + push fan-out.
- **moderation** — report queue, blocking enforcement, content states.

## Development Workflow

### Pre-Commit / CI Gates (MANDATORY)

```bash
npm run format:check     # Prettier
npm run lint             # ESLint, zero warnings
npm run typecheck        # tsc --noEmit, zero errors
npm test                 # unit + integration
npm run build            # compiles
```

### Review Requirements

- All code changes MUST be reviewed before merge.
- Security/privacy-sensitive changes (auth, tokens, authz guards, private-account
  / block enforcement, secrets, logging, rate limits, media access control) MUST
  receive additional scrutiny against Principles II, III & VIII.
- Schema/migration changes MUST include a migration + an integration test proving
  it applies and is backward-compatible.
- API-shape changes MUST update OpenAPI + `api-context.md` and a contract test,
  and MUST be checked against the client's deserialization.
- New dependencies MUST be justified, pinned, and audited (Principle XV).

### Quality Checks

- Auth verified: register, login (valid/invalid/locked), OAuth, refresh rotation,
  reuse-detection/revoke, logout.
- Authz verified: ownership + visibility on every protected resource;
  private-account withholding; bidirectional block enforcement.
- Idempotency verified: retried create-post/send-message/like does not duplicate.
- Media verified: presigned upload → finalize → processed variants → CDN URL;
  oversized/wrong-type rejected; private media not world-readable.
- Realtime verified: authenticated connect, per-user subscription isolation,
  persist-before-push, reconnect catch-up, multi-instance via Redis.
- Performance verified: feed pagination under load, cache hit/invalidate, queue
  drains (push/transcode/fanout), no N+1 on hot paths.

## Governance

This constitution establishes non-negotiable principles for We36 Backend
development. All implementation decisions MUST align with these principles. On any
conflict between this constitution and other guidance, the constitution wins;
`CLAUDE.md`/`AGENTS.md` provide runtime development guidance subordinate to it.
This backend constitution and the client constitution
(`../../.specify/memory/constitution.md`) are peers; the **shared contract**
(`api-context.md` here, `ui-design-context.md` there) is the boundary both honor.

### Amendment Process

1. Proposed amendments MUST be documented with rationale.
2. Amendments MUST be reviewed for impact on existing code and the client.
3. Breaking changes require a migration plan (and an API version bump if the
   contract changes) before approval.
4. Version MUST be incremented per semantic versioning:
   - MAJOR: principle removal or incompatible redefinition.
   - MINOR: new principle or material expansion.
   - PATCH: clarification or wording refinement.

### Compliance

- All pull requests MUST verify compliance with relevant principles.
- Complexity exceeding these standards MUST be explicitly justified.
- Deviations MUST be documented with rationale and approved by the project lead.
- Use `CLAUDE.md`/`AGENTS.md` for runtime development guidance and
  `.claude/claude-app/api-context.md` for API/data-contract compliance.

**Version**: 1.0.0 | **Ratified**: 2026-06-30 | **Last Amended**: 2026-06-30
