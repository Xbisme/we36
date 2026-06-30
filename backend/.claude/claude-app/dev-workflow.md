# Dev Workflow — We36 Backend

> Workflow between user and Claude for each spec/feature in the **we36-api** backend (NestJS modular monolith + PostgreSQL + Redis + S3-compatible storage).

## Flow For Each Spec

### Step 1: Pre-spec Discussion
- User and Claude discuss the upcoming backend spec.
- Claude reviews context: [`project-context.md`](project-context.md), [`sdd-roadmap.md`](sdd-roadmap.md), [`api-context.md`](api-context.md) (for any spec with API surface), `CLAUDE.md`/`AGENTS.md`, `.specify/memory/constitution.md`.
- **Cross-check the client**: confirm the endpoints/shapes this spec ships match what the corresponding client app spec expects (the app's `ui-design-context.md` + its Dart models).
- Open `[NEEDS CLARIFICATION]` items are surfaced and resolved. Blockers → ask user.

### Step 2: Claude Drafts `/speckit.specify` Prompt
- Detailed prompt focused on **WHAT/WHY** (endpoints, data, rules — not implementation detail).

### Step 3: User Runs `/speckit.specify` in IDE
- Speckit creates branch (`NNN-feature-name`) + `specs/NNN-feature-name/spec.md`.

### Step 4: Clarify (if needed)
- Resolve speckit questions; `/speckit.clarify` for more rounds. Answers written back into `spec.md`.

### Step 5: Plan & Tasks
- `/speckit.plan` → `plan.md`, `research.md`, `data-model.md` (tables/migrations), `quickstart.md`, `contracts/` (the OpenAPI/WS slice for this spec).
- `/speckit.tasks` → `tasks.md` (by user story, dependency-ordered).

### Step 6: Final Review
- `/speckit.analyze` for cross-artifact consistency. Confirm spec/plan/tasks + contract alignment.

### Step 7: Implement
- `/speckit.implement`. Pre-commit/CI gates (mandatory): `npm run format:check`, `npm run lint`, `npm run typecheck`, `npm test`, `npm run build`.
- Merge PR when complete; update status → "✅ Merged" in `project-context.md` + `sdd-roadmap.md`.

## Principles

- **Claude does NOT directly run speckit commands** — Claude drafts prompts; user runs them in the IDE.
- **All important decisions go through user confirmation** before being included in prompts.
- **Spec is the source of truth** — code is generated from specs.
- **Constitution is authoritative** — all specs/plans MUST comply. Conflicts → constitution / `CLAUDE.md` wins.
- **Vietnamese** = communication language (user ↔ Claude); **English** = all code, docs, comments, commits.
- **Discuss before acting** — large artifacts (specs, plans, multi-section docs) need explicit user approval before Claude writes them.
- **Contract-first & client-synced** — [`api-context.md`](api-context.md) + the generated OpenAPI are the binding contract with the app. Any shape change updates `api-context.md` + OpenAPI + a contract test, and is checked against the client's Dart models. Never let server and client silently diverge; a breaking shape change means a version bump, not an in-place `/v1` edit.
- **Security/privacy-first** — auth, tokens, secrets, private-account + bidirectional block enforcement, rate limits, and media access control get extra scrutiny (Constitution II/III/VIII). No PII/secrets in logs.
- **Backend-agnostic storage** — code targets the S3-compatible API behind a driver; never hardcode an AWS/MinIO/R2 specific path. Heavy work goes to the worker, never the request path.

## Per-Spec Hygiene

After every spec merges:
1. Update [`project-context.md`](project-context.md): move spec → "✅ Merged"; point "Current Focus" at the next spec.
2. Update [`sdd-roadmap.md`](sdd-roadmap.md): status → ✅ Merged; mark next spec 🟡 Next.
3. Append to [`changelog.md`](changelog.md) (format below).
4. Update `CLAUDE.md`/`AGENTS.md` if a working rule/stack item changed. Update [`api-context.md`](api-context.md) if the contract changed (+ OpenAPI + contract test).
5. Update the Constitution when a new universal rule emerged (PATCH/MINOR/MAJOR).
6. Archive any pre-spec alignment session to [`decisions/<spec-NNN>-<topic>.md`](decisions/).
7. **Notify the client side** if the contract changed so the app team updates its models.

## Branch Naming
- Spec branch: `NNN-feature-name` (e.g. `001-service-foundation`, `011-realtime-dm`).
- Sub-spec: `NNNx-feature-name`. Hotfix: `hotfix/<short-description>`.
- `main` is default and protected from direct push.

## Commit Message Style
- Conventional Commits: `<type>: <subject>` (e.g. `feat: add presigned media upload`, `fix: rotate refresh token on reuse`).
- Subject: imperative, sentence case, no trailing period, ≤ 72 chars.
- Body (when needed): wrapped at 72 chars, explains "why".
- Co-author trailer (when Claude assisted): `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`.

## Changelog Entry Format
```
### YYYY-MM-DD — Spec #NNN <Name> ✅ <verb>

- 1–4 bullets: scope shipped, endpoints/migrations added, tech notes, follow-ups, packages.
```
`<verb>`: `MERGED INTO MAIN` · `COMPLETE` (awaiting PR) · `IMPLEMENTED` (deploy/QA pending) · `LANDED` (awaiting merge gate).

## Infra & Integration Note (We36-backend-specific)

The service is **CI-testable without third parties**: integration tests run against a **real Postgres + Redis** (Testcontainers), and object storage / push / OAuth / email have **fakes/stubs**. But the full picture needs live infra to validate: **presigned upload → CDN delivery** (MinIO/R2), **FCM/APNs push** delivery, **OAuth** provider round-trips, **WebSocket** behavior across multiple replicas via Redis, and **migrations on a production-like DB**. Every spec touching storage/realtime/push/auth carries an **integration-on-real-infra smoke test** as an explicit (often deferred) task in its `tasks.md` banner — CI cannot prove CDN delivery, real push, or multi-instance socket fan-out.
