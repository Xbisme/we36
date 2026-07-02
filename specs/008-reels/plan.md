# Implementation Plan: Reels

**Branch**: `008-reels` | **Date**: 2026-07-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/008-reels/spec.md`

## Summary

A full-screen vertical short-video feed (`PageView`, reverse-chron, cursor-paginated, ready-only) with disciplined video lifecycle (only the active reel plays; off-screen paused+disposed; ±1 preload window), per-reel engagement (optimistic + idempotent like/save; comment via the reused #006 surface; surface-only share/follow), and a minimal create-reel flow (pick one video → caption/options → resilient idempotent upload via the #007 pipeline). Built on the **existing B#007 backend contract** (real `ReelsRepository` seam + in-memory fake); app runs `environment:'fake'` (zero-network). Reels are cached canonically in drift (schema v4→v5) mirroring the #004 feed. One new dependency: `video_player ^2.11.1` (no `chewie`, no `visibility_detector`).

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (canonical baseline; `pubspec` floor `sdk: ^3.11.5`).

**Primary Dependencies**: `flutter_bloc ^9.1.1`, `get_it`/`injectable ^3.0.0`, `go_router ^17.3.0`, `freezed ^3.2.5` + `json_serializable ^6.14.0` + `build_runner`, `dio ^5.10.0`, `drift ^2.34.0`, `uuid ^4.5.3`, `photo_manager ^3.9.0`, `cached_network_image ^3.4.1`, `lucide_icons_flutter`. **NEW**: `video_player ^2.11.1` (flutter.dev, Flutter Favorite; verified pub.dev 2026-07-02).

**Storage**: `drift` (SQLite) local cache — add `Reels` table + `ReelsDao`, schema **v4 → v5** (non-destructive migration).

**Testing**: `flutter_test`, `bloc_test ^10.0.0`, `mocktail ^1.0.5`, golden tests. Fakes for all repos (zero-network CI).

**Target Platform**: iOS 13+ & Android (minSdk 24) phones + iPad/Android tablets (adaptive by width). Both prereqs already satisfied since #003; Android needs `INTERNET` permission for network video (T-native check).

**Project Type**: Mobile app (Flutter), Clean Architecture feature-first (`lib/core` + `lib/features/reels`).

**Performance Goals**: First frame < 2s (SC-001); ≤ 3 `VideoPlayerController`s alive at once (SC-002); ≤ 1 playing at a time, prev stops within a fraction of a second (SC-003); like/save reflects < 100ms (SC-004); 60fps swipe.

**Constraints**: Bounded memory while scrolling rich video (Constitution II — off-screen pause+dispose, ±1 window, every controller disposed); optimistic + idempotent + one canonical cached representation (Constitution IX); offline-from-cache render; no secrets/URLs in logs; ≤ 90s video at create.

**Scale/Scope**: One new feature module + one core data slice + one drift table + one new dependency. ~2 screens (reels feed, reel compose) + comments bottom sheet reuse. Reverse-chronological only (no ranking — Constitution XIII).

## Constitution Check

*GATE: evaluated pre-Phase 0 and re-checked post-Phase 1 design. All PASS.*

| Principle | Status | How this plan complies |
|---|---|---|
| I. Privacy, Safety & Trust | ✅ | Video URLs/tokens never logged (redaction test); block/report moderation explicitly out of scope → #014; contextual gallery permission at pick. |
| II. Media-Centric Performance | ✅ | **Core of this feature**: cursor pagination; only active reel plays; off-screen pause+**dispose**; ±1 preload window (≤3 controllers, SC-002); every controller disposed; video upload streams from file (real) / bounded fake; poster via bounded image. |
| III. BLoC 4-state | ✅ | `ReelsCubit` + create cubit are freezed 4-state (`initial/loading/loaded(+Paginating/Refreshing)/error`); paginated `loaded` carries cursor+hasMore; side effects via `BlocListener`; `@injectable` page-scoped, playback controller closed with the cubit. |
| IV. Code Quality & Dart Safety | ✅ | freezed immutables + generated JSON for `Reel`; strict analysis, zero warnings; explicit types. |
| V. Result<T> | ✅ | `ReelsRepository` returns `Result<T>`; cubits `.fold()`; errors mapped centrally by existing `FailureMapper` (contract-stable codes, no new mapping). |
| VI. Design System & Theming | ✅ | Reuse tokens + `AppIcon` (solid active like), `Toast`, `ActionSheet`, shared comment widgets; brand color only on like/active; Reduce-Motion → static poster; adaptive layout; no hardcoded hex. |
| VII. Cross-Platform Native | ✅ | `video_player` iOS 13/Android 24 (met); action sheet platform-appropriate; edge-to-edge immersive viewer; a11y (screen reader labels, Dynamic Type, Reduce Motion, overlay contrast). |
| VIII. API & Realtime Architecture | ✅ | New `ReelsRepository` behind the single `ApiClient`; endpoints centralized in `ApiEndpoints` (no inline literals); cursor envelope `CursorPage<Reel>`; fake impl for zero-network CI. No realtime needed. |
| IX. Data Integrity, Caching, Optimistic UX | ✅ | Optimistic like/save + rollback; idempotent create (stable key ⇒ one reel); **one canonical cached `Reel`** (drift, reactive `watchReel`); comment-count delta seam routes to the canonical reel; non-destructive v4→v5 migration + test; malformed page item skipped. |
| X. go_router Navigation | ✅ | `/reels` tab branch reused; create is a nav-less pushed route via `AppRoutes` (Create is contextual, not a tab); comments = bottom sheet; `context.go/push` only; centralized route constants. |
| XI. Feature-First Modularity | ✅ | Core data slice `lib/core/data/reels/`; feature `lib/features/reels/`; `core` never imports `features`; reuse of feed shared types is core→core; comments reuse via a small core seam, not feature→feature import. |
| XII. Testing Discipline | ✅ | Fake repo, `bloc_test` cubits, playback-lifecycle unit tests, comment-seam unit test, migration test, widget + golden tests, log-redaction test — all zero-network. |
| XIII. Simplicity & YAGNI | ✅ | Reverse-chron only (no ranking); no trim/cover/filter; one new package (dropped `visibility_detector` + `chewie`); reel draft not persisted (no new drift draft table). |
| XIV. i18n | ✅ | All new strings in ARB (EN primary + VI); counts/relative-time via shared `intl` formatters. |
| XV. Dependency Hygiene | ✅ | `video_player ^2.11.1` version + iOS/Android minimums + `INTERNET`/ATS notes verified on pub.dev 2026-07-02 (research R1); caret-pinned; lockfiles committed. |

**No violations → Complexity Tracking is empty.**

## Project Structure

### Documentation (this feature)
```text
specs/008-reels/
├── plan.md              # This file
├── research.md          # Phase 0 — decisions (video_player, lifecycle, cache, comments seam)
├── data-model.md        # Phase 1 — Reel model, Reels drift table, state transitions
├── quickstart.md        # Phase 1 — run + validation scenarios
├── contracts/
│   └── reels-api.md      # Phase 1 — client view of the B#007 contract
├── checklists/
│   └── requirements.md   # spec quality checklist (from /speckit.specify)
└── tasks.md             # Phase 2 — /speckit.tasks (NOT created here)
```

### Source Code (repository root)
```text
lib/
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart         # + reels/reel/reelLike/reelSave/reelComments
│   │   └── app_routes.dart            # + reelCompose (nav-less); reelDetailPath (optional/deferred)
│   ├── data/
│   │   ├── reels/                     # NEW core slice (mirrors data/feed/)
│   │   │   ├── reel.dart              # Reel freezed model (+ .g/.freezed) — reuses UserSummary/Media/Place/EngagementState
│   │   │   ├── reels_repository.dart          # interface (Result<T>)
│   │   │   ├── reels_repository_impl.dart      # @LazySingleton(env:['real'])
│   │   │   ├── fake_reels_repository.dart       # @LazySingleton(env:['fake'])
│   │   │   └── reels_remote_data_source.dart
│   │   └── cache/
│   │       ├── app_database.dart      # schemaVersion 4→5; register ReelsDao; clearUserScoped += reels
│   │       ├── tables/reels_table.dart # NEW
│   │       └── daos/reels_dao.dart     # NEW (watchReelsFeed/watchReel/upsert/applyEngagement/adjustCommentCount)
│   └── services/
│       └── photo_library_service.dart # EXTEND: video pick (RequestType.video) + duration + poster accessors
├── features/
│   ├── reels/
│   │   ├── domain/
│   │   │   ├── reel_draft.dart
│   │   │   └── usecases/               # watch_reels, toggle_reel_like/save, publish_reel, delete_reel
│   │   └── presentation/
│   │       ├── reels_page.dart        # REPLACE #001 placeholder — vertical PageView feed
│   │       ├── cubit/                  # reels_cubit + state; reel_compose_cubit + state (4-state)
│   │       ├── playback/reel_playback_controller.dart  # window-bounded VideoPlayerController manager
│   │       └── widgets/                # ReelView, ReelActionRail, ReelAuthorHeader, ReelCaption,
│   │                                   #   ProcessingBadge, reel_compose_page, video_pick widgets
│   └── post/ (reused)                  # comment widgets + CommentsCubit opened in a bottom sheet keyed by reel id
└── l10n/arb/                           # + reels strings (EN + VI)
```

**Structure Decision**: Feature-first Clean Architecture (Constitution XI). Reels get a `core/data/reels/` slice (canonical model + repo + fake, mirroring `core/data/feed/`) and a `features/reels/` module (cubits, page, playback controller, widgets). The comment surface is **reused** from `features/post/` via a small core-level `CommentTarget` seam (post vs reel) so no feature→feature import is introduced. New drift table lives in `core/data/cache/`.

## Complexity Tracking

*No Constitution violations — table intentionally empty.*

## Phase 0 → 1 outputs

- **research.md** — 10 decisions, all NEEDS CLARIFICATION resolved (video package, lifecycle/active-detection, audio, upload reuse, cache, comments seam, processing reel, routing).
- **data-model.md** — `Reel` + `ReelDraft` models, `Reels` drift table (v5), state transitions, traceability.
- **contracts/reels-api.md** — client view of B#007 endpoints + DTO→model mapping + fake seam + new `ApiEndpoints`.
- **quickstart.md** — run steps + US1–US4 manual validation + automated coverage map + pre-commit gate.
- **Agent context**: no `update-agent-context` script in this repo; `CLAUDE.md` (already comprehensive) is the agent context — updated at spec close via `.claude/claude-app/` docs, not auto-generated.

## Open items carried to `/speckit.tasks` (non-blocking)
- Audio silent-switch: prefer a minimal platform channel to set the iOS `ambient` audio session; only add `audio_session` if the channel proves fragile (research R3). On-device verify → #015.
- Real chunked/resumable video upload streams from a file path (fake buffers bytes) — real-impl detail for backend cutover.
- Sample video assets for the fake feed / goldens (bundle small clips or poster-only for CI).
