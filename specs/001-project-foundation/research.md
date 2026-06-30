# Phase 0 Research — Project Foundation, Design System & Navigation

All versions fetched from pub.dev on 2026-06-30 (Constitution XV — never guessed). Toolchain: Flutter 3.41.7 / Dart 3.11.5 stable.

---

## R1. Adaptive shell: custom vs `flutter_adaptive_scaffold`

**Decision**: Build a custom `AdaptiveShell` widget driven by `LayoutBuilder`/`MediaQuery` width, wrapping `go_router`'s `StatefulShellRoute.indexedStack`. No adaptive-scaffold package.

**Rationale**: The We36 chrome is specific — bottom nav `<700`; sidebar rail (compact icon-only `<980`, full labeled `≥980`) that promotes Notifications + Create + a profile chip; centered content with a conditional right "Suggestions" rail `≥1100`; two-pane master/detail for Messages + Post detail. `flutter_adaptive_scaffold` imposes its own slot model and would fight these exact rules. A custom shell is ~one width-switch widget, gives pixel control, removes a dependency (YAGNI, Constitution XIII), and keeps one nav model with width-only adaptation (Constitution VI/VII).

**Alternatives considered**: `flutter_adaptive_scaffold` (Google) — rejected: opinionated slots, harder to match the rail compact/full + right-rail + two-pane spec; still need custom two-pane anyway.

## R2. Two-pane master/detail primitive

