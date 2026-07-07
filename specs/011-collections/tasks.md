---
description: "Task list for #011 Saved Collections (We36 Flutter client)"
---

# Tasks: Saved Collections

**Input**: Design documents from `specs/011-collections/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/collections-api.md](contracts/collections-api.md)

**Tests**: Included (the repo's pre-commit gate requires `flutter test` green; every prior slice ships bloc/widget/golden/fake/redaction coverage). Widget tests seed **stub cubits** — never real drift I/O inside `testWidgets` (the #009 gate learning). Any clock-dependent fake seam is frozen in tests (the post-#10 time-bomb learning).

**Organization**: Grouped by user story (US1–US5 from spec.md). Phase 2 builds the shared `core/data/collections/` slice + the drift v8 `SavedCollections` cache that all stories consume. Reuses shipped `Post`/`viewerHasSaved` + `FeedRepository.save` (#004), `ExploreItem`/`DiscoveryGrid`/`DiscoveryGridTile` (#009), `CursorPage`/`PaginatedListCubit` (#002), `ProfileTabBar` (#010). **drift schema v7→v8 (additive); no new pub dependency.**

## Format: `[ID] [P?] [Story] Description with file path`

- **[P]**: parallelizable (different files, no dependency on an incomplete task).
- **[Story]**: US1–US5 (Setup/Foundational/Polish carry no story label).

---

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 Add collections endpoints to `lib/core/constants/api_endpoints.dart` — `meCollections` (GET/POST `/me/collections`), `meCollection(id)` (PATCH/DELETE), `meCollectionItems(id)` (GET), `meSaved` (GET `/me/saved`), `meCollectionItem(id, postId)` (POST/DELETE `/me/collections/{id}/items/{postId}`), `meSavedCollections(postId)` (GET `/me/saved/{postId}/collections`); reuse the shipped `postSave(id)` (#004). No inline literals elsewhere.
- [x] T002 [P] Add collection routes to `lib/core/constants/app_routes.dart` — `collection = '/collections/:id'` + `collectionPath(id)` helper (`id='all'` → All saved), and the `we36://collections/:id` deep-link mapping.
- [x] T003 [P] Add EN+VI ARB keys in `lib/l10n/arb/app_en.arb` + `app_vi.arb` — "Saved", "All saved", "N saved" (plural), "New collection", "Save to collection", "Add to collection", create/rename dialog title + name hint + name-length error, "Remove from collection", delete-collection confirm title+body, "set cover", full-unsave confirm title+body ("remove from N collections"), empty states (no collections / nothing saved / empty collection), save/file/remove/rename/delete success+failure toasts.
- [x] T004 [P] Scaffold folders per [plan.md](plan.md): `lib/core/data/collections/`, `lib/core/data/cache/tables/` + `daos/` (new files), `lib/core/presentation/slots/` (the `SavedTabSlot` seam), and `lib/features/collections/{domain/usecases,presentation/cubit,presentation/widgets}` with file placeholders.

---

## Phase 2: Foundational (data slice + drift v8 — BLOCKS all user stories)

