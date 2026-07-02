---
description: "Task list for Reels (#008) implementation"
---

# Tasks: Reels

**Input**: Design documents from `/specs/008-reels/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/reels-api.md](contracts/reels-api.md), [quickstart.md](quickstart.md)

**Tests**: INCLUDED — Constitution XII mandates fake repos + `bloc_test` cubits + widget/golden tests, and spec US4 + quickstart require them. Each story carries its own test tasks.

**Organization**: Tasks grouped by user story (P1→P4) for independent implementation + testing. App runs DI `environment:'fake'` (zero-network).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on an incomplete task)
- **[Story]**: US1 / US2 / US3 (US4 is cross-cutting → Polish). Setup/Foundational/Polish carry no story label.

## Path Conventions

Flutter feature-first (Constitution XI): core slice `lib/core/data/reels/`, feature `lib/features/reels/`, cache `lib/core/data/cache/`, tests mirror under `test/`.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Dependency + platform prerequisites.

- [x] T001 Add `video_player: ^2.11.1` to `pubspec.yaml` (dependencies), run `flutter pub get`, commit `pubspec.lock` + `ios/Podfile.lock` churn (Constitution XV; verified pub.dev 2026-07-02)
- [x] T002 [P] Add `<uses-permission android:name="android.permission.INTERNET"/>` to `android/app/src/main/AndroidManifest.xml` if absent (required for network video; iOS 13 / Android minSdk 24 already met — no other native change)
- [x] T003 [P] Scaffold reels ARB keys (empty values ok) in `lib/l10n/arb/app_en.arb` + `app_vi.arb` with `@description` (reels tab, action-rail labels, create-reel, processing, report, errors)
- [x] T003a [P] Provision sample video assets for fake mode + tests: add 1–2 small looping clips under `assets/reels_samples/` (registered in `pubspec.yaml`) OR a poster-only fake flag for CI; used by `FakeReelsRepository` (T011), goldens (T052), and the widget test (T053)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The core data slice + cache + repository every story depends on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [x] T004 [P] Create `Reel` freezed model + JSON in `lib/core/data/reels/reel.dart` (fields per data-model.md; reuse `UserSummary`/`Media`/`Place`/`EngagementState` from `lib/core/data/feed/post.dart`; derived `posterUrl`/`videoUrl`/`isProcessing`)
- [x] T005 [P] Add reel endpoints to `lib/core/constants/api_endpoints.dart` (`reels`, `reel(id)`, `reelLike(id)`, `reelSave(id)`, `reelComments(id)` — no inline literals, Constitution VIII)
- [x] T006 [P] Add `AppRoutes.reelCompose` (`/reel/compose`, nav-less) in `lib/core/constants/app_routes.dart`
- [x] T007 Create `Reels` drift table in `lib/core/data/cache/tables/reels_table.dart` (columns per data-model.md; `createdAt` indexed desc)
- [x] T008 Create `ReelsDao` in `lib/core/data/cache/daos/reels_dao.dart` (`watchReelsFeed`, `watchReel`, `upsert`/`upsertAll`, `clearFeed`, `applyEngagement`, `adjustCommentCount`, `getById`) mirroring `PostsDao`
- [x] T009 Bump `AppDatabase.schemaVersion` 4→5, register `ReelsDao`, add non-destructive `onUpgrade` step for `Reels`, extend `clearUserScoped()` to wipe reels in `lib/core/data/cache/app_database.dart`
- [x] T010 Define `ReelsRepository` interface in `lib/core/data/reels/reels_repository.dart` (`Result<T>`: `loadFirstPage`/`loadNextPage`, `watchReelsFeed`, `watchReel`, `toggleLike`, `toggleSave`, `createReel`, `deleteReel`, `applyCommentCountDelta`)
- [x] T011 [P] Implement `FakeReelsRepository` in `lib/core/data/reels/fake_reels_repository.dart` (`@LazySingleton(as: ReelsRepository, env:['fake'])`; deterministic reels, optimistic like/save reconcile, `failNextMutation` seam, `createReel` → `isVideoReady:false` then simulated flip to ready)
- [x] T012 [P] Implement `ReelsRemoteDataSource` in `lib/core/data/reels/reels_remote_data_source.dart` (typed `ApiClient` calls per contracts/reels-api.md)
- [x] T013 Implement `ReelsRepositoryImpl` in `lib/core/data/reels/reels_repository_impl.dart` (`@LazySingleton(as: ReelsRepository, env:['real'])`; drift-cached, optimistic write→remote→reconcile/rollback per #004 pattern)
- [x] T014 Run `dart run build_runner build --delete-conflicting-outputs` (freezed/json/drift/injectable) and verify the DI graph resolves `ReelsRepository` for both `fake` and `real`

**Checkpoint**: Reel data + cache + repository ready — user stories can begin.

---

## Phase 3: User Story 1 - Watch the reels feed (Priority: P1) 🎯 MVP

**Goal**: A full-screen vertical `PageView` of reels — newest-first, cursor-paginated, only the active reel plays and loops, tap pauses/resumes, off-screen reels pause+dispose (≤3 controllers live).

**Independent Test**: Open Reels on fakes → newest-first playback, tap toggles pause, swipe advances/stops previous, more pages load on scroll, ≤3 controllers ever initialized, empty/loading/error-retry + offline-from-cache states.

### Tests for User Story 1

- [x] T015 [P] [US1] `FakeReelsRepository` feed-pagination + createReel-flip test in `test/core/data/reels/fake_reels_repository_test.dart`
- [x] T016 [P] [US1] `ReelsCubit` load/paginate/refresh/error `bloc_test` in `test/features/reels/reels_cubit_test.dart`
- [x] T017 [P] [US1] `ReelPlaybackController` window-bounding (≤3), active-only play, off-screen dispose, skip-not-ready unit test in `test/features/reels/reel_playback_controller_test.dart`

### Implementation for User Story 1

- [x] T018 [P] [US1] Feed use cases `LoadReelsPage` + `WatchReelsFeed` in `lib/features/reels/domain/usecases/reel_feed_usecases.dart` (inject use cases into cubit, Constitution III)
- [x] T019 [US1] `ReelsCubit` + freezed 4-state (`initial/loading/loaded(reels,hasMore,cursor)/loadedPaginating/loadedRefreshing/error`) in `lib/features/reels/presentation/cubit/reels_cubit.dart` + `reels_state.dart` (cache-first cold start via `watchReelsFeed`, `loadMore`, `refresh`)
- [x] T020 [US1] `ReelPlaybackController` in `lib/features/reels/presentation/playback/reel_playback_controller.dart` (bounded `VideoPlayerController` map ±1 window; play+`setLooping` active; pause others; dispose out-of-window; skip `isVideoReady:false`; dispose-all on close)
- [x] T021 [US1] `ReelView` widget in `lib/features/reels/presentation/widgets/reel_view.dart` (video render via controller, tap pause/resume, poster while initializing/processing, loop)
- [x] T022 [US1] Replace #001 placeholder `lib/features/reels/presentation/reels_page.dart` with vertical `PageView` (`PageController.onPageChanged` → `ReelPlaybackController`; pull-to-refresh; empty/loading/error-retry via 4-state)
- [x] T023 [US1] Provide `ReelsCubit` page-scoped on the `/reels` branch (+ dispose playback controller) in `lib/core/router/app_router.dart`

**Checkpoint**: US1 fully functional and independently testable — MVP reels feed.

---

## Phase 4: User Story 2 - Engage with a reel (Priority: P2)

**Goal**: Author header + follow, styled caption, action rail (like/comment/share/save) — optimistic + idempotent like/save with rollback; comments open the reused #006 surface as a bottom sheet; share/follow surface-only.

**Independent Test**: like/save flip <100ms + rollback on `failNextMutation`; comment sheet opens over the playing reel and count updates; `commentsDisabled` respected; caption tokens styled; share/follow show a Toast.

### Tests for User Story 2

- [x] T024 [P] [US2] `ReelsCubit` optimistic like/save + rollback + last-intent `bloc_test` in `test/features/reels/reels_engagement_test.dart`
- [x] T025 [P] [US2] Comment-count-delta seam routes reel adds/deletes to `ReelsRepository.applyCommentCountDelta` unit test in `test/features/reels/reel_comment_seam_test.dart`

### Implementation for User Story 2

- [x] T026 [P] [US2] `ToggleReelLike` + `ToggleReelSave` use cases in `lib/features/reels/domain/usecases/reel_engagement_usecases.dart`
- [x] T027 [US2] Add `toggleLike`/`toggleSave` to `ReelsCubit` (optimistic write to `ReelsDao` → repo → reconcile/revert + Toast; one canonical `Reel`) in `lib/features/reels/presentation/cubit/reels_cubit.dart`
- [x] T028 [P] [US2] `ReelActionRail` widget in `lib/features/reels/presentation/widgets/reel_action_rail.dart` (like/comment/share/save; solid `AppIcon` for active like/save; press scale-down)
- [x] T029 [P] [US2] `ReelAuthorHeader` widget + surface-only follow Toast in `lib/features/reels/presentation/widgets/reel_author_header.dart`
- [x] T030 [P] [US2] `ReelCaption` widget with `@mention`/`#hashtag` violet styling (reuse the #006 `CommentText` tokenizer) in `lib/features/reels/presentation/widgets/reel_caption.dart`
- [x] T031 [US2] Introduce `CommentTarget` (post vs reel) and generalize `AddComment`/`DeleteComment` count-delta routing to the right repository in `lib/features/post/domain/usecases/comment_usecases.dart` (keeps #006 post path intact — analyze-F1 parity)
- [x] T032 [US2] `ReelCommentsSheet` — modal bottom sheet reusing #006 `CommentsCubit` + comment widgets, keyed by reel id, honoring `commentsDisabled`, in `lib/features/reels/presentation/widgets/reel_comments_sheet.dart`; open from the action rail comment button
- [x] T033 [US2] Wire reel comments to `reelComments(id)` endpoint + confirm `FakeCommentsRepository` is target-agnostic (keyed by id) so fake mode works unchanged. **Note (I1):** the reused #006 `CommentsCubit` is oldest-first, while the backend reel-comments alias is newest-first — document/resolve ordering at real cutover (invisible in fake mode)
- [x] T034 [US2] Share action → surface-only Toast (share-to-DM deferred to #012) in the action rail
- [x] T034a [US2] Reel overflow/`ActionSheet`: **Report** (surface-only Toast ack, FR-024a) for others' reels, **Delete** for own (wired to T042); reachable from every reel (Constitution I) — mirror #006 report-other, in `lib/features/reels/presentation/widgets/reel_more_sheet.dart`

**Checkpoint**: US1 + US2 both work independently.

---

## Phase 5: User Story 3 - Create and publish a reel (Priority: P3)

**Goal**: Pick one video (≤90s) → caption/tag/location/comments-off → resilient idempotent upload (progress/cancel/retry) → optimistic top-of-feed processing reel → reconcile to ready; delete own reel.

**Independent Test**: pick video, >90s rejected; publish shows cancellable progress; cancel → no reel; retry after failure → exactly one reel; new reel at feed top with processing badge → flips to playable; discard-confirm; delete-own removes it.

### Tests for User Story 3

- [x] T035 [P] [US3] `PhotoLibraryService` video pick + duration/size validation test — rejects > 90s and > 150 MB (real+fake) in `test/core/services/photo_library_service_video_test.dart`
- [x] T036 [P] [US3] `ReelComposeCubit` pick→validate(≤90s)→publish + cancel + retry-idempotency `bloc_test` in `test/features/reels/reel_compose_cubit_test.dart`

### Implementation for User Story 3

- [x] T037 [US3] Extend `PhotoLibraryService` (+ fake) for video in `lib/core/services/photo_library_service.dart` (`RequestType.video` query, `videoDuration`, video bytes/file accessor, poster thumbnail) + enforce the 90s / 150 MB caps (constants aligned with the backend media pipeline)
- [x] T038 [P] [US3] `ReelDraft` model in `lib/features/reels/domain/reel_draft.dart` (stable `idempotencyKey` UUIDv7; `videoAssetId`, `videoDurationMs`, `posterThumb`, `caption`, reused `PostMetadata`)
- [x] T039 [US3] `PublishReel` use case in `lib/features/reels/domain/usecases/publish_reel.dart` (resolve video bytes → `MediaUploadService.upload` (reuse #007) → `ReelsRepository.createReel`; reuse idempotency key on retry; emit progress; optimistic top-of-feed insert)
- [x] T040 [US3] `ReelComposeCubit` + freezed 4-state (`initial/loading/loaded(draft)/loadedUploading(draft,progress)/error(draft)/published(reel)`) in `lib/features/reels/presentation/cubit/reel_compose_cubit.dart` + state (pick/validate/setCaption/setOptions/publish/cancel/retry/discard)
- [x] T041 [US3] `ReelComposePage` in `lib/features/reels/presentation/reel_compose_page.dart` (video preview, caption input, tag-people/location/comments-off, upload progress + cancel, discard-confirm dialog)
- [x] T042 [US3] `DeleteReel` use case + delete-own via `ActionSheet` + confirm in `lib/features/reels/domain/usecases/delete_reel.dart` (wire into action rail overflow)
- [x] T043 [US3] Wire `reelCompose` route + contextual **Create** entry point (not a tab) in `lib/core/router/app_router.dart`
- [x] T044 [US3] `ProcessingBadge` widget + cubit handling for optimistic processing reel → reconcile to ready in `lib/features/reels/presentation/widgets/processing_badge.dart`

**Checkpoint**: All three stories independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns (User Story 4 + release gate)

**Purpose**: Accessibility, resilience, adaptivity (US4 P4) + quality gate across all stories.

- [x] T045 [P] Reduce Motion: poster + tap-to-play, no autoplay-loop, across `ReelView`/`ReelPlaybackController` (FR-026, SC-007)
- [x] T046 [P] `Semantics` labels on action rail, author, and caption; verify screen-reader announcement (FR-027, SC-009) in reels widgets
- [ ] T047 [P] iOS audio session honoring the silent switch (`ambient` category) — channel-first per research R3 (only add `audio_session` if the channel is fragile); Android per stream volume
- [ ] T048 [P] Adaptive tablet/iPad reels layout (centered/constrained video column per §Responsive) in `reels_page.dart` (FR-028)
- [x] T049 [P] Verify all user messages use `Toast` (no `ScaffoldMessenger.showSnackBar`) across reels (FR-025)
- [x] T050 [P] Finalize reels ARB strings EN + VI in `lib/l10n/arb/` (counts/relative-time via shared `intl` formatters)
- [ ] T051 [P] Log-redaction test — no video URLs/tokens logged — in `test/features/reels/log_redaction_test.dart`
- [ ] T052 [P] Golden tests: `ReelActionRail` + `ProcessingBadge` (light + dark) in `test/features/reels/goldens/`
- [x] T053 [P] Widget test: `ReelsPage` render + swipe + Reduce-Motion poster path (fixed `pump(Duration)`, avoid `pumpAndSettle` with video/router — carried #006 gotcha) in `test/features/reels/reels_page_test.dart`
- [x] T054 [P] Drift v4→v5 migration test (Reels table added, existing rows intact) in `test/core/data/cache/migration_v4_to_v5_test.dart`
- [ ] T055 Run pre-commit gate (`dart format .`, `flutter analyze` zero warnings, `flutter test` all pass, `dart run bloc_tools:bloc lint .`) + walk quickstart.md US1–US4

---

## Dependencies & Execution Order

### Phase Dependencies
- **Setup (P1)** → no deps.
- **Foundational (P2)** → depends on Setup; **blocks all stories**. Within P2: T004/T005/T006 [P]; T007→T008→T009 (cache chain); T010→(T011[P],T012)→T013; T014 last (codegen, needs all models/annotations).
- **US1 (P3)** → after Foundational. **MVP.**
- **US2 (P4)** → after Foundational; independently testable (may layer on US1's page).
- **US3 (P5)** → after Foundational; independent (own compose surface).
- **Polish (P6)** → after the stories you intend to ship.

### User Story Independence
- US1 needs only the feed read + playback (foundational data slice).
- US2 adds engagement + comments seam — testable without US3.
- US3 adds create/delete — testable without US2 (uses the foundational repo + upload pipeline).

### Within a story
Tests → use cases (models) → cubit → widgets → page/route wiring.

### Parallel Opportunities
- Setup: T002, T003 [P].
- Foundational: T004/T005/T006 [P]; T011/T012 [P] after T010.
- US1 tests T015/T016/T017 [P]; US2 widgets T028/T029/T030 [P]; US3 T035/T036 [P], T038 [P].
- Polish: T045–T054 largely [P] (T055 last).

---

## Parallel Example: User Story 1

```bash
# US1 tests together:
Task: "FakeReelsRepository feed-pagination test in test/core/data/reels/fake_reels_repository_test.dart"
Task: "ReelsCubit bloc_test in test/features/reels/reels_cubit_test.dart"
Task: "ReelPlaybackController unit test in test/features/reels/reel_playback_controller_test.dart"
```

---

## Implementation Strategy

### MVP First (US1 only)
1. Phase 1 Setup → 2. Phase 2 Foundational → 3. Phase 3 US1 → **STOP & VALIDATE** the watch-feed on fakes → demo. This is the smallest shippable reels surface.

### Incremental Delivery
Foundation → US1 (MVP, watch) → US2 (engage) → US3 (create) → Polish (a11y/adaptive/gate). Each story adds value without breaking the previous.

---

## Notes
- [P] = different files, no dependency on an incomplete task.
- Reels are Posts `kind=reel` on the backend → like/save/comments reuse the exact kind-agnostic machinery; keep client `Reel`/`Reels`-table separate from `Post`/`Posts` to avoid regressing #004.
- App stays DI `environment:'fake'` (zero-network); real reel-comments wiring + chunked video upload finalize at backend cutover (research R4/R7).
- Commit after each task or logical group; run the gate (T055) before PR.
