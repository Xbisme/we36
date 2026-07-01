# Implementation Plan: Home Feed & Stories

**Branch**: `004-home-feed-stories` | **Date**: 2026-07-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/004-home-feed-stories/spec.md`

## Summary

Build the first content surface behind the auth gate: the **Home feed** (Screen 7) and the
**Story viewer** (Screen 8). A drift-backed, reverse-chronological following feed pages via the
#002 cursor model and renders through the existing `PostCard`; **like** and **save** are
optimistic + idempotent + rollback over **one canonical cached `Post`** (drift, reactive
`.watch()`). A **StoriesRail** above the feed opens a full-screen segmented **Story viewer**
(auto-advance, tap-forward/back, hold-to-pause, like), with **seen state persisted locally**.
The app keeps running DI `environment: 'fake'`: `FeedRepository` follows the **real B#004
posts-feed contract** (`GET /feed`, `POST/DELETE /posts/{id}/like|save`) with a real impl seam
(`env:['real']`) + an in-memory fake (`env:['fake']`, the one that actually runs); **Stories have
no backend contract yet**, so they ship a fake plus a documented real seam awaiting a future
backend stories spec. No new packages. Two screens; carousels, comments, real DM/share, and
collections are explicitly deferred.

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (current toolchain, bumped in #003).

**Primary Dependencies** (all existing — **no new packages**): `flutter_bloc`, `get_it`+
`injectable`, `freezed`+`json_serializable`+`build_runner`, `drift`+`drift_flutter` (cache),
`dio` (real seam only; fake runs), `cached_network_image` (bounded feed thumbnails),
`lucide_icons_flutter` (via `AppIcon`), `intl`/`gen-l10n`. Reuses #001 `PostCard`/`StoriesRail`/
`Avatar`(ring)/`TopBar`/`Toast`/`AdaptiveShell` and #002 `CursorPage`/`PageRequest`/`ApiClient`/
`AppDatabase`/repository+fake pattern.

**Storage**: drift (`AppDatabase`) — **schema v2 → v3**: new `Posts` table (canonical cached
post) + `StorySeenSegments` table (persisted seen-state). Non-destructive `onUpgrade` (create
both tables when `from < 3`); `clearUserScoped()` extended to wipe both. Migration test covers
v2→v3 (Constitution IX). Story reels/segments are synthesized by the fake in memory (deterministic,
not cached) — only seen-state persists.

**Testing**: `flutter test` + `bloc_test` + `mocktail` + goldens. Fake repositories drive all
flows (zero network, Constitution XII). Goldens for the feed `PostCard` states and the Story
viewer chrome (light + dark). Migration test for v2→v3.

**Target Platform**: iOS + Android phones + iPad/Android tablets. Feed adapts by width
(`<700` bottom-nav single column · `≥700` centered ~560 column + sidebar rail · `≥1100` + right
rail: footer links + static `SearchBar`). Story viewer is full-screen edge-to-edge on all widths.

**Project Type**: Mobile app (Flutter), Clean Architecture feature-first — new `lib/features/feed/`
+ `lib/features/stories/`, canonical post cache + repositories in `lib/core/data/`.

**Performance Goals**: cached feed visible < 2 s cold (SC-001); like/save reflects < 100 ms
(SC-003, optimistic); smooth 200+ post scroll with bounded memory (SC-002) via `cacheWidth`
on thumbnails (the #001 carried follow-up).

**Constraints**: offline-buildable (zero network in tests); `lib/core/` MUST NOT import
`lib/features/`; no secrets/PII in logs; cursor pagination only; one canonical cached `Post`;
optimistic actions roll back exactly; malformed item tolerance; Reduce-Motion static transitions.

**Scale/Scope**: 2 screens, 5 user stories (US1 feed · US2 like · US3 save · US4 rail · US5
viewer), ~35 FR. New: 2 feature modules, 1 feed repository (+DTO/models/fake/real), 1 stories
repository (+fake/real seam), 2 drift tables + 1 schema bump, 3–4 cubits, feed/story pages,
new ARB keys.

## Constitution Check

*GATE: evaluated against constitution v1.0.2. Re-checked after Phase 1 design.*

| Principle | Status | Notes |
|---|---|---|
| I. Privacy, Safety & Trust | ✅ | Feed/stories honor server visibility/removal states; withheld content never rendered from stale cache (FR-035); no PII/media in logs (FR-034). Block/report reachability is a #014 concern (no comment/DM surfaces here). |
| II. Media-Centric Performance | ✅ | Cursor pagination (#002 `CursorPage`), `cached_network_image` with bounded `cacheWidth` on feed + story media, lazy list. No inline video (stories = image segments this spec); reels = #008. |
| III. BLoC 4-state | ✅ | `FeedCubit`/`StoriesRailCubit`/`StoryViewerCubit` extend the #001 `AppCubit`; extended `loadedPaginating`/`loadedRefreshing` variants for the feed; page-scoped `@injectable`; side effects via `BlocListener`. |
| IV. Code Quality & Dart Safety | ✅ | freezed models + generated JSON for `Post`/`PostMedia`/`Media`/`EngagementState`; explicit types; `very_good_analysis` zero-warning. |
| V. Result\<T\> Error Handling | ✅ | Repos return `Result<T>`; existing `AppFailure` variants suffice (`offline`/`networkError`/`serverError`/`timeout`/`notFound`/`forbidden`); no new variants. Cubits `.fold()`, no try/catch. |
| VI. Design System & Theming | ✅ | Reuse `PostCard`/`StoriesRail`/`Avatar`(ring)/`TopBar`/`Toast`/`AppIcon`; semantic tokens only; gradient limited to unseen story ring + like affordance; no full-page wash; Reduce-Motion static (FR-033). |
| VIII. API & Realtime Architecture | ✅ | `FeedRepository` consumes `ApiClient` (real seam); endpoints centralized in `ApiEndpoints` (`/feed`, `/posts/{id}/like|save`); cursor envelope reused. No realtime in this spec. |
| IX. Data Integrity & Caching | ✅ | One canonical `Post` in drift, reactive `.watch()` reads; optimistic like/save + rollback; idempotent mutations (client key via `ApiClient` + server-idempotent contract); malformed-item skip (FR-006); non-destructive v2→v3 migration + test. |
| X. go_router Navigation | ✅ | Home tab already wired (`AppRoutes.home`); Story viewer pushed as a nav-less full-screen route (new `AppRoutes.storyViewer`); no ad-hoc `Navigator`. Activity/Messages header icons are inert placeholders (no dead routes). |
| XI. Feature-First Modularity | ✅ | New `features/feed/` + `features/stories/` (data/domain/presentation); canonical cache + repos in `core/data/`; `core/` never imports features; repos don't import repos. |
| XII. Testing Discipline | ✅ | Fakes for feed + stories; bloc_test for all cubits (load/paginate/refresh/error/optimistic toggle+rollback); widget tests for feed render+paginate + like/save; goldens PostCard + viewer; migration test. |
| XIII. Simplicity & YAGNI | ✅ | Reverse-chronological only (no ranking); single-image posts (no carousel); simple save flag (no collections); story image segments only. Deferred scope enumerated in spec. |
| XIV. Internationalization | ✅ | New ARB keys (EN+VI) for feed/story strings; counts via `CountFormatter`, relative time via `RelativeTimeFormatter`; `yourStory` key already exists. |
| XV. Dependency Hygiene | ✅ | No new packages; nothing to source/verify. |

**Result**: PASS (no violations; Complexity Tracking empty).

## Project Structure

### Documentation (this feature)

```text
specs/004-home-feed-stories/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (client-facing contracts)
│   ├── README.md
│   ├── feed-repository.md
│   ├── stories-repository.md
│   └── optimistic-engagement.md
└── tasks.md             # Phase 2 (/speckit.tasks — NOT created here)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart        # +postLike/postUnlike/postSave/postUnsave (feed exists); +provisional stories
│   ├── data/
│   │   ├── feed/                     # canonical Post domain + feed repo (core, cross-feature reusable)
│   │   │   ├── post.dart             # freezed Post/PostMedia/Media/UserSummary/EngagementState (+JSON)
│   │   │   ├── feed_repository.dart   # interface (Result<T>, watch stream, paginate, like/save)
│   │   │   ├── feed_repository_impl.dart      # @LazySingleton(as:, env:['real']) — ApiClient + drift upsert
│   │   │   ├── fake_feed_repository.dart       # @LazySingleton(as:, env:['fake']) — synthesizes N posts
│   │   │   └── feed_remote_data_source.dart    # HTTP marshaling (real seam)
│   │   ├── stories/                  # story domain + repo (fake runs; real seam awaits backend)
│   │   │   ├── story.dart            # freezed StoryReel/StorySegment
│   │   │   ├── stories_repository.dart
│   │   │   ├── stories_repository_impl.dart    # env:['real'] seam (provisional; returns offline/empty)
│   │   │   └── fake_stories_repository.dart     # env:['fake'] — deterministic reels + persisted seen
│   │   └── cache/
│   │       ├── tables/posts_table.dart          # Posts (canonical cached post)
│   │       ├── tables/story_seen_table.dart      # StorySeenSegments (persisted seen)
│   │       ├── daos/posts_dao.dart               # upsert/watchHomeFeed/getById/applyEngagement
│   │       ├── daos/story_seen_dao.dart          # markSeen/watchSeen
│   │       └── app_database.dart                 # register tables; schemaVersion 2→3; onUpgrade; clearUserScoped++
│   └── router/app_router.dart        # +storyViewer full-screen route
└── features/
    ├── feed/
    │   ├── domain/usecases/          # LoadFeed, RefreshFeed, LoadMoreFeed, ToggleLike, ToggleSave
    │   └── presentation/
    │       ├── home_page.dart        # replaces #001 placeholder: TopBar + StoriesRail + feed list + adaptive
    │       ├── feed_cubit.dart       # drift-backed reactive list + cursor pagination (4-state + extended)
    │       ├── feed_state.dart
    │       └── widgets/              # feed skeleton, empty/error, right-rail (≥1100)
    └── stories/
        ├── domain/usecases/          # LoadStoryReels, MarkSegmentSeen, LikeStorySegment
        └── presentation/
            ├── stories_rail_cubit.dart      # rail items + seen ring state (from fake + drift watch)
            ├── story_viewer_page.dart       # full-screen segmented viewer (nav-less route)
            ├── story_viewer_cubit.dart      # playback: reel/segment index, progress, paused, like
            └── story_viewer_state.dart

