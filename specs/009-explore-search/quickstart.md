# Quickstart / Validation: Explore & Search (#009)

Runnable validation for the discovery surfaces. Automated (fake-mode, zero-network) coverage is authoritative; the on-device dev-backend walkthrough is a release-gate check (#015).

## Prerequisites

- Flutter 3.44.4 / Dart 3.12.2 (repo baseline); `flutter pub get` + `dart run build_runner build --delete-conflicting-outputs` after adding freezed models + the drift v6→v7 table.
- Runs on the `env:['fake']` DI graph (zero-network) for tests; `env:['real']` hits the dev backend (`http://localhost:3000/v1`) — note reels/media need the backend worker + `ffmpeg` for video content to be `ready`.

## Automated validation (authoritative)

```bash
dart format .
flutter analyze                 # zero warnings (bar pre-existing pubspec infos)
flutter test                    # all pass, incl. the new discovery suites
dart run bloc_tools:bloc lint . # zero violations (no local CLI — carried)
```

Target suites (added by `/speckit.tasks` → implement):

- `test/core/data/discovery/fake_discovery_repository_test.dart` — explore paging; search by type (prefix+substring, case/accent-insensitive); block/private filtering; hashtag/place pages; recents dedupe-and-promote + delete + clear.
- `test/features/explore/explore_cubit_test.dart` — load-first/next/refresh; offline-from-cache path; empty/error states.
- `test/features/explore/search_cubit_test.dart` — debounce + ≥2-char gate; latest-term-wins (stale request ignored); Top snapshot; tab switch + per-type pagination.
- `test/features/explore/recents_cubit_test.dart` — record on tap/submit (promote, no duplicate); delete one; clear all (optimistic).
- `test/features/explore/*_page_test.dart` — widget tests (grid render + reel marker + hero tile; results tabs; recents rows; hashtag/place header+grid; surface-only follow toast). Use fixed `pump(Duration)` + tall `surfaceSize` (carried #006/#008 gotcha — no `pumpAndSettle` with images/router).
- `test/features/explore/goldens/` — DiscoveryGridTile (post + reel), AccountResultRow (follow/following), CategoryChips, ResultsTabs (light+dark).
- `test/features/explore/a11y_adaptive_test.dart` — screen-reader labels; 2× text scale; phone 3-col vs tablet responsive grid.
- `test/features/explore/log_redaction_test.dart` — no `print`/`debugPrint`; no query terms / urls / tokens leaked.
- `test/core/data/cache/migration_v6_to_v7_test.dart` — `ExploreItems` added; existing rows intact.

## Manual walkthrough (per user story)

1. **US1 Search** — open Explore → tap the SearchBar → type "al" (≥2 chars) → results appear live on **Top**; switch **Accounts/Tags/Places**; tap an account → profile; tap a tag → hashtag page; tap a place → place page. Verify a blocked user never appears and a private account is findable by handle.
2. **US2 Explore grid** — open the Explore tab → a mixed post/reel grid renders (reels marked, a 2×2 hero tile); scroll to load more; pull-to-refresh; tap a tile → opens the item; tap the "travel" chip → `#travel` page. Kill the network → reopen Explore → cached grid shows with an offline indication.
3. **US3 Recents** — open Search with an empty field → recents listed newest-first; submit a term / tap a result → it appears at the top (repeat → promoted, not duplicated); delete one row; "Clear all" empties the list.
4. **US4 Hashtag/Place** — open a hashtag page → header (tag + post count) + grid; scroll to paginate; tap **Follow** → toast "coming soon" (no relationship created). Repeat for a place page. Open a hashtag page via deep link (not via search) → works.
5. **US5 Inclusive/adaptive** — with a screen reader, traverse a tile / account row / recent row (each announces meaningfully, reel vs photo distinguished); set 2× text scale (no clipping); toggle light/dark; run on a tablet width (grid reflows to more columns, tabs still usable).

## Expected outcomes (tie to Success Criteria)

- Find a known account/tag/place and open it in ≤3 taps (SC-001).
- Results for a typed term appear < 1 s; each tab shows the right type (SC-002).
- Blocked accounts never appear; no gated private content leaks (SC-003).
- Explore/hashtag/place scroll ≥5 pages with no duplicate/dropped tiles or slowdown (SC-004).
- A repeated search yields exactly one promoted recent (SC-005).
- Every error path surfaces a toast and/or inline retry (SC-006).
- a11y/large-text/light-dark/adaptive checks green (SC-007).
- Full build + tests run with zero network (SC-008).
