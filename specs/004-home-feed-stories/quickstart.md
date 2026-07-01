# Quickstart & Validation: Home Feed & Stories (#004)

Runnable validation for the feature. The app runs DI `environment: 'fake'` — everything below works
**with zero network** against the fake feed/stories repositories.

## Prerequisites

- Flutter 3.44.4 / Dart 3.12.2 toolchain.
- From repo root: `flutter pub get`.
- After any freezed/json/injectable/drift change: `dart run build_runner build --delete-conflicting-outputs`.
- After ARB edits: `flutter gen-l10n` (or the configured build step).

## Build & run (fake env)

```bash
flutter run --flavor dev -t lib/main_dev.dart
# Sign in with the seeded demo account (demo@we36.app / password123) → lands on Home.
```

## Gate (must pass before commit — Constitution)

```bash
dart format .
flutter analyze                  # zero warnings
flutter test                     # all pass (unit + bloc + widget + golden + migration)
dart run bloc_tools:bloc lint .  # zero violations
```

## Validation scenarios (map to spec)

> Full acceptance criteria live in [spec.md](spec.md); repositories/models in
> [contracts/](contracts/) + [data-model.md](data-model.md).

1. **Feed loads (US1 / FR-001..008)** — Home shows synthesized posts newest-first via `PostCard`
   (single image). Scroll to end → next page appends (loadedPaginating). Pull down → refresh
   (loadedRefreshing) reloads from top.
2. **Offline-from-cache (FR-004 / SC-001)** — kill + relaunch (fake persists to drift): cached feed
   renders immediately, then a background refresh runs. No blank/spinner-only screen.
3. **Feed states (FR-005 / SC-005)** — force the fake to return empty → empty state; force first-load
   failure with empty cache → error + retry; retry recovers.
4. **Malformed item (FR-006 / SC-006)** — fake injects one bad post in a page → it's skipped, the
   rest render.
5. **Like optimistic + rollback (US2 / FR-010..013)** — tap like → instant fill + count+1; enable
   fake `failNextMutation` → tap → rolls back + Toast; double-tap → no double-count (idempotent).
6. **Save optimistic (US3 / FR-014..016)** — tap save → instant bookmark; failure rolls back;
   saved state survives refresh/relaunch (canonical `Post`).
7. **Stories rail (US4 / FR-017..020)** — rail above feed leads with "Your story"; unseen reels show
   the gradient ring, seen ones desaturated, unseen ordered first. Tap → viewer opens. "Your story"
   with no self-reel is inert (no `+`).
8. **Story viewer (US5 / FR-021..028)** — segments auto-advance (≈5 s), then next account or close;
   tap-right/left seeks; hold pauses; like flips optimistically; "Send message"/reply + share are
   visibly inactive; closing marks seen → rail ring desaturates and **persists across relaunch**.
9. **Reduce-Motion (FR-033 / SC-008)** — enable Reduce Motion: story still advances, decorative
   transitions are static.
10. **Adaptive (FR-029 / SC-010)** — phone (<700) single column; tablet (≥700) centered ~560 +
    sidebar rail; ≥1100 adds right rail (footer + static SearchBar). Viewer full-screen everywhere;
    verify rotation + iPad split-view reflow.
11. **i18n + theme (FR-031 / SC-007)** — switch EN⇄VI and light⇄dark: all feed/story strings
    localized; counts ("38.4k") + relative time ("2h") locale-aware.
12. **Migration (FR / Constitution IX)** — drift v2→v3 migration test green (creates `Posts` +
    `StorySeenSegments`); v1→v2 test still green; `clearUserScoped()` wipes feed + seen on logout.

## Deferred (not validated here)

Carousels (#007), comments/post detail (#006), reels (#008), real DM/story-share (#012), collection
picker (#011), suggestions/follow (#010), search behavior (#009), notifications (#013), and any
ranked feed (post-v1.0).