test/
├── core/data/feed/                   # Post JSON round-trip, fake feed, engagement reconcile
├── core/data/cache/                  # posts_dao, story_seen_dao, v2→v3 migration
├── features/feed/                    # feed_cubit bloc_test (load/paginate/refresh/error/like+save rollback), home_page widget
├── features/stories/                 # stories_rail_cubit, story_viewer_cubit (advance/seek/pause/like/seen)
└── golden/                           # PostCard feed states + story viewer chrome (light+dark)
```

**Structure Decision**: The canonical `Post` model, `FeedRepository`, `StoriesRepository`, and the
new drift tables live in **`lib/core/data/`** (reused by later features — post detail #006,
profile grids #010, save/collections #011), keeping `core/` feature-free. UI, cubits, and use
cases live in the two new **`lib/features/feed/`** and **`lib/features/stories/`** modules,
mirroring the `features/auth/` layout (data/domain/presentation; use cases in `domain/usecases/`,
screen cubits `@injectable` in `presentation/`). The Home tab branch (`HomePage`) is swapped from
the #001 placeholder to the real feed page in the existing `StatefulShellRoute`.

## Complexity Tracking

> No constitution violations — table intentionally empty.

## Phase Outputs

- **Phase 0** → [research.md](research.md): resolved decisions (feed cache = single canonical
  `Post` table ordered by `createdAt` desc; feed cubit = drift-reactive + cursor controller, not
  the in-memory `PaginatedListCubit`; single-image render of the contract media array; stories
  fake-only with persisted seen-state; no new packages; provisional stories real seam).
- **Phase 1** → [data-model.md](data-model.md), [contracts/](contracts/), [quickstart.md](quickstart.md):
  `Post`/`PostMedia`/`Media`/`UserSummary`/`EngagementState` + `StoryReel`/`StorySegment` models,
  `Posts`+`StorySeenSegments` drift tables (v3), `FeedRepository`/`StoriesRepository` contracts,
  optimistic-engagement reconcile/rollback rules, and the runnable validation guide.

*Command ends after planning. `/speckit.tasks` generates `tasks.md`.*