- [x] T005 [P] `SavedCollection` freezed+json in `lib/core/data/collections/saved_collection.dart` (`id`, `name`, `itemCount`, `coverRefs: List<String>`, `isDefault`, `updatedAt`) + derivations `canManage`/`isEmpty`/`coverCount`; validation (`name` trimmed non-empty ≤50, ≤4 coverRefs, itemCount ≥0).
- [x] T006 `SavedCollections` drift table in `lib/core/data/cache/tables/saved_collections_table.dart` (id PK text, name, itemCount, coverRefs [JSON text], isDefault bool, updatedAt datetime, position int).
- [x] T007 `SavedCollectionsDao` in `lib/core/data/cache/daos/saved_collections_dao.dart` — `watchCollections()` (ordered by `position`), `upsertAll(List)`, `deleteById(id)`, `clearUserScoped()`; map row ↔ `SavedCollection` (decode `coverRefs` JSON).
- [x] T008 Bump `lib/core/data/cache/app_database.dart` — register `SavedCollections` table + `SavedCollectionsDao`; `schemaVersion` **7→8**; add the additive migration step (`m.createTable(savedCollections)`), no backfill.
- [x] T009 `CollectionsRepository` interface in `lib/core/data/collections/collections_repository.dart` — `Stream<List<SavedCollection>> watchCollections()`; `Result<void> refreshCollections()`; `Result<CursorPage<ExploreItem>> collectionItems(id, cursor?)` / `allSaved(cursor?)`; `Result<PostCollectionsMembership> membership(postId)`; `Result<SavedCollection> create(name)` / `rename(id, name)` / `setCover(id, coverItemId)`; `Result<void> delete(id)`; `Result<SavedCollection> file(id, postId)` / `unfile(id, postId)`; `Result<void> unsave(postId)` (delegates to `FeedRepository.save(save:false)`).
- [x] T010 `PostCollectionsMembership` view model (+ `PickerRow`) in `lib/core/data/collections/collections_repository.dart` (or `post_collections_membership.dart`) — `postId`, `isSaved`, `collections: List<PickerRow>`, derived `namedMembershipCount`.
- [x] T011 `CollectionsRemoteDataSource` in `lib/core/data/collections/collections_remote_data_source.dart` — `ApiClient` calls per [contracts/collections-api.md](contracts/collections-api.md) (Idempotency-Key on create/file/unfile); returns typed DTOs.
- [x] T012 `CollectionsRepositoryImpl` `@LazySingleton(as: CollectionsRepository, env: ['real'])` in `lib/core/data/collections/collections_repository_impl.dart` — DTO→domain; writes the collections list into `SavedCollectionsDao` (canonical cache, default prepended); item grids live via `ApiClient`; `unsave` calls the shipped `FeedRepository.save`; `Result`/`FailureMapper`.
- [x] T013 `FakeCollectionsRepository` `@LazySingleton(as: CollectionsRepository, env: ['fake'])` in `lib/core/data/collections/fake_collections_repository.dart` — in-memory graph over the shipped fake `Post`/`viewerHasSaved`: several saved posts+reels, 2–3 named collections (one with set cover, one empty) + the synthetic "All saved"; file/unfile/create/rename/delete/set-cover; membership lookup; fail-next seams for rollback tests; **no fixed wall-clock** (inject a clock or pass timestamps).
- [x] T014 Run `dart run build_runner build --delete-conflicting-outputs` and verify DI resolves `CollectionsRepository` (`env:['fake']` for the app; `['real']` annotated) and the drift v8 schema compiles.
- [x] T015 [P] `SavedCollectionsDao` test in `test/core/data/cache/saved_collections_dao_test.dart` (`test()`, real in-memory `AppDatabase`) — upsert/watch emits, `position` ordering (default first), `deleteById`, `clearUserScoped`; v7→v8 migration `createTable` succeeds.
- [x] T016 [P] `FakeCollectionsRepository` tests in `test/core/data/collections/fake_collections_repository_test.dart` — list (default prepended), create (non-unique names accepted), rename, delete (posts stay saved), set-cover + **cover fallback when the cover item is removed/unsaved** (FR-010), file/unfile membership, `allSaved` + `collectionItems` pagination, membership lookup (`namedMembershipCount`).

**Checkpoint**: data slice + drift v8 builds + fakes green → user stories can proceed.

---

## Phase 3: US1 — Saved tab + collections grid (P1) 🎯 MVP

**Goal**: The profile **Saved** tab (owner-only) opens Screen 24 — a 2-column grid of collection cards (quilt cover + name + "N saved") with "All saved" always first and a create (`+`) action; renders offline-from-cache.

**Independent test**: Seed collections + saved posts; open the Saved tab; verify the grid + cards + "All saved" first + create action, the empty (only All saved) / fully-empty / offline-from-cache / error-retry states.

