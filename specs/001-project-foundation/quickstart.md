# Quickstart — Project Foundation (#001)

Validation/run guide proving the foundation works end-to-end with **no backend**. References [contracts/](contracts/) + [data-model.md](data-model.md); implementation lives in `tasks.md` + code.

## Prerequisites
- Flutter 3.41.7+ / Dart 3.11.5+ (stable) — `flutter --version`.
- Run from repo root. No backend, no network, no credentials required.

## Setup
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed, injectable, json
flutter gen-l10n                                            # ARB → localizations (or via build)
```

## Run (both flavors)
```bash
flutter run -t lib/main_dev.dart   --flavor dev    # app id app.we36.dev, name "We36 Dev"
flutter run -t lib/main_prod.dart  --flavor prod   # app id app.we36,     name "We36"
```
**Expect**: launches into the main shell (stub signed-in) with Home showing the stories rail + post cards from mock data. No network activity.

## Validation scenarios

### V1 — Five destinations + state preservation (US1 / SC-001)
Tap Home/Explore/Reels/Messages/Profile; scroll one, switch away, return → scroll + back-stack preserved per tab.

### V2 — Adaptive chrome across breakpoints (US1 / SC-002)
Resize the window (or rotate / iPad split-view) through `<700` → `700–979` → `980–1099` → `≥1100`.
**Expect**: bottom nav → compact rail (icon-only) → full rail (icon+label) → full rail + Home right "Suggestions"; active destination preserved; no restart.

### V3 — Two-pane master/detail (US2 / SC-003)
Open `/dev/two-pane` (or Messages). Tablet width: list + detail side-by-side, selecting an item swaps detail in place (no push). Narrow to phone width with a selection open: same flow now pushes detail full-screen; selection preserved across the resize.

### V4 — Auth-guard split (US1 / FR-004/005)
Toggle `AuthGuardStub.isSignedIn=false` → app shows pre-auth placeholders (Splash/Onboarding/…) with **no** nav chrome. Set `true` → main shell.

### V5 — Theming light/dark + "color earns its place" (US3 / SC-005/006)
Open `/dev/gallery`. Switch device theme light↔dark↔system → every surface follows; dark is ink-tinted (not black). Confirm brand color/gradient appears only on primary CTA / unseen story ring / active nav / badge / sticker; gradient never a full-page wash.

### V6 — Component library + goldens (US4 / SC-004)
`/dev/gallery` renders all ~19 components + variants in light + dark. Run goldens:
```bash
flutter test --update-goldens   # first run to capture
flutter test                    # PostCard, Avatar(ring/online/create), BottomNav, SidebarRail — light+dark
```

### V7 — Four presentation states (US6 / FR-028a / SC-010)
Open `/dev/states`: cycle initial → loading → loaded → error (simulated local source). All four render via `AppCubit`/`AppState`.

### V8 — Accessibility (SC-012)
Enable VoiceOver/TalkBack → icon-only controls (IconButton, BottomNav, SidebarRail) announce meaningful labels. Set OS text size to large → component text scales without clipping/overlap.

### V9 — Localization EN ↔ VI (US6 / SC-009)
Switch device language English ↔ Vietnamese → every visible string changes to a fully translated value; no untranslated fallback.

### V10 — Mock data, zero network (SC-007)
Run with a network monitor / offline: all destinations render from mock; **zero** network requests, zero auth.

## Pre-commit gate (Constitution / dev-workflow)
```bash
dart format .
flutter analyze                  # zero warnings (very_good_analysis)
flutter test                     # unit + bloc_test + widget + golden
dart run bloc_tools:bloc lint .  # zero violations
```

## Done = all of
- Both flavors run, report their own id/name, no backend.
- V1–V10 pass; pre-commit gate clean.
- No hardcoded hex/strings at call sites; no `print`/`debugPrint`; no secrets logged.
