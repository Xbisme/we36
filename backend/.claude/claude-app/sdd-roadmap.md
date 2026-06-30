# We36 Backend v1.0 — Spec Roadmap (SDD Roadmap)

> Goal v1.0: Ship the **we36-api** backend — a **NestJS modular monolith + BullMQ worker** over **PostgreSQL + Redis + S3-compatible object storage** — implementing the versioned **REST/JSON + WebSocket** contract that the We36 Flutter client consumes (feed · stories · reels · DM · explore · profiles). **Out of scope v1.0**: monetization/commerce, livestreaming, ranked-recommendation feeds (MVP feed = reverse-chronological, fan-out-on-read).
>
> **Vai trò file này**: pure planning — dependency graph, scope per spec, optimal order. Current status sống ở [`project-context.md`](project-context.md). Ship history ở [`changelog.md`](changelog.md). **Contract** (REST/WS/data model) sống ở [`api-context.md`](api-context.md) — đọc trước mọi phần API của spec.
>
> Backend specs are prefixed **B#NNN** to distinguish them from the client app specs (#NNN). Each B-spec maps to the client spec(s) it unblocks.
>
> Last updated: 2026-06-30 (Initial roadmap. No specs started. Next: B#001 Service Foundation.)

---

## SDD Workflow For Each Spec

```
/speckit.specify → /speckit.clarify → /speckit.plan → /speckit.tasks → /speckit.analyze → /speckit.implement
```

Each spec creates: branch `NNN-feature-name`, folder `specs/NNN-feature-name/`. See [`dev-workflow.md`](dev-workflow.md).

---

## Architecture Primer (read before B#002)

we36-api is a **NestJS modular monolith + a worker process** sharing one codebase:

1. **API process** — HTTP (REST `/v1`) + the **WebSocket gateway**. Global pipeline: `ValidationPipe` (DTO in) → guards (auth/ownership/visibility) → controller → service → repository → Postgres. Global exception filter shapes every error into the standard envelope.
2. **Worker process** — **BullMQ** consumers for media processing (resize/transcode/thumbnail), push fan-out (FCM/APNs), notification/activity fan-out, **story 24h expiry**, cleanup. Idempotent, retry+backoff, dead-letter.
3. **PostgreSQL** — system of record (relations + FTS + JSONB), versioned migrations, FK/constraints, transactions, idempotency keys.
4. **Redis** — cache (sessions/aggregates/feed pages), **presence**, **pub/sub** backplane for the WS gateway (so N API replicas can reach any socket), and the BullMQ queue.
5. **S3-compatible object storage** — **MinIO** (dev/self-host) / **Cloudflare R2** (prod). **Presigned uploads**: client PUTs media directly to storage; API never proxies bytes; CDN serves delivery.

> **Why B#001 → B#002 → B#003 are the blocking foundation**: B#001 stands up the service skeleton + infra + the contract conventions (envelopes, error filter, OpenAPI, docker-compose). B#002 builds auth/identity (the gate). B#003 builds the media pipeline (every content feature uploads through it). Everything after is a domain module on this spine.

> **Pairing with the client**: each backend spec is sequenced to **unblock** the matching client spec — e.g. B#002 (auth) before app #003, B#003+B#004 (media+posts) before app #004/#007, B#011 (realtime DM) before app #012. Run a backend spec just ahead of (or alongside) its client consumer.

---

## Dependency Graph

```
B#001: Service Foundation, Infra & Contract Skeleton   ← FOUNDATION (blocking)
   (NestJS modular monolith, config validation, Postgres+
    Prisma, Redis, docker-compose [pg/redis/minio], error
    envelope + filter, ValidationPipe, cursor pagination,
    OpenAPI/Swagger, health, logging, BullMQ worker bootstrap)
    │
    ▼
B#002: Auth & Identity                                 ← GATE (blocking)
   (register/login email+phone+password, OAuth verify,
    JWT access + rotating refresh, argon2id, sessions,
    me/profile + settings, auth/ownership guards)
    │
    ▼
B#003: Media Pipeline & Object Storage                 ← MEDIA SPINE (blocking)
   (S3-compatible storage [MinIO/R2], presigned uploads,
    finalize, worker resize/transcode/thumbnail, CDN URLs,
    validation + cleanup)
    │
    ├───────────────┬───────────────┬───────────────┐
    ▼               ▼               ▼               ▼
B#004            B#005           B#006           B#007
Posts & Feed     Comments        Stories         Reels
(carousel,       (+1-level       (24h expiry     (vertical
 reverse-chron,   replies,        worker, close   video feed)
 like/save)       mentions)       friends)
    └───────────────┴───────┬───────┴───────────────┘
                            ▼
                    B#008: Social Graph (Follow & Block)
                    (follow/unfollow, private follow requests,
                     followers/following, bidirectional block,
                     profile aggregates + visibility rule)
                            │
                            ▼
                    B#009: Explore & Search (Postgres FTS)
                            │
                            ▼
                    B#010: Collections (Saved)
                            │
                            ▼
                    B#011: Realtime & Direct Messages
                    (WS gateway + Redis pub/sub, conversations,
                     persist-before-push, typing/presence,
                     share post, stickers)
                            │
                            ▼
                    B#012: Notifications & Push
                    (activity events, fan-out worker,
                     FCM/APNs, device registry)
                            │
                            ▼
                    B#013: Settings, Privacy & Moderation
                    (private account, close friends, blocking,
                     report queue, 2FA, data export/delete,
                     rate limits)
                            │
                            ▼
                    B#014: Hardening, Observability & v1.0 Release
```

---

## Spec Details

> Status legend: ⬜ Not started · 🟡 Next · 🔵 In progress · ✅ Merged.

### B#001: Service Foundation, Infra & Contract Skeleton  ⬜
- **Depends on**: none. **Blocking**: all.
- **Scope**: NestJS modular-monolith skeleton + `common`/`core` (config validation [Zod/Joi, fail-fast], structured logging + correlation id, global error filter + envelope, global `ValidationPipe`, cursor-pagination util, rate-limit guard); **Postgres + Prisma** (or TypeORM) wiring + migration tooling; **Redis** client; **BullMQ** worker bootstrap (empty); **docker-compose** (postgres/redis/minio) + `.env.example`; **OpenAPI/Swagger**; `/health`; base auth-guard scaffolding; CI gates. Establishes the [`api-context.md`](api-context.md) conventions in code.
- **Out of scope**: any domain endpoint.

### B#002: Auth & Identity  ⬜  → unblocks client #003
- **Depends on**: B#001.
- **Scope**: register/login (email/phone + password, **argon2id**); **OAuth Google/Apple** server-side verify; **JWT access + rotating, revocable refresh** (Redis/DB store, reuse-detection); forgot/reset (OTP via worker email/SMS); `me` profile + profile-setup + `check-username`; auth + ownership guards; per-route access rules; login rate-limit/lockout.
- **Out of scope**: content, social graph.

### B#003: Media Pipeline & Object Storage  ⬜  → unblocks client #007 (+ #004/#005/#008)
- **Depends on**: B#001, B#002.
- **Scope**: S3-compatible storage driver (configurable endpoint — **MinIO** dev / **Cloudflare R2** prod); `POST /media/uploads` **presigned PUT** + `finalize`; worker **image resize/variants** + **video transcode + poster/thumbnail** (ffmpeg, containerized); MIME/size/duration validation; CDN URL assembly; private-media access control; orphan cleanup job.
- **New infra**: MinIO (compose) / R2 (prod), ffmpeg in the worker image.
- **Out of scope**: post/story/reel domain logic (consumes media ids).

### B#004: Posts & Feed  ⬜  → unblocks client #004/#007
- **Depends on**: B#003.
- **Scope**: create post (carousel media ids, caption, hashtags, tagged users, location, comments-disabled, **idempotency key**); **reverse-chronological feed** (fan-out-on-read over followees, cursor); post detail; **like/save** (optimistic-friendly, atomic counters); delete; hashtag/place linking.
- **Out of scope**: comments (B#005), ranked feed.

### B#005: Comments  ⬜  → unblocks client #006
- **Depends on**: B#004.
- **Scope**: comments list (cursor) + create (text, **one-level replies**, **mentions**), comment likes, delete; comment-count maintenance; mention → notification hook (wired in B#012).
- **Out of scope**: multi-level threads.

### B#006: Stories  ⬜  → unblocks client #004/#005
- **Depends on**: B#003, B#008 (close friends needs the graph — or land basic + close-friends after B#008).
- **Scope**: create story (media, audience everyone|closeFriends), active stories feed grouped by user, story views, **24h expiry worker**; visibility rule applied.
- **Out of scope**: story stickers/polls (defer).

### B#007: Reels  ⬜  → unblocks client #008
- **Depends on**: B#003, B#004.
- **Scope**: create reel (video media + caption), reels feed (cursor), like/comment/save mirroring posts. Decide reel-as-post vs separate entity at plan.
- **Out of scope**: ranked reel recommendation.

### B#008: Social Graph (Follow & Block)  ⬜  → unblocks client #010
- **Depends on**: B#002.
- **Scope**: follow/unfollow; **private-account follow requests** (pending → accept/reject); followers/following lists (cursor); **bidirectional block** enforcement across all reads/writes; profile aggregates (posts/followers/following counts); the shared **visibility rule** ([`api-context.md`](api-context.md)).
- **Out of scope**: collections, messaging.

### B#009: Explore & Search  ⬜  → unblocks client #009
- **Depends on**: B#004, B#008.
- **Scope**: explore grid (non-personalized, cursor); **Postgres FTS** search for users/hashtags/places + result types; hashtag/place pages; search recents. MVP = simple, no recommendation engine.
- **Out of scope**: dedicated search engine, personalization.

### B#010: Collections (Saved)  ⬜  → unblocks client #011
- **Depends on**: B#004.
- **Scope**: collections CRUD + save/unsave a post into a collection; the profile "saved" listing.

### B#011: Realtime & Direct Messages  ⬜  → unblocks client #012
- **Depends on**: B#001 (gateway), B#003 (media in chat), B#008 (who can DM).
- **Scope**: **WebSocket gateway** + **Redis pub/sub** + presence; conversations + members; messages (text | media | **shared post** | sticker) **persist-before-push**, idempotent send, read state, typing; REST history (cursor) for catch-up; per-user subscription isolation; block enforcement.
- **Out of scope**: group chats, calls.

### B#012: Notifications & Push  ⬜  → unblocks client #013
- **Depends on**: B#004/B#005/B#008 (event sources), B#011 (realtime delivery).
- **Scope**: activity events (like/comment/follow/follow-request/mention) → notification feed (cursor, grouped); **fan-out worker**; **FCM/APNs push** + device registry; in-app live `notification.new` over WS; read state.
- **New infra**: FCM/APNs credentials.
- **Out of scope**: digest/email notifications.

### B#013: Settings, Privacy & Moderation  ⬜  → unblocks client #014
- **Depends on**: most prior.
- **Scope**: account settings (private account toggle, **close friends** list, activity status); **report** flow + moderation queue + content states (hidden/removed); 2FA (TOTP); **data export + account deletion** (cascade/anonymize); rate-limit/abuse tuning; surface server-side privacy enforcement consistently.
- **Out of scope**: full admin console (internal-only minimal queue).

### B#014: Hardening, Observability & v1.0 Release  ⬜
- **Depends on**: all.
- **Scope**: security audit (authz matrix, private/block enforcement, secrets, rate limits, dependency `npm audit`); load/perf (feed/search/DM, cache hit, queue drain, N+1 sweep); **observability** (metrics, Sentry, dashboards, runbooks); backups + restore drill; deploy/infra (containers, migrations-on-deploy, secret manager, TLS, CDN) + **CI/CD**; contract-test pass against the shipped client.
- **New infra**: none expected.

---

## Optimal Order (1 Backend Developer)

B#001 → B#002 → B#003 → B#004 → B#005/B#006/B#007 (content, parallelizable on the media spine) → B#008 → B#009 → B#010 → B#011 (realtime, heaviest) → B#012 → B#013 → B#014.

Sequence each backend spec **just ahead of** its client consumer so the app team is never blocked: ship B#002 before app #003, B#003+B#004 before app #004, B#011 before app #012, etc. A throwaway seed/fixtures script (from B#002) lets the app dogfood against real-ish data early.

---

## Post-v1.0 (v1.1+)

- Ranked feed + personalized explore (fan-out-on-write, ML ranking).
- Dedicated search engine (Meilisearch/Elasticsearch) if Postgres FTS hits limits.
- Group chats; audio/video calls; multi-level reply threads.
- Microservice extraction of hot modules (media, realtime) if load demands.
- Read replicas, sharding, regional CDN tuning.