**Decision**: Custom `TwoPaneScaffold` widget: at tablet width renders `Row(listPane, detailPane)` and swaps the detail in place via a selection callback (no route push); at phone width it pushes the detail as a full-screen route. Generic over a list item type; ships with a dev demo. Messages (#012) and Post detail (#006) plug content in later.

**Rationale**: Master/detail is the biggest tablet payoff and structurally part of the shell (FR-014). Building the primitive + demo now means #006/#012 inherit it instead of reinventing, preventing redesign. Same Cubit, two presentations — only the layout differs.

**Alternatives considered**: Defer to #006/#012 — rejected at clarify (chose "build primitive in #001"). `flutter_adaptive_scaffold` two-pane — rejected per R1.

## R3. Breakpoints

**Decision**: Width thresholds (logical px), from `ui-design-context.md` §Responsive: `< 700` phone (bottom nav); `≥ 700` tablet (sidebar rail); rail compact `< 980` / full `≥ 980`; Home right-rail `≥ 1100`. Centralized as named constants (`AppBreakpoints`); evaluated by window width via `LayoutBuilder`, never device model — so iPad split-view/rotation reflow correctly.

**Rationale**: Matches the design source and Constitution VII (width-driven, split-view aware). Centralizing avoids magic numbers scattered across widgets.

**Alternatives considered**: `MediaQuery.size` device-class heuristics — rejected (breaks split-view).

## R4. Design tokens: `ThemeExtension` semantic aliases

**Decision**: Encode semantic tokens (`surface`, `surface2`, `border`, `textPrimary/Secondary/Tertiary`, `accent`, `iconActive`, `overlay`, status colors, gradients, etc.) as a custom `ThemeExtension` (`AppColorsX`) plus parallel `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadow`, `AppMotion`, `AppGradients` token classes. Light and dark each supply a full `AppColorsX`. Widgets read `Theme.of(context).extension<AppColorsX>()!` (or a `context.tokens` helper) — never hardcoded hex. Dark is ink-tinted (`#0E0E1A` bg, never pure black).

**Rationale**: `ThemeExtension` is the idiomatic Flutter way to carry a fixed custom palette through light/dark with `MaterialApp`'s `theme`/`darkTheme`, giving automatic system-mode following (Constitution VI: light/dark/system only, no picker). Semantic names enforce "use aliases, never hex at call sites."

**Alternatives considered**: A global `AppColors` static referenced directly — rejected: doesn't switch with light/dark via the framework; risks call sites reading the wrong mode.

## R5. Fonts: bundle Plus Jakarta Sans + Inter (no runtime fetch)

**Decision**: Use `google_fonts ^8.1.0` **with the TTFs bundled** under `assets/fonts/` and declared so the package serves them locally (set `GoogleFonts.config.allowRuntimeFetching = false`). Display = Plus Jakarta Sans (400–800), Body/UI = Inter (400–700). Wordmark = Plus Jakarta Sans 800 gradient-clipped.

**Rationale**: #001 is strictly no-network; runtime font fetching would violate that and make golden tests non-deterministic/flaky. Bundling gives offline determinism and stable goldens while honoring the constitution's named font stack. `google_fonts` retained (constitution Technical Standards lists it) but pinned to bundled assets.

**Alternatives considered**: Pure runtime `google_fonts` fetch — rejected (network + non-deterministic goldens). Plain `pubspec fonts:` without google_fonts — viable, but keeping google_fonts matches the stated stack and eases later weights.

## R6. Icons: `lucide_icons_flutter`

**Decision**: `lucide_icons_flutter ^3.1.14`. Wrap in a single `AppIcon` widget (24px, stroke 2, round cap; outline default, solid/filled variant for active states — home/like/save/reels) exposing a curated `AppIcons` name set. No mixing of `Icons`/`CupertinoIcons`/emoji (Constitution VI).

**Rationale**: Among Lucide ports, `lucide_icons_flutter` is the most actively maintained (latest 3.1.14, published 2026-05; tracks the upstream Lucide monorepo). `lucide_icons` (0.257.0) is stale since 2023; `flutter_lucide` is maintained but smaller adoption. A single `AppIcon` wrapper isolates the dependency so swapping is a one-file change.

**Alternatives considered**: `lucide_icons` (stale) — rejected. `flutter_lucide` — viable fallback. Custom SVG icon set via `flutter_svg` — rejected (Lucide already complete; more upkeep).

## R7. Toast: custom overlay, no package

**Decision**: Build a custom `Toast` (ink-pill, colored dot icon by tone success=mint/error=rose/info=violet/neutral=gray, optional action) shown via an `OverlayEntry`-based service registered in DI. `ScaffoldMessenger.showSnackBar` is forbidden (Constitution VI).

**Rationale**: The design's toast is bespoke (pill, dot, tones, custom motion) and must be reachable app-wide including over nav-less routes; an overlay service is the clean fit and avoids a dependency.

**Alternatives considered**: A toast/snackbar package (e.g. `another_flushbar`, `toastification`) — rejected: YAGNI + design-specific styling + constitution forbids the default snackbar path anyway.

## R8. Routing + stubbed auth guard

**Decision**: `go_router ^17.3.0` with `StatefulShellRoute.indexedStack` for the 5 tabs (stable keys, per-tab stack/scroll). Routes centralized in `AppRoutes`. A `redirect` reads a stubbed session source (`AuthGuardStub` — a simple toggleable signed-in/out flag, dev-only) to split pre-auth vs main app. Flow routes are top-level (outside the shell) so they render nav-less full-screen. A `DeepLinkParser` validates scheme (`we36://`) + known paths and rejects malformed/unknown links.

**Rationale**: Matches Constitution X exactly while keeping real auth out of scope (#003). Putting the guard behind a tiny stub that #003 later replaces with the real session Cubit means the routing shape is final now and only the data source swaps.

**Alternatives considered**: No guard until #003 — rejected (FR-004/005 require both zones reachable + the redirect shape proven now).

## R9. Foundation primitives

**Decision**:
- `Result<T>` = freezed sealed `Ok(T) | Err(AppFailure)` with `.fold()`.
- `AppFailure` = freezed sealed enumerating the full constitution-V set (`unauthenticated`, `sessionExpired`, `forbidden`, `notFound`, `validation`, `conflict`, `rateLimited`, `networkError`, `serverError`, `timeout`, `offline`, `unknown`, plus the media/auth/realtime variants) — defined now as the shared vocabulary even though #001 only exercises a few; each maps to a localized message.
- `AppState<T>` = freezed sealed 4-state (`initial | loading | loaded(T) | error(AppFailure)`); `AppCubit<T>` base provides `emitLoading/emitLoaded/emitError` + a `run(Future<Result<T>>)` helper.
- `AppLogger` = thin leveled logger (debug/info/warn/error) with a redaction guard; raw `print`/`debugPrint` forbidden.
- Formatters: `CountFormatter` (38.4k / 1.2M / 1,240 — locale-aware via `intl`) and `RelativeTimeFormatter` (2h / 1d — locale-aware).

**Rationale**: These are the exact vocabulary #002+ consume; defining the full sealed sets once avoids churn later. Demonstrating all four `AppState` transitions via a simulated local source (FR-028a) lets bloc_test cover the pattern now.

**Alternatives considered**: Minimal `AppFailure` (only what #001 uses) — rejected: every later spec would re-edit the sealed class; define complete now. `dartz`/`fpdart` for `Result` — rejected (YAGNI; a small freezed sealed type is enough).

## R10. DI, codegen, i18n, lint, test

**Decision**: `get_it ^9.2.1` + `injectable ^3.0.0` (`@lazySingleton` for services/shared cubits, `@injectable` for screen cubits; eager `@singleton` forbidden) generated by `injectable_generator ^3.1.0` + `build_runner ^2.15.0`. States/models via `freezed ^3.2.5` + `json_serializable ^6.14.0`. i18n via Flutter `gen-l10n` (`flutter_localizations` + `intl ^0.20.3`), ARB in `lib/l10n/arb/` (`app_en.arb` primary + `app_vi.arb` fully translated), accessed via a `context.l10n` extension. Lint `very_good_analysis ^10.3.0` + `bloc_lint`. Test `bloc_test ^10.0.0` + `mocktail ^1.0.5`; goldens for PostCard/Avatar/BottomNav/SidebarRail in light+dark.

**Rationale**: This is the constitution's prescribed stack; versions confirmed current on pub.dev. gen-l10n is built-in (no extra package) and the standard ARB path.

**Alternatives considered**: `slang` for i18n — rejected (constitution specifies ARB/intl). Hand-rolled DI — rejected (injectable is the prescribed standard).

## R11. Accessibility (baked in — clarified)

**Decision**: Every shared component exposes `Semantics` (labels/roles, including icon-only `IconButton`/`BottomNav`/`SidebarRail` items) and lays out with text-scale tolerance (no fixed-height text rows that clip at large `textScaler`). Press feedback = scale-down; Reduce-Motion → static. Full audit (contrast on media overlays, focus order) remains #015, but components ship accessible.

**Rationale**: Clarify decision (FR-024a/SC-012). Adding semantics + scaling at the component layer now is far cheaper than retrofitting across every screen later.

**Alternatives considered**: Defer all a11y to #015 — rejected at clarify.

## R12. Mock data strategy

**Decision**: In-memory `MockData` provider in `core` (or `features/dev`) supplying sample users, posts (with `cached_network_image` URLs pointing at stable placeholder image hosts only as display targets — but to honor "no network", PostCard mock uses bundled asset images or solid-color placeholders in tests/goldens), stories, and conversations. Placeholder destinations render real layouts from this. Golden tests use bundled assets / fake image providers so they never hit the network.

**Rationale**: FR-025/026 require real-fidelity placeholders with zero network. Using bundled/fake images keeps the "no networking" guarantee testable and goldens deterministic, while `PostCard` still proves the `cached_network_image` integration path for #004.

**Alternatives considered**: Remote sample images — rejected (violates no-network + flaky goldens). Keep `cached_network_image` wired but feed it a fake/asset provider in #001.

---

## Resolved unknowns

No `NEEDS CLARIFICATION` remain. The spec's previously-Outstanding **performance** dimension is now pinned (R1–R3 + 60fps target in plan Technical Context). Persistence engine (drift vs hive) is intentionally **not** decided here — it has no bearing on #001 (no cache) and is owned by #002.
