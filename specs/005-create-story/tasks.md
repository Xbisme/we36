---
description: "Task list for Create Story & Story Tools (#005)"
---

# Tasks: Create Story & Story Tools

**Input**: Design documents from `specs/005-create-story/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: INCLUDED — the constitution mandates Testing Discipline (XII) and the plan enumerates the suites. Test tasks are written before/with their implementation and must pass green.

**Organization**: Grouped by user story (US1–US5, priority order). US1 is the MVP; each later story is an independently testable increment on top of it.

## Format: `[ID] [P?] [Story?] Description with file path`

- **[P]** = parallelizable (different files, no dependency on an incomplete task).
- **[Story]** = US1..US5 (setup/foundational/polish have no story label).
- Fake-first: everything runs in DI `environment: 'fake'`, zero-network. Reuses the #004 rail/viewer + #007 pipeline (`PhotoLibraryService`, `MediaUploadService`, `image`).

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Assets, constants, and copy the whole feature depends on.

- [X] T001 Confirm **no new pub dependency** is required (reuse `image` from #007 for isolate JPEG re-encode; overlays use Flutter built-ins) per research R8; add a small **bundled sticker set** under `assets/stickers/` and declare it in `pubspec.yaml` `flutter/assets`.
- [X] T002 [P] Add EN + VI ARB keys for the story composer copy (share, "Your story", "Close friends", add text, discard-story dialog, upload-failed, retry, cancel, empty-gallery, permission-denied/open-settings) in `lib/l10n/arb/app_en.arb` + `app_vi.arb`; run `gen-l10n`.
- [X] T003 [P] Add `AppRoutes.storyCompose` (nav-less full-screen) in `lib/core/constants/` routes + a story-create endpoint constant (inert) in `lib/core/constants/api_endpoints.dart`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The shared create-story spine (models, store, composer service, create seam, use case, DI). **⚠️ No user story can begin until this phase is complete.**

- [X] T004 [P] Define freezed domain models in `lib/features/stories/domain/models/`: `story_audience.dart` (enum `yourStory`/`closeFriends`), `story_text_overlay.dart`, `story_sticker_overlay.dart`, `story_compose_draft.dart` (assetId + overlays + audience + idempotencyKey); run `build_runner`.
- [X] T005 Extend `StorySegment` with `@Default(StoryAudience.yourStory) StoryAudience audience` (non-breaking) in `lib/core/data/stories/story.dart`; regen freezed; confirm #004 rail/viewer usages still compile.
- [X] T006 [P] Implement `OwnStoryStore` (`@lazySingleton`: `add`, `activeSegments()` with 24h `createdAt` filter + **injected clock**, `changes` stream/Listenable, `clear`) in `lib/core/data/stories/own_story_store.dart` (contract: [own-story-store.md](contracts/own-story-store.md)).
- [X] T007 [P] Unit test `OwnStoryStore` (add → activeSegments returns it; `clear` empties; `changes` emits on add) in `test/core/data/stories/own_story_store_test.dart` (24h-expiry case lands in US5).
- [X] T008 Extend the `StoriesRepository` create path: add `publishSegment(...)` to the interface; wire `FakeStoriesRepository.loadReels()` to **merge `OwnStoryStore.activeSegments()` (prepended, newest first)** into the `isYou:'you'` reel + recompute `hasUnseen`/`latestAt`; leave `stories_repository_impl.dart` real publish **inert** — in `lib/core/data/stories/`. Also add a `WatchOwnStoryChanges` use case (wrapping `OwnStoryStore.changes`) in `lib/features/stories/domain/usecases/` so the rail can react (consumed in T022).
- [X] T009 [P] Implement `StoryImageComposer` (`RepaintBoundary`→`toImage(pixelRatio)`→isolate JPEG re-encode via `image`, deterministic 1080×1920) + a synchronous `FakeStoryImageComposer` stub + DI, in `lib/core/services/story_image_composer.dart` (contract: [story-image-composer.md](contracts/story-image-composer.md)).
- [X] T010 [P] Define `CreateStoryRepository` interface (`publish({imageBytes, audience, idempotencyKey, cancelToken, onProgress})`) in `lib/features/stories/data/create_story_repository.dart` (contract: [create-story-repository.md](contracts/create-story-repository.md)).
- [X] T011 Implement `FakeCreateStoryRepository` (`env:['fake']`, runs): drive `FakeMediaUploadService` progress → keep the flattened JPEG bytes **in `OwnStoryStore`** and set `StorySegment.imageUrl` to a `memory://<id>` ref (no disk / no new dependency — see T020a) → synthesize `StorySegment` (author = fake `Me`, `durationMs:5000`, `createdAt:now`, `audience`) → `OwnStoryStore.add(segment, bytes:)`; **dedupe by `idempotencyKey`** so retry ⇒ one segment; in `lib/features/stories/data/create_story_repository_fake.dart` + DI.
- [X] T012 [P] Implement `CreateStoryRepositoryReal` (`env:['real']`, **inert**): documented `ApiClient` multipart seam returning `unsupported` until a backend stories contract exists, in `lib/features/stories/data/create_story_repository_real.dart` + DI.
- [X] T013 Implement `PublishStory` use case (flatten via `StoryImageComposer` → `CreateStoryRepository.publish` with progress/cancel + one idempotency key per session; **no repo→repo**) in `lib/features/stories/domain/usecases/publish_story.dart` + DI.
- [X] T014 Wire `OwnStoryStore.clear()` into the logout / `clearUserScoped()` path so own stories are wiped on sign-out (privacy, Constitution I/IX).

