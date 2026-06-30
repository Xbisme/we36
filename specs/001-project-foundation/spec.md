# Feature Specification: Project Foundation, Design System & Navigation

**Feature Branch**: `001-project-foundation`

**Created**: 2026-06-30

**Status**: Draft

**Input**: User description: "Build the foundation for We36 — a cross-platform (iOS + Android phones + iPad/Android tablets) Instagram-style social media app built in Flutter. This first spec delivers the design-system shell, navigation, and shared building blocks that every later feature sits on. It contains NO networking, NO authentication, and NO real data — only the visual + structural foundation, validated with local mock data."

## Overview

This is the blocking foundation for We36 v1.0. It delivers four things every subsequent feature depends on: (1) an adaptive, auth-guarded navigation shell that works on phones and tablets/iPad from one codebase; (2) a fixed light/dark design-token system carrying the We36 brand identity; (3) the complete shared component library, built once; and (4) the app-wide foundation primitives (typed results/failures, a base presentation state, logging, formatters, dependency injection, and localization). It ships with placeholder destination pages rendered at real fidelity using local mock data — no networking, no authentication, no real backend.

The goal is leverage: by building the navigation, theming, and component library once and correctly here, every one of the 14 remaining specs becomes "a new screen plus a repository" that only assembles existing pieces — it never re-styles or re-architects.

## Clarifications

### Session 2026-06-30

- Q: Accessibility for the shared component library in #001 — bake in now or defer to #015? → A: Bake in from the start — every shared component ships with screen-reader semantics (VoiceOver/TalkBack) and supports Dynamic Type / text-scaling now; the full a11y audit still happens in #015.
- Q: Vietnamese localization completeness in #001 (Definition of Done for SC-009)? → A: Both fully translated — the (small) #001 string set is translated completely in both English and Vietnamese so language switching updates every string end-to-end.
- Q: Do placeholder destinations / the four-state base demonstrate all four states or only loaded? → A: Demonstrate all four — placeholders (or a dedicated demo) exercise initial / loading / loaded / error via a simulated local source so the base state and BLoC tests cover every transition now.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Navigate the adaptive app shell on any form factor (Priority: P1)

A person opening the app lands in the main experience and can move between the five primary destinations — Home, Explore, Reels, Messages, Profile — each remembering its own place. The same app, resized from a phone width to a tablet/iPad width (or rotated, or run in iPad split-view), seamlessly swaps its navigation chrome from a bottom bar to a left sidebar rail, and back, without losing where the person was. A separate pre-auth zone (splash → onboarding → sign-in/up → forgot password → profile setup) is reachable as placeholder screens with no app navigation chrome, gated from the main app by a guard.

**Why this priority**: The navigation spine is what makes the app an app. Every later feature is "a screen reachable from one of these destinations or flows." Without the adaptive shell and the auth-guarded split, nothing else can be placed. It is independently demonstrable and delivers the structural skeleton on its own.

**Independent Test**: Launch the app; confirm all five destinations are reachable and each preserves its own scroll position and back-stack when switched away and back. Toggle the (stubbed) auth guard and confirm the pre-auth flow placeholders show with no nav chrome and the main app shows with nav chrome. Resize the window across the phone↔tablet boundary and confirm the bottom bar and sidebar rail swap correctly, preserving the active destination.

**Acceptance Scenarios**:

1. **Given** the app is in the main (authenticated-stub) zone on a phone-width window, **When** the person taps each of the five bottom-bar destinations, **Then** the corresponding destination is shown and its independent navigation stack and scroll position are preserved when returning to it.
2. **Given** the app is showing a destination on a phone-width window, **When** the window is widened past the tablet threshold (or the device is rotated to a tablet-width layout), **Then** the bottom bar is replaced by a left sidebar rail showing the same active destination, with no loss of state.
3. **Given** the app is on a tablet-width window, **When** the window narrows below the compact threshold, **Then** the sidebar rail collapses to icon-only; widening past the full threshold restores icon-plus-label.
4. **Given** the sidebar rail is shown, **When** the person looks at it, **Then** it includes the five destinations plus Notifications and Create as first-class items and a profile chip, whereas the phone bottom bar shows only the five destinations (Create, Notifications, and the DM shortcut being reached contextually/from the Home header).
5. **Given** the stubbed auth guard is set to "signed out", **When** the app launches, **Then** the pre-auth flow placeholders are shown with no navigation chrome; **When** the guard is set to "signed in", **Then** the main app shell is shown.
6. **Given** a destination opens a full-screen flow (e.g. a pushed placeholder route), **When** it is displayed, **Then** the primary navigation chrome (bottom bar / rail) is hidden for that route.

