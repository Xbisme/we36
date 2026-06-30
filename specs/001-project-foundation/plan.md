# Implementation Plan: Project Foundation, Design System & Navigation

**Branch**: `001-project-foundation` | **Date**: 2026-06-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-project-foundation/spec.md`

## Summary

Build the blocking foundation for We36: a clean-architecture Flutter shell with two flavors (dev/prod), an auth-guarded adaptive navigation system (5-tab `StatefulShellRoute` on phones ↔ sidebar rail + two-pane master/detail on tablets/iPad, switched purely by window width), a fixed light/dark design-token layer carrying the We36 brand, the complete shared component library built once, app-wide primitives (`Result<T>`, `AppFailure`, a 4-state `AppCubit` base, `AppLogger`, count/relative-time formatters), DI, and full EN+VI localization. It ships placeholder destinations rendered at real fidelity from in-memory mock data — no networking, no auth, no persistence. Accessibility (screen-reader semantics + text-scaling) is baked into every component now; all four presentation states are demonstrated and tested.

Technical approach: custom `AdaptiveShell` and `TwoPaneScaffold` widgets driven by `LayoutBuilder`/`MediaQuery` width (no adaptive-scaffold package, for full control of the We36 chrome); `go_router` `StatefulShellRoute.indexedStack` with a stubbed auth-guard redirect; semantic tokens via a `ThemeExtension`-based `AppTheme`; bundled Plus Jakarta Sans + Inter fonts (deterministic, offline, golden-stable); Lucide icons via `lucide_icons_flutter`; freezed sealed states; `get_it`/`injectable` DI; Flutter `gen-l10n` ARB.

## Technical Context

**Language/Version**: Dart 3.11.5 (stable) / Flutter 3.41.7 (stable) — floor pinned to the installed toolchain; constitution mandates "latest stable".

**Primary Dependencies** (latest stable from pub.dev, 2026-06-30):
- State: `flutter_bloc ^9.1.1`
- DI: `get_it ^9.2.1`, `injectable ^3.0.0` (+ dev `injectable_generator ^3.1.0`)
- Routing: `go_router ^17.3.0`
- Codegen models/state: `freezed ^3.2.5` (+ `freezed_annotation ^3.1.0`), `json_serializable ^6.14.0` (+ `json_annotation ^4.12.0`), `build_runner ^2.15.0`
- Icons: `lucide_icons_flutter ^3.1.14` (most-maintained Lucide port; tracks upstream, published 2026-05)
- Fonts: `google_fonts ^8.1.0` **configured with bundled font files** (no runtime HTTP fetch)
- Media display: `cached_network_image ^3.4.1` (used by `PostCard` for mock remote images)
- Vector marks: `flutter_svg ^2.3.0` (We36 wordmark/logo)
- i18n/format: `intl ^0.20.3` + `flutter_localizations` (SDK), ARB via `gen-l10n`
- Lint: `very_good_analysis ^10.3.0` (+ `bloc_lint` via `bloc_tools`)
- Test: `flutter_test` (SDK), `bloc_test ^10.0.0`, `mocktail ^1.0.5`
- **Custom, no package**: Toast (overlay-based ink pill — `ScaffoldMessenger.showSnackBar` is forbidden by Constitution VI), `AdaptiveShell` + `TwoPaneScaffold`, `Result<T>`/`AppFailure`, `AppCubit`, `AppLogger`, formatters.

**Storage**: N/A for #001 — in-memory mock data only. No local DB/cache (deferred to #002).

**Testing**: `flutter_test` (widget + golden), `bloc_test` (4-state Cubit transitions), `mocktail`. Command: `very_good test --test-randomize-ordering-seed random`. Goldens for `PostCard`, `Avatar` (ring/online/create states), `BottomNav`, `SidebarRail` in light + dark.

**Target Platform**: iOS (phones + iPad) + Android (phones + tablets). Adaptive by width; supports iPad split-view/multitasking and rotation. Desktop/web post-v1.0.

**Project Type**: Mobile app (Flutter, single codebase, feature-first Clean Architecture).

**Performance Goals**: 60 fps during scroll and during adaptive-breakpoint resize/rotation transitions; no decode of full-res images for thumbnails (bounded `cacheWidth`); no jank when the chrome swaps bottom-nav ↔ rail. (Resolves the spec's previously-Outstanding performance dimension.)

**Constraints**: No networking, no auth, no persistence, no secrets/logs of sensitive data (none exist yet). Fonts bundled for offline + golden determinism. Reduce-Motion → static. All visual values from semantic tokens; no hardcoded hex/strings.

**Scale/Scope**: #001 delivers 19 shared components (+ layout primitives), 5 main destination placeholders, ~6 auth-flow placeholders, the adaptive shell + two-pane demo, the token system (light+dark), foundation primitives, DI graph, and EN+VI ARB. Target after foundation: 31 designed screens across 14 later specs.

## Constitution Check

*GATE: evaluated against We36 Constitution v1.0.1. Re-checked after Phase 1 design — still PASS.*

| Principle | Relevance to #001 | Status |
|---|---|---|
| I. Privacy, Safety & Trust | No auth/secrets/PII handled yet; `AppLogger` designed to never log secrets; deep-link validation wired (rejects malformed) | ✅ PASS |
| II. Media-Centric Performance | `cached_network_image` + bounded `cacheWidth` for mock images; 60fps target; no unbounded decode | ✅ PASS |
| III. BLoC-Driven State (4-state) | `AppCubit<T>` base = freezed 4-state (initial/loading/loaded/error); FR-028a demonstrates + bloc_tests all transitions | ✅ PASS |
| IV. Code Quality & Dart Safety | `very_good_analysis` zero-warning; strict-casts/raw-types/inference; freezed immutability; explicit types | ✅ PASS |
| V. Result\<T\> Error Handling | `Result<T>` + `AppFailure` sealed class defined here as the shared vocabulary; `.fold()` in Cubits, no try/catch in Cubits | ✅ PASS |
| VI. Design System & Theming | Fixed light/dark semantic tokens; "color earns its place"; Lucide single family; shared widgets built once in `core/presentation/`; custom Toast; Reduce-Motion | ✅ PASS |
| VII. Cross-Platform / Adaptive | One nav model, width-driven chrome; bottom-nav ↔ sidebar rail; two-pane master/detail primitive; split-view + rotation; a11y baked in (FR-024a) | ✅ PASS |
| VIII. API & Realtime | Out of scope (#002); per-flavor config slot present but empty; no HTTP/socket code | ✅ PASS (N/A) |
| IX. Data Integrity / Caching | Out of scope (#002); no cache/optimistic logic; single canonical mock source per content sample | ✅ PASS (N/A) |
| X. go_router Navigation | `AppRoutes` constants; `context.go/push/pop`; `StatefulShellRoute.indexedStack`; stubbed auth-guard `redirect`; nav-less flow routes; deep-link validation | ✅ PASS |
| XI. Feature-First Modularity | `core/` + `features/`; `core/` must not import `features/`; DI `@lazySingleton`/`@injectable` (no eager `@singleton`) | ✅ PASS |
| XII. Testing Discipline | Unit (Result/AppFailure/formatters/4-state), bloc_test, widget + golden tests; fully runnable with no backend | ✅ PASS |
| XIII. Simplicity & YAGNI | Custom shell over adaptive-scaffold pkg; no DB/network/flags; build only what 14 specs reuse; 3 lines > premature abstraction | ✅ PASS |
| XIV. i18n by Default | ARB EN primary + VI secondary, both fully translated for #001's string set (FR-031); `context.l10n`; intl formatters | ✅ PASS |
| XV. Dependency Hygiene | All versions fetched from pub.dev 2026-06-30 (not guessed); caret constraints; Lucide pkg chosen by maintenance; lockfiles committed | ✅ PASS |

**No violations. Complexity Tracking not required.**

## Project Structure

### Documentation (this feature)

```text
specs/001-project-foundation/
├── plan.md              # This file
├── research.md          # Phase 0 — decisions + rationale (package + architecture choices)
├── data-model.md        # Phase 1 — foundation entities (tokens, destinations, components, primitives)
├── quickstart.md        # Phase 1 — run/validate guide (flavors, breakpoints, themes, a11y, l10n)
├── contracts/           # Phase 1 — UI contracts
│   ├── navigation.md     #   route table + tab shell + deep-link scheme + nav-less rules
│   ├── design-tokens.md  #   semantic token contract (names → light/dark values)
│   └── components.md      #   public API surface of every shared component
├── checklists/
│   └── requirements.md  # spec quality checklist (from /speckit.specify)
└── tasks.md             # Phase 2 — created by /speckit.tasks (NOT here)
```

### Source Code (repository root)

```text
lib/
├── app/                         # App root widget, MaterialApp.router, theme + locale wiring
├── bootstrap.dart               # Pre-runApp: configureDependencies(), error/zone setup
├── main_dev.dart                # dev flavor entry (AppConfig.dev)
├── main_prod.dart               # prod flavor entry (AppConfig.prod)
├── core/                        # Shared infra — MUST NOT import features/
│   ├── config/                  # AppConfig + Flavor (bundle id, app name, empty endpoint slot)
│   ├── constants/               # AppRoutes, asset keys (API/socket constants deferred to #002)
│   ├── di/                      # injectable graph (injection.dart + injection.config.dart)
│   ├── domain/                  # Result<T>, AppFailure (freezed sealed), AppCubit<T>, AppState<T>
│   ├── presentation/            # Shared widget library (Button, IconButton, AppIcon, Avatar,
│   │                            #   Badge, Tag, PostCard, SearchBar, AppSwitch, BottomNav,
│   │                            #   SidebarRail, StoriesRail, TopBar, PaneHeader, Wordmark,
│   │                            #   Toast, ActionSheet, AppDialog, StickerTray)
│   ├── router/                  # go_router config, AdaptiveShell, TwoPaneScaffold, auth-guard stub, deep-link parser
│   ├── theme/                   # AppColors (light+dark), AppTypography, AppSpacing/Radius/Shadow/Motion,
│   │                            #   AppGradients, AppTheme (ThemeExtension semantic tokens)
│   └── utils/                   # AppLogger, formatters (CountFormatter 38.4k, RelativeTimeFormatter 2h)
├── features/                    # Placeholder destinations + auth-flow placeholders (real impls later)
│   ├── auth/presentation/       # Splash/Onboarding/SignIn/SignUp/Forgot/ProfileSetup placeholders (#003)
│   ├── feed/presentation/       # Home placeholder (StoriesRail + PostCards from mock) (#004)
│   ├── explore/presentation/    # Explore placeholder (#009)
│   ├── reels/presentation/      # Reels placeholder (#008)
│   ├── messaging/presentation/  # Messages placeholder — adopts TwoPaneScaffold demo (#012)
│   ├── profile/presentation/    # Profile placeholder (#010)
│   └── dev/presentation/        # Component gallery + 4-state demo + two-pane demo (dev-only harness)
└── l10n/
    └── arb/                     # app_en.arb (primary) + app_vi.arb (secondary, fully translated)

test/
├── core/
│   ├── domain/                  # Result/AppFailure/AppCubit 4-state (bloc_test)
│   ├── utils/                   # CountFormatter / RelativeTimeFormatter (incl. locale)
│   ├── presentation/            # Widget + golden tests (PostCard, Avatar, BottomNav, SidebarRail)
│   └── router/                  # AdaptiveShell breakpoint + TwoPaneScaffold + deep-link validation
└── helpers/                     # mock data, pump helpers, golden setup

assets/
├── brand/                       # We36 wordmark / logo SVGs
└── fonts/                       # Plus Jakarta Sans + Inter TTFs (bundled, no runtime fetch)
```

**Structure Decision**: Feature-first Clean Architecture per Constitution XI. #001 is overwhelmingly `core/` (the shared spine: theme, components, router/shell, primitives, DI, l10n); `features/*` carry only thin presentation-layer placeholders (no data/domain layers yet — those arrive when each feature's spec lands). A dev-only `features/dev/` harness hosts the component gallery, the 4-state demo, and the two-pane demo so reviewers and golden tests can exercise everything without polluting real destinations.

## Complexity Tracking

> No constitution violations — section intentionally empty.
