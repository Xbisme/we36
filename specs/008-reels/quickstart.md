# Quickstart & Validation: Reels (#008)

How to run and validate the Reels feature end-to-end. App runs DI `environment: 'fake'` — **zero network** (FR-029). See [spec.md](spec.md), [data-model.md](data-model.md), [contracts/reels-api.md](contracts/reels-api.md).

## Prerequisites
- Flutter 3.44.4 / Dart 3.12.2 (canonical baseline).
- `flutter pub get` after `video_player ^2.11.1` lands in `pubspec.yaml`.
- `dart run build_runner build --delete-conflicting-outputs` (freezed/injectable/drift codegen for `Reel`, `ReelsCubit` state, `ReelsDao`, DI).

## Run
```bash
flutter run --flavor development -t lib/main_dev.dart
```
Navigate to the **Reels** tab (3rd of 5). On tablet/iPad the sidebar rail replaces the bottom nav.

## Manual validation scenarios (map to user stories)

### US1 — Watch feed (P1)
1. Open Reels → first (newest) reel plays automatically and loops. ✅ SC-001 (<2s to first frame).
2. Tap the video → pauses; tap again → resumes.
3. Swipe up → next reel plays, previous stops. Swipe down → returns.
4. Keep swiping past the first page → more reels append seamlessly.
5. Scroll fast through many reels → at most 3 videos initialized at once (active ±1); no OOM. ✅ SC-002/SC-003.
6. Kill network / empty fake → explicit empty, loading, and error-with-retry states; cached reels render offline. ✅ FR-007.

### US2 — Engage (P2)
1. Tap like → fills + count +1 instantly (<100ms, before any server echo); tap again reverts. ✅ SC-004.
2. Set `FakeReelsRepository.failNextMutation` → like rolls back + Toast. ✅ FR-011.
3. Tap save/unsave → same instant + rollback behavior.
4. Tap comment → comments **bottom sheet** opens over the (still-playing) reel; add a comment → count +1 on the reel; a `commentsDisabled` reel shows the comment action as unavailable. ✅ FR-015.
5. Caption with `@mention` / `#hashtag` → tokens styled violet (non-tappable). ✅ FR-009.
6. Tap share / follow → Toast acknowledgement only. ✅ FR-016.

### US3 — Create & publish (P3)
1. From the Create action → reel compose → pick a video from the gallery (grant permission contextually).
2. Pick a >90s video → rejected with a clear message. ✅ FR-017.
3. Add caption + tag people + location + comments-off → publish.
4. Upload shows a cancellable progress bar; cancel → no reel created. ✅ FR-019.
5. Simulate a mid-upload failure → retry → exactly one reel (idempotency key reused). ✅ FR-020/SC-005.
6. On success the new reel appears at the **top of the feed** with a **processing** badge, then auto-flips to playable (fake simulated delay). ✅ FR-021/FR-023.
7. Try to leave compose with a selected video → discard-confirm. ✅ FR-022.
8. Delete your own reel (action → confirm) → it disappears. ✅ FR-024.

### US4 — Accessible / resilient / adaptive (P4)
1. Enable Reduce Motion → reels do NOT autoplay-loop; poster shown with tap-to-play. ✅ FR-026/SC-007.
2. All messages appear as toasts (never SnackBar/dialog). ✅ FR-025.
3. Screen reader announces author, caption, and each action-rail control. ✅ FR-027/SC-009.
4. Large text scale + light/dark render correctly.
5. Tablet/iPad → adapted layout (centered/constrained video column per §Responsive), not a stretched phone layout. ✅ FR-028.
6. Silent switch on (iOS) → active reel plays without sound.

## Automated test coverage (authoritative — Constitution XII)
Run: `flutter test` (or `very_good test --test-randomize-ordering-seed random`).
- **Fake repo**: `FakeReelsRepository` feed pagination, optimistic like/save + `failNextMutation` rollback, `createReel` processing→ready flip, delete.
- **Cubit (`bloc_test`)**: `ReelsCubit` load/paginate/refresh/error; like/save optimistic + rollback; canonical reel from `watchReel`. Create cubit: pick→validate(≤90s)→publish (progress/cancel/retry idempotency).
- **Playback lifecycle (unit)**: `ReelPlaybackController` window bounding (≤3 controllers), active-only play, off-screen dispose. ✅ SC-002/SC-003.
- **Comment seam (unit)**: reel add/delete routes count delta to `ReelsRepository.applyCommentCountDelta`.
- **Migration**: drift v4→v5 (`Reels` table added, existing data intact).
- **Widget**: reels page render + swipe (fixed `pump(Duration)`, avoid `pumpAndSettle` with video/router — carried #006 gotcha), action rail, Reduce-Motion poster path, adaptive (phone vs tablet). Redaction test: no media URLs/tokens logged.
- **Goldens**: reel card / action rail (light + dark), processing badge.

## Pre-commit gate (Constitution)
```bash
dart format .
flutter analyze                  # zero warnings
flutter test                     # all pass
dart run bloc_tools:bloc lint .  # zero violations (no local CLI — carried limitation)
```