---

### User Story 2 - Two-pane master/detail on wide layouts (Priority: P1)

On a tablet/iPad-width window, a list-plus-detail surface shows both panes side by side: selecting an item in the list updates the detail pane in place rather than pushing a new full screen. On a phone-width window, the very same flow falls back to push navigation (tap an item → push its detail). This spec provides the reusable two-pane primitive and a working demo; the real Messages (#012) and Post detail (#006) surfaces will plug their content into it later.

**Why this priority**: Master/detail is the single biggest tablet payoff and is structurally part of the adaptive shell. Building the primitive now — and proving it with a demo — means #006 and #012 inherit it instead of inventing it, and prevents a costly redesign later. It is testable in isolation via the demo.

**Independent Test**: Open the two-pane demo on a tablet-width window and confirm list and detail render side by side and selecting a list item swaps the detail pane without a route push. Narrow the window to phone width and confirm the same demo now pushes the detail as a full screen.

**Acceptance Scenarios**:

1. **Given** the two-pane demo on a tablet-width window, **When** the person selects an item in the list pane, **Then** the detail pane updates in place and no new full-screen route is pushed.
2. **Given** the two-pane demo on a phone-width window, **When** the person selects an item in the list, **Then** the detail is shown as a pushed full-screen route with a back affordance.
3. **Given** the window is resized across the phone↔tablet threshold while a detail is open, **When** the layout changes, **Then** the current selection is preserved and presented in the appropriate mode (side-by-side vs pushed).

---

### User Story 3 - Consistent light & dark theming from semantic tokens (Priority: P2)

Every surface, text level, border, icon, accent, and status color comes from a fixed, named design-token system with a complete light and dark variant. The app honors the device light/dark setting (and can be previewed in either), and the We36 brand identity — rose + violet, the signature gradient, the two type families, and the spacing/radius/shadow/motion scales — is expressed through these tokens. The "color earns its place" rule holds: chrome and surfaces stay neutral, and brand color or gradient appears only on highlights (primary CTAs, unseen story rings, the active navigation item, badges, stickers) — never as a full-page background.

**Why this priority**: Theming underpins the component library and every screen. It must be correct before components are built so light/dark and brand restraint are baked in, not retrofitted. It is independently verifiable by previewing the token set in both modes.

**Independent Test**: Render a token/style gallery in both light and dark and confirm each semantic token resolves to its specified value, type families and scale are applied, and brand color/gradient appear only on designated highlight elements — never as a page wash. Switch the device theme and confirm the whole app follows.

**Acceptance Scenarios**:

1. **Given** the app is in light mode, **When** any screen renders, **Then** all colors, type, spacing, radii, shadows, and motion derive from named semantic tokens with no hardcoded values at the screen level.
2. **Given** the device theme is changed between light, dark, and system, **When** the app reacts, **Then** every surface updates to the corresponding palette (dark is ink-tinted, never pure black) with no orphaned hardcoded colors.
3. **Given** any screen, **When** brand color or the brand gradient appears, **Then** it appears only on a primary CTA, an unseen story ring, the active navigation item, a badge, or a sticker — and the gradient is never used as a full-page background.
4. **Given** the device has Reduce Motion enabled, **When** an interaction occurs, **Then** decorative/looping motion degrades to a static state and only press-scale feedback (and equivalent essential motion) remains.

---

### User Story 4 - Complete shared component library (Priority: P2)

The full set of reusable UI components is built once and themed for light and dark: Button (primary/secondary/ghost), IconButton, a unified single-family icon set, Avatar (with story-ring states, online dot, create badge), Badge, Tag/hashtag chip, PostCard, SearchBar, Switch, BottomNav, SidebarRail, StoriesRail, TopBar, PaneHeader, Wordmark, Toast (custom — not the platform default), ActionSheet, Dialog, and the Sticker tray. Each honors the tokens and the design-system rationale (voice, iconography, "color earns its place"). Feature specs compose these; they never re-create the markup.

**Why this priority**: The component library is the reuse surface for all 14 later specs. Building it completely here is the explicit leverage of this foundation. It is independently testable via a component gallery and golden tests.

**Independent Test**: Render every component in a gallery in light and dark, exercise each documented variant/state (e.g. button kinds, avatar ring seen/unseen/online/create, toast tones), and confirm each matches the design source and uses only tokens. Capture golden snapshots for the visually critical components.

**Acceptance Scenarios**:

1. **Given** the component gallery, **When** it is rendered in light and dark, **Then** every component in the library is present and themed correctly in both modes.
2. **Given** a component with variants/states (e.g. Avatar ring unseen/seen/online/create, Button primary/secondary/ghost, Toast success/info/error/with-action), **When** each variant is rendered, **Then** it matches its specification in the design source and consumes only semantic tokens.
3. **Given** a feature screen needs a recurring element (post card, avatar, bottom nav, toast, action sheet, dialog), **When** it is built, **Then** it composes the shared component rather than duplicating its markup.

---

### User Story 5 - Placeholder destinations rendered with mock data (Priority: P3)

The five destination pages and key shells render at real fidelity using local sample data only — Home shows the stories rail plus a few post cards, and the other destinations render their true layout — so the design system and navigation can be reviewed and golden-tested immediately. None of this touches a network, a repository, or authentication; the data is local and illustrative.

**Why this priority**: Real-fidelity placeholders make the foundation reviewable and golden-testable now, and they validate that the component library and tokens compose into the actual screens later features will fill in. It depends on the shell, theming, and components, so it follows them.

**Independent Test**: Open each of the five destinations and confirm it renders its real layout populated with local mock data, in light and dark, with no network activity. Confirm Home shows the stories rail and several post cards built from the shared components.

**Acceptance Scenarios**:

1. **Given** the main app shell, **When** the Home destination is opened, **Then** it renders the stories rail and multiple post cards built from the shared components using local mock data, with no network calls.
2. **Given** any of the five destinations, **When** it is opened in light or dark, **Then** it renders its true layout populated with local mock data and consuming only shared components and tokens.
3. **Given** the app runs end to end, **When** any destination loads its mock data, **Then** no network request, repository call, or authentication occurs.

---

### User Story 6 - App-wide foundation primitives & localization (Priority: P3)

The shared building blocks every later feature reuses exist and are exercised: a typed result wrapper for fallible operations and a typed app-failure model; a base four-state presentation unit (initial / loading / loaded / error) that screens extend; a single app logger used for all logging (never raw prints, never secrets); locale-aware formatters for abbreviated counts (e.g. 38.4k, 1.2M) and relative time (e.g. 2h, 1d); dependency-injection wiring; and the localization setup with English as the primary locale and Vietnamese as the first secondary locale. Two build flavors (dev and prod) exist, each with its own app identifier and an empty config slot for a future API/realtime endpoint.

**Why this priority**: These primitives are the vocabulary and scaffolding that #002+ build on (repositories return the typed result, Cubits extend the base state, counts/times use the shared formatters, strings come from localization). They are independently testable as units even with no feature behavior yet.

**Independent Test**: Unit-test the result/failure types, the four-state base, the count/relative-time formatters (incl. locale switching), and confirm the logger never emits secrets. Build and run both flavors and confirm each reports its own identifier and config. Switch the app language between English and Vietnamese and confirm UI strings follow.

**Acceptance Scenarios**:

1. **Given** a fallible operation, **When** it succeeds or fails, **Then** it is expressed through the typed result/failure types rather than throwing, and a screen state can be derived from it via the four-state base.
2. **Given** a large number or a past timestamp, **When** the shared formatters are applied, **Then** they produce the abbreviated count (e.g. 38.4k) and relative time (e.g. 2h) in a locale-aware way, identically wherever used.
3. **Given** the app emits a log line, **When** it is written, **Then** it goes through the single app logger and contains no secret (no token, password, message body, email, phone, or precise location), and raw print/debugPrint is not used.
4. **Given** the app language is set to English or Vietnamese, **When** the UI renders, **Then** all user-facing strings resolve from the localization resources for that locale (English primary, Vietnamese secondary).
5. **Given** the dev and prod flavors, **When** each is built and launched, **Then** it uses its own app identifier (prod: app.we36, dev: app.we36.dev), its own app name, and an (empty this spec) config slot for a future API/realtime endpoint.

---

### Edge Cases

- **Window resize mid-flow**: When the window crosses an adaptive breakpoint while a full-screen flow or an open two-pane detail is showing, the current location/selection is preserved and re-presented in the mode appropriate to the new width.
- **iPad split-view / multitasking**: When the app window narrows (split-view) below the phone threshold, the layout reflows to the phone chrome (bottom bar, push navigation) and back when widened, without a restart.
- **Rotation**: Rotating between portrait and landscape re-evaluates the layout by width, not by a hardcoded device model.
- **Very wide windows**: At the widest breakpoint, Home may show an additional right-hand suggestions rail; below that width it is absent without layout breakage.
- **Theme change at runtime**: Switching light/dark/system while the app is open updates every visible surface with no orphaned hardcoded colors and no restart.
- **Reduce Motion**: With Reduce Motion enabled, decorative/looping motion is static; essential affordance feedback (press-scale) remains.
- **Stubbed guard transition**: Toggling the stubbed auth guard moves cleanly between the pre-auth zone and the main app without leaving stale chrome.
- **Empty mock data**: A placeholder destination given an empty mock dataset renders a sensible empty layout rather than breaking.

## Requirements *(mandatory)*

### Functional Requirements

**Structure & flavors**

- **FR-001**: The codebase MUST be organized into a clean, layered structure that separates shared infrastructure from feature modules, with shared infrastructure never depending on any feature module.
- **FR-002**: The app MUST provide two build flavors (dev and prod), each with its own app identifier (prod: app.we36, dev: app.we36.dev), its own app name, and a centralized, per-flavor configuration slot for a future API/realtime endpoint (left empty in this spec).
- **FR-003**: The app MUST perform a pre-launch bootstrap step that wires dependency injection and configuration before the UI is shown.

**Navigation & adaptive shell**

- **FR-004**: The app MUST separate a pre-auth zone (splash, onboarding, sign-in, sign-up, forgot password, profile setup — placeholders this spec) that shows no app navigation chrome, from the main app, gated by an auth guard.
- **FR-005**: The auth guard in this spec MUST be a stubbed toggle that makes both zones reachable for review; real authentication and guard logic are out of scope (deferred to #003).
- **FR-006**: The main app MUST present exactly five primary destinations — Home, Explore, Reels, Messages, Profile — and each MUST preserve its own independent navigation stack and scroll position when switching between them.
- **FR-007**: Create (post/story/reel) MUST NOT be a primary destination; it MUST be a contextual action. On phones, Notifications and the DM shortcut MUST be reachable from the Home header rather than as destinations.
- **FR-008**: Full-screen flows (viewers, multi-step create, chat, comments, settings, edit profile, etc. — placeholders this spec) MUST be presented as routes that hide the primary navigation chrome.
- **FR-009**: The app MUST provide deep-link / universal-link routing wiring into destinations, with per-feature link targets added by later specs; malformed or unknown links MUST be rejected rather than routed.
- **FR-010**: The app MUST be a single adaptive experience — one navigation model, one set of routes, one token set, one component set — where only the chrome adapts; a forked second screen set for tablets is FORBIDDEN.
- **FR-011**: Layout adaptation MUST be driven by the app window's logical width (reacting to resize, rotation, and iPad split-view/multitasking), never by a hardcoded device model.
- **FR-012**: At phone width (below the tablet threshold) the app MUST show a bottom navigation bar with the five destinations and an unread badge on Messages.
- **FR-013**: At tablet/iPad width (at or above the tablet threshold) the app MUST replace the bottom bar with a left sidebar rail that surfaces the five destinations plus Notifications and Create as first-class items and a profile chip; the rail MUST be icon-only below the compact threshold and icon-plus-label at or above the full threshold.
- **FR-014**: The app MUST provide a reusable two-pane master/detail primitive that, on tablet width, shows a list pane and a detail pane side by side and updates the detail pane in place on selection (no route push), and on phone width falls back to push navigation; this spec MUST include a working demo of the primitive (Messages and Post detail adopt it later).
- **FR-015**: On wide layouts the app MUST center content within a maximum readable width (e.g. feed column, profile, notifications), and at the widest breakpoint Home MAY show an additional right-hand suggestions rail that is absent below that width without breaking layout.
- **FR-016**: Flow/secondary/auth screens on tablet width MUST use a centered, constrained mobile layout (no separate tablet design at v1.0).

**Design tokens & theming**

- **FR-017**: The app MUST provide a fixed design-token system with complete light and dark variants; a user-facing color-scheme picker is FORBIDDEN, and only light/dark/follow-system is supported (the switcher UI itself is deferred to #014).
- **FR-018**: All visual properties at the screen/component level MUST be expressed through named semantic tokens (background, surface levels, border, text levels, accent, icon states, overlay, status colors); hardcoded raw color/value usage at call sites is FORBIDDEN.
- **FR-019**: The token system MUST express the We36 brand identity: rose and violet accents, the signature rose→violet gradient and the unseen-story-ring gradient, the two type families (a display face for headings/wordmark/counts and a readable face for body/UI), the type scale, and the spacing, radius, shadow, and motion scales (shadows ink-tinted, never pure black; dark surfaces ink-tinted, never pure black).
- **FR-020**: The "color earns its place" rule MUST be enforced: chrome, surfaces, and the feed stay neutral, and brand color or gradient appears only on a primary CTA, an unseen story ring, the active navigation item, a badge, or a sticker; the brand gradient MUST NOT be used as a full-page background.
- **FR-021**: The app MUST respect Reduce Motion by degrading decorative/looping motion to a static state, and MUST use press-scale feedback for interactive elements; infinite decorative loops are FORBIDDEN by default.

**Shared component library**

- **FR-022**: The app MUST build the complete shared component library once, in shared infrastructure: Button (primary/secondary/ghost), IconButton, a unified single-family icon set, Avatar (with story-ring seen/unseen states, online dot, create badge), Badge, Tag/hashtag chip, PostCard, SearchBar, Switch, BottomNav, SidebarRail, StoriesRail, TopBar, PaneHeader, Wordmark, Toast (custom), ActionSheet, Dialog, and the Sticker tray.
- **FR-023**: Each shared component MUST consume only design tokens, render correctly in light and dark, and follow the design-system rationale (voice/tone, single icon family, "color earns its place"); duplicating a component's markup inside a feature is FORBIDDEN.
- **FR-024**: User-facing transient messages MUST use the custom Toast component, not the platform default snackbar.
- **FR-024a**: Every shared component MUST be accessible from the start: it MUST expose screen-reader semantics (meaningful labels/roles for VoiceOver and TalkBack, including icon-only controls) and MUST support Dynamic Type / OS text-scaling without clipping or overlap. (The full accessibility audit — contrast on media overlays, focus order, etc. — remains in #015, but the component library ships accessible.)

**Placeholder destinations & mock data**

- **FR-025**: The five destination pages and key shells MUST render their true layout at real fidelity using local mock data only; Home MUST show the stories rail and several post cards built from the shared components.
- **FR-026**: No part of this spec may perform networking, repository access, or authentication; all data MUST be local and illustrative.

**Foundation primitives & localization**

- **FR-027**: The app MUST provide a typed result wrapper for fallible operations and a typed app-failure model, defined here as the shared vocabulary later repositories and Cubits return.
- **FR-028**: The app MUST provide a base four-state presentation unit (initial / loading / loaded / error) that feature screens extend.
- **FR-028a**: This spec MUST demonstrate all four presentation states (initial, loading, loaded, error) — via the placeholder destinations or a dedicated demo driven by a simulated local source (no network) — so every state transition is exercised and covered by tests now, not deferred to when real async arrives in #002.
- **FR-029**: The app MUST route all logging through a single app logger; raw print/debugPrint is FORBIDDEN, and no secret (token, password, message body, email, phone, precise location) may appear in any log.
- **FR-030**: The app MUST provide shared, locale-aware formatters for abbreviated counts (e.g. 38.4k, 1.2M, 1,240) and relative time (e.g. 2h, 1d); hand-formatting these at call sites is FORBIDDEN.
- **FR-031**: The app MUST wire dependency injection and a localization setup with English as the primary locale and Vietnamese as the first secondary locale; all user-facing strings MUST resolve from localization resources, with no hardcoded UI strings. Every user-facing string introduced in this spec MUST be fully translated in BOTH English and Vietnamese (the #001 string set is small — nav labels, placeholders, component text), so switching language updates every string with no untranslated fallback.

### Key Entities *(include if feature involves data)*

- **Navigation destination**: One of the five primary destinations (Home, Explore, Reels, Messages, Profile), each owning an independent navigation stack and scroll position; Messages carries an unread-count badge value.
- **Adaptive breakpoint state**: The current layout mode derived from window width (phone / tablet-compact / tablet-full / extra-wide) that selects the navigation chrome and content constraints.
- **Design token**: A named semantic value (color, type, spacing, radius, shadow, motion) resolved per light/dark mode and consumed everywhere in place of raw values.
- **Shared component**: A reusable, token-driven UI element with defined variants/states (e.g. Button kinds, Avatar ring states, Toast tones) composed by feature screens.
- **Mock content sample**: Local, illustrative data (e.g. sample users, posts, stories) used to populate placeholder destinations with no network or persistence.
- **App-wide primitive**: A foundation type/utility — the typed result, the typed app-failure, the four-state presentation base, the logger, and the count/relative-time formatters — reused by later features.
- **Flavor configuration**: A per-flavor (dev/prod) bundle of app identifier, app name, and an (empty this spec) endpoint config slot.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reviewer can reach and navigate all five primary destinations and confirm each preserves its own scroll position and back-stack across switches, in a single session, in both light and dark.
- **SC-002**: Resizing the window across each adaptive breakpoint (phone, tablet-compact, tablet-full, extra-wide) swaps the navigation chrome (bottom bar ↔ sidebar rail) and content layout correctly 100% of the time, preserving the active destination, with no restart.
- **SC-003**: The two-pane primitive demo shows list and detail side by side on tablet width (selection updates the detail in place, no route push) and falls back to push navigation on phone width — verified by toggling width with a selection open.
- **SC-004**: Every shared component listed in scope exists and renders correctly in both light and dark; golden snapshots exist for at least the visually critical components (e.g. PostCard, Avatar with ring states, BottomNav).
- **SC-005**: Toggling the device/app theme between light, dark, and system updates every visible surface with zero orphaned hardcoded colors, and no screen-level code references raw color values.
- **SC-006**: Brand color and the brand gradient appear only on the designated highlight elements (primary CTA, unseen story ring, active nav item, badge, sticker), and the gradient is never used as a full-page background — verifiable by inspecting the rendered destinations and component gallery.
- **SC-007**: Each of the five placeholder destinations renders its true layout populated with local mock data, in both themes, with zero network requests and zero authentication during the entire run.
- **SC-008**: Both flavors (dev and prod) build and run with no live backend, each reporting its own app identifier and app name.
- **SC-009**: Switching the app language between English and Vietnamese updates every user-facing string to a fully translated value (no untranslated fallback, no hardcoded UI strings remaining).
- **SC-010**: Unit and BLoC tests pass for the typed result/failure types, the four-state base (covering all four transitions: initial → loading → loaded → error), and the count/relative-time formatters (including locale variation), and a check confirms the logger emits no secrets and no raw print/debugPrint is used.
- **SC-011**: With Reduce Motion enabled, no decorative/looping motion plays; only essential press-scale feedback remains.
- **SC-012**: Every shared component exposes screen-reader semantics (icon-only controls included) and renders without clipping or overlap at increased OS text-scaling, verifiable with the platform screen reader and a large-text setting.

## Assumptions

- **Default launch zone**: With no real authentication yet, the app launches into the main (stub-authenticated) zone by default so the shell is reviewable; the stubbed guard can be toggled to preview the pre-auth flow. (The real launch decision is owned by #003.)
- **Default destination**: Home is the initial primary destination.
- **Adaptive thresholds**: The width breakpoints follow the design source (phone below ~700, tablet/iPad at/above ~700, sidebar compact below ~980 and full at/above ~980, extra-wide suggestions rail at/above ~1100); exact pixel values are finalized at planning against `ui-design-context.md` §Responsive.
- **Placeholder fidelity**: Placeholder destinations render the real layout with local mock data (chosen over minimal stubs) to enable immediate visual review and golden testing; they intentionally have no real behavior.
- **Component library completeness**: The full component library (~22 components) is built in this spec (chosen over a grow-as-needed subset) so later specs only compose; highly feature-specific composites (e.g. a multi-step create editor) remain with their owning feature.
- **Two-pane primitive**: The reusable master/detail primitive is built here with a demo; the actual Messages and Post detail content is supplied by #012 and #006.
- **Pre-auth and flow screens are placeholders**: The auth-flow screens and full-screen flow routes exist as nav-less placeholders only; their real implementations belong to later specs.
- **Design source of truth**: All screens, tokens, and components derive from the claude_design "We36" project distilled in `.claude/claude-app/ui-design-context.md`; pixel-level originals are pulled from claude_design as needed. The UI is original to We36; other apps are functional references only.
- **No persistence**: There is no local database or persisted cache in this spec; mock data lives in memory only (persistence/cache arrives in #002).

## Out of Scope

- Any networking, API client, real endpoints, or realtime channel (deferred to #002).
- Authentication, sessions, tokens, secure storage, OAuth, and real auth-guard logic (deferred to #003; the guard here is a stub).
- Any real feature behavior: real feed, posting, stories, reels, search, profiles, DMs, notifications, settings actions (deferred to #004+).
- The light/dark/system theme switcher UI (deferred to #014).
- Local persistence / cache and drafts (deferred to #002).
- Push notifications, media capture/upload, and platform share-sheet integration (deferred to their owning specs).
