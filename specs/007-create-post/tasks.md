---
description: "Task list for Create Post (Compose & Upload) — Spec #007"
---

# Tasks: Create Post (Compose & Upload)

**Input**: Design documents from `specs/007-create-post/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: INCLUDED — Constitution XII mandates unit + bloc + widget + golden coverage and every repository/service has a fake. Migration, idempotency, rollback, and log-redaction tests are required.

**Organization**: Grouped by user story (US1–US5, priority order). US1 is the MVP; each later story is an independently testable increment.

## Format: `[ID] [P?] [Story] Description`

- **[P]** = parallelizable (different files, no dependency on an incomplete task).
- **[Story]** = US1..US5 (setup/foundational/polish have no story label).
- Constitution gate after every task group: `dart format` · `flutter analyze` (0 warn) · `flutter test` · `dart run bloc_tools:bloc lint .` (0).
- Run `build_runner` after any freezed/json/injectable/drift change; `gen-l10n` after ARB edits.
- App stays DI `environment: 'fake'`; real seams annotated `env:['real']`, fakes `env:['fake']`.

---

## Phase 1: Setup (Shared Infrastructure)

- [X] T001 Add verified deps to `pubspec.yaml` (Constitution XV, versions from research.md): `photo_manager: ^3.9.0`, `photo_manager_image_provider: ^2.2.0`, `crop_your_image: ^2.0.0`, `image: ^4.9.1`; run `flutter pub get`; commit `pubspec.lock` (+ `ios/Podfile.lock` after a pod install) and review for unexpected transitive churn.
- [X] T002 Native permissions: add `NSPhotoLibraryUsageDescription` (clear reason) to `ios/Runner/Info.plist`; add `<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>` to `android/app/src/main/AndroidManifest.xml` (Constitution I/VII).
- [X] T003 [P] Create the `lib/features/compose/{domain,data,presentation}` folder skeleton (models/usecases, data/dtos, presentation/{cubit,pages,widgets}) matching plan.md Project Structure.

**Checkpoint**: Packages resolve, native permission strings present, feature folders exist.

---

## Phase 2: Foundational (Blocking Prerequisites)

**⚠️ CRITICAL**: The shared media pipeline + models + drift + routes below block ALL user stories.

- [X] T004 [P] Add media-upload + create-post paths to `lib/core/constants/api_endpoints.dart` (`media`, `posts`) — no inline literals (Constitution VIII).
- [X] T005 [P] Add compose route constants (nav-less full-screen) to `lib/core/constants/app_routes.dart` (`composePick`, `composeEdit`, `composeCaption`).
- [X] T006 [P] Define freezed models in `lib/features/compose/domain/models/`: `compose_draft.dart`, `selected_media_item.dart`, `media_edit_state.dart` (+ `FilterPreset` enum), `post_metadata.dart` (+ `PlaceRef`), `upload_progress.dart`, `media_ref.dart`; run `build_runner`.
- [X] T007 [P] Define the shared `FilterPreset` → 4×5 color-matrix const table in `lib/features/compose/domain/models/filter_matrices.dart` (single source for the live `ColorFilter.matrix` preview AND the `image` bake — R3 fidelity).
- [X] T008 Add `ComposeDrafts` drift table in `lib/core/data/cache/tables/compose_draft_table.dart`; bump `AppDatabase` schema **v3 → v4** in `lib/core/data/cache/app_database.dart` with non-destructive `onUpgrade` (`if (from < 4) create`) and extend `clearUserScoped()` to delete the draft (Constitution I/IX); run `build_runner`.
- [X] T009 Extend `test/core/data/cache/migration_test.dart` to cover **v3 → v4** (and confirm v1→v2→v3 still passes).
- [X] T010 Implement `ImageProcessingService` in `lib/core/services/image_processing_service.dart` — bake the 4×5 matrix + crop + `copyResize` + `encodeJpg(quality)` on a background isolate (`image` `Command().executeThread()`); `@lazySingleton`, env-agnostic.
- [X] T011 [P] Unit test bake fidelity + resize/encode in `test/core/services/image_processing_service_test.dart` (baked matrix matches preset; output within size bound).
- [ ] T012 Implement `PhotoLibraryService` (interface + real over `photo_manager`/`photo_manager_image_provider`, env-agnostic per contract) in `lib/core/services/photo_library_service.dart` + register DI; contextual permission via `requestPermissionExtend()`, paged Recents, bounded-size thumbnails.
- [ ] T013 [P] Add `FakePhotoLibraryService` (deterministic bundled-asset stubs) in `lib/core/services/photo_library_service_fake.dart` for tests; unit test in `test/core/services/photo_library_service_fake_test.dart`.
- [X] T014 Implement `MediaUploadService` (interface + real seam `env:['real']` over `ApiClient` multipart + `onSendProgress` + `CancelToken`, idempotency key forwarded) in `lib/core/services/media_upload_service.dart` + DI; log by index/size only (FR-024).
- [X] T015 [P] Add `FakeMediaUploadService` (`env:['fake']`, deterministic progress + `failAfterFraction`/`cancelable` hooks) in `lib/core/services/media_upload_service_fake.dart`; unit test progress/cancel/fail in `test/core/services/media_upload_service_fake_test.dart`.
- [ ] T016 Define `CreatePostRepository` interface + `PublishEvent` in `lib/features/compose/domain/create_post_repository.dart`; add create-post request/response DTOs in `lib/features/compose/data/dtos/`.
- [ ] T017 Implement `ComposeDraftStore` (drift-backed, single row, JSON payload, `read/save/clear/watch`) in `lib/features/compose/data/compose_draft_store.dart` + DI.
- [ ] T018 [P] Add EN+VI ARB keys for compose (titles, actions, filter names, toggles, errors, keep/discard prompt) in `lib/l10n/arb/app_en.arb` + `app_vi.arb`; run `gen-l10n`.
- [ ] T019 Wire the compose routes into `lib/core/router/app_router.dart` as nav-less full-screen pushed routes (bottom nav hidden) and add the contextual **Create** entry action (phone affordance + tablet sidebar-rail Create), all page-scoped `BlocProvider`s.

**Checkpoint**: Pipeline services + models + drift v4 + routes exist with fakes and pass; no story UI yet.

---

## Phase 3: User Story 1 — Publish a single photo (Priority: P1) 🎯 MVP

**Goal**: Open Create → pick one photo → (pass-through edit) → caption → Share → post appears atop the Home feed.

**Independent Test**: In fake mode, select one gallery photo, add a caption, tap Share, confirm the post renders at the top of the feed with image + caption — zero-network (S1 in quickstart).

### Tests for User Story 1 ⚠️ (write first, ensure they FAIL)

- [ ] T020 [P] [US1] `bloc_test` `GalleryCubit` (permission → loaded → single select) in `test/features/compose/gallery_cubit_test.dart`.
- [ ] T021 [P] [US1] `bloc_test` `ComposeCubit` publish-success path (loaded → loadedUploading → success writes to Posts cache) in `test/features/compose/compose_cubit_publish_test.dart`.
- [ ] T022 [P] [US1] Widget test the pick→caption→Share happy path + feed insertion in `test/features/compose/publish_flow_test.dart`.

### Implementation for User Story 1

- [ ] T023 [US1] Implement `GalleryCubit` (+ freezed `GalleryState` 4-state: loading/loaded/loadedPaginating/error) in `lib/features/compose/presentation/cubit/gallery_cubit.dart` — permission, paged Recents, single-select.
- [ ] T024 [US1] Implement `ComposeCubit` (+ freezed `ComposeState`: loaded/loadedUploading/error) in `lib/features/compose/presentation/cubit/compose_cubit.dart` — build draft from selection, `publish()` driving `PublishPost`.
- [ ] T025 [US1] Implement `PublishPost` use case in `lib/features/compose/domain/usecases/publish_post.dart` (orchestrates upload-all → create-post → cache write; idempotency key from draft — no repo→repo, Constitution XI).
- [ ] T026 [US1] Implement `CreatePostRepository` real seam (`env:['real']`) in `lib/features/compose/data/create_post_repository_real.dart` + write created `Post` into #004 `PostsDao` at feed top (FR-020).
- [ ] T027 [US1] Implement `FakeCreatePostRepository` (`env:['fake']`, runs) in `lib/features/compose/data/create_post_repository_fake.dart` — synthesize `Post` from draft (author = fake `Me`) and write to `PostsDao`.
- [ ] T028 [P] [US1] Build the `pick_page` (custom 4-col grid, square preview, "Recents", Next disabled until ≥1 selected) in `lib/features/compose/presentation/pages/pick_page.dart` + `gallery_grid`/`selection_badge` widgets — tokens + `AppIcon` + Semantics.
- [ ] T029 [P] [US1] Build the `caption_page` (thumbnail + `AppTextField` caption with violet hashtags, 2,200 cap, Share) in `lib/features/compose/presentation/pages/caption_page.dart`.
- [ ] T030 [US1] Build a minimal pass-through `edit_page` shell (Next only; crops to default 4:5) in `lib/features/compose/presentation/pages/edit_page.dart` — enriched in US2.
- [ ] T031 [US1] Wire side effects via `BlocListener` (success Toast + haptic + pop flow + clear draft; failure Toast) — never in `BlocBuilder` (Constitution III/VI).
- [ ] T032 [P] [US1] Golden tests for pick + caption pages (light + dark) in `test/features/compose/compose_goldens_test.dart`.

**Checkpoint**: MVP — a single photo can be published and appears in the feed, fully in fake mode. STOP & validate (S1).

---

## Phase 4: User Story 2 — Edit media before publishing (Priority: P2)

**Goal**: Per-photo crop to 4:5, preset filters, and brightness/contrast/warmth with live preview, baked into the published image.

**Independent Test**: Select a photo, apply a filter + adjustments + crop, publish, confirm the post reflects the baked edits (S2).

### Tests for User Story 2 ⚠️

- [ ] T033 [P] [US2] `bloc_test` `ComposeCubit` edit mutations (filter/adjust/crop update the active item's `MediaEditState`) in `test/features/compose/compose_cubit_edit_test.dart`.
- [ ] T034 [P] [US2] Widget test the edit step (filter select updates preview; sliders update; crop passes through) in `test/features/compose/edit_page_test.dart`.

### Implementation for User Story 2

- [ ] T035 [US2] Enrich `edit_page` with the live preview using `ColorFilter.matrix` from `filter_matrices.dart` + crop stage (`crop_your_image` v2 `Crop`/`CropController`, `aspectRatio: 4/5`, custom overlay) in `lib/features/compose/presentation/pages/edit_page.dart`.
- [ ] T036 [P] [US2] Build `filter_row` (Original/Warm/Lux/Mono/Fade, active = rose border) in `lib/features/compose/presentation/widgets/filter_row.dart`.
- [ ] T037 [P] [US2] Build `adjust_slider` (Brightness/Contrast/Warmth, gradient fill + white knob) in `lib/features/compose/presentation/widgets/adjust_slider.dart`.
- [ ] T038 [US2] Add edit-mutation methods to `ComposeCubit` (setFilter/setAdjust/setCrop on the active item) and feed the baked result via `ImageProcessingService` at publish (T010).
- [ ] T039 [P] [US2] Golden test the edit page (light + dark) added to `test/features/compose/compose_goldens_test.dart`.

**Checkpoint**: Edits preview live and are baked into the published post; US1 still works.

---

## Phase 5: User Story 3 — Publish a multi-photo carousel (Priority: P2)

**Goal**: Multi-select with tracked order, per-photo editing across the set, swipeable carousel in the feed; cap 10.

**Independent Test**: Select 3 photos, give each a different edit, publish, confirm a swipeable ordered carousel in the feed; 11th selection blocked (S3).

### Tests for User Story 3 ⚠️

- [ ] T040 [P] [US3] `bloc_test` `GalleryCubit` multi-select + order + cap-10 block in `test/features/compose/gallery_multiselect_test.dart`.
- [ ] T041 [P] [US3] Widget test carousel edit navigation (move between items, each keeps its own edit) in `test/features/compose/carousel_edit_test.dart`.

### Implementation for User Story 3

- [ ] T042 [US3] Extend `GalleryCubit` for multi-select: ordered `selectedIds`, "Carousel" indicator, enforce cap 10 with a clear message (FR-006) in `lib/features/compose/presentation/cubit/gallery_cubit.dart`.
- [ ] T043 [US3] Add per-item navigation to `edit_page` (thumbnail strip / pager to switch the active item) in `lib/features/compose/presentation/pages/edit_page.dart`.
- [ ] T044 [US3] Ensure `PublishPost` uploads items sequentially with aggregated progress (bounded memory, Constitution II) in `lib/features/compose/domain/usecases/publish_post.dart`.
- [ ] T045 [P] [US3] Verify the feed `PostCard` renders a multi-image carousel in order (reuse #004 `PostCard`; add carousel support if absent) in `lib/core/presentation/` + `test/features/compose/carousel_feed_render_test.dart`.

**Checkpoint**: Carousels publish and render in order; US1/US2 still work.

---

## Phase 6: User Story 4 — Resilient, non-duplicating upload (Priority: P2)

**Goal**: Visible progress + cancel + retry; interrupted/retried uploads never duplicate.

**Independent Test**: Drive fake progress/fail/cancel hooks — progress shows, cancel is clean, retry offered, and retrying yields exactly one post over 100 runs (S4 / SC-003, SC-004).

### Tests for User Story 4 ⚠️

- [ ] T046 [P] [US4] `bloc_test` `ComposeCubit` cancel path (loadedUploading → cancel → loaded with selection/edits intact) in `test/features/compose/compose_cancel_test.dart`.
- [ ] T047 [P] [US4] `bloc_test` failure + retry + **idempotency** (same key → exactly one post; no partial cache on failure) in `test/features/compose/compose_retry_idempotency_test.dart`.

### Implementation for User Story 4

- [ ] T048 [US4] Build `upload_progress` widget (determinate bar + cancel affordance) in `lib/features/compose/presentation/widgets/upload_progress.dart`; render on `loadedUploading`.
- [ ] T049 [US4] Wire cancel/retry in `ComposeCubit`: cancel aborts via `CancelToken` (no post, returns to `loaded`); failure → `error(draft kept)`; retry re-runs `publish()` with the same idempotency key (FR-017/018a/019) in `lib/features/compose/presentation/cubit/compose_cubit.dart`.
- [ ] T050 [US4] Ensure `PublishPost` writes to the Posts cache ONLY on full success (no partial post) and is safe to re-run with the same key in `lib/features/compose/domain/usecases/publish_post.dart`.

**Checkpoint**: Upload is observable, cancelable, retryable, and duplicate-free; earlier stories still work.

---

## Phase 7: User Story 5 — Post options & draft safety (Priority: P3)

**Goal**: Tag people / add location / turn off commenting; persist a single draft across app kill with keep/discard.

**Independent Test**: Add metadata + toggle, back out → keep, kill+relaunch → draft restored; publish carries metadata; discard clears it (S5 / SC-006).

### Tests for User Story 5 ⚠️

- [ ] T051 [P] [US5] Unit test `ComposeDraftStore` round-trip + `clearUserScoped` wipe in `test/features/compose/compose_draft_store_test.dart`.
- [ ] T052 [P] [US5] `bloc_test` draft restore + keep/discard + metadata carried to created post in `test/features/compose/compose_draft_test.dart`.

### Implementation for User Story 5

- [ ] T053 [US5] Add caption-step option rows to `caption_page`: Tag people (simple picker), Add location (lightweight), and the **Turn off commenting** toggle; **hide** "Also share to Stories" + "Add music" (FR-014, Q5) in `lib/features/compose/presentation/pages/caption_page.dart`.
- [ ] T054 [US5] Persist the draft on every mutation via `ComposeDraftStore.save`; on compose entry, read an existing draft and show a keep/discard `AppDialog` (restore or clear) in `lib/features/compose/presentation/cubit/compose_cubit.dart`.
- [ ] T055 [US5] On back-out mid-flow, trigger the keep/discard prompt via `BlocListener`; clear the draft on publish success or explicit discard; drop assets no longer present on restore (Constitution IX) in `lib/features/compose/presentation/pages/`.

**Checkpoint**: All five stories work independently; drafts survive app-kill.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [ ] T056 [P] Log-redaction test — assert no media paths/bytes/PII in logs across the flow (FR-024 / SC-008) in `test/features/compose/log_redaction_test.dart`.
- [ ] T057 [P] Edge-case widget tests: permission denied → settings CTA; undecodable file rejected; offline publish → deferred/retry (FR-007 + Edge Cases); **assert the compose routes are auth-gated** (unauthenticated → redirected by the #003 guard, FR-003) in `test/features/compose/compose_edge_cases_test.dart`.
- [ ] T058 [P] Accessibility + text-scaling + light/dark pass on all three pages (Semantics labels, Reduce-Motion static transitions) — assertions in the widget tests.
- [ ] T062 [P] Adaptive/tablet widget test — compose pages reflow by width (phone `<700` vs tablet `≥700` via the #001 adaptive shell, no forked screens, FR-022) in `test/features/compose/compose_adaptive_test.dart`.
- [ ] T059 Run the full Constitution gate: `dart format .` · `flutter analyze` (0 warn) · `flutter test` (all, incl. goldens + v3→v4 migration) · `dart run bloc_tools:bloc lint .` (0).
- [ ] T060 Execute [quickstart.md](quickstart.md) scenarios S1–S6 (fake mode; on-device gallery-permission check) and mark results.
- [ ] T061 [P] Update `.claude/claude-app/changelog.md` + `project-context.md` + `sdd-roadmap.md` for #007 completion (do at merge time).

---

## Dependencies & Execution Order

### Phase dependencies

- **Setup (P1)** → no deps.
- **Foundational (P2)** → depends on Setup; **BLOCKS all user stories**.
- **US1 (P3)** → after Foundational. MVP.
- **US2/US3/US4 (P4–6, all P2)** → after Foundational; build on US1's flow but are independently testable. US2 (edit) and US4 (upload UX) touch `ComposeCubit`/`edit_page` — sequence US2 → US3 → US4 to avoid same-file races when solo.
- **US5 (P7, P3)** → after Foundational; touches `caption_page` + `ComposeCubit`.
- **Polish (P8)** → after the desired stories.

### Within a story

Tests (fail first) → cubit/use-case → data/real+fake → pages/widgets → BlocListener wiring → goldens.

### Parallel opportunities

- Setup: T003 ∥ others after T001.
- Foundational: T004/T005/T006/T007 ∥; T011 ∥ T013 ∥ T015 ∥ T018 (different files) once their targets exist.
- Within each story, all `[P]` test tasks run together first; `[P]` widgets (different files) in parallel.
- Different stories can be staffed in parallel after Foundational (mind the shared-file notes above).

---

## Parallel Example: User Story 1

```bash
# Tests first (must fail):
Task: "bloc_test GalleryCubit in test/features/compose/gallery_cubit_test.dart"          # T020
Task: "bloc_test ComposeCubit publish in test/features/compose/compose_cubit_publish_test.dart"  # T021
Task: "Widget publish-flow test in test/features/compose/publish_flow_test.dart"         # T022
# Then parallel pages/widgets (different files):
Task: "pick_page + gallery_grid in lib/features/compose/presentation/pages/pick_page.dart"  # T028
Task: "caption_page in lib/features/compose/presentation/pages/caption_page.dart"        # T029
```

---

## Implementation Strategy

### MVP first (US1)

Setup → Foundational → US1 → **STOP & validate** (open Create, pick 1, caption, Share, see it atop the feed — S1). Demoable gate; first content a user can create.

### Incremental delivery

US1 (publish) → US2 (edit) → US3 (carousel) → US4 (resilient upload) → US5 (options + draft) → Phase 8. Each story is an independently testable increment that doesn't break the previous.

---

## Notes

- `[P]` = different files, no incomplete-task dependency. `[Story]` maps to spec User Stories.
- One canonical cached `Post` (#004) is the single render source — publish writes it and the feed repaints via `watchHomeFeed()` (Constitution IX). This feature adds no second post representation.
- Keep `diEnvironment = 'fake'`; `MediaUploadService`/`CreatePostRepository` real seams follow B#007; `PhotoLibraryService` real impl is env-agnostic (platform, not backend) with a test fake.
- drift v3→v4 is privacy-sensitive (Constitution I/IX): T008/T009 (+ `clearUserScoped`) get extra review.
- **FR-018a**: in-session retry/resume only; no persistent background queue surviving app-kill (T049/T050 + persisted draft T054 cover the kill-then-republish path).
- **SC-002 (preview < 100 ms)**: `ColorFilter.matrix` on the raster (no re-decode); baking runs on an isolate (T010) so the main thread stays smooth.
- Deferred (per clarifications): in-app camera capture, "Also share to Stories", "Add music" — hidden, not stubbed.
