# Implementation Plan: Create Post (Compose & Upload)

**Branch**: `007-create-post` | **Date**: 2026-07-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/007-create-post/spec.md`

## Summary

Build the first content-creation surface: a full-screen, nav-less **Compose flow** (Screens 11–13)
reached from the contextual **Create** action — **Pick → Edit → Caption → Publish**. The person
picks one or more photos from a **custom in-app gallery grid** (`photo_manager`, 4-col, selection
order, "Recents"), edits each per-photo (crop to 4:5 with `crop_your_image`; preset filters +
brightness/contrast/warmth previewed live via Flutter `ColorMatrix`), writes a caption (+ optional
tag people / location / turn-off-commenting), and publishes. Publish runs a reusable
**client-side media pipeline** — bake edits + compress on a background isolate (`image` package),
then upload with **visible progress + cancel**, and an **idempotent** create-post — after which the
new post is written into the **#004 canonical cached `Post`** so the Home feed shows it at top with
no manual refresh. A **single in-progress draft** persists locally (drift) and is restored across
app kill/restart. The app keeps running DI `environment: 'fake'`: `MediaUploadService` and
`CreatePostRepository` follow a documented real B#007 seam (`env:['real']`) plus in-memory fakes
(`env:['fake']`, the ones that actually run). Photos only; camera capture, "share to Stories", and
"add music" are deferred (per clarifications).

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (current toolchain).

**Primary Dependencies**:
- **New (verified on pub.dev 2026-07-01)**: `photo_manager ^3.9.0` + `photo_manager_image_provider ^2.2.0`
  (custom gallery grid — device albums/assets + thumbnail `ImageProvider`), `crop_your_image ^2.0.0`
  (pure-Flutter 4:5 crop, custom chrome), `image ^4.9.1` (pure-Dart bake color-matrix + resize/encode
  on isolate; also covers upload compression — no extra native plugin).
- **Reused**: `flutter_bloc`, `get_it`+`injectable`, `freezed`+`json_serializable`+`build_runner`,
  `drift`+`drift_flutter` (draft persistence + canonical post cache), `dio`/`ApiClient` (real seam
  only; fake runs), `uuid` (idempotency key), `cached_network_image`, `lucide_icons_flutter` (via
  `AppIcon`), `intl`/`gen-l10n`. Reuses #001 `TopBar`/`AppButton`/`AppIconButton`/`AppTextField`/
  `Toast`/`AdaptiveShell`/`AppDialog`/`ActionSheet` and #002 `ApiClient`/`FailureMapper`/`Result`/
  repository+fake pattern + #004 `Posts` cache + `watchHomeFeed()`.
- **Deferred (not added)**: `flutter_image_compress` — adopt only if isolate `image.encodeJpg` is
  profiled too slow on a mid-range device (documented fallback in research.md).

**Storage**: drift (`AppDatabase`) — **schema v3 → v4**: new `ComposeDrafts` table (single persisted
in-progress draft: serialized selected asset ids + per-item edit state + caption + metadata +
idempotency key). Non-destructive `onUpgrade` (create table when `from < 4`); `clearUserScoped()`
extended to wipe the draft on logout (privacy, Constitution I/IX). Migration test covers v3→v4.
Published posts write into the existing #004 `Posts` table (canonical cached representation).

**Testing**: `flutter test` + `bloc_test` + `mocktail` + goldens. Fakes drive every flow zero-network
(Constitution XII): `FakeCreatePostRepository`, `FakeMediaUploadService` (deterministic progress +
cancel + fail hooks), `FakePhotoLibraryService` (deterministic asset stubs — no device in CI).
Goldens for the three compose steps (light + dark). Migration test for v3→v4. Idempotency + rollback
unit tests. Log-redaction test (no media paths).

**Target Platform**: iOS + Android phones + iPad/Android tablets. Compose adapts by width, reusing
the #001 adaptive shell — no new nav model. Full-screen nav-less pushed routes (bottom nav hidden).

**Project Type**: Mobile app (Flutter), Clean Architecture feature-first — new `lib/features/compose/`
+ reusable media pipeline in `lib/core/services/` (`MediaUploadService`, `PhotoLibraryService`,
`ImageProcessingService`) for later reuse by #005/#006.

**Performance Goals**: single-photo publish (open → in feed) < 60 s typical (SC-001); filter/adjust
preview updates < 100 ms (SC-002, `ColorMatrix` on the raster, no re-decode); bake + compress off the
main isolate (no jank, Constitution II); carousel bake processed sequentially to bound peak memory.

**Constraints**: offline-buildable (zero network in tests); `lib/core/` MUST NOT import
`lib/features/`; **no media paths / bytes / PII in logs** (FR-024, Constitution I); idempotent create
never duplicates (FR-018); in-session retry/resume only — no background queue surviving app-kill
(FR-018a); single canonical cached `Post`; contextual photo-library permission with graceful denied
state; Reduce-Motion static transitions.

**Scale/Scope**: 3 screens, 5 user stories (US1 publish · US2 edit · US3 carousel · US4 resilient
upload · US5 options+draft), ~27 FR. New: 1 feature module (`compose/`), 3 core services (+fakes),
1 repository (+DTO/fake/real seam), 1 drift table + schema bump, 2–3 cubits, 3 pages + widgets, EN+VI
ARB. Carousel cap 10; caption cap 2,200.

## Constitution Check

*GATE: initial evaluation below; re-checked after Phase 1 (unchanged — see end).*

| Principle | Compliance in this plan |
|---|---|
| **I. Privacy, Safety & Trust** | Photo-library permission requested contextually with a clear reason and a graceful denied state (FR-007); **no media paths/bytes/PII logged** (FR-024) — enforced by a redaction test; persisted draft holds asset ids + edit state (no secrets) and is wiped on logout via `clearUserScoped()`; drift migration is non-destructive. |
| **II. Media-Centric Performance** | Grid thumbnails decoded at bounded resolution via `AssetEntityImage` thumb size; bake + resize + encode run on a **background isolate** (`image` `Command().executeThread()`); carousel baked sequentially (no all-in-memory); compress before upload; upload is progress+cancel (resumable within session). |
| **III. BLoC-Driven State** | `GalleryCubit` + `ComposeCubit`, freezed 4-state; extended variants `loadedEditing`/`loadedUploading(progress)`/`loadedPaginating`; side effects (toast, nav, dialog) via `BlocListener`; page-scoped providers; `@injectable`. |
| **IV. Code Quality** | freezed immutable state + json models; explicit types; `very_good_analysis` zero-warning; snake_case files, `{Feature}Cubit`/`State` naming. |
| **V. Result\<T\>** | Services/repos return `Result<T>`; reuses enumerated `AppFailure` `uploadFailed`/`mediaTooLarge`/`unsupportedMedia`/`permissionDenied`/`offline`/`networkError` — no new failure modes needed; Cubits `.fold()`, no try/catch. |
| **VI. Design System** | Tokens via `context.tokens`; reuses `TopBar`/`AppButton`/`AppTextField`/`Toast`/`ActionSheet`/`AppDialog`; new compose widgets built in `features/compose/presentation/widgets/` from tokens; Lucide via `AppIcon`; brand rose only on selection check / active filter / primary CTA. |
| **VII. Native Integration** | `photo_manager` platform permissions wired (iOS `NSPhotoLibraryUsageDescription`; Android 13+ `READ_MEDIA_IMAGES`); Cupertino/Material action sheets; safe-area respected; haptic on publish success. |
| **VIII. API & Realtime** | Upload + create-post go through `ApiClient` (real seam) behind `MediaUploadService`/`CreatePostRepository`; **no widget/Cubit touches HTTP**; endpoints centralized in `api_endpoints.dart`; error mapping in `FailureMapper`. |
| **IX. Data Integrity & Optimistic UX** | Idempotent create via uuid request id (FR-018); published post written to the **one canonical cached `Post`** (#004) so all screens repaint; draft survives app kill (FR-021); non-destructive migration + v3→v4 test; malformed asset skipped, not crashing. |
| **X. go_router Navigation** | Compose is pushed **nav-less full-screen** routes (`AppRoutes` constants); `context.push`/`pop`; back-out mid-flow triggers keep/discard dialog; no `Navigator.of` direct. |
| **XI. Feature-First Modularity** | New `features/compose/` (data/domain/presentation); reusable pipeline in `core/services/`; `core/` does not import `features/`; repository→repository forbidden (publish orchestrated by a use case). |
| **XII. Testing Discipline** | Fakes for repository + all three services; `bloc_test` for both cubits; widget tests for pick/edit/caption + publish path; goldens for 3 steps; migration + idempotency + rollback + redaction tests. |
| **XIII. Simplicity & YAGNI** | Photos-only, gallery-only, single draft; reuse `image` for compression instead of adding a second native plugin; filters implemented with built-in `ColorMatrix`; deferred toggles hidden not stubbed. |
| **XIV. i18n** | All copy in EN + VI ARB via `context.l10n`; counts/limits via `intl` helpers; `AppFailure` messages localized. |
| **XV. Dependency Hygiene** | `photo_manager`/`crop_your_image`/`image` versions + platform reqs + breaking-change notes sourced from pub.dev (2026-07-01) — see research.md; caret constraints; lock files committed; `flutter_image_compress` explicitly deferred. |

**Result**: PASS — no violations; no Complexity Tracking entries required.

## Project Structure

### Documentation (this feature)

```text
specs/007-create-post/
├── plan.md              # This file
├── research.md          # Phase 0 — package + pipeline decisions
├── data-model.md        # Phase 1 — entities, drift schema v3→v4, state shapes
├── quickstart.md        # Phase 1 — runnable validation scenarios
├── contracts/           # Phase 1 — service/repository + backend seam contracts
│   ├── README.md
│   ├── create-post-repository.md
│   ├── media-upload-service.md
│   ├── photo-library-service.md
│   └── compose-draft-store.md
└── tasks.md             # Phase 2 (/speckit-tasks — NOT created here)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart          # + media-upload + create-post paths
│   ├── data/
│   │   └── cache/
│   │       ├── app_database.dart       # schema v3 → v4
│   │       └── tables/
│   │           └── compose_draft_table.dart   # new: single persisted draft
│   └── services/
│       ├── media_upload_service.dart   # interface + real(env:real) + fake(env:fake)
│       ├── photo_library_service.dart  # interface + real(platform, env-agnostic) + fake(test)
│       └── image_processing_service.dart  # bake color-matrix + resize/encode (isolate, pure-Dart)
└── features/
    └── compose/
        ├── domain/
        │   ├── models/                 # ComposeDraft, SelectedMediaItem, MediaEditState, PostMetadata (freezed)
        │   ├── create_post_repository.dart   # interface → Result<Post>
        │   └── usecases/               # PublishPost, LoadDraft, SaveDraft, DiscardDraft
        ├── data/
        │   ├── create_post_repository_real.dart   # env:['real']
        │   ├── create_post_repository_fake.dart   # env:['fake'] (runs)
        │   ├── compose_draft_store.dart           # drift-backed draft read/write
        │   └── dtos/                              # create-post request/response DTOs
        └── presentation/
            ├── cubit/                  # GalleryCubit, ComposeCubit (+ freezed states)
            ├── pages/                  # pick_page, edit_page, caption_page
            └── widgets/                # gallery_grid, selection_badge, filter_row, adjust_slider, edit_stage, caption_field, upload_progress

test/
├── core/
│   ├── data/cache/migration_test.dart          # + v3→v4
│   └── services/                               # media_upload_fake, image_processing, photo_library_fake
└── features/compose/                           # gallery_cubit, compose_cubit, publish idempotency+rollback,
                                                # pick/edit/caption widget, redaction, goldens
```

**Structure Decision**: Feature-first. The **reusable media pipeline** (pick / process / upload)
lives in `lib/core/services/` so #005 Create Story and #006 comment media can consume it without
importing the compose feature. Compose-specific composition (the 3-step flow, its cubits, pages,
draft store) lives in `lib/features/compose/`. The published post is written into the existing #004
`Posts` cache — this feature adds no second post representation.

## Complexity Tracking

No constitution violations — section intentionally empty.