- [x] T017 [US1] Extend `enum ProfileTab { posts, tagged }` → add `saved` in `lib/features/profile/domain/usecases/profile_usecases.dart`; render the Saved tab **owner-only** in `lib/features/profile/presentation/widgets/profile_tab_bar.dart` (hidden when `!isMe`); its body renders `getIt<SavedTabSlot>().build(context)` (the core seam — no `features/collections` import; see T023).
- [x] T018 [US1] `collections_usecases.dart` in `lib/features/collections/domain/usecases/` — `WatchCollections` (drift v8 `watchCollections`), `LoadCollections` (background `refreshCollections` + saved-count for the default).
- [x] T019 [US1] `CollectionsCubit` + `CollectionsState` (freezed 4-state: `loaded(List<SavedCollection>, isOffline)`) in `lib/features/collections/presentation/cubit/` — cache-first watch, background reconcile, offline flag, error-retry.
- [x] T020 [P] [US1] `CollectionCard` widget in `lib/features/collections/presentation/widgets/collection_card.dart` — 4-image quilt cover (radius-16, bounded `cacheWidth`, empty-cover placeholder) + name + "N saved" (`CountFormatter`); Semantics label.
- [x] T021 [P] [US1] `CollectionsGrid` widget in `lib/features/collections/presentation/widgets/collections_grid.dart` — 2-col grid of `CollectionCard` with "All saved" first; tap → `AppRoutes.collectionPath(id)`.
- [x] T022 [US1] `SavedCollectionsView` in `lib/features/collections/presentation/saved_collections_view.dart` — Screen 24 body (header "Saved" + create `+`, `CollectionsGrid`); empty/fully-empty/offline/error-retry states; hosted by the profile Saved tab.
- [x] T023 [US1] Create the **cross-feature render seam** (Constitution XI): `abstract class SavedTabSlot { Widget build(BuildContext); }` in `lib/core/presentation/slots/saved_tab_slot.dart`, and its impl `SavedTabSlotImpl` `@LazySingleton(as: SavedTabSlot)` in `lib/features/collections/presentation/saved_tab_slot_impl.dart` returning `BlocProvider(create: getIt<CollectionsCubit>()..loadInitial()) → SavedCollectionsView`. `features/profile` renders it via `getIt<SavedTabSlot>()` (T017) — **no direct `features/collections` import**. Verify DI resolves `SavedTabSlot`.
- [x] T024 [P] [US1] `CollectionsCubit` tests in `test/features/collections/collections_cubit_test.dart` (`test()`/`blocTest`) — cache-first load, background reconcile, offline flag, empty vs fully-empty, error.
- [x] T025 [P] [US1] `SavedCollectionsView` widget test in `test/features/collections/saved_collections_view_test.dart` — **stub cubit** seeded `loaded`; grid + cards render, "All saved" first, create action present, empty states (no real drift).

**Checkpoint**: MVP — the Saved surface is viewable end-to-end.

---

## Phase 4: US2 — Save a post into a collection (P1)

**Goal**: The default Save (bookmark) saves silently to "All saved"; the explicit "Save to collection" sheet files into an existing/new collection; optimistic + idempotent + rollback.

**Independent test**: Tap Save → post in "All saved" (no picker); open "Save to collection" → pick/create a collection → filed (and still in All saved); forced failure rolls back; retried file → one membership.

