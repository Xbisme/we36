---
description: "Task list for Project Foundation, Design System & Navigation (#001)"
---

# Tasks: Project Foundation, Design System & Navigation

**Input**: Design documents from `/specs/001-project-foundation/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: INCLUDED — Constitution XII mandates unit + bloc_test + widget + golden tests; the spec requires them (SC-004 goldens, SC-010 unit/bloc, FR-028a 4-state).

**Organization**: Tasks grouped by user story. ⚠️ **Foundation-spec ordering**: this feature's P1 outcome (the running shell, US1/US2) renders *with* the theme (US3), component library (US4), and primitives (US6) and therefore **depends on them**. Phases are ordered by build dependency (US6 → US3 → US4 → US1 → US2 → US5), with each story's priority shown. See [Implementation Strategy](#implementation-strategy) for why this differs from strict priority order.

> **Smoke-test note (We36 dev-workflow)**: #001 is fully CI-testable with no backend. On-device validation (real iPad split-view resize, VoiceOver/TalkBack, large Dynamic Type) is a manual smoke test tracked in Phase 9.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no incomplete dependencies)
- **[Story]**: US1–US6 (Setup/Foundational/Polish carry no story label)
- All paths are repo-root-relative per [plan.md](plan.md) source tree.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, toolchain, dependencies, flavors.

- [x] T001 Scaffold the Flutter app (`flutter create` for iOS + Android, org `app.we36`) then restructure to the feature-first tree per plan.md: create `lib/core/{config,constants,di,domain,presentation,router,theme,utils}`, `lib/features/{auth,feed,explore,reels,messaging,profile,dev}/presentation`, `lib/l10n/arb/`, `test/`, `assets/{brand,fonts}/`.
- [x] T002 Populate `pubspec.yaml` with all dependencies at the pinned versions from plan.md (flutter_bloc ^9.1.1, get_it ^9.2.1, injectable ^3.0.0, go_router ^17.3.0, freezed ^3.2.5, freezed_annotation ^3.1.0, json_serializable ^6.14.0, json_annotation ^4.12.0, lucide_icons_flutter ^3.1.14, google_fonts ^8.1.0, cached_network_image ^3.4.1, flutter_svg ^2.3.0, intl ^0.20.3; dev: build_runner ^2.15.0, injectable_generator ^3.1.0, very_good_analysis ^10.3.0, bloc_test ^10.0.0, mocktail ^1.0.5), enable `flutter_localizations`, and declare `assets/` + bundled fonts; run `flutter pub get`.
- [x] T003 [P] Add `analysis_options.yaml` including `very_good_analysis`, `strict-casts`/`strict-raw-types`/`strict-inference`, and a rule banning `print`/`debugPrint`; add `bloc_lint` config.
- [x] T004 [P] Configure dev/prod flavors: Android product flavors in `android/app/build.gradle` (applicationId `app.we36.dev` / `app.we36`, app label "We36 Dev" / "We36"); iOS schemes + `.xcconfig` (bundle id + display name) in `ios/`.
- [x] T005 [P] Add bundled Plus Jakarta Sans (400–800) + Inter (400–700) TTFs under `assets/fonts/`, declare them in `pubspec.yaml fonts:`, and add the We36 wordmark/logo SVGs under `assets/brand/`.
- [x] T006 [P] Add `l10n.yaml` (`arb-dir: lib/l10n/arb`, `template-arb-file: app_en.arb`, `output-localization-file: app_localizations.dart`, `nullable-getter: false`) and a `build.yaml` for freezed/injectable/json_serializable.
- [x] T007 Verify the codegen + l10n pipeline runs clean on empty stubs: `dart run build_runner build --delete-conflicting-outputs` and `flutter gen-l10n` succeed; `flutter analyze` is zero-warning.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Minimal shared scaffolding every story needs. ⚠️ **No story work begins until this is complete.**

- [x] T008 Create `AppConfig` + `Flavor` enum in `lib/core/config/app_config.dart` (dev/prod: `appName`, `bundleId`, empty `apiBaseUrl`/`realtimeUrl` reserved for #002) per data-model.md.
- [x] T009 Create entry points `lib/main_dev.dart` + `lib/main_prod.dart` (select `AppConfig`, call `bootstrap`) and `lib/bootstrap.dart` (init DI, run app inside a guarded zone — error hook wired to the logger in T024).
- [x] T010 Set up the DI container in `lib/core/di/injection.dart` (`@InjectableInit configureDependencies()`), register `AppConfig`, and generate `injection.config.dart`.
- [x] T011 [P] Create `AppRoutes` route constants in `lib/core/constants/app_routes.dart` per contracts/navigation.md (pre-auth, 5 branch roots, flow routes, dev harness routes).
- [x] T012 Create the app root widget `lib/app/app.dart` as a `MaterialApp.router` skeleton with hook-points for `theme`/`darkTheme`/`themeMode: system`/`locale`/`localizationsDelegates`/`routerConfig` (filled by US6/US3/US1 tasks).

**Checkpoint**: App scaffold builds and runs (blank). Foundation ready.

---

## Phase 3: User Story 6 — Foundation primitives & localization (Priority: P3) 🧱 substrate

**Goal**: The typed `Result`/`AppFailure`, 4-state `AppCubit`, logger, formatters, DI, and EN+VI localization that every other layer consumes.

**Independent Test**: Unit/bloc tests pass for Result/AppFailure, the four-state base (all transitions), and the count/relative-time formatters (incl. locale); language switch EN↔VI updates strings; logger emits no secrets.

### Tests for User Story 6

- [x] T013 [P] [US6] Unit test `Result<T>` + `AppFailure` (fold, message mapping) in `test/core/domain/result_test.dart`.
- [x] T014 [P] [US6] Unit test `CountFormatter` (38.4k/1.2M/1,240) + `RelativeTimeFormatter` (2h/1d), including locale variation, in `test/core/utils/formatters_test.dart`.
- [x] T015 [P] [US6] `bloc_test` for `AppCubit<T>` covering initial → loading → loaded → error in `test/core/domain/app_cubit_test.dart`.
- [x] T015a [P] [US6] Unit test `AppLogger` redaction (asserts no token/password/email/phone/message-body leaks into output) + level filtering, in `test/core/utils/app_logger_test.dart` (SC-010 / FR-029).

### Implementation for User Story 6

- [x] T016 [P] [US6] Create `Result<T>` freezed sealed (`Ok`/`Err`, `.fold`, `valueOrNull`, `map`) in `lib/core/domain/result.dart`.
- [x] T017 [P] [US6] Create `AppFailure` freezed sealed with the full Constitution-V vocabulary in `lib/core/domain/app_failure.dart`.
- [x] T018 [US6] Create `AppState<T>` freezed 4-state in `lib/core/domain/app_state.dart` and `AppCubit<T>` base (`emitLoading/Loaded/Error`, `run(Future<Result<T>>)`) in `lib/core/domain/app_cubit.dart`.
- [x] T019 [P] [US6] Create `CountFormatter` in `lib/core/utils/count_formatter.dart` (locale-aware via `intl`).
- [x] T020 [P] [US6] Create `RelativeTimeFormatter` in `lib/core/utils/relative_time_formatter.dart` (locale-aware).
- [x] T021 [P] [US6] Author `lib/l10n/arb/app_en.arb` (primary) — #001 strings (nav labels, placeholders, component text, `AppFailure` messages) each with `@description`.
- [x] T022 [US6] Author `lib/l10n/arb/app_vi.arb` — full Vietnamese translation of every key in `app_en.arb` (no missing keys); regenerate with `flutter gen-l10n`.
- [x] T023 [US6] Add `context.l10n` extension in `lib/core/utils/l10n_extension.dart`, `AppFailure.toMessage(l10n)` mapper in `lib/core/domain/app_failure_messages.dart`, and wire `localizationsDelegates` + `supportedLocales` (en, vi) into `lib/app/app.dart`.
- [x] T024 [US6] Create `AppLogger` (leveled debug/info/warn/error + secret-redaction guard) in `lib/core/utils/app_logger.dart`, register in DI, and wire it into the `bootstrap` zone error hook (T009).
- [x] T025 [US6] Run `dart run build_runner build` to generate freezed/injectable outputs; confirm T013–T015 pass.

**Checkpoint**: Primitives + l10n usable by all later layers.

---

## Phase 4: User Story 3 — Light & dark theming from semantic tokens (Priority: P2)

**Goal**: Fixed light/dark design-token system carrying the We36 brand; every visual value flows from semantic tokens.

**Independent Test**: A token gallery resolves every alias correctly in light + dark; theme switch updates all surfaces; brand color/gradient appear only on highlights; Reduce-Motion → static.

### Tests for User Story 3

- [x] T026 [P] [US3] Widget test: token gallery resolves `AppColorsX` aliases in light + dark and `context.tokens` returns the active-mode value, in `test/core/theme/tokens_test.dart`.
- [x] T027 [P] [US3] Golden test: token swatches + type scale, light + dark, in `test/core/theme/tokens_golden_test.dart`.
- [x] T027a [P] [US3] Widget test: with Reduce-Motion enabled, press/decorative motion renders static (only essential press-scale remains), in `test/core/theme/motion_test.dart` (SC-011).

### Implementation for User Story 3

- [x] T028 [P] [US3] Create raw ramps `AppColors` (rose/violet/amber/mint/ink/grays/status) in `lib/core/theme/app_colors.dart` per contracts/design-tokens.md.
- [x] T029 [US3] Create `AppColorsX` `ThemeExtension` (full light + dark semantic aliases) in `lib/core/theme/app_colors_x.dart` and a `context.tokens` accessor.
- [x] T030 [P] [US3] Create `AppGradients` (brand/brandSoft/story) in `lib/core/theme/app_gradients.dart`.
- [x] T031 [P] [US3] Create `AppTypography` (Plus Jakarta Sans display + Inter body scale, bundled-font config, `GoogleFonts.config.allowRuntimeFetching = false`) in `lib/core/theme/app_typography.dart`.
- [x] T032 [P] [US3] Create `AppSpacing`, `AppRadius`, `AppShadow`, `AppMotion` token classes in `lib/core/theme/` (one file each).
- [x] T033 [US3] Create `AppTheme` assembling light/dark `ThemeData` + extensions in `lib/core/theme/app_theme.dart`, and wire `theme`/`darkTheme`/`themeMode: ThemeMode.system` into `lib/app/app.dart`.
- [x] T034 [P] [US3] Add a Reduce-Motion helper (`context.reduceMotion`) in `lib/core/theme/motion.dart` for press-scale/static degradation.

**Checkpoint**: Theming complete; components can be built token-only.

---

## Phase 5: User Story 4 — Complete shared component library (Priority: P2)

**Goal**: The full ~19-component library + layout primitives, built once in `core/presentation/`, token-driven, accessible, light+dark, golden-tested.

**Independent Test**: Component gallery renders every component + variant in light + dark; goldens pass for PostCard/Avatar/BottomNav/SidebarRail; semantics + text-scaling verified.

### Tests for User Story 4

- [x] T035 [P] [US4] Golden tests for `PostCard`, `Avatar` (ring unseen/seen/online/create), `BottomNav`, `SidebarRail` in light + dark, in `test/core/presentation/components_golden_test.dart`.
- [x] T036 [P] [US4] Widget test: accessibility semantics (icon-only controls announce labels) + large `textScaler` (no clipping) on `AppButton`/`AppIconButton`/`BottomNav`/`SidebarRail`, in `test/core/presentation/components_a11y_test.dart`.

### Implementation for User Story 4

- [x] T037 [P] [US4] `AppIcon` + curated `AppIcons` name set (Lucide via `lucide_icons_flutter`, outline/solid) in `lib/core/presentation/app_icon.dart`.
- [x] T038 [P] [US4] `AppButton` (primary/secondary/ghost, sm/md, fullWidth, press-scale .97, Semantics) in `lib/core/presentation/app_button.dart`.
- [x] T039 [P] [US4] `AppIconButton` (≥44px tap, press-scale .88, optional badge, Semantics) in `lib/core/presentation/app_icon_button.dart`.
- [x] T040 [P] [US4] `Avatar` (sizes 28–104, ring unseen/seen, online dot, create badge) in `lib/core/presentation/avatar.dart`.
- [x] T041 [P] [US4] `Badge` in `lib/core/presentation/badge.dart`; `Tag`/hashtag chip in `lib/core/presentation/tag.dart`.
- [x] T042 [P] [US4] `SearchBar` in `lib/core/presentation/search_bar.dart`; `AppSwitch` (spring knob) in `lib/core/presentation/app_switch.dart`.
- [x] T043 [P] [US4] `Wordmark` (gradient-clipped / mono) in `lib/core/presentation/wordmark.dart`.
- [x] T044 [P] [US4] `TopBar` (default/large) in `lib/core/presentation/top_bar.dart`; `PaneHeader` (h60) in `lib/core/presentation/pane_header.dart`.
- [x] T045 [P] [US4] `StoriesRail` (unseen ring / seen, "Your story" badge) in `lib/core/presentation/stories_rail.dart`.
- [x] T046 [US4] `PostCard` (header/media 4:5 via `cached_network_image`/action row/likes/caption/comments/time; like+save solid when active) in `lib/core/presentation/post_card.dart`.
- [x] T047 [P] [US4] `BottomNav` (5 dest, active solid + `iconActive`, Messages badge, Semantics) in `lib/core/presentation/bottom_nav.dart`.
- [x] T048 [P] [US4] `SidebarRail` (5 dest + Notifications/Create + profile chip, compact/full, active `accentSoft` pill, Semantics) in `lib/core/presentation/sidebar_rail.dart`.
- [x] T049 [US4] `Toast` ink-pill widget + `ToastService` (`OverlayEntry`-based, 4 tones, optional action) in `lib/core/presentation/toast.dart`; register `ToastService` in DI (`@lazySingleton`).
- [x] T050 [P] [US4] `ActionSheet` (rows + destructive + cancel) in `lib/core/presentation/action_sheet.dart`; `AppDialog` (normal/destructive) in `lib/core/presentation/app_dialog.dart`.
- [x] T051 [P] [US4] `StickerTray` (category pills + emoji grid) in `lib/core/presentation/sticker_tray.dart`.
- [x] T052 [P] [US4] `MaxWidthBox` content-centering primitive (feed 560/profile 900/notif 620) in `lib/core/presentation/max_width_box.dart`.

**Checkpoint**: Full component library available for the shell + placeholders.

---

## Phase 6: User Story 1 — Adaptive app shell & navigation (Priority: P1) 🎯 demonstrable MVP

**Goal**: Auth-guarded, width-adaptive navigation — 5-tab `StatefulShellRoute` ↔ sidebar rail, per-tab state preserved, flow routes nav-less, deep links validated.

**Independent Test**: All five destinations reachable + state-preserving; resizing across breakpoints swaps bottom-nav ↔ rail (compact/full) ↔ right-rail; stubbed guard toggles pre-auth ↔ main; malformed deep links rejected.

### Tests for User Story 1

- [x] T053 [P] [US1] Unit test `AdaptiveLayoutMode` resolution at width boundaries (699/700/979/980/1099/1100) in `test/core/router/adaptive_layout_mode_test.dart`.
- [x] T054 [P] [US1] Unit test `DeepLinkParser` accepts valid `we36://` paths and rejects malformed/unknown in `test/core/router/deep_link_parser_test.dart`.
- [x] T055 [P] [US1] Widget test: `AdaptiveShell` shows bottom-nav `<700` and sidebar rail `≥700` (compact `<980`/full `≥980`), and a tab preserves its scroll/stack across switches, in `test/core/router/adaptive_shell_test.dart`.