**Checkpoint**: Shared spine ready — user stories can begin.

---

## Phase 3: User Story 1 — Publish a photo to your story (Priority: P1) 🎯 MVP

**Goal**: Pick one photo → Share → it appears at the front of "Your story" and plays in the viewer, fully offline, no manual refresh.

**Independent Test**: Open composer from the rail/Profile, pick a photo, tap Share; confirm the rail shows an unseen "Your story" ring with no refresh and the viewer plays the 5 s photo.

### Tests for User Story 1

- [ ] T015 [P] [US1] `bloc_test` `StoryComposeCubit` publish-success path (loaded → loadedUploading → success writes a segment to `OwnStoryStore`) in `test/features/stories/story_compose_cubit_test.dart`.
- [ ] T016 [P] [US1] Widget test the pick → Share happy path + own-reel update, using `FakeStoryImageComposer` + `FakeMediaUploadService` + `FakePhotoLibraryService` (logic-first, `pump(Duration)` not settle) in `test/features/stories/story_publish_flow_test.dart`.

### Implementation for User Story 1

- [ ] T017 [US1] Implement `StoryGalleryCubit` (+ freezed state: loading/loaded/loadedPaginating/error) — permission, paged Recents, **single-select** — in `lib/features/stories/presentation/cubit/story_gallery_cubit.dart` (reuse #007 gallery patterns).
- [ ] T018 [US1] Implement `StoryComposeCubit` + `StoryComposeState` (loaded/loadedUploading/error; build draft from picked asset; `publish()` drives `PublishStory`; disabled while uploading — FR-017) in `lib/features/stories/presentation/cubit/`.
- [ ] T019 [US1] Build `story_pick_page` (reuse #007 gallery grid widgets, single-select, "Recents", Next disabled until 1 selected) in `lib/features/stories/presentation/compose/story_pick_page.dart`.
- [ ] T020 [US1] Build `story_compose_page` MVP: **9:16 canvas** (cover-fit photo) wrapped in a `RepaintBoundary` (GlobalKey) + Share button; footer shows default "Your story" (audience UI arrives US3) in `lib/features/stories/presentation/compose/story_compose_page.dart`.
- [ ] T020a [US1] Extend the #004 story image rendering (rail avatar + `story_viewer_page`) with a **story image resolver**: render `memory://<id>` `imageUrl`s via `MemoryImage(OwnStoryStore.bytesFor(id))` (and keep network/asset paths working) so an offline-published own story actually displays in the viewer (resolves analysis finding U1) — in `lib/features/stories/presentation/` (+ a shared image-resolver helper).
- [ ] T021 [US1] Wire the `storyCompose` route (nav-less full-screen, bottom nav hidden) + entry points from the stories-rail "Your story" tap and the Profile create action, via `go_router` (`context.push`/`pop`).
- [ ] T022 [US1] Wire success side effects via `BlocListener` (success Toast + haptic + pop flow); **and make the rail auto-repaint**: inject `WatchOwnStoryChanges` (from T008) into the #004 `StoriesRailCubit` and re-run `load()` on each emit so a newly published story appears with no manual refresh (FR-011). Side effects never in `BlocBuilder`.
- [ ] T023 [P] [US1] Golden tests for the pick page + MVP compose canvas (light + dark) in `test/features/stories/story_compose_goldens_test.dart`.

**Checkpoint**: MVP — a plain photo story publishes and appears in the rail + viewer, fully in fake mode. STOP & validate.

---

## Phase 4: User Story 2 — Decorate with text and stickers (Priority: P2)

**Goal**: Add baked text + sticker overlays; published result is pixel-identical to the preview.

**Independent Test**: Add a text line + sticker, drag to position, Share; open the story and confirm decorations match the preview; typing past ~100 chars is blocked.

### Tests for User Story 2

- [ ] T024 [P] [US2] Widget test add / move / remove text + sticker overlays and the **~100-char text limit** (AS-2.6) in `test/features/stories/story_overlay_test.dart`.
- [ ] T025 [P] [US2] Test that the flattened output includes overlays — assert the `RepaintBoundary` subtree contains the placed overlays handed to `StoryImageComposer` (preview == export, FR-005) in `test/features/stories/story_overlay_bake_test.dart`.

### Implementation for User Story 2

- [ ] T026 [US2] Build `text_overlay_editor` widget (single line ≤ ~100 chars via input formatter, token-driven style/color swatches, draggable) in `lib/features/stories/presentation/widgets/text_overlay_editor.dart`.
- [ ] T027 [US2] Build `sticker_tray` widget (fixed bundled set, tap-to-add) + draggable `Positioned` sticker in `lib/features/stories/presentation/widgets/sticker_tray.dart`.
- [ ] T028 [US2] Extend `StoryComposeCubit` + `StoryComposeDraft` with add / update-position / remove for text + sticker overlays in `lib/features/stories/presentation/cubit/story_compose_cubit.dart`.
- [ ] T029 [US2] Render overlays as normalized-position `Positioned` children inside the `RepaintBoundary` 9:16 canvas on `story_compose_page` (baked at publish by the existing flatten — no new bake code).
- [ ] T030 [US2] Add discard-confirm `AppDialog` on back-out when the draft has a photo or placed overlays (FR-015) — wired via `BlocListener`/router pop guard.
- [ ] T031 [P] [US2] Golden test the compose canvas with text + sticker overlays (light + dark) in `test/features/stories/story_compose_goldens_test.dart`.

**Checkpoint**: US1 + US2 both work independently.

---

## Phase 5: User Story 3 — Choose who can see it (Priority: P2)

**Goal**: Pick audience (Your story / Close friends, default Your story) and record it on the story.

**Independent Test**: Toggle to "Close friends", Share; confirm the segment records `closeFriends` and is marked as such to the creator; publishing works with no close-friends list.

### Tests for User Story 3

- [ ] T032 [P] [US3] `bloc_test` audience toggle + publish records the chosen `audience`; `closeFriends` allowed with no list (FR-007) in `test/features/stories/story_audience_test.dart`.

### Implementation for User Story 3

- [ ] T033 [US3] Build `audience_toggle` widget (Your story / Close friends, default Your story) with the brand **gradient share CTA** in `lib/features/stories/presentation/widgets/audience_toggle.dart`.
- [ ] T034 [US3] Wire audience into `StoryComposeDraft` → `PublishStory` → `StorySegment.audience`; mark close-friends where shown to the creator (own-reel / viewer marker) — `lib/features/stories/...`.

**Checkpoint**: US1–US3 work independently.

---

## Phase 6: User Story 4 — Resilient publishing (Priority: P2)

**Goal**: Visible progress + cancel; failure → retry; retry never duplicates; no partial story.

**Independent Test**: Start Share → see progress; cancel mid-upload → nothing added; force failure → retry affordance; retry → exactly one story.

### Tests for User Story 4

- [ ] T035 [P] [US4] Test cancel writes nothing to `OwnStoryStore` + a failed-then-retried publish (same idempotency key) yields **exactly one** story (FR-009/010, SC-004/005) in `test/features/stories/story_upload_cancel_retry_test.dart`.

### Implementation for User Story 4

- [ ] T036 [US4] Build `story_upload_progress` widget (progress bar + cancel) in `lib/features/stories/presentation/widgets/story_upload_progress.dart`.
- [ ] T037 [US4] Extend `StoryComposeCubit` `loadedUploading(progress)` + `cancel()` (via `UploadCancelToken`) + retry that **reuses the session idempotency key**; ensure no partial `OwnStoryStore` write on cancel/fail.
- [ ] T038 [US4] Wire progress / cancel / failure-retry UI on `story_compose_page` (progress overlay + failure Toast + retry affordance) via `BlocListener`/`BlocBuilder`.

**Checkpoint**: US1–US4 work independently.

---

## Phase 7: User Story 5 — Stories expire after 24 hours (Priority: P3)

**Goal**: Segments older than 24h are excluded from the rail + viewer; "Your story" shows no ring when all expired.

**Independent Test**: Seed an own segment `createdAt` > 24h ago → absent from rail/viewer, no ring; a < 24h one shows.

### Tests for User Story 5

- [ ] T039 [P] [US5] Unit test the 24h expiry via **injected clock**: a 25h-old segment is excluded, a < 24h one included, all-expired ⇒ "Your story" `hasUnseen == false` in `test/core/data/stories/own_story_store_expiry_test.dart`.

### Implementation for User Story 5

- [ ] T040 [US5] Ensure `OwnStoryStore.activeSegments()` 24h filter drives the `FakeStoriesRepository` own-reel merge and the "Your story" `hasUnseen` recompute (expired excluded); expose the clock seam for tests — `lib/core/data/stories/`.

**Checkpoint**: All user stories independently functional.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [ ] T041 [P] Log-redaction test — no media bytes/paths/PII in logs during pick/flatten/upload (FR-019) in `test/features/stories/story_compose_redaction_test.dart`.
- [ ] T042 [P] a11y + text-scaling + adaptive test (Semantics, large text, tablet **centered-mobile fallback** for Screen 9) in `test/features/stories/story_compose_a11y_test.dart`.
- [ ] T043 [P] [US1] Wire + test empty-gallery and permission-denied (with open-settings) states on `story_pick_page`, reusing #007 patterns, in `test/features/stories/story_pick_states_test.dart`.
- [ ] T044 Run the pre-commit gate: `dart format .` · `flutter analyze` (zero warnings) · `flutter test` (all green) · `dart run bloc_tools:bloc lint .` (if runnable).
- [ ] T045 Execute [quickstart.md](quickstart.md) manual scenarios 1–7 in fake mode and record the sign-off.
- [ ] T046 At merge: add the #005 changelog entry + update `project-context.md` / `sdd-roadmap.md` spec status (🟡 → ✅) + the `decisions/spec-005-create-story.md` cross-links.

---

## Dependencies & Execution Order

### Phase dependencies
- **Setup (P1)**: no dependencies.
- **Foundational (P2)**: depends on Setup; **blocks all user stories**.
- **User Stories (P3–P7)**: all depend on Foundational. US1 is the MVP; US2/US3/US4 build on US1's cubit + compose page (sequential-friendly but each independently testable); US5 depends only on the Foundational store.
- **Polish (P8)**: after the targeted stories.

### Story dependencies
- **US1 (P1)**: after Foundational. No dependency on other stories.
- **US2 (P2)**: extends US1's `StoryComposeCubit` + compose page (overlays).
- **US3 (P2)**: extends US1's draft/publish (audience) — independent of US2.
- **US4 (P2)**: extends US1's publish (progress/cancel/retry) — independent of US2/US3.
- **US5 (P3)**: depends only on Foundational `OwnStoryStore` — independent of US1–US4 UI.

### Within each story
- Tests written with implementation and must pass; models → cubit → page → wiring.

### Parallel opportunities
- Setup: T002, T003 in parallel.
- Foundational: T004, T006, T007, T009, T010, T012 are `[P]` (distinct files); T005/T008/T011/T013/T014 have ordering deps.
- US1 tests T015, T016 in parallel; golden T023 parallel after the page exists.
- US2 tests T024, T025 parallel; US3 T032, US4 T035, US5 T039 parallel within their phases.
- Polish T041, T042, T043 in parallel.

---

## Parallel Example: Foundational

```bash
# Distinct-file foundational tasks can run together:
Task: "T004 domain models in features/stories/domain/models/"
Task: "T006 OwnStoryStore in core/data/stories/own_story_store.dart"
Task: "T009 StoryImageComposer in core/services/story_image_composer.dart"
Task: "T010 CreateStoryRepository interface in features/stories/data/"
```

## Parallel Example: User Story 1

```bash
Task: "T015 bloc_test StoryComposeCubit publish-success"
Task: "T016 widget test pick→share happy path"
```

---

## Implementation Strategy

### MVP first (US1 only)
1. Phase 1 Setup → Phase 2 Foundational (critical, blocks all).
2. Phase 3 US1 → **STOP & validate**: a plain photo story publishes and appears in the rail + viewer, offline.
3. Demo the MVP.

### Incremental delivery
US1 (MVP) → US2 overlays → US3 audience → US4 resilient upload → US5 expiry → Polish. Each adds value without breaking prior stories.

---

## Notes
- `[P]` = different files, no incomplete-task dependency.
- Reuse over rebuild: `PhotoLibraryService` / `MediaUploadService` / `image` (#007) and the #004 rail/viewer are consumed as-is; only `StorySegment` gains an optional `audience` field.
- **Test gotcha (from #007)**: real `MemoryImage` + go_router in widget tests hang `pumpAndSettle`. Inject the synchronous `FakeStoryImageComposer` + fakes, test logic-first via cubits, and use fixed `pump(Duration)`.
- No drift schema change; no new pub dependency (target); no new native config.
- Commit after each task or logical group; stop at any checkpoint to validate a story independently.
