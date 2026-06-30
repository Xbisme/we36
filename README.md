# We36

A cross-platform (iOS + Android phones **and** iPad / Android tablets) **Instagram-style social app** built in Flutter — feed, stories, reels, direct messages, explore/search, and profiles. Backend-agnostic client over a custom versioned REST/JSON + WebSocket contract (server out of scope; every repository ships an in-memory fake).

- **In-app language:** English-first (+ Vietnamese).
- **Design:** fixed light & dark palette, signature rose → violet gradient. UI source of truth: [`.claude/claude-app/ui-design-context.md`](.claude/claude-app/ui-design-context.md).
- **Method:** Spec-Driven Development (Speckit). Specs live in [`specs/`](specs/); day-to-day rules in [`CLAUDE.md`](CLAUDE.md); architecture law in [`.specify/memory/constitution.md`](.specify/memory/constitution.md).

> **Status:** Spec #001 (Project Foundation, Design System & Navigation) is implemented — the adaptive shell, design-token system, full shared component library, app-wide primitives, DI, and EN/VI localization. It runs entirely on local mock data (no networking/auth/persistence yet — those land in #002/#003).

---

## Prerequisites

| Tool        | Version                  | Notes                                        |
| ----------- | ------------------------ | -------------------------------------------- |
| Flutter     | **3.41.x** (stable)      | Dart **3.11.5** bundled. `flutter --version` |
| Xcode       | 15+                      | iOS builds (Mac only) + CocoaPods            |
| Android SDK | latest                   | Android builds. Set `ANDROID_HOME`           |
| An editor   | VS Code / Android Studio | with the Flutter + Dart plugins              |

> The repo pins a few packages slightly below their newest releases because the newest require Dart ≥ 3.12 (e.g. `injectable_generator` 3.0.x, `very_good_analysis` 10.2.x). If you upgrade Flutter/Dart to ≥ 3.12, you can bump those.

Check your setup:

```bash
flutter doctor
```

---

## First-time setup

```bash
# 1. Install Dart/Flutter packages
flutter pub get

# 2. Generate code (freezed unions, injectable DI graph, json)
dart run build_runner build --delete-conflicting-outputs

# 3. Generate localizations from the ARB files (lib/l10n/arb)
flutter gen-l10n
```

> `build_runner` and `gen-l10n` outputs (`*.freezed.dart`, `injection.config.dart`, `lib/l10n/generated/`) are generated — re-run step 2/3 whenever you change a `@freezed`/`@injectable` annotation or an `.arb` file.

iOS only (first run): install pods —

```bash
cd ios && pod install && cd ..
```

---

## Running the app

The app ships two **flavors** (`dev` / `prod`) with separate bundle ids (`app.we36.dev` / `app.we36`) and separate entry points.

```bash
# Development flavor
flutter run -t lib/main_dev.dart --flavor dev

# Production flavor
flutter run -t lib/main_prod.dart --flavor prod
```

Pick a device with `flutter devices` first, or pass `-d <id>` (e.g. `-d ios`, `-d emulator-5554`).

**What you'll see:** the app launches into the main shell (stubbed as signed-in) on Home — stories rail + post cards from mock data. Resize the window / rotate / use iPad split-view to watch the chrome adapt: bottom nav (`< 700` wide) → sidebar rail (`≥ 700`, compact `< 980` / labeled `≥ 980`) → Home gains a right "Suggestions" rail (`≥ 1100`).

### Dev harness (dev flavor)

Reachable via the router (deep-link or temporary navigation):

- `/dev/gallery` — every shared component + variants (light/dark)
- `/dev/states` — the four AppState transitions (initial → loading → loaded → error)
- `/dev/two-pane` — the master/detail primitive (side-by-side on tablet, push on phone)

### Toggling the auth zones

There is no real auth yet (#003). `AuthGuardStub` defaults to **signed-in** so the main shell is reviewable. Flip `AuthGuardStub.isSignedIn` (or call `.toggle()`) to preview the nav-less pre-auth flow (Splash / Onboarding / Sign in…).

---

## Building

```bash
# Android (dev)
flutter build apk     -t lib/main_dev.dart  --flavor dev
flutter build appbundle -t lib/main_prod.dart --flavor prod

# iOS (prod, Mac only)
flutter build ios     -t lib/main_prod.dart --flavor prod
```

---

## Testing & quality gate

```bash
# All tests (unit + bloc + widget)
flutter test

# A single file
flutter test test/core/router/app_shell_test.dart

# Golden tests — capture/refresh baselines (run on a consistent machine)
flutter test --update-goldens
```

Pre-commit gate (run all four before pushing):

```bash
dart format .          # format
dart analyze           # static analysis — must be clean
flutter test           # all tests pass
# bloc_lint runs as a custom_lint plugin (see note below)
```

> **Note on `flutter analyze`:** on some custom Flutter builds the bundled analysis server crashes (AOT-snapshot mismatch). Use **`dart analyze`** instead — it produces the same lint results. `bloc_lint` is wired as a `custom_lint` plugin (not a standalone CLI); enable it via your IDE's Dart analysis or a `custom_lint` runner.

---

## Project structure

```text
lib/
├── app/              # MaterialApp.router root (theme + l10n wiring)
├── bootstrap.dart    # pre-runApp: DI + zone-guarded runApp
├── main_dev.dart / main_prod.dart   # flavor entry points
├── core/             # shared infra — MUST NOT import features/
│   ├── config/       # AppConfig + Flavor
│   ├── constants/    # AppRoutes, AppBreakpoints
│   ├── di/           # get_it + injectable graph
│   ├── domain/       # Result, AppFailure, AppState, AppCubit
│   ├── mock/         # in-memory sample data (no network)
│   ├── presentation/ # the shared component library (built once)
│   ├── router/       # go_router, AdaptiveShell, TwoPaneScaffold, guard, deep links
│   ├── theme/        # AppColorsX tokens, typography, dimens, motion, AppTheme
│   └── utils/        # AppLogger, formatters, context.l10n
├── features/         # feed / explore / reels / messaging / profile / auth / dev (placeholders this spec)
└── l10n/arb/         # app_en.arb (primary) + app_vi.arb

test/                 # mirrors lib/ ; helpers/pump_app.dart for widget tests
assets/fonts/         # bundled Plus Jakarta Sans + Inter (variable TTFs)
specs/                # Speckit feature specs (spec.md, plan.md, tasks.md, …)
```

---

## Contributing / workflow

This project follows Spec-Driven Development. For each feature: `/speckit.specify → clarify → plan → tasks → analyze → implement`. A git branch (`NNN-feature-name`) is created automatically by an `after_specify` hook. Conventions: see [`.claude/claude-app/dev-workflow.md`](.claude/claude-app/dev-workflow.md). All code, comments, docs, commits, and in-app copy are in **English**; spoken collaboration is in Vietnamese.
