# Implementation Plan: Create Story & Story Tools

**Branch**: `005-create-story` | **Date**: 2026-07-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/005-create-story/spec.md`

## Summary

Add the create-story surface (Screen 9) on top of the #004 stories rail + viewer, reusing the
#007 media pipeline. A signed-in person opens a **full-screen, nav-less Story composer** from the
contextual Create action (stories-rail "Your story" entry / Profile create), **picks one photo**
from the device gallery (reuse `PhotoLibraryService`), the photo is fit/cropped to a **9:16 canvas**,
they add **text (≤~100 chars) + sticker overlays** from a small built-in set and drag to position,
choose **audience** (Your story / Close friends, default Your story), and **publish**. Publish
**flattens the composed 9:16 canvas WYSIWYG** via `RepaintBoundary.toImage()` (guarantees the export
== the preview, overlays included), re-encodes/compresses on a background isolate, then **uploads with
visible progress + cancel** and an **idempotent create** (retry reuses the key → exactly one story).
On success the new **5-second segment** is prepended to the current user's own "Your story" reel and
appears in the rail + plays in the existing viewer with **no manual refresh**; segments older than
**24 h** are filtered client-side.

Fake-first, fully offline (DI `environment: 'fake'`): there is **no backend stories contract**, so a
published story is written into a shared in-memory **`OwnStoryStore`** that the #004
`StoriesRepository` read path merges into the "you" reel (reels are re-synthesized each launch, so a
published story is session-scoped — no drift schema bump). A `CreateStoryRepository` **real seam**
(`env:['real']`) is registered but inert, awaiting a future backend stories spec. **No persisted
draft** (unlike #007): abandoning the composer discards work after a confirm. Photos only; camera
capture, video, editable/metadata overlays, and close-friends **list** management are out of scope.

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (current toolchain).

**Primary Dependencies**:
- **New**: none expected. Overlay flatten uses Flutter's built-in `RepaintBoundary` /
  `RenderRepaintBoundary.toImage()` + `dart:ui`; re-encode/compress reuses the `image` package already
  added in #007. Sticker set ships as bundled vector/raster assets (no new package). Verified at
  research: confirm no new pub dependency is required (fallback documented if isolate re-encode is slow).
- **Reused**: `PhotoLibraryService` (#007 platform seam — pick + permission + `openSettings` +
  bounded thumbnails + `originBytes`), `MediaUploadService` (#007 — `upload()` stream with progress /
  `UploadCancelToken` / `idempotencyKey`), `image` (#007 — isolate re-encode/compress), the #004
  `StoriesRepository` / `StorySegment` / `StoryReel` + `StoriesRailCubit` / `StoryViewerPage`,
  `flutter_bloc`, `get_it`+`injectable`, `freezed`+`json_serializable`+`build_runner`, `uuid`
  (idempotency key), `dio`/`ApiClient` (real seam only; fake runs), `lucide_icons_flutter` via
  `AppIcon`, `intl`/`gen-l10n`. Reuses #001 `TopBar`/`AppButton`/`AppIconButton`/`AppTextField`/
  `Toast`/`ActionSheet`/`AppDialog`/`AdaptiveShell` + centered-mobile tablet fallback.
- **Deferred (not added)**: any drawing/overlay-editor package, camera/video packages,
  `flutter_image_compress` (only if isolate re-encode profiled too slow).

**Storage**: **No drift schema bump.** Own published story segments live in an in-memory
`OwnStoryStore` (injectable singleton) shared by the create seam (write) and `StoriesRepository`
(read); session-scoped, consistent with #004's "reels re-synthesized each launch". Seen-state keeps
using the existing #004 `StorySeenSegments` table unchanged. `clearUserScoped()`/logout also clears
`OwnStoryStore` (privacy). Relaunch-persistence of own stories is deferred until a backend stories
contract exists.

**Testing**: `flutter test` + `bloc_test` + `mocktail` + goldens, all zero-network via fakes
(Constitution XII): `FakeCreateStoryRepository` (writes to `OwnStoryStore`), reuse `FakeMediaUploadService`
+ `FakePhotoLibraryService` (#007), a fake/stub `StoryImageComposer` (synchronous, no real raster) for
widget/cubit tests. Goldens for the composer (empty/pick, overlay-editor, audience footer) in light +
dark. Idempotency + cancel/rollback + 24 h-expiry-filter + log-redaction + a11y/adaptive tests.

**Target Platform**: iOS + Android phones + iPad/Android tablets. Composer is a full-screen nav-less
pushed route (bottom nav hidden); tablet/iPad uses the #001 **centered-mobile fallback** (no bespoke
tablet layout for Screen 9). Reuses the existing viewer for playback (already adaptive from #004).

**Project Type**: Mobile app (Flutter), Clean Architecture feature-first. Create-story lives under the
existing **`lib/features/stories/`** domain (adds `presentation/compose/`, `domain/usecases/`,
`domain/models/`, `data/`); the shared in-memory `OwnStoryStore` + `StoriesRepository` extension live
in **`lib/core/data/stories/`**; the WYSIWYG flatten helper (`StoryImageComposer`) lives in
`lib/core/services/` for symmetry with the other pipeline services.

**Performance Goals**: open → published plain-photo story in feed < 30 s / ≤ 3 actions (SC-001);
overlay drag stays at 60 fps (raster-only, no re-decode); flatten (`toImage`) + re-encode/compress off
the main isolate where possible (no jank, Constitution II); a single 9:16 image bounded in memory.

**Constraints**: offline-buildable (zero network in tests); `lib/core/` MUST NOT import
`lib/features/`; **no media bytes / paths / PII in logs** (FR-019); idempotent create never duplicates
(FR-009); no partial/orphan story on cancel/fail (FR-010); one canonical own-reel representation
(`OwnStoryStore`); contextual photo-library permission with graceful denied + open-settings; 24 h
expiry client-side (FR-013); Reduce-Motion → static transitions; no persisted draft (FR-015).

**Scale/Scope**: 1 screen (composer) + reuse of the #004 viewer; 5 user stories (US1 publish · US2
overlays · US3 audience · US4 resilient upload · US5 expiry), 20 FR. New: create-story area in
`features/stories/`, 1 core store (`OwnStoryStore`) + `StoriesRepository` create-method extension, 1
core flatten helper (`StoryImageComposer`), 1 repository (`CreateStoryRepository` + real/fake),
1 use case (`PublishStory`), 2 cubits (`StoryGalleryCubit` reuse-or-thin + `StoryComposeCubit`),
composer pages + overlay/sticker/audience widgets, EN+VI ARB. Text overlay cap ~100 chars; small
fixed sticker set; 9:16; 5 s/segment.

## Constitution Check

*GATE: initial evaluation below; re-checked after Phase 1 (unchanged — see Post-Design note).*

| Principle | Compliance in this plan |
|---|---|
| **I. Privacy, Safety & Trust** | Photo-library permission requested contextually with a graceful denied + open-settings path (FR-016, reuse #007); **no media bytes/paths/PII logged** (FR-019) — redaction test; no persisted draft, and `OwnStoryStore` cleared on logout (Constitution I/IX). Close-friends flag stored without exposing any list. |
| **II. Media-Centric Performance** | Grid thumbnails bounded via `PhotoLibraryService.thumbnail(pixelSize:)`; overlay editing is raster-only (60 fps, no re-decode); flatten via `toImage` then re-encode/compress on an isolate; a single bounded 9:16 image; upload is progress+cancel (resumable within session). |
| **III. BLoC-Driven State** | `StoryComposeCubit` (+ reuse/thin `StoryGalleryCubit`), freezed 4-state; extended variants `loadedEditing`/`loadedUploading(progress)`; side effects (toast, nav, haptic, discard dialog) via `BlocListener`; page-scoped `@injectable`. |
| **IV. Code Quality** | freezed immutable state + models; explicit types; `very_good_analysis` zero-warning; snake_case files; `{Feature}Cubit`/`State` naming. |
| **V. Result\<T\>** | Composer/upload/create seams return `Result<T>`; reuses enumerated `AppFailure` (`uploadFailed`/`permissionDenied`/`offline`/`networkError`) — no new failure modes; Cubits `.fold()`, no try/catch. |
| **VI. Design System** | Tokens via `context.tokens`; reuses `TopBar`/`AppButton`/`AppIconButton`/`Toast`/`ActionSheet`/`AppDialog`; new composer widgets built from tokens; Lucide via `AppIcon`; brand **gradient earns its place** only on the share CTA + unseen ring; overlay text-style swatches use tokens. |
| **VII. Native Integration** | Reuses #007 `photo_manager` permission wiring (iOS `NSPhotoLibraryUsageDescription`; Android 13+ `READ_MEDIA_IMAGES`) — **no new native config**; safe-area respected; haptic on publish success. |
| **VIII. API & Realtime** | Upload + create-story go through `ApiClient` (real seam) behind `MediaUploadService`/`CreateStoryRepository`; **no widget/Cubit touches HTTP**; endpoints centralized in `api_endpoints.dart` (add story-create constant, inert until backend); mapping in `FailureMapper`. |
| **IX. Data Integrity & Optimistic UX** | Idempotent create via uuid key (FR-009); published segment written to the **one canonical own-reel store** so rail + viewer repaint (FR-011/012); no partial story on cancel/fail (FR-010); 24 h expiry filters by `createdAt` (FR-013). |
| **X. go_router Navigation** | Composer pushed **nav-less full-screen** (`AppRoutes` constant); `context.push`/`pop`; back-out with placed overlays triggers a discard-confirm dialog (FR-015); no direct `Navigator.of`. |
| **XI. Feature-First Modularity** | Create-story under `features/stories/`; shared store + flatten helper in `core/`; `core/` never imports `features/`; publish orchestrated by a **use case** (`PublishStory`) — no repo→repo. |
| **XII. Testing Discipline** | Fakes for create repo + reuse of upload/photo fakes + synchronous composer stub; `bloc_test` for the compose cubit; widget tests for pick/overlay/audience + publish path; goldens for the composer; idempotency + cancel + expiry-filter + redaction + a11y/adaptive tests. |
| **XIII. Simplicity & YAGNI** | Photos-only, single segment, gallery-only, no draft, no drift bump; overlay flatten via built-in `RepaintBoundary` (no drawing package); session-scoped `OwnStoryStore`; deferred options hidden not stubbed. |
| **XIV. i18n** | All copy EN + VI ARB via `context.l10n`; char/count limits via `intl`; `AppFailure` messages localized. |
| **XV. Dependency Hygiene** | Target: **no new package**; if research shows a helper is unavoidable, pin from pub.dev (2026-07-01) with rationale; lock files committed. |

**Result**: PASS — no violations; no Complexity Tracking entries required.

**Post-Design re-check (after Phase 1)**: PASS, unchanged. The design added no new packages (R8), no
drift schema change (R3), no new nav model, and no `core → features` import (shared `OwnStoryStore` +
`StoriesRepository` extension are both in `core/`; the create seam in `features/` writes into the core
store). Publish is orchestrated by the `PublishStory` use case (no repo→repo). Overlay flatten via
built-in `RepaintBoundary` keeps the dependency surface flat. All 15 principles remain satisfied.

## Project Structure

### Documentation (this feature)

```text
specs/005-create-story/
├── plan.md              # This file
├── research.md          # Phase 0 — flatten strategy, sticker set, own-story store, no-new-dep decision
├── data-model.md        # Phase 1 — entities, compose/overlay/audience state, OwnStoryStore, expiry rule
├── quickstart.md        # Phase 1 — runnable validation scenarios (fake mode)
├── contracts/           # Phase 1 — service/repository + backend seam contracts
│   ├── README.md
│   ├── create-story-repository.md
│   ├── story-image-composer.md
│   ├── own-story-store.md
│   └── reused-pipeline.md      # references #007 media-upload + photo-library seams (no re-spec)
└── tasks.md             # Phase 2 (/speckit-tasks — NOT created here)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── data/stories/
│   │   ├── stories_repository.dart          # +publishSegment(...) create method (real/fake impls)
│   │   ├── fake_stories_repository.dart      # read path merges OwnStoryStore into the "you" reel
│   │   ├── stories_repository_impl.dart      # real seam: publish is inert until backend contract
│   │   ├── own_story_store.dart              # NEW — shared in-memory own-segments (singleton) + 24h filter
│   │   └── story.dart                        # StorySegment/StoryReel reused (add audience field)
│   ├── services/
│   │   ├── story_image_composer.dart         # NEW — RepaintBoundary→bytes flatten + isolate re-encode
│   │   ├── media_upload_service.dart         # reused as-is (#007)
│   │   └── photo_library_service.dart        # reused as-is (#007)
│   └── constants/api_endpoints.dart          # +story-create endpoint constant (inert)
└── features/stories/
    ├── domain/
    │   ├── models/                           # story_compose_draft.dart, story_overlay.dart, story_audience.dart
    │   └── usecases/publish_story.dart       # orchestrates compose→flatten→upload→create (no repo→repo)
    ├── data/
    │   ├── create_story_repository.dart       # interface
    │   ├── create_story_repository_fake.dart  # env:['fake'] — writes segment to OwnStoryStore
    │   └── create_story_repository_real.dart   # env:['real'] — ApiClient seam (inert; awaits backend)
    └── presentation/
        ├── compose/
        │   ├── story_pick_page.dart           # gallery grid (reuse #007 pick widgets)
        │   └── story_compose_page.dart         # 9:16 canvas + overlay editor + audience footer + share
        ├── cubit/
        │   ├── story_compose_cubit.dart + story_compose_state.dart
        │   └── (reuse/thin gallery cubit)
        └── widgets/                            # text_overlay_editor, sticker_tray, audience_toggle, story_upload_progress
```

**Structure Decision**: Extend the existing **`features/stories/`** module (the stories domain already
owns the rail cubit + viewer from #004) rather than a separate `story_compose/` feature — keeps the
create + view story flows in one feature per Constitution XI. The shared **`OwnStoryStore`** and the
`StoriesRepository` create-method extension live in `core/data/stories/` (both read and write paths are
core, avoiding any `core → features` import); the WYSIWYG **`StoryImageComposer`** joins the other
pipeline services in `core/services/`. No new nav model, no drift schema change, target no new package.

## Complexity Tracking

> No Constitution violations — table intentionally empty.