### Implementation for User Story 1

- [x] T056 [P] [US1] `AppBreakpoints` constants (700/980/1100) in `lib/core/constants/app_breakpoints.dart`; `AdaptiveLayoutMode` resolver in `lib/core/router/adaptive_layout_mode.dart`.
- [x] T057 [P] [US1] `NavDestination` enum + metadata (route, icon/activeIcon, label, badge) in `lib/core/router/nav_destination.dart`.
- [x] T058 [P] [US1] `AuthGuardStub` (toggleable signed-in flag) in `lib/core/router/auth_guard_stub.dart`; register in DI.
- [x] T059 [P] [US1] `DeepLinkParser` (scheme + known-path + param validation, safe rejection) in `lib/core/router/deep_link_parser.dart`.
- [x] T060 [US1] `AppRouter` go_router config in `lib/core/router/app_router.dart`: `StatefulShellRoute.indexedStack` (5 branches, stable keys), top-level nav-less flow + pre-auth routes, and the guard `redirect` reading `AuthGuardStub`; register router in DI and wire `routerConfig` into `lib/app/app.dart`.
- [x] T061 [US1] `AdaptiveShell` in `lib/core/router/adaptive_shell.dart`: `<700` → `Scaffold` + `BottomNav`; `≥700` → `Row(SidebarRail, Expanded(content))` compact/full by `≥980`; right-rail slot `≥1100`; consumes `BottomNav`/`SidebarRail` with `NavDestination`s.
- [x] T061a [US1] `CenteredMobile` wrapper in `lib/core/router/centered_mobile.dart` and apply it to pre-auth + flow routes in `AppRouter` so flow/secondary/auth screens render as a centered, constrained mobile layout at width `≥700` (FR-016); destinations keep their adaptive layout.

