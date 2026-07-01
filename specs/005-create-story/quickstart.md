# Quickstart — Create Story & Story Tools (#005)

Validation guide for the create-story flow. Everything runs **offline** in DI `environment:'fake'`
(Constitution XII) — no backend. Implementation details live in `tasks.md`; this file proves the
feature end-to-end.

## Prerequisites
- Flutter 3.44.4 / Dart 3.12.2; deps fetched (`flutter pub get`); codegen run
  (`dart run build_runner build --delete-conflicting-outputs`) for freezed models.
- App on the dev flavor (`main_dev.dart`), signed in (fake session from #003).

## Automated validation (authoritative)
```bash
dart format .
flutter analyze                 # zero warnings
flutter test                    # all green, incl. the #005 suites below
dart run bloc_tools:bloc lint . # zero violations (if runnable locally)
```

Key #005 test targets:
- `test/features/stories/story_compose_cubit_test.dart` — build draft, publish success → segment in
  `OwnStoryStore`; uploading/progress state; error path.
- `test/features/stories/story_publish_flow_test.dart` — pick → (overlay) → share → own reel updated.
- `test/features/stories/story_overlay_test.dart` — add/move/remove text+sticker; text ≤100 chars (AS-2.6).
- `test/features/stories/story_upload_cancel_retry_test.dart` — cancel writes nothing; retry same key ⇒ 1 story.
- `test/core/data/stories/own_story_store_test.dart` — active filter, 24h expiry via injected clock, clear.
- `test/features/stories/story_compose_goldens_test.dart` — composer light+dark (pick / overlay / audience).
- `test/features/stories/story_compose_redaction_test.dart` — no media bytes/paths in logs.

> Use the synchronous `FakeStoryImageComposer` + `FakeMediaUploadService` + `FakePhotoLibraryService`
> in widget/cubit tests; avoid real rasterization and `pumpAndSettle` with live images (the #007
> lesson: prefer fixed `pump(Duration)` and logic-first cubit assertions).

## Manual scenarios (fake mode)

1. **Publish a plain photo (US1 / MVP)** — Home → tap "Your story" (or Profile create) → composer opens
   full-screen (no bottom nav) → pick a photo → tap Share → composer closes, "Your story" shows an
   unseen ring at the front of the rail with **no manual refresh** → open it → plays full-screen 5 s.
2. **Overlays (US2)** — in the composer add a text line + a sticker, drag to position → Share → open the
   story → decorations appear exactly as arranged (pixel-identical). Type past ~100 chars → blocked.
3. **Audience (US3)** — toggle footer to "Close friends" (default is "Your story") → Share → the story
   is marked close-friends where shown to you; publishing works even with no close-friends list.
4. **Resilient upload (US4)** — start Share, watch progress; Cancel mid-upload → nothing added, composer
   editable again; force failure → toast + retry affordance; Retry → exactly one story appears.
5. **Expiry (US5)** — with a seeded own segment `createdAt` > 24h ago, confirm it is absent from rail +
   viewer and "Your story" shows no ring; a < 24h segment still shows.
6. **Permission denied** — deny photo access → clear explanation + open-settings path (reuse #007); no
   crash / blank grid. Empty gallery → friendly empty state.
7. **Abandon** — place an overlay then tap back/close → discard-confirm dialog; confirm discards (no
   draft persisted); relaunch shows no in-progress story.

## Expected outcomes (map to Success Criteria)
- Open→published plain story in the rail in < 30 s / ≤ 3 actions (SC-001).
- Published story pixel-identical to preview (SC-002); appears with zero manual refresh (SC-003).
- Retries never create >1 story (SC-004); cancel/fail leaves 0 partial entries (SC-005).
- Segments > 24h absent, < 24h present (SC-006); whole journey works with no network (SC-007);
  composer passes a11y/text-scaling/light-dark on phone + tablet (SC-008).
