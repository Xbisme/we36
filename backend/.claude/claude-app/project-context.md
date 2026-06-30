# We36 Backend — Project Context

> Last updated: 2026-06-30 (Project bootstrap: backend constitution v1.0.0 ratified + `.claude/claude-app/` docs authored. **No code started yet.** **Next: B#001 Service Foundation, Infra & Contract Skeleton**.)
> **Mục đích**: Snapshot tối thiểu để bắt đầu một session làm việc trên backend — context hiện tại, focus, links.
>
> **Đọc file nào khi nào**:
> - Bắt đầu session mới → file này (snapshot) + `CLAUDE.md`/`AGENTS.md` (tạo ở B#001).
> - Chuẩn bị spec mới → file này (focus) + [`sdd-roadmap.md`](sdd-roadmap.md).
> - Làm phần **API/contract** của spec → [`api-context.md`](api-context.md) (REST/WS/data model) — và OpenAPI sinh từ code.
> - Cần biết spec nào đã ship → [`changelog.md`](changelog.md).

## Snapshot

- **Service**: we36-api — backend cho **We36** (Instagram-style social app: feed · stories · reels · DM · explore · profiles).
- **Consumer**: We36 Flutter client (`/Users/ase/Documents/flutter_we36`) qua **versioned REST/JSON + WebSocket** contract.
- **Stack**: **NestJS (TypeScript)** · **PostgreSQL** (system of record + FTS) · **Redis** (cache/presence/pub-sub + BullMQ queue) · **S3-compatible object storage** · **BullMQ worker**.
- **Object storage (no AWS account needed)**: code theo **S3 API endpoint cấu hình được** → **MinIO** (dev/self-host) / **Cloudflare R2** (prod, free tier, zero egress). Đổi driver không sửa code. **Presigned upload** (client PUT thẳng lên storage) + **CDN** delivery.
- **Shape**: **modular monolith** (1 deployable, module boundaries) + worker process. Microservices = deferred.
- **Out of scope v1.0**: monetization/commerce, livestreaming, ranked-recommendation feed (MVP = reverse-chronological, fan-out-on-read).
- **Communication**: Vietnamese (user ↔ Claude) · English cho code, docs, comments, commits.

## How It Works (one-paragraph mental model)

The API process serves REST `/v1` + a WebSocket gateway through a strict pipeline (DTO validation → auth/ownership/visibility guards → controller → service → repository → Postgres), with a global filter shaping every error into one envelope. Heavy/async work (media transcode, push + notification fan-out, story 24h expiry, cleanup) runs in a **BullMQ worker** — idempotent, retrying. **Redis** backs caching, presence, and the **pub/sub** that lets N API replicas reach any connected socket; DMs are **persisted before pushed**. Media never flows through the API: clients get a **presigned URL** and upload directly to S3-compatible storage, the worker processes variants, and a **CDN** serves delivery. Privacy and blocking are enforced at the **data/authorization layer**, never assumed from the client. See the Architecture Primer in [`sdd-roadmap.md`](sdd-roadmap.md).

## Current Focus

- **Now**: **Project bootstrap complete (docs only).** Backend constitution v1.0.0 ratified at [`.specify/memory/constitution.md`](../../.specify/memory/constitution.md); `.claude/claude-app/` docs authored. **No NestJS code exists yet.** Speckit scaffold present in `backend/.specify/`.
- **Next spec: B#001 Service Foundation, Infra & Contract Skeleton** — NestJS modular-monolith skeleton, config validation, Postgres+Prisma, Redis, docker-compose (pg/redis/minio), error envelope + filter, ValidationPipe, cursor pagination, OpenAPI, health, BullMQ worker bootstrap, CI gates. See [`sdd-roadmap.md`](sdd-roadmap.md) §B#001 + [`api-context.md`](api-context.md).
- **Decisions to confirm at B#001 planning**: ORM (**Prisma** vs **TypeORM**); id format (**UUIDv7** vs **ULID**); WebSocket lib (**Socket.IO** vs native `ws`); validation (**class-validator** vs **Zod**); prod storage target (**Cloudflare R2** vs self-hosted MinIO); deploy target (VPS/Docker vs a PaaS).
- **Active blockers**: none. Pair each backend spec just ahead of its client consumer (B#002 → app #003, B#003+B#004 → app #004/#007, B#011 → app #012).

## Spec Status

| # | Name | Status | Unblocks client | Branch |
|---|---|---|---|---|
| B#001 | Service Foundation, Infra & Contract Skeleton | ⬜ **Next** | (all) | `001-service-foundation` |
| B#002 | Auth & Identity | ⬜ Not started | #003 | `002-auth-identity` |
| B#003 | Media Pipeline & Object Storage | ⬜ Not started | #007 (+#004/#005/#008) | `003-media-pipeline` |
| B#004 | Posts & Feed | ⬜ Not started | #004/#007 | `004-posts-feed` |
| B#005 | Comments | ⬜ Not started | #006 | `005-comments` |
| B#006 | Stories | ⬜ Not started | #004/#005 | `006-stories` |
| B#007 | Reels | ⬜ Not started | #008 | `007-reels` |
| B#008 | Social Graph (Follow & Block) | ⬜ Not started | #010 | `008-social-graph` |
| B#009 | Explore & Search | ⬜ Not started | #009 | `009-explore-search` |
| B#010 | Collections (Saved) | ⬜ Not started | #011 | `010-collections` |
| B#011 | Realtime & Direct Messages | ⬜ Not started | #012 | `011-realtime-dm` |
| B#012 | Notifications & Push | ⬜ Not started | #013 | `012-notifications-push` |
| B#013 | Settings, Privacy & Moderation | ⬜ Not started | #014 | `013-settings-moderation` |
| B#014 | Hardening, Observability & v1.0 Release | ⬜ Not started | — | `014-hardening-release` |

## Tech Stack (planned, concise)

- **NestJS** (TypeScript strict) modular monolith + **BullMQ** worker process.
- **PostgreSQL** via **Prisma** (or TypeORM) + versioned migrations.
- **Redis** — cache, presence, pub/sub backplane, BullMQ queue.
- **S3-compatible** object storage (MinIO dev / Cloudflare R2 prod) via the S3 SDK; presigned uploads; CDN delivery; **ffmpeg** in the worker for transcode.
- **WebSocket** gateway (Socket.IO or `ws`) + Redis pub/sub.
- **Auth**: JWT access + rotating/revocable refresh; OAuth Google/Apple verify; **argon2id**.
- **Push**: FCM + APNs (worker).
- **Validation/docs**: `class-validator`/Zod + `ValidationPipe`; OpenAPI/Swagger.
- **Observability**: pino logs + correlation id; health checks; Prometheus metrics; Sentry (PII-scrubbed).
- **Testing**: Jest + Supertest + Testcontainers + contract tests.
- **Tooling**: ESLint + Prettier; Docker + docker-compose; CI on every PR.
- **Environments**: dev / staging / prod (env-validated config + secrets).

## Architecture Decisions (anchors)

- **Modular monolith + worker** — one codebase, module boundaries enforced in-code; worker is a separate process for async. Microservices deferred (YAGNI).
- **Contract-first, versioned** — `/v1`, DTO-validated, OpenAPI-documented; the contract is the binding agreement with the app ([`api-context.md`](api-context.md)).
- **Privacy/block at the data layer** — visibility never depends on the client; blocks enforced bidirectionally server-side.
- **Presigned, worker-processed, CDN-delivered media** — media never proxied through the API; S3-compatible abstraction (no vendor lock-in).
- **Persist-before-push realtime** — Postgres is source of truth; Redis pub/sub fans out; reconnect catch-up via REST cursor.
- **Idempotent writes + DB-level integrity** — idempotency keys + FK/constraints + transactions; counters never drift.
- **Async-by-default for heavy work** — transcode, push/notification fan-out, story expiry, cleanup all on BullMQ; never on the request path.
- **No PII/secrets in logs**; config validated at boot; lockfile committed.

## Repo Map (target after B#001)

```
src/
├── main.ts                    # API bootstrap
├── worker.ts                  # BullMQ worker bootstrap (separate process)
├── app.module.ts
├── common/                    # cross-cutting (no domain logic)
│   ├── config/                # env schema + validation (fail-fast)
│   ├── logging/               # pino + correlation id
│   ├── errors/                # error envelope + global exception filter + catalog
│   ├── pagination/            # cursor envelope util
│   ├── auth/                  # JWT strategy, guards (auth/ownership/visibility)
│   ├── validation/            # global ValidationPipe config
│   ├── redis/                 # redis client + pub/sub
│   ├── storage/               # S3-compatible driver (MinIO/R2) + presign
│   ├── queue/                 # BullMQ setup + queue tokens
│   └── health/                # health checks
├── modules/
│   ├── auth/                  # B#002
│   ├── users/                 # B#002/#008/#013
│   ├── media/                 # B#003
│   ├── posts/  feed/          # B#004
│   ├── comments/              # B#005
│   ├── stories/               # B#006
│   ├── reels/                 # B#007
│   ├── social/                # B#008 (follow/block)
│   ├── collections/           # B#010
│   ├── search/                # B#009
│   ├── messaging/             # B#011 (+ WS gateway)
│   ├── notifications/         # B#012
│   └── moderation/            # B#013
│       (each: *.controller.ts · *.service.ts · *.repository.ts · dto/ · entities/)
└── jobs/                      # BullMQ processors (media, push, fanout, expiry, cleanup)

prisma/ (or src/migrations/)   # schema + versioned migrations
test/                          # unit · integration (Testcontainers) · contract
docker-compose.yml             # postgres · redis · minio (local)
.env.example
.claude/claude-app/            # project meta (this file lives here)
├── project-context.md         # ← you are here
├── sdd-roadmap.md             # spec planning (dependency graph, scope)
├── api-context.md             # API/data contract source of truth
├── dev-workflow.md            # Speckit workflow conventions
├── changelog.md               # spec ship history
└── decisions/                 # alignment decisions per spec
```

## References

- **We36 client** (`/Users/ase/Documents/flutter_we36`) — the API consumer. Its [`ui-design-context.md`](../../../.claude/claude-app/ui-design-context.md) shows the screens that drive each endpoint; its constitution declares the app backend-agnostic against this contract. Keep the contract here in sync with the Dart models there.
- **flutter_send_anytime (Safe Send)** (`/Users/ase/Documents/flutter_send_anytime`) — SDD methodology source (`.claude/` structure, Speckit per-spec workflow). **Follow the methodology, not the product.**

## Key Documents

| File | Vai trò |
|---|---|
| [`.specify/memory/constitution.md`](../../.specify/memory/constitution.md) | **Backend Constitution v1.0.0** — 15 non-negotiable principles (authoritative) |
| `CLAUDE.md` / `AGENTS.md` | Day-to-day codebase reference (created during B#001) |
| [`sdd-roadmap.md`](sdd-roadmap.md) | Spec planning (dependency graph, scope per spec, architecture primer) |
| [`api-context.md`](api-context.md) | **API/data contract** — REST map, WS catalog, error/pagination envelopes, data model |
| [`dev-workflow.md`](dev-workflow.md) | Speckit workflow + per-spec hygiene + commit style |
| [`changelog.md`](changelog.md) | Spec ship history (append-only) |
| [`decisions/`](decisions/) | Alignment decisions per spec |
