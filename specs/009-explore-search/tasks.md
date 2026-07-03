---
description: "Task list for #009 Explore & Search (We36 Flutter client)"
---

# Tasks: Explore & Search

**Input**: Design documents from `specs/009-explore-search/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/discovery-api.md](contracts/discovery-api.md)

**Tests**: Included (the repo's pre-commit gate requires `flutter test` green; every prior slice ships bloc/widget/golden/fake/migration/redaction coverage).

**Organization**: Grouped by user story (US1–US5 from spec.md) so each is independently implementable + testable. Foundational (Phase 2) builds the full `core/data/discovery/` data slice + cache that all stories consume.

## Format: `[ID] [P?] [Story] Description with file path`

- **[P]** = parallelizable (different files, no dependency on an incomplete task).
- Client-only feature — backend B#009 is already shipped; app runs `env:['fake']` for tests (zero-network).

---

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 Add discovery endpoint constants (explore, search, hashtagPage, placePage, searchRecents, searchRecent(id)) in `lib/core/constants/api_endpoints.dart` (no inline literals).
- [x] T002 [P] Add discovery routes (`search`, `hashtag(tag)` → `/hashtags/:tag`, `place(id)` → `/places/:id`) in `lib/core/constants/app_routes.dart`.
- [ ] T003 [P] Add discovery ARB strings (EN primary + VI) — search/explore/recents/hashtag/place/follow-stub/empty-error copy — in `lib/l10n/arb/app_en.arb` + `lib/l10n/arb/app_vi.arb`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The full `core/data/discovery/` slice + drift cache. **Blocks all user stories.** App must still build + tests pass (`env:['fake']`).

- [x] T004 [P] `ViewerRelationship` + `AccountResult` freezed+json models in `lib/core/data/discovery/search_results.dart` (mirror `RelationshipStateDto` / `UserListItemDto`; reuse `UserSummary`).
- [x] T005 [P] `HashtagResult` + `PlaceResult` + `SearchTop` freezed+json models in `lib/core/data/discovery/search_results.dart`.
- [x] T006 [P] `ExploreItem` (kind-tagged `Post`|`Reel`) freezed+json + helpers (`id`/`isReel`/`author`/`thumbnailUrl`) in `lib/core/data/discovery/explore_item.dart` (reuse `Post`/`Reel`; assert exactly-one-payload).
- [x] T007 [P] `HashtagPage` + `PlacePage` envelopes (header + `CursorPage<ExploreItem>`) in `lib/core/data/discovery/discovery_page.dart`.
- [x] T008 [P] `SearchRecent` + `RecordSearchRecent` (request) freezed+json models in `lib/core/data/discovery/search_recent.dart` (exactly-one-target per `type`).
- [x] T009 Drift `ExploreItems` table (orderIndex PK, itemId, kind, payloadJson) in `lib/core/data/cache/tables/explore_items_table.dart`; bump `schemaVersion` 6→7 + migration step + join the user-scoped clear in `lib/core/data/cache/app_database.dart`.
- [x] T010 `ExploreDao` (`watchExplore()`, `replaceAll()`, `appendAll()`, `clearUserScoped()`) in `lib/core/data/cache/daos/explore_dao.dart`.
- [x] T011 `DiscoveryRepository` interface (Result<T> + reactive explore read: `watchExplore`, `loadExploreFirst/Next`, `search{Top,Accounts,Tags,Places}`, `hashtagPage`, `placePage`, `recents`, `recordRecent`, `deleteRecent`, `clearRecents`) in `lib/core/data/discovery/discovery_repository.dart`.
- [x] T012 `DiscoveryRemoteDataSource` (all endpoints → `Result` via shared `ApiClient`; decode envelopes/DTOs) in `lib/core/data/discovery/discovery_remote_data_source.dart`.
- [x] T013 `DiscoveryRepositoryImpl` `@LazySingleton(as: DiscoveryRepository, env: ['real'])` (explore pages reconcile into `ExploreDao`; search/pages pass-through; recents optimistic upsert seam) in `lib/core/data/discovery/discovery_repository_impl.dart`.
- [x] T014 `FakeDiscoveryRepository` `@LazySingleton(as: DiscoveryRepository, env: ['fake'])` — deterministic mixed explore grid, searchable accounts/hashtags/places (prefix+substring, case/accent-insensitive, block/private filtering), hashtag/place pages, recents dedupe-and-promote, `failNextQuery`/`failNextMutation` seams — in `lib/core/data/discovery/fake_discovery_repository.dart`.
- [x] T015 Run codegen (`dart run build_runner build --delete-conflicting-outputs`) for freezed/json/drift; verify `flutter analyze` clean + app builds on `env:['fake']`.
- [x] T016 [P] Fake-repo test (explore paging; search-by-type matching + block/private filter; hashtag/place pages; recents dedupe-and-promote/delete/clear) in `test/core/data/discovery/fake_discovery_repository_test.dart`.

**Checkpoint**: data slice + cache proven by the fake-repo test; stories can start in parallel.

---

## Phase 3: User Story 1 — Search for accounts, hashtags, and places (Priority: P1) 🎯 MVP

**Goal**: Type a term → live results across Top/Accounts/Tags/Places → navigate to profile/hashtag/place.
**Independent test**: Open the search route, type ≥2 chars, switch tabs; verify each type matches, blocked users absent, private findable-by-handle, relationship label shown, tap navigates.

- [ ] T017 [US1] Search use cases (`SearchTop`, `SearchAccounts/Tags/Places` paginated, wraps `DiscoveryRepository`) in `lib/features/explore/domain/usecases/search_usecases.dart`.
- [ ] T018 [US1] `SearchCubit` (freezed 4-state) — query + ~300 ms debounce + ≥2-char gate + latest-term guard; active tab (top/accounts/tags/places); Top snapshot + per-type cursor pagination — in `lib/features/explore/presentation/cubit/search_cubit.dart` (+ state file).
- [ ] T019 [US1] `SearchPage` scaffold (SearchBar + results tabs when query ≥2 chars; recents slot reserved for US3) in `lib/features/explore/presentation/search_page.dart`; wire `AppRoutes.search` (nav-less push) in `lib/core/router/app_router.dart`.
- [ ] T020 [P] [US1] `ResultsTabs` (Top/Accounts/Tags/Places, active underline) widget in `lib/features/explore/presentation/widgets/results_tabs.dart`.
- [ ] T021 [P] [US1] `AccountResultRow` (avatar+ring, name/handle, read-only Follow/Requested/Following label, tap→profile route) in `lib/features/explore/presentation/widgets/account_result_row.dart`.
- [ ] T022 [P] [US1] `HashtagResultRow` + `PlaceResultRow` (glyph + name + postCount/coords, tap→page) in `lib/features/explore/presentation/widgets/result_rows.dart`.
- [ ] T023 [US1] Top view (blended sections + per-type "see more" → switch tab) + single-type paginated lists rendering in `search_page.dart`.
- [ ] T024 [US1] Empty/loading/error-retry states per tab + latest-term-wins UI behavior in `search_page.dart`.
- [ ] T025 [P] [US1] `SearchCubit` bloc test — debounce + ≥2-char gate, stale-term ignored, Top snapshot, tab switch + pagination, error — in `test/features/explore/search_cubit_test.dart`.
- [ ] T026 [P] [US1] `SearchPage` widget test — type→results, tab switch, block/private visibility, tap-navigation intents (fixed `pump(Duration)`, tall `surfaceSize`) — in `test/features/explore/search_page_test.dart`.

**Checkpoint**: Search is independently usable end-to-end (MVP).

---

## Phase 4: User Story 2 — Explore discovery grid (Priority: P2)

**Goal**: Browse the non-personalized mixed post/reel grid; category chips → hashtag pages; offline-from-cache.
**Independent test**: Open the Explore tab; grid renders (reels marked, hero tile), scroll-paginates, pull-to-refresh, tile→item, chip→#tag; offline cold-start shows cached grid.

- [ ] T027 [US2] Explore grid use cases (`WatchExplore`, `LoadExploreFirst/Next`, `RefreshExplore`) in `lib/features/explore/domain/usecases/explore_usecases.dart`.
- [ ] T028 [US2] `ExploreCubit` (freezed 4-state, reactive over `watchExplore()`, load-first/next/refresh, `isOffline` flag) in `lib/features/explore/presentation/cubit/explore_cubit.dart` (+ state file).
- [ ] T029 [US2] `ExplorePage` (Screen 16 tab body: SearchBar→push search, category chips, grid) replacing the placeholder in `lib/core/router/app_router.dart` / `lib/features/explore/presentation/explore_page.dart`.
- [ ] T030 [P] [US2] `DiscoveryGridTile` (post/reel thumbnail via `cached_network_image` bounded `cacheWidth`; reel marker; tap→post-detail/reel route) in `lib/features/explore/presentation/widgets/discovery_grid_tile.dart`.
- [ ] T031 [P] [US2] Quilted grid (3-col + 2×2 hero on phone; responsive `SliverGridDelegateWithMaxCrossAxisExtent` ≥700) helper in `lib/features/explore/presentation/widgets/discovery_grid.dart`.
- [ ] T032 [P] [US2] `CategoryChips` (static travel/food/design/fitness → `hashtag(tag)` route; no "For you") in `lib/features/explore/presentation/widgets/category_chips.dart`.
- [ ] T033 [US2] Pull-to-refresh + empty/loading/error-retry + offline-from-cache indication in `explore_page.dart`.
- [ ] T034 [P] [US2] `ExploreCubit` bloc test — load-first/next/refresh, reactive cache read, offline path, empty/error — in `test/features/explore/explore_cubit_test.dart`.
- [ ] T035 [P] [US2] `ExplorePage` widget test — mixed tiles + reel marker + hero tile, scroll-paginate, chip→route, offline cached grid — in `test/features/explore/explore_page_test.dart`.

**Checkpoint**: Explore grid independently usable, incl. offline cold-start.

---

## Phase 5: User Story 3 — Recent searches (Priority: P3)

**Goal**: Recents shown on empty query; dedupe-and-promote on record; per-row delete + clear all.
**Independent test**: Open Search empty → recents listed; submit term / tap result → promoted (no duplicate); delete one; clear all.

- [ ] T036 [US3] Recents use cases (`GetRecents`, `RecordRecent`, `DeleteRecent`, `ClearRecents`) in `lib/features/explore/domain/usecases/recents_usecases.dart`.
- [ ] T037 [US3] `RecentsCubit` (freezed 4-state; optimistic dedupe-and-promote record, delete, clear) in `lib/features/explore/presentation/cubit/recents_cubit.dart` (+ state file).
- [ ] T038 [US3] Recents view in `SearchPage` (shown when query < 2 chars) + wire recording on result-tap (US1 rows) and term-submit in `search_page.dart`.
- [ ] T039 [P] [US3] `RecentRow` (typed: account avatar / tag glyph / place icon / term; per-row `x` delete) + "Clear all" control in `lib/features/explore/presentation/widgets/recent_row.dart`.
- [ ] T040 [P] [US3] `RecentsCubit` bloc test — record promote-not-duplicate, delete-one, clear-all (optimistic), error revert — in `test/features/explore/recents_cubit_test.dart`.

**Checkpoint**: Recents work on top of Search.

---

## Phase 6: User Story 4 — Hashtag & place pages (Priority: P3)

**Goal**: Header + single cursor grid for a tag/place; surface-only Follow; deep-linkable.
**Independent test**: Open a hashtag page + a place page directly; header + grid render, paginate, empty/error; Follow → toast only.

- [ ] T041 [US4] Hashtag/place use cases (`LoadHashtagPage`/`LoadPlacePage` first+next) in `lib/features/explore/domain/usecases/discovery_page_usecases.dart`.
- [ ] T042 [US4] `DiscoveryGridCubit` (reuses the `PaginatedListCubit<ExploreItem>` pattern; carries `HashtagPage`/`PlacePage` header meta) in `lib/features/explore/presentation/cubit/discovery_grid_cubit.dart`.
- [ ] T043 [US4] `HashtagPage` screen (header: tag + postCount + surface-only Follow → toast; grid) in `lib/features/explore/presentation/hashtag_page.dart`; wire `hashtag(tag)` route.
- [ ] T044 [US4] `PlacePage` screen (header: name/details + postCount; grid) in `lib/features/explore/presentation/place_page.dart`; wire `place(id)` route. Reuse `DiscoveryGridTile` + quilted/responsive grid from US2.
- [ ] T045 [P] [US4] `DiscoveryGridCubit` bloc test — first/next page, header meta, empty/error — in `test/features/explore/discovery_grid_cubit_test.dart`.
- [ ] T046 [P] [US4] Hashtag/place page widget test — header + grid + paginate + surface-only Follow toast (no relationship) + direct deep-link — in `test/features/explore/discovery_pages_test.dart`.

**Checkpoint**: Hashtag/place destinations complete; search rows + chips now land fully.

---

## Phase 7: Polish & Cross-Cutting Concerns (User Story 5 + release gate)

**Purpose**: Accessibility, adaptivity, resilience (US5 P4) + quality gate across all stories.

- [ ] T047 [P] [US5] `Semantics` labels on grid tiles (reel vs photo), account/hashtag/place/recent rows, tabs, and controls (FR-030, SC-007) across explore widgets.
- [ ] T048 [P] [US5] Adaptive: phone 3-col grid + bottom nav vs ≥700 responsive grid; results tabs + hashtag/place pages reflow to width (FR-031) — verify in pages via `AppBreakpoints`.
- [ ] T049 [P] [US5] Verify all user messages use `Toast` (no `ScaffoldMessenger.showSnackBar`) across discovery (FR-028).
- [ ] T050 [P] [US5] Log-redaction test — no `print`/`debugPrint`; no query terms / urls / tokens logged — in `test/features/explore/log_redaction_test.dart`.
- [ ] T051 [P] [US5] Golden tests: `DiscoveryGridTile` (post + reel), `AccountResultRow` (follow/following), `CategoryChips`, `ResultsTabs` (light + dark) in `test/features/explore/goldens/`.
- [ ] T052 [P] [US5] a11y + adaptive widget test (screen-reader labels; 2× text scale no overflow; phone 3-col vs tablet responsive grid) in `test/features/explore/a11y_adaptive_test.dart`.
- [ ] T053 [P] [US5] Drift v6→v7 migration test (`ExploreItems` added, existing rows intact) in `test/core/data/cache/migration_v6_to_v7_test.dart`.
- [ ] T054 [US5] Run pre-commit gate (`dart format .`, `flutter analyze` zero warnings, `flutter test` all pass, `dart run bloc_tools:bloc lint .`) + walk quickstart.md US1–US5. **SC-004 memory ceiling**: automated pagination coverage (T034/T035/T045 — no duplicated/dropped tiles across ≥5 pages) is authoritative here; **on-device long-scroll memory profiling of the discovery grids is deferred to the #015 release gate** (matches #004/#008 — tiles use bounded `cacheWidth`, Principle II).

---

## Dependencies & Execution Order

### Phase dependencies
- **Setup (P1)** → no deps.
- **Foundational (P2)** → depends on Setup; **blocks all stories**. Within P2: T004–T008 [P] models; T009→T010 (cache chain); T011→T012→T013 and T014 (repo/remote/real/fake, after models); T015 codegen (needs all models/table); T016 after T014/T015.
- **US1 (P3)** → after Foundational. **MVP.**
- **US2 (P4)** → after Foundational; independent (own tab + cache read).
- **US3 (P5)** → after Foundational; layers onto the US1 `SearchPage` (recording hooks into US1 rows — sequence US3 after US1).
- **US4 (P6)** → after Foundational; independent (own pushed pages); search rows + chips (US1/US2) fully land once US4 exists.
- **Polish (P7)** → after the stories you intend to ship.

### User story independence
- US1 Search: needs only the data slice (search + navigation intents).
- US2 Explore: needs only the explore read + cache; independently testable.
- US3 Recents: needs the recents seam; hooks into the US1 search screen for recording.
- US4 Pages: needs the hashtag/place seam; independently testable via direct deep-link.

### Within a story
Tests → use cases → cubit → widgets → page/route wiring.

### Parallel opportunities
- Setup: T002, T003 [P].
- Foundational: T004–T008 [P]; T011/T012 groundwork parallel to model finalization.
- US1: T020/T021/T022 [P]; T025/T026 [P].
- US2: T030/T031/T032 [P]; T034/T035 [P].
- US3: T039/T040 [P].
- US4: T045/T046 [P].
- Polish: T047–T053 all [P]; T054 last (gate).

---

## Implementation Strategy

- **MVP = US1 (Search)**: Setup + Foundational + Phase 3 delivers live search with navigation — the highest-value discovery entry point, shippable alone.
- **Incremental**: add US2 (Explore grid + offline), then US3 (recents), then US4 (hashtag/place pages) — each an independent, testable increment.
- **Gate every increment**: `dart format` · `flutter analyze` (zero warnings) · `flutter test` · bloc lint (no local CLI — carried). No new pub dependency expected.
