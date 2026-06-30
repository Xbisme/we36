# CLAUDE.md — We36 Day-to-Day Reference

> Runtime guidance for working in this repo. Subordinate to `.specify/memory/constitution.md` (constitution wins on any conflict). Project meta lives in `.claude/claude-app/` (context, roadmap, UI design, workflow). UI source of truth: `.claude/claude-app/ui-design-context.md`.

## What this is
We36 — cross-platform (iOS + Android phones + iPad/Android tablets) **Instagram-style social app** in Flutter: feed, stories, reels, DMs, explore, profiles. Backend-agnostic client over a custom versioned REST/JSON + WebSocket contract (server tech out of scope; every repo has an in-memory fake). English-first UI (+ Vietnamese). Fixed light/dark palette, signature rose→violet gradient.

## Communication
- **Vietnamese** between user and Claude; **English** for all code, comments, docs, commits, and in-app UI copy.
- Discuss before large artifacts; decisions go through user confirmation. Spec is the source of truth (SDD via Speckit). Claude drafts speckit prompts; the **user** runs `/speckit.*` in the IDE.

## SDD workflow (per spec)
`/speckit.specify → /speckit.clarify → /speckit.plan → /speckit.tasks → /speckit.analyze → /speckit.implement`. Branch `NNN-feature-name`, folder `specs/NNN-feature-name/`. **Create the git branch yourself** before specify (`git checkout -b NNN-...`). See `.claude/claude-app/dev-workflow.md`.

## Stack (decided at #001 — versions from pub.dev 2026-06-30)
- Flutter 3.41.7 / Dart 3.11.5 (stable floor).
- State `flutter_bloc ^9.1.1` (4-state freezed Cubits) · DI `get_it ^9.2.1` + `injectable ^3.0.0` · Router `go_router ^17.3.0` (StatefulShellRoute + auth-guard redirect, `we36://`).
- Codegen `freezed ^3.2.5` + `json_serializable ^6.14.0` + `build_runner ^2.15.0`.
- Icons `lucide_icons_flutter ^3.1.14` (wrap in `AppIcon`) · Fonts Plus Jakarta Sans + Inter via `google_fonts ^8.1.0` **bundled** (no runtime fetch) · `cached_network_image ^3.4.1` · `flutter_svg ^2.3.0`.
- i18n Flutter `gen-l10n` + `intl ^0.20.3`, ARB in `lib/l10n/arb/` (EN primary + VI). Lint `very_good_analysis ^10.3.0` + `bloc_lint`. Test `bloc_test ^10.0.0` + `mocktail ^1.0.5` + goldens.
- **Custom, no package**: Toast (overlay ink-pill — never `ScaffoldMessenger.showSnackBar`), `AdaptiveShell`, `TwoPaneScaffold`, `Result<T>`/`AppFailure`, `AppCubit`, `AppLogger`, formatters.
- **Networking/cache (added #002)**: HTTP `dio ^5.10.0` · realtime `socket_io_client ^3.1.6` (Socket.IO — matches backend gateway) · cache `drift ^2.34.0` + `drift_flutter ^0.3.0` (+ `drift_dev ^2.34.0` dev, pinned: 2.34.1 needs analyzer 13) · `flutter_secure_storage ^10.3.1` (token store seam, impl #003) · `uuid ^4.5.3` (UUIDv7 ids + idempotency keys).

## Networking conventions (#002 — `lib/core/data/`)
- One `ApiClient` (single `Dio`) behind interceptors: idempotency → auth-token → single-flight refresh → logging. Repos call it; widgets/Cubits never touch HTTP. Errors centralized in `FailureMapper` (envelope `{error:{code,message,details}}` → `AppFailure`; `code`s contract-stable). Returns `Result<T>`.
- Single-flight refresh on `401 SESSION_EXPIRED` via `TokenStore`/`TokenRefresher`/`AuthEventsSink` seams (fakes now; real in #003). Cursor pagination = `CursorPage<T>` + reusable `PaginatedListCubit<T>` (4-state). Endpoints/events in `core/constants/{api_endpoints,socket_events}.dart` — never inline literals.
- Cache = `AppDatabase` (drift) + DAO base; reactive `.watch()` reads (one canonical copy). Realtime = one `RealtimeClient` (scaffold; wired #012/#013).
- **DI environments**: app runs `environment: 'fake'` (in-memory fakes, no backend) until #003; real impls annotated `env: ['real']`. Every repo has a real + fake behind one interface.

## Architecture anchors
- Clean Architecture, feature-first. `lib/core/` MUST NOT import `lib/features/`; features don't import each other's internals (handoff via core/router/DI).
- One API client + one realtime socket behind repositories returning `Result<T>` (from #002); widgets/Cubits never touch HTTP/socket.
- BLoC: Events = plain sealed; States = freezed 4-state (`initial/loading/loaded/error`; extended variants prefix the base name). Inject Use Cases into Cubits, not Repos. BlocProvider page-scoped. `@lazySingleton` services/shared cubits, `@injectable` screen cubits; eager `@singleton` forbidden.
- Optimistic + idempotent mutations (from #004+); one canonical cached representation per item.
- Toast for all user messages; `AppLogger` for all logging — never `print`/`debugPrint`, never log secrets.

## Design discipline (Constitution VI + ui-design-context.md)
- Fixed light/dark via `AppColorsX` ThemeExtension + token classes. Use **semantic aliases** (`context.tokens`) — never hardcode hex/TextStyle at call sites.
- "Color earns its place": neutral chrome/feed; brand color/gradient ONLY on primary CTA, unseen story ring, active nav, badge, sticker. Gradient never a full-page wash.
- Single Lucide family via `AppIcon` (outline default, solid for active). Pills default for interactive. Press = scale-down; Reduce-Motion → static; no infinite decorative loops.
- Shared widgets built once in `core/presentation/` — never duplicate markup per feature. Every component: `Semantics` + text-scaling + light/dark.
- Adaptive by **width** (`LayoutBuilder`/`MediaQuery`): `<700` bottom nav · `≥700` sidebar rail (compact `<980` / full `≥980`) · right rail `≥1100`. Two-pane master/detail for Messages + Post detail. Supports iPad split-view + rotation.
- Navigation IA: 5 tabs (Home/Explore/Reels/Messages/Profile). **Create** is contextual, not a tab. Flow/auth screens are nav-less pushed routes.

## Pre-commit gate (mandatory)
```bash
dart format .
flutter analyze                  # zero warnings
flutter test                     # all pass
dart run bloc_tools:bloc lint .  # zero violations
```

## Current focus
**Spec #002 Networking, Cache & Realtime Core** — implemented on branch `002-networking-core` (50/50 tasks; 103 tests green, `dart analyze` clean). Built: `ApiClient` + single-flight refresh + `FailureMapper`, cursor pagination + `PaginatedListCubit`, drift cache base + reactive reads, `RealtimeClient` (Socket.IO scaffold), repository pattern + fakes proven by the `User` reference slice — all on fakes (zero-network). #001 (Foundation) shipped earlier. **No auth UI/session persistence yet** (that's #003). Next: #003 Auth & Onboarding (backend B#002 Auth already implemented).
