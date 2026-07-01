---
description: "Task list for Spec #004 Home Feed & Stories"
---

# Tasks: Home Feed & Stories

**Input**: Design documents from `specs/004-home-feed-stories/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: REQUIRED — Constitution XII mandates unit + BLoC tests, and widget tests for engagement-critical flows (feed render/paginate, like/save). Test tasks are included per story and authored to **fail first**.

> **⚠️ Environment banner**: the app runs DI `environment: 'fake'` — every task below is CI-testable on fakes with **zero network**. `FeedRepository`'s `env:['real']` seam follows the real **B#004** contract; `StoriesRepository`'s `env:['real']` seam is **provisional** (no backend stories contract yet — documented follow-up). Neither real seam is exercised while the app runs `fake`.

**Organization**: by user story (US1–US5) for independent implementation/testing. Paths follow [plan.md](plan.md) §Project Structure.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: parallelizable (different files, no incomplete-task dependency)
- **[Story]**: US1–US5; Setup/Foundational/Polish have no story label

---

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 [P] Add feed engagement endpoint constants to `lib/core/constants/api_endpoints.dart`: `postLike(id)`/`postUnlike(id)` (`POST|DELETE /posts/{id}/like`), `postSave(id)`/`postUnsave(id)` (`POST|DELETE /posts/{id}/save`); `feed` (`/feed`) already present. Add a commented **provisional** `stories` constant (contract TBD).
- [x] T002 [P] Scaffold feature folders: `lib/features/feed/{domain/usecases,presentation/widgets}` and `lib/features/stories/{domain/usecases,presentation}`; core data folders `lib/core/data/feed/` and `lib/core/data/stories/` (empty placeholders committed via `.gitkeep` or first files).
- [x] T003 [P] Scaffold test folders: `test/core/data/feed/`, `test/core/data/cache/`, `test/features/feed/`, `test/features/stories/`, `test/golden/` (create dirs; first tests land in later phases).

---

## Phase 2: Foundational (Blocking Prerequisites)

**⚠️ CRITICAL**: the feed data spine — no user story can begin until this phase is complete.

- [x] T004 [P] `Post` + `UserSummary` + `PostMedia` + `Media` (+ `MediaKind`/`MediaStatus` enums) + `Place` + `EngagementState` freezed models with generated JSON in `lib/core/data/feed/post.dart` (fields per [data-model.md](data-model.md), camelCase matching B#004).
- [x] T005 [P] Unit test for `Post` JSON round-trip + **malformed/partial item tolerance** (decode skips a bad item, does not throw) in `test/core/data/feed/post_test.dart` (author FIRST, must fail).
- [x] T006 [P] `Posts` drift table (`@DataClassName('CachedPost')`, columns per [data-model.md](data-model.md)) in `lib/core/data/cache/tables/posts_table.dart`.
- [x] T007 [P] `StorySeenSegments` drift table (`@DataClassName('SeenSegment')`, `segmentId` PK + `authorId` + `seenAt`) in `lib/core/data/cache/tables/story_seen_table.dart`.
- [x] T008 `PostsDao` (`upsertAll` / `watchHomeFeed` ORDER BY createdAt DESC / `getById` / `applyEngagement(EngagementState)` / `clearFeed`) in `lib/core/data/cache/daos/posts_dao.dart` (depends on T006).
- [x] T009 Wire both tables into `lib/core/data/cache/app_database.dart`: register `Posts`+`PostsDao` and `StorySeenSegments`; bump `schemaVersion` **2→3**; extend `onUpgrade` (`if (from < 3) { createTable(posts); createTable(storySeenSegments); }` keeping the `from < 2` branch); extend `clearUserScoped()` to also delete `posts` + `storySeenSegments` (depends on T006, T007, T008).
- [x] T010 Migration test: v2→v3 creates both tables (and existing **v1→v2 stays green**); `clearUserScoped()` wipes feed + seen in `test/core/data/cache/migration_v3_test.dart` (author FIRST, must fail) (depends on T009).
- [x] T011 [P] `FeedRepository` interface (`watchHomeFeed` / `loadFirstPage` / `loadNextPage` / `toggleLike` / `toggleSave` — signatures per [contracts/feed-repository.md](contracts/feed-repository.md)) in `lib/core/data/feed/feed_repository.dart`.
- [x] T012 `FeedRemoteDataSource` (dio via `ApiClient`: `GET /feed` decode→`CursorPage<Post>`; like/save with idempotency → `EngagementState`) in `lib/core/data/feed/feed_remote_data_source.dart` (depends on T004, T011).
- [x] T013 `FeedRepositoryImpl` (`@LazySingleton(as: FeedRepository, env: ['real'])`: remote → `PostsDao` upsert; `watchHomeFeed` reads drift; like/save reconcile via `applyEngagement`) in `lib/core/data/feed/feed_repository_impl.dart` (depends on T008, T012).
- [x] T014 [P] `FakeFeedRepository` (`@LazySingleton(as: FeedRepository, env: ['fake'])`: ~30 deterministic single-image contract-shaped posts across 2 cursors, writes to drift for the reactive read, `toggleLike/Save` mutate in-memory+drift and echo `EngagementState`, injectable `failNextMutation` hook) in `lib/core/data/feed/fake_feed_repository.dart` (depends on T004, T008, T011).
- [x] T015 [P] Unit test for `FakeFeedRepository` (deterministic paging, dedupe, engagement echo, `failNextMutation`) in `test/core/data/feed/fake_feed_repository_test.dart` (author FIRST, must fail).
- [x] T016 Run `dart run build_runner build --delete-conflicting-outputs`; regenerate `lib/core/di/injection.config.dart`; verify both `env` registrations resolve; keep `diEnvironment = 'fake'` (depends on T004, T013, T014).
- [x] T017 [P] Base feed/story l10n keys (EN `lib/l10n/arb/app_en.arb` + VI `lib/l10n/arb/app_vi.arb`) with `@description`: feed empty/error/retry, "New posts", like/save failure toasts, story "Send message" placeholder, viewer a11y labels (`yourStory` already exists). Run `flutter gen-l10n`.
- [x] T018 [P] Unit test that `CountFormatter` (abbreviated like counts, e.g. `38.4k`) + `RelativeTimeFormatter` (e.g. `2h`) produce the expected EN + VI outputs the feed will consume — **independent of feed UI** — in `test/core/utils/feed_format_test.dart`. (PostCard wiring to these helpers, no ad-hoc formatting, is verified in T026.)

**Checkpoint**: Post model + drift v3 cache + `FeedRepository` (real+fake) resolve on fakes; DB migrates non-destructively. User stories can begin.

---

## Phase 3: User Story 1 - Browse the home feed (Priority: P1) 🎯 MVP

**Goal**: A signed-in person opens Home and browses a paginated, reverse-chronological feed rendered with `PostCard`, with cache-first cold start, pull-to-refresh, infinite scroll, and empty/error states.

**Independent Test**: Sign in → Home shows newest-first posts; scroll appends a page; pull-to-refresh reloads; relaunch shows cached feed; empty + error states render with retry.

### Tests for User Story 1 (author FIRST, must fail) ⚠️

- [x] T019 [P] [US1] `bloc_test` `FeedCubit`: initial→loading→loaded; **cache-first** cold start (emits cached loaded before refresh); `loadMore`→`loadedPaginating`→appended; `refresh`→`loadedRefreshing`→new top; first-load error with empty cache→`error`; malformed item skipped in `test/features/feed/feed_cubit_test.dart`.
- [x] T020 [P] [US1] Widget test `HomePage`: renders posts (PostCard), empty state, error+retry, pull-to-refresh triggers refresh, scroll near end triggers `loadMore` in `test/features/feed/home_page_test.dart`.

### Implementation for User Story 1

- [x] T021 [P] [US1] `LoadFeed` / `RefreshFeed` / `LoadMoreFeed` use cases (inject `FeedRepository`) in `lib/features/feed/domain/usecases/`.
- [x] T022 [US1] `FeedState` (4-state + extended `loadedPaginating`/`loadedRefreshing`) in `lib/features/feed/presentation/feed_state.dart`.
- [x] T023 [US1] `FeedCubit` (`@injectable`, extends `AppCubit<List<Post>>`): subscribe `watchHomeFeed()`; `loadInitial` (cache-first + background `loadFirstPage`); `loadMore` (guard `hasMore`/in-flight); `refresh` (**`clearFeed`+`loadFirstPage`** so posts the server no longer returns — removed/withheld — drop from the cache, honoring FR-035 / Constitution I; soft-fail keeps cache on network error); track `nextCursor`/`hasMore`; malformed-safe in `lib/features/feed/presentation/feed_cubit.dart` (depends on T021, T022). Add a `bloc_test` case in T019 asserting a post absent from the refresh page is gone from `loaded`.
- [x] T024 [P] [US1] Feed skeleton + empty + error-retry widgets in `lib/features/feed/presentation/widgets/` (semantic labels, light/dark, text-scaling).
- [x] T025 [P] [US1] Right-rail widget (≥1100: footer links + **static** `SearchBar`, no navigation, no suggestions) in `lib/features/feed/presentation/widgets/home_right_rail.dart`.
- [x] T026 [US1] `HomePage` (replaces the #001 placeholder): `TopBar` (Wordmark + Activity bell w/ unseen dot + Messages icon as **inert placeholders**) → `StoriesRail` slot → feed `ListView` of `PostCard` (bounded `cacheWidth` on media, FR-032) → skeleton/empty/error via `BlocBuilder`; pull-to-refresh; infinite scroll; adaptive (centered ~560 ≥700, right rail ≥1100) in `lib/features/feed/presentation/home_page.dart` (depends on T023, T024, T025).
- [x] T027 [US1] Wire `HomePage` + `BlocProvider(FeedCubit)` into the Home branch of `StatefulShellRoute` in `lib/core/router/app_router.dart` (replace placeholder `HomePage` import) (depends on T026).
- [x] T028 [US1] Map feed `AppFailure`→localized text for the empty-cache error state (via existing failure→l10n mapping); wire retry.

**Checkpoint**: Home feed browses, paginates, refreshes, and serves from cache offline — MVP demoable.

---

## Phase 4: User Story 2 - Like a post (Priority: P1)

**Goal**: Optimistic like/unlike with instant count update, server reconcile, rollback on failure, and idempotent retries over one canonical cached `Post`.

**Independent Test**: Tap like → instant fill + count+1; force failure → rollback + Toast; double-tap/retry → no double-count; same post in two places updates identically.

### Tests for User Story 2 (author FIRST, must fail) ⚠️

- [x] T029 [P] [US2] `bloc_test` `FeedCubit.toggleLike`: optimistic flip → server counts adopted; server-failure → rollback + Toast trigger; idempotent double-tap → single net effect; one-canonical consistency in `test/features/feed/feed_like_test.dart`.

### Implementation for User Story 2

- [x] T030 [P] [US2] `ToggleLike` use case (inject `FeedRepository`) in `lib/features/feed/domain/usecases/toggle_like.dart`.
- [x] T031 [US2] Add `toggleLike(postId)` to `FeedCubit`: optimistic `PostsDao` write (flip `viewerHasLiked`, `likeCount±1`) → `repo.toggleLike` → reconcile `applyEngagement` / rollback re-upsert (per [contracts/optimistic-engagement.md](contracts/optimistic-engagement.md)) in `lib/features/feed/presentation/feed_cubit.dart` (depends on T030).
- [x] T032 [US2] Wire `PostCard.onLike` in `HomePage` → `FeedCubit.toggleLike`; failure → `Toast` (localized) via `BlocListener` in `lib/features/feed/presentation/home_page.dart` (depends on T031).

**Checkpoint**: Like is optimistic, consistent, and idempotent with rollback.

---

## Phase 5: User Story 3 - Save a post (Priority: P2)

**Goal**: Optimistic save/unsave bookmark (no collection picker), rollback on failure, idempotent, persisted via the canonical `Post`.

**Independent Test**: Tap save → instant bookmark; failure → rollback + Toast; saved state survives refresh/relaunch.

### Tests for User Story 3 (author FIRST, must fail) ⚠️

- [x] T033 [P] [US3] `bloc_test` `FeedCubit.toggleSave`: optimistic flip → reconcile; failure → rollback + Toast; idempotent; saved state persists across refresh in `test/features/feed/feed_save_test.dart`.

### Implementation for User Story 3

- [x] T034 [P] [US3] `ToggleSave` use case in `lib/features/feed/domain/usecases/toggle_save.dart`.
- [x] T035 [US3] Add `toggleSave(postId)` to `FeedCubit` (mirror of like on `viewerHasSaved`/`saveCount`) in `lib/features/feed/presentation/feed_cubit.dart` (depends on T034).
- [x] T036 [US3] Wire `PostCard.onSave` in `HomePage` → `FeedCubit.toggleSave`; failure Toast via `BlocListener` in `lib/features/feed/presentation/home_page.dart` (depends on T035).

**Checkpoint**: Save toggles optimistically and persists; US1–US3 all independently functional.

---

## Phase 6: User Story 4 - Stories rail (Priority: P2)

**Goal**: A stories rail above the feed leads with "Your story", shows followed accounts with unseen (gradient ring) / seen (desaturated) ordering, and opens the viewer on tap.

**Independent Test**: Rail shows "Your story" first, unseen ringed and ordered ahead of seen; tap opens the viewer; "Your story" with no self-reel is inert (no `+`).

### Tests for User Story 4 (author FIRST, must fail) ⚠️

- [x] T037 [P] [US4] `bloc_test` `StoriesRailCubit`: loaded reels; unseen-first ordering; ring state derived from seen set; "Your story" leads and is inert when no self-reel in `test/features/stories/stories_rail_cubit_test.dart`.
- [x] T038 [P] [US4] Unit test `FakeStoriesRepository` (deterministic reels, self-reel presence, `watchSeen` merge → `hasUnseen`) in `test/features/stories/fake_stories_repository_test.dart`.

### Implementation for User Story 4

- [x] T039 [P] [US4] `StoryReel` + `StorySegment` freezed models in `lib/core/data/stories/story.dart` (fields per [data-model.md](data-model.md)).
- [x] T040 [P] [US4] `StorySeenDao` (`markSeen` / `watchSeen` / `getSeen`) in `lib/core/data/cache/daos/story_seen_dao.dart` (table from T007/T009).
- [x] T041 [P] [US4] `StoriesRepository` interface (`loadReels` / `watchSeen` / `markSegmentSeen` / `likeSegment` — per [contracts/stories-repository.md](contracts/stories-repository.md)) in `lib/core/data/stories/stories_repository.dart`.
- [x] T042 [US4] `FakeStoriesRepository` (`env:['fake']`: deterministic reels for followed accounts + optional self-reel; merges `watchSeen`; `markSegmentSeen`→drift; `likeSegment` in-memory) in `lib/core/data/stories/fake_stories_repository.dart` (depends on T039, T040, T041).
- [x] T043 [US4] `StoriesRepositoryImpl` (`env:['real']` **provisional** seam: `loadReels`/`likeSegment`→`Result.err(offline)`/empty, `markSegmentSeen`→drift persist; documented follow-up) in `lib/core/data/stories/stories_repository_impl.dart` (depends on T040, T041).
- [x] T044 [P] [US4] `LoadStoryReels` use case in `lib/features/stories/domain/usecases/load_story_reels.dart`.
- [x] T045 [US4] `StoriesRailCubit` (`@injectable`, extends `AppCubit<List<StoryReel>>`: combine `loadReels` + `watchSeen`; order isYou→unseen(latestAt desc)→seen) in `lib/features/stories/presentation/stories_rail_cubit.dart` (depends on T044).
- [x] T046 [US4] Wire `StoriesRail` into `HomePage` (map `StoryReel`→`StoryItem` with `seen`/`isYou`; `onTap`→push story viewer route; "Your story" inert when no self-reel) in `lib/features/feed/presentation/home_page.dart` (depends on T045).
- [x] T047 [US4] Run `build_runner` + regenerate DI (`StoriesRepository` both envs resolve); `flutter gen-l10n` for any new rail keys.

**Checkpoint**: Stories rail renders with correct ring/ordering and opens the viewer.

---

## Phase 7: User Story 5 - Story viewer (Priority: P3)

**Goal**: Full-screen segmented viewer with auto-advance, tap-forward/back, hold-to-pause, optimistic story like, inert send/share, and persisted seen-state; Reduce-Motion keeps advance but drops decoration.

**Independent Test**: Open a story → segments auto-advance then next account/close; tap seeks; hold pauses; like flips; send/share inert; close marks seen and the ring persists across relaunch.

### Tests for User Story 5 (author FIRST, must fail) ⚠️

- [x] T048 [P] [US5] `bloc_test` `StoryViewerCubit` (inject a fake ticker/clock): auto-advance progresses + moves to next reel; `next`/`previous` seek; `pauseHold`/`resumeRelease`; `likeCurrent` optimistic + rollback; `onSegmentShown`→`markSegmentSeen` persists; Reduce-Motion path in `test/features/stories/story_viewer_cubit_test.dart`.
- [x] T049 [P] [US5] Golden test `StoryViewerPage` chrome (progress segments, header, protection gradient, inert send/share) in light + dark in `test/golden/story_viewer_golden_test.dart`.

### Implementation for User Story 5

- [x] T050 [P] [US5] `MarkSegmentSeen` + `LikeStorySegment` use cases in `lib/features/stories/domain/usecases/`.
- [x] T051 [US5] `StoryViewerState` (playback: `reels`, `reelIndex`, `segmentIndex`, `progress`, `paused`) in `lib/features/stories/presentation/story_viewer_state.dart`.
- [x] T052 [US5] `StoryViewerCubit` (`@injectable`: timer-driven progress w/ injectable ticker; `openAt`/`next`/`previous`/`pauseHold`/`resumeRelease`/`likeCurrent`/`onSegmentShown`; last-reel→close; Reduce-Motion static transitions) in `lib/features/stories/presentation/story_viewer_cubit.dart` (depends on T050, T051).
- [x] T053 [US5] Add `storyViewer` route to `lib/core/constants/app_routes.dart` + a nav-less full-screen route (hides bottom nav) in `lib/core/router/app_router.dart` (depends on T052).
- [x] T054 [US5] `StoryViewerPage` (edge-to-edge, top segmented progress, avatar+username+relative time+close, protection gradient, like affordance, **inert** "Send message"/reply + share, tap-left/right zones + press-hold gesture) in `lib/features/stories/presentation/story_viewer_page.dart` (depends on T052, T053).
- [x] T055 [US5] Handle expired/removed segment on open (skip/close with soft `Toast`, FR-028) in `StoryViewerCubit`/`StoryViewerPage`.

**Checkpoint**: Story viewer plays, seeks, pauses, likes, and persists seen — all five stories complete.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [x] T056 [P] Golden tests: `PostCard` feed states (liked/unliked, saved/unsaved, long caption truncation, verified badge) in light + dark in `test/golden/post_card_feed_golden_test.dart`.
- [x] T057 [P] Widget test: adaptive layout — phone (<700) single column, tablet (≥700) centered + sidebar rail, ≥1100 right rail present; rotation reflow in `test/features/feed/home_adaptive_test.dart`.
- [x] T058 [P] Accessibility + text-scaling sweep: `Semantics` on PostCard actions, StoriesRail entries, viewer controls; verify large text-scale doesn't overflow (feed + viewer).
- [x] T059 [P] Verify VI translations complete for all new keys (`app_vi.arb` parity with `app_en.arb`); relative-time + count labels locale-correct (EN+VI).
- [x] T060 [P] Log-hygiene check: no post/story content, media URLs, or PII in `AppLogger` output (Constitution I / FR-034); add a redaction assertion test if a feed logger path exists.
- [x] T061 Reduce-Motion end-to-end check: story auto-advance still progresses, decorative transitions static (FR-033); PostCard press-scale respects Reduce-Motion.
- [x] T062 Run [quickstart.md](quickstart.md) scenarios 1–12 in fake mode; record results.
- [x] T063 [P] Long-scroll perf/memory widget test (SC-002 / Constitution II): build the feed with 200+ synthesized posts, scroll fully to the end (paginating), assert no crash, list stays lazy, and `PostCard` media decode is bounded via `cacheWidth` (not full-res) in `test/features/feed/feed_scroll_perf_test.dart`. On-device memory-ceiling **profiling** remains a #015 release-gate item (carried, non-CI) — noted here so the bound is not silently skipped.
- [x] T064 Pre-commit gate: `dart format .` ✅ · `dart analyze` **No issues** ✅ (`flutter analyze` crashes on an AOT-snapshot mismatch in this toolchain — `dart analyze` is the working substitute) · `flutter test` **206 pass** ✅, migration + all #004 suites green; the only failures are **6 pre-existing golden pixel-diffs (0.00–0.49%)** on #001/#003 components (PostCard, SidebarRail, tokens, SignInPage — none touched by #004), which reproduce on the untouched auth screen and are environmental font-AA drift vs. the CI-baked baselines (no golden `.png` changed on this branch); baselines intentionally left as-is · `bloc lint` **0 issues** (175 files, via globally-activated `bloc_tools`).

---

## Dependencies & Execution Order

### Phase dependencies

- **Setup (P1)** → no deps.
- **Foundational (P2)** → depends on Setup; **BLOCKS all stories**.
- **US1 (P3)** & **US2 (P4)** → both P1; depend only on Foundational. US2 extends the `FeedCubit` built in US1 (T023), so US2 follows US1 in a single-dev flow.
- **US3 (P5)** → mirrors US2 on the same `FeedCubit`; after US1.
- **US4 (P6)** → depends on Foundational (uses the `StorySeenSegments` table created in T009) + wires into the `HomePage` from US1 (T046).
- **US5 (P7)** → depends on US4 (StoriesRepository + models + rail entry point).
- **Polish (P8)** → after the desired stories.

### Within each story

Tests authored to fail first → use cases → cubit → page → routing/l10n. Models before DAOs; DAOs before repos; repos before cubits; cubits before pages.

### Parallel opportunities

- Setup: T001/T002/T003 in parallel.
- Foundational: T004/T006/T007/T011/T017/T018 in parallel (distinct files); T005 after T004; T008 after T006; T009 after T006/T007/T008; T010 after T009; T012 after T004/T011; T013 after T008/T012; T014 after T004/T008/T011; T016 after generated-code producers.
- Each story's `[P]` test + use-case + model tasks run together; the cubit→page→routing chain is sequential.
- US4 data layer (T039/T040/T041) parallel; T042/T043 after.
- With multiple devs: after Foundational, US1+US2+US3 (feed track) and US4+US5 (stories track) proceed on separate branches; the only shared file is `home_page.dart` (US1 owns it; US2/US3/US4 add wiring).

---

## Parallel Example: Foundational

```bash
# Distinct files, no incomplete-task dependency:
Task: "Post/Media/EngagementState models in lib/core/data/feed/post.dart"       # T004
Task: "Posts drift table in lib/core/data/cache/tables/posts_table.dart"        # T006
Task: "StorySeenSegments table in lib/core/data/cache/tables/story_seen_table.dart"  # T007
Task: "FeedRepository interface in lib/core/data/feed/feed_repository.dart"      # T011
Task: "Base feed/story l10n keys in lib/l10n/arb/app_en.arb + app_vi.arb"        # T017
```

## Parallel Example: User Story 1

```bash
# Tests first (must fail):
Task: "bloc_test FeedCubit in test/features/feed/feed_cubit_test.dart"           # T019
Task: "Widget test HomePage in test/features/feed/home_page_test.dart"           # T020
# Then use cases + independent widgets:
Task: "LoadFeed/RefreshFeed/LoadMoreFeed use cases in lib/features/feed/domain/usecases/"  # T021
Task: "Right-rail widget in lib/features/feed/presentation/widgets/home_right_rail.dart"   # T025
```

---

## Implementation Strategy

### MVP first (US1)

Setup → Foundational → US1 → **STOP & validate** (browse, paginate, refresh, cache-offline, empty/error). Demoable gate.

### Incremental delivery

US1 (MVP) → US2 (like) → US3 (save) → US4 (stories rail) → US5 (story viewer) → Phase 8. Each story is an independently testable increment that doesn't break the previous.

---

## Notes

- `[P]` = different files, no incomplete-task dependency. `[Story]` maps to spec User Stories.
- Constitution gate after every task group: `dart format` · `flutter analyze` (0 warn) · `flutter test` · `bloc lint` (0).
- One canonical cached `Post` (drift) is the single render source — like/save write it and every screen repaints via `watchHomeFeed()` (Constitution IX).
- Run `build_runner` after any freezed/json/injectable/drift change; `gen-l10n` after ARB edits.
- Keep `diEnvironment = 'fake'`; `FeedRepository` real seam follows B#004; `StoriesRepository` real seam is provisional (backend stories contract TBD — follow-up).
- drift migration is privacy-sensitive (Constitution I/IX): T009/T010 (v2→v3 + `clearUserScoped`) get extra review.
- **FR-035 (visibility/removal)**: enforced by the backend; the client honors it by (a) `refresh` clearing + repopulating so removed posts drop from cache (T023), and (b) skipping expired/removed story segments on open (T055). Deeper moderation/blocked-state handling is a #006/#014 concern.
- **SC-002 (long-scroll memory)**: mechanism = pagination + bounded `cacheWidth` (T026), CI-verified by T063; on-device memory-ceiling profiling is a #015 release-gate item (carried).