- [x] T026 [US2] `save_to_collection_usecases.dart` in `lib/features/collections/domain/usecases/` — `LoadPicker(postId)` (membership + `isSaved`), `FileInto(id, postId)` / `Unfile(id, postId)` (optimistic + `Idempotency-Key` + rollback; file an unsaved post also sets the canonical flag), `CreateCollectionInline(name)`.
- [x] T027 [US2] `SaveToCollectionCubit` + `SaveToCollectionState` in `lib/features/collections/presentation/cubit/` — `loaded(PostCollectionsMembership, creating)`; toggle membership optimistically, create-inline, error rollback.
- [x] T028 [P] [US2] `SaveToCollectionSheet` widget in `lib/features/collections/presentation/widgets/save_to_collection_sheet.dart` — bottom sheet listing collections with a checkmark for those containing the post + a "New collection" row; Semantics.
- [x] T029 [P] [US2] `CreateCollectionDialog` widget in `lib/features/collections/presentation/widgets/create_collection_dialog.dart` — name input (create + rename), ≤50 chars + non-empty validation, **no uniqueness check** (FR-005); reuse `AppTextField` + `AppDialog`.
- [x] T030 [US2] Wire the entry points — the default bookmark on `PostCard` (#004) / post detail (#006) / reel action rail (#008) already toggles `FeedRepository.save` (silent → All saved); add a **long-press / "Save to collection"** affordance opening `SaveToCollectionSheet` via a `core/router`/DI seam (no cross-feature internals import).
- [x] T031 [P] [US2] Save-to-collection tests in `test/features/collections/save_to_collection_cubit_test.dart` — default save → All saved (canonical flag), file/unfile optimistic + rollback, retried file = one membership (SC-004), create-inline then file, file-unsaved-post also saves.
- [x] T032 [P] [US2] `SaveToCollectionSheet` widget test in `test/features/collections/save_to_collection_sheet_test.dart` — **stub cubit**; collections listed with membership checkmarks, "New collection" opens the dialog, toggle reflects.

**Checkpoint**: saving + filing works; content flows into collections.

---

## Phase 5: US3 — Open & curate a collection (P2)

**Goal**: Open a collection (or "All saved") → cursor item grid (reels marked); remove an item from a collection; full unsave (confirm when in ≥1 named collection) removes it everywhere.

**Independent test**: Open a collection → grid + pagination; tile tap → post detail; remove from collection keeps it in All saved; full unsave of an in-collection item confirms then removes everywhere; unsave of an All-saved-only item is silent.

- [x] T033 [US3] `collection_items_usecases.dart` in `lib/features/collections/domain/usecases/` — `LoadCollectionItems(id, cursor?)` / `LoadAllSaved(cursor?)` (cursor `ExploreItem`), `RemoveFromCollection(id, postId)` (optimistic), `FullUnsave(postId)` (confirm-gated on `namedMembershipCount`, delegates to `unsave`).
- [x] T034 [US3] `CollectionDetailCubit` + `CollectionDetailState` in `lib/features/collections/presentation/cubit/` — over `PaginatedListCubit<ExploreItem>`; `id='all'` → `allSaved`; remove-from-collection + full-unsave with the confirm gate; empty state.
- [x] T035 [P] [US3] Reuse `DiscoveryGrid`/`DiscoveryGridTile` (#009) for the item grid in `lib/features/collections/presentation/collection_detail_page.dart` — reels marked; tile tap → `AppRoutes.postDetail` (#006); per-tile remove/unsave affordance.
- [x] T036 [US3] `CollectionDetailPage` in `lib/features/collections/presentation/collection_detail_page.dart` — nav-less push (`/collections/:id`), TopBar (collection name / "All saved"), grid, remove + full-unsave (`AppDialog` confirm when in ≥1 named collection), empty/loading/error-retry.
- [x] T037 [US3] Add `/collections/:id` route in `lib/core/router/app_router.dart` (nav-less push) → `CollectionDetailPage` (`id='all'` = All saved).
- [x] T038 [P] [US3] `CollectionDetailCubit` tests in `test/features/collections/collection_detail_cubit_test.dart` — pagination (no dupes ≥5 pages), remove-from-collection keeps All saved (SC-005), full-unsave confirm gate (in-named vs All-saved-only), unsave cascades canonical flag (SC-007), **a deleted/unavailable post renders no blank tile** (edge case — graceful skip).
- [x] T039 [P] [US3] `CollectionDetailPage` widget test in `test/features/collections/collection_detail_page_test.dart` — **stub cubit**; grid + reels marker, tile tap routes, remove affordance, full-unsave confirm dialog appears only when in a named collection.

---

## Phase 6: US4 — Manage a collection (P2)

**Goal**: Rename / delete (confirm) / set-cover a named collection via an action sheet; delete keeps posts saved; the "All saved" default exposes no management.

**Independent test**: Open a collection's more sheet → rename updates the card; set-cover updates the cover; delete (confirm) removes the collection but posts stay in All saved; "All saved" shows no rename/delete/set-cover.

- [x] T040 [US4] `manage_collection_usecases.dart` in `lib/features/collections/domain/usecases/` — `CreateCollection` / `RenameCollection(id, name)` / `DeleteCollection(id)` / `SetCover(id, coverItemId)` (optimistic on the `SavedCollections` cache + `Idempotency-Key` + rollback); delete never touches `viewerHasSaved`.
- [x] T041 [US4] `CollectionEditCubit` + `CollectionEditState` in `lib/features/collections/presentation/cubit/` — create/rename `editing(name, saving)`; delete + set-cover one-shot optimistic ops surfaced via `CollectionsCubit` reconcile.
- [x] T042 [P] [US4] `CollectionMoreSheet` widget in `lib/features/collections/presentation/widgets/collection_more_sheet.dart` — `ActionSheet` with Rename / Set cover / Delete (danger); **hidden/disabled for `isDefault`** (FR-003); Semantics.
- [x] T043 [US4] Wire create (`+` on `SavedCollectionsView`) + the more sheet (per-card) → `CollectionEditCubit` / `CreateCollectionDialog` / delete `AppDialog` confirm; optimistic grid updates.
- [x] T044 [P] [US4] `CollectionEditCubit` tests in `test/features/collections/collection_edit_cubit_test.dart` — create (non-unique), rename optimistic + rollback, delete keeps posts saved (SC-006), set-cover, **cover auto-fallback** (removing/unsaving the current cover item reconciles `coverRefs` to the next item, else empty-cover — FR-010), default collection rejects manage ops.

---

## Phase 7: US5 — Inclusive & adaptive (P2)

**Goal**: Harden US1–US4 — a11y labels, 2× text scale, light/dark, phone↔tablet reflow (Screen 24 centered-mobile fallback).

**Independent test**: Screen-reader labels on cards/tiles/actions; 2× text scale no clip (light+dark); tablet renders the centered-mobile fallback (no bespoke layout).

- [x] T045 [P] [US5] a11y + text-scale + adaptive widget test in `test/features/collections/a11y_adaptive_test.dart` — labels on `CollectionCard`/`DiscoveryGridTile`/create/save-to-collection/remove/rename/delete; 2× scale no overflow; phone 2-col vs tablet centered-mobile fallback.
- [x] T046 [P] [US5] Goldens in `test/features/collections/goldens/` — `CollectionCard` (with cover + empty-cover), `CollectionsGrid` (with All saved first), `SaveToCollectionSheet`, empty state (light + dark).
- [x] T047 [US5] Verify `CountFormatter` abbreviates "N saved" (12.3k) without overflow at 2× scale on the card + detail TopBar.

---

## Phase 8: Polish & Cross-Cutting

- [x] T048 [P] Clear the `SavedCollections` drift cache on logout — wire `SavedCollectionsDao.clearUserScoped()` into the session cache-wipe path (`SessionController`), alongside the other user-scoped tables.
- [x] T049 [P] Log-redaction test in `test/features/collections/log_redaction_test.dart` — no `print`/`debugPrint`; no tokens/media refs leaked; collection names not logged as secrets.
- [x] T050 [US1] [US3] Confirm all user messages route through `ToastService` (save/file/remove/rename/delete success + failure, surface acks) — no `ScaffoldMessenger`.
- [x] T051 Run pre-commit gate (`dart format .`, `flutter analyze` zero warnings, `flutter test` all pass, `dart run bloc_tools:bloc lint .`) + walk [quickstart.md](quickstart.md) US1–US5. **SC-005/006/007** automated coverage authoritative; on-device VoiceOver/TalkBack + rotation + long-list memory profiling deferred to the **#015** release gate (matches #004/#008/#009/#010).

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → **Phase 2 (Foundational, incl. drift v8)** block everything.
- **US1 (P1)** is the MVP and has no dependency on US2–US5 (reads the collections cache).
- **US2 (P1)** depends on Phase 2 (repo + membership); independent of US1 but shares no widget with it.
- **US3 (P2)** depends on US2 (membership → full-unsave confirm gate) + the item-grid reuse.
- **US4 (P2)** depends on US1 (`SavedCollectionsView`/`CollectionsCubit` for optimistic grid updates).
- **US5 (P2)** hardens US1–US4 (do after they exist).
- **Polish** last.

## Parallel Opportunities

- Setup: T002/T003/T004 in parallel after T001.
- Foundational: T005 parallel to T006; T015/T016 in parallel after the slice builds (T014).
- Within each story, `[P]` widget/test tasks run parallel to sibling widgets (different files).
- US1 and US2 can be built in parallel by two developers (disjoint files) once Phase 2 is done; US3→US4 chain after US2.

## Implementation Strategy

- **MVP = Phase 1 + Phase 2 + US1** (Saved tab + collections grid viewable, offline-capable). Ship/demo, then layer US2 (save-to-collection) → US3 (open & curate) → US4 (manage) → US5 (hardening) → Polish.
- Keep the app on DI `environment: 'fake'`; reconcile `contracts/collections-api.md` with the shipped B#011 before wiring `CollectionsRepositoryImpl` (`env:['real']`) — in particular whether `POST /me/collections/{id}/items` auto-saves an unsaved post or the client composes `POST /posts/{id}/save` first.