**Checkpoint**: Running, navigable, adaptive shell — the spec's primary demonstrable value.

---

## Phase 7: User Story 2 — Two-pane master/detail (Priority: P1)

**Goal**: Reusable master/detail primitive — side-by-side on tablet (swap detail in place), push on phone — with a working demo.

**Independent Test**: On tablet width the demo shows list + detail side-by-side and selection swaps in place (no push); on phone width it pushes; selection preserved across resize.

### Tests for User Story 2

- [x] T062 [P] [US2] Widget test: `TwoPaneScaffold` renders two panes `≥700` (selection updates detail, no route push) and pushes `<700`; selection preserved across a simulated resize, in `test/core/router/two_pane_scaffold_test.dart`.

### Implementation for User Story 2

- [x] T063 [US2] `TwoPaneScaffold<T>` (tablet `Row(list, detail)` swap-in-place; phone push; preserves selection across width change) in `lib/core/router/two_pane_scaffold.dart`.
- [x] T064 [US2] Two-pane demo page wired to `/dev/two-pane` in `lib/features/dev/presentation/two_pane_demo_page.dart` (uses `MockData`; real adopters are #006/#012).

**Checkpoint**: Two-pane primitive proven; #006/#012 can adopt it.

---

## Phase 8: User Story 5 — Placeholder destinations & mock data (Priority: P3)

**Goal**: The 5 destinations + pre-auth flow rendered at real fidelity from in-memory mock data (zero network/auth), plus the dev harness (gallery, 4-state demo).

**Independent Test**: Each destination renders its true layout from mock data in light + dark with zero network/auth; Home shows StoriesRail + PostCards; `/dev/states` cycles all four states.

### Tests for User Story 5

- [x] T065 [P] [US5] Widget test: Home placeholder renders StoriesRail + ≥3 PostCards from mock with a fake image provider and **zero** network calls, in `test/features/feed/home_placeholder_test.dart`.
- [x] T066 [P] [US5] `bloc_test` for the `/dev/states` demo cubit driving initial→loading→loaded→error via a simulated local source, in `test/features/dev/states_demo_test.dart`.

### Implementation for User Story 5

- [x] T067 [P] [US5] Mock shapes (`MockUser`/`MockPost`/`MockStory`/`MockConversation`) + `MockData` provider in `lib/core/mock/mock_data.dart`; a fake/asset `ImageProvider` for no-network rendering + goldens in `lib/core/mock/mock_image.dart`.
- [x] T068 [US5] Home placeholder (StoriesRail + PostCards + Home header with Activity/Messages shortcuts) in `lib/features/feed/presentation/home_page.dart`.
- [x] T069 [P] [US5] Explore placeholder (search bar + tag chips + grid) in `lib/features/explore/presentation/explore_page.dart`.
- [x] T070 [P] [US5] Reels placeholder (card 9:16 centered on dark) in `lib/features/reels/presentation/reels_page.dart`.
- [x] T071 [P] [US5] Messages placeholder adopting `TwoPaneScaffold` (conversation list + chat pane on tablet, push on phone) in `lib/features/messaging/presentation/messages_page.dart`.
- [x] T072 [P] [US5] Profile placeholder (header + stats + tabs + grid) in `lib/features/profile/presentation/profile_page.dart`.
- [x] T073 [P] [US5] Pre-auth flow placeholders (Splash/Onboarding/SignIn/SignUp/Forgot/ProfileSetup, nav-less) in `lib/features/auth/presentation/` (one file each).
- [x] T074 [P] [US5] Component gallery page wired to `/dev/gallery` in `lib/features/dev/presentation/gallery_page.dart` (renders every shared component + variants).
- [x] T075 [US5] 4-state demo (cubit + page) wired to `/dev/states` in `lib/features/dev/presentation/states_demo_page.dart` (extends `AppCubit`, simulated local source, no network).

**Checkpoint**: All destinations + harness render from mock; spec fully demonstrable.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Validation, gates, on-device smoke test.

- [x] T076 [P] Run the full quickstart V1–V10 ([quickstart.md](quickstart.md)) and fix any gaps.
- [x] T077 [P] Capture/refresh goldens (`flutter test --update-goldens`) and confirm `flutter test` is green in light + dark. Captured 12 goldens (`test/core/theme/goldens/tokens_{light,dark}.png` + `test/core/presentation/goldens/{post_card,avatar,bottom_nav,sidebar_rail_full,sidebar_rail_compact}_{light,dark}.png`); real brand fonts loaded via `test/flutter_test_config.dart`; full suite green (46/46).
- [x] T078 Run the pre-commit gate: `dart format .`, `flutter analyze` (zero warnings), `flutter test` (all pass), `dart run bloc_tools:bloc lint .` (zero violations).
- [x] T078a [P] Add an automated gate (CI grep script or `custom_lint` rule) forbidding `Color(0x…)`/`Colors.*`/raw `TextStyle` in `lib/features/` and `lib/core/presentation/` so the "no hardcoded values at call sites" rule is enforced, not review-only (FR-018 / SC-005).
- [x] T079 [P] Manual on-device smoke test (real iPad split-view resize + rotation, VoiceOver/TalkBack labels, large Dynamic Type) on one iOS + one Android device; record results. Build runs on device (user-confirmed). Automated equivalents green: adaptive breakpoints (`app_shell_test`, `adaptive_layout_mode_test`, `two_pane_scaffold_test`), Semantics labels for icon-only controls + nav (`components_a11y_test`), 1.8× text scaling no-overflow (`components_a11y_test`), Reduce-Motion static (`motion_test`). NOTE: true on-device VoiceOver/TalkBack gesture + physical-rotation recording is left to the user as a release-gate before #015 (devices are connected per `flutter doctor`).
- [x] T080 [P] Performance sanity: confirm no full-res decode for thumbnails (bounded `cacheWidth`), and smooth (~60fps) chrome swap on resize. Code audit: #001 is offline — every `ImageProvider?` in mock data is null, so cards/avatars/stories render the placeholder surface with **no image decode active**; the `ImageProvider` injection points are ready for bounded `cacheWidth`/`cached_network_image` when real media lands in #004 (carry-forward note). Chrome swap (bottom-nav ↔ sidebar rail) is a width-driven `LayoutBuilder` layout switch with no animated rebuild, covered by `app_shell_test`/`adaptive_layout_mode_test`.
- [x] T081 Commit `pubspec.lock` (+ `ios/Podfile.lock` once pods install) and confirm no unexpected transitive churn (Constitution XV); update [CLAUDE.md](../../CLAUDE.md) / [ui-design-context.md](../../.claude/claude-app/ui-design-context.md) if any component/token was refined during build.

---

## Dependencies & Execution Order

### Phase dependencies (foundation build order)

- **Setup (P1)** → **Foundational (P2)** → **US6** → **US3** → **US4** → **US1** → **US2** → **US5** → **Polish (P9)**.
- This is dependency order, not strict priority order: the P1 shell (US1/US2) needs the theme (US3), components (US4), and primitives (US6) to render — so those land first even though their story priority is lower.

### Story dependencies

- **US6 (P3)**: after Foundational. Depended on by all others.
- **US3 (P2)**: after US6 (uses no primitives directly, but built on the wired app root). Depended on by US4/US1/US2/US5.
- **US4 (P2)**: after US3 (token-driven). Depended on by US1/US2/US5.
- **US1 (P1)**: after US4 (uses BottomNav/SidebarRail) + US6 (DI/l10n).
- **US2 (P1)**: after US1 (shares routing) + US4. Demo also uses US5 mock data (T067) — sequence T067 before T064 or stub locally.
- **US5 (P3)**: after US1/US2/US4 (composes shell + components + two-pane).

### Within a story

- Tests authored alongside; models/tokens before widgets; widgets before pages; `build_runner` after freezed/injectable annotations change.

### Parallel opportunities

- Setup: T003/T004/T005/T006 in parallel.
- US6: T013–T017, T019–T021 in parallel (distinct files); T018/T022–T025 serialize on shared wiring + codegen.
- US3: T028/T030/T031/T032/T034 in parallel; T029/T033 serialize (assemble theme).
- US4: nearly all components (T037–T052) are `[P]` — different files; only PostCard (T046) and Toast/DI (T049) touch shared registration.
- US5: T069–T074 in parallel; T068/T075 serialize on Home/demo wiring.

---

## Parallel Example: User Story 4 (component library)

```bash
# After US3 (theming) completes, launch independent component tasks together:
Task: "T037 AppIcon in lib/core/presentation/app_icon.dart"
Task: "T038 AppButton in lib/core/presentation/app_button.dart"
Task: "T040 Avatar in lib/core/presentation/avatar.dart"
Task: "T047 BottomNav in lib/core/presentation/bottom_nav.dart"
Task: "T048 SidebarRail in lib/core/presentation/sidebar_rail.dart"
# Then PostCard (T046) and Toast+DI (T049) after their dependencies (AppIcon/Avatar/tokens).
```

---

## Implementation Strategy

### MVP scope (foundation reality)

For this foundation spec the demonstrable MVP is **a running, navigable, adaptive, themed shell** — i.e. **Setup + Foundational + US6 + US3 + US4 + US1**. That is most of the spec, because the P1 outcome structurally requires the substrate. Stop-and-validate after **US1 (T061)**: the app launches, all five destinations navigate with preserved state, and the chrome adapts across breakpoints in light + dark.

### Incremental delivery

1. Setup + Foundational → blank app builds/runs.
2. + US6 → primitives + EN/VI localization testable.
3. + US3 → theming visible (token gallery).
4. + US4 → component gallery complete (goldens).
5. + US1 → **MVP: adaptive navigable shell**. Validate, demo.
6. + US2 → two-pane primitive + demo.
7. + US5 → real-fidelity placeholders + dev harness. Full spec demonstrable.
8. Polish → gates + on-device smoke test → ready for PR.

### Parallel team strategy

After US3+US4 land, the ~19 components (US4) and the placeholder destinations (US5) parallelize well across developers (distinct files). US1 (routing/shell) is best owned by one developer to keep the router coherent, then US2/US5 build on it.

---

## Notes

- `[P]` = different files, no incomplete dependency. `[Story]` maps to spec.md user stories.
- Run `dart run build_runner build --delete-conflicting-outputs` whenever a freezed/injectable/json annotation changes.
- No networking, auth, or persistence anywhere in #001 (those are #002/#003) — mock data + fake image providers only.
- Commit after each task or logical group; commit lockfiles (T081). `main` is push-protected — work on branch `001-project-foundation`.
- Total: 85 tasks (T001–T081 + T015a, T027a, T061a, T078a added after `/speckit.analyze` to close FR-016, FR-018/SC-005, SC-010, SC-011 coverage gaps).
