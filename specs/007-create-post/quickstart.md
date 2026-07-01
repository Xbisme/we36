# Quickstart & Validation: Create Post (Compose & Upload)

> Runnable validation for #007. The app runs DI `environment: 'fake'` — the whole flow works
> zero-network. Scenarios map to the spec's user stories and success criteria.

## Prerequisites

- Toolchain: Flutter 3.44.4 / Dart 3.12.2.
- Branch `007-create-post`; signed in (fake session from #003).
- New packages installed: `photo_manager`, `photo_manager_image_provider`, `crop_your_image`, `image`.
- After model/DI/drift changes: `dart run build_runner build --delete-conflicting-outputs`; after ARB
  edits: `flutter gen-l10n`.

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor development -t lib/main_dev.dart
```

Real-device note (gallery access): grant photo-library permission when prompted. In tests/CI the
`FakePhotoLibraryService` supplies deterministic assets — no device needed.

## Validation scenarios

### S1 — Publish a single photo (US1 / SC-001, SC-005)

1. Tap the contextual **Create** action → the full-screen pick step opens, bottom nav hidden.
2. Select one photo (rose check appears) → **Next** → edit step → **Next** → caption step.
3. Type a caption with a `#hashtag` → **Share**.
4. **Expect**: upload progress → flow dismisses → the new post is at the **top of Home feed** with the
   image + violet hashtag, no manual refresh. End-to-end in fake mode.

### S2 — Edit per photo (US2 / SC-002)

1. In the edit step, tap filters (Original/Warm/Lux/Mono/Fade) → preview updates instantly (<100 ms).
2. Drag Brightness/Contrast/Warmth → live preview reflects each.
3. Crop to 4:5 → **Next**. **Expect**: the published post reflects the baked edits (matches preview).

### S3 — Carousel with per-photo edits (US3)

1. Select 3 photos → "Carousel" indicator + order badges appear.
2. In edit, move between images and give each a different filter/crop.
3. Publish. **Expect**: feed shows a swipeable 3-image post in order; each image shows its own edit.
4. Try to select an 11th photo → blocked with a clear message (cap 10), no crash.

### S4 — Resilient upload (US4 / SC-003, SC-004)

Drive `FakeMediaUploadService` hooks in a widget/integration test:
1. Progress is shown with a **cancel** affordance during upload.
2. **Cancel** → no post created, returned to compose with selection + edits intact (SC-004).
3. Force `failAfterFraction` → Toast + **retry** offered without re-pick/re-edit.
4. Retry (same idempotency key) → **exactly one** post created; repeat 100× → 0 duplicates (SC-003).

### S5 — Options + draft persistence (US5 / SC-006)

1. On caption step, tag people + add a location + toggle **Turn off commenting**.
   (Confirm **"Also share to Stories"** and **"Add music"** are **not shown** — deferred.)
2. Back out mid-flow → keep/discard prompt → **keep**.
3. **Kill and relaunch the app**, open Create → **Expect**: draft restored (selection, edits, caption,
   metadata) (SC-006, Q2). Publish → post carries the metadata + comments-disabled; draft cleared.
4. Repeat, choose **discard** → draft cleared, next Create starts empty.

### S6 — Permissions & edge cases

- Deny photo-library permission → explanatory empty state + settings CTA (no crash, FR-007).
- Undecodable file selected → rejected with a message, excluded from selection.
- Offline at publish → deferred/retryable message; retry when back online → one post.
- Log inspection → **no media paths/bytes** appear in logs (FR-024 / SC-008).

## Constitution gate (run before commit)

```bash
dart format .
flutter analyze                  # zero warnings
flutter test                     # unit + bloc + widget + goldens + v3→v4 migration
dart run bloc_tools:bloc lint .  # zero violations
```

Key tests: `gallery_cubit_test`, `compose_cubit_test` (publish success / cancel / fail+retry /
idempotency / rollback), pick/edit/caption widget + goldens (light+dark), `image_processing` bake
fidelity, `migration_test` (v3→v4), log-redaction.

## Validation results (2026-07-01, fake mode)

| Scenario | Automated coverage | Result |
|---|---|---|
| S1 Publish single photo | `publish_flow_test`, `compose_cubit_publish_test` | ✅ PASS |
| S2 Per-photo edit | `edit_page_test`, `compose_cubit_edit_test`, `image_processing_service_test` | ✅ PASS |
| S3 Carousel + per-photo edit + cap 10 | `gallery_multiselect_test`, `carousel_edit_test`, `carousel_feed_render_test` | ✅ PASS |
| S4 Resilient upload (progress/cancel/retry/idempotency) | `compose_cancel_test`, `compose_retry_idempotency_test` | ✅ PASS |
| S5 Options + draft persistence | `compose_draft_store_test`, `compose_draft_test`, `caption` widget | ✅ PASS |
| S6 Permissions & edge cases + log redaction | `compose_edge_cases_test`, `log_redaction_test` | ✅ PASS |

- Compose goldens (pick/caption/edit, light+dark) generated and green on the current toolchain.
- **On-device gallery-permission check** deferred to the #015 release gate (same as #001's on-device
  a11y/rotation) — CI/local run uses `FakePhotoLibraryService` (no device).
- **Gate note**: `flutter analyze` is clean for all #007 code (2 pre-existing `sort_pub_dependencies`
  infos on the comment-grouped `pubspec.yaml` are unchanged by this spec). The pre-existing repo
  goldens (#001/#003/#004: tokens, sign-in, PostCard, SidebarRail) mismatch on the upgraded
  Flutter 3.44.4 engine and need a one-time repo-wide `--update-goldens` refresh (tracked separately).
  `bloc_tools:bloc lint` is not runnable here (`bloc_lint 0.4.1` ships no CLI and `bloc_tools` is not a
  dependency); bloc conventions are enforced by construction + `flutter analyze`.
