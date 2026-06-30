<!--
================================================================================
SYNC IMPACT REPORT
================================================================================
Version Change: (none) → 1.0.0 (initial ratification)

This is the first ratified constitution for We36. Adapted from the Safe Send
constitution v1.0.0 (flutter_send_anytime), with the domain reframed from
"peer-to-peer file transfer over WebRTC" to "Instagram-style social media app
(feed · stories · reels · direct messages · explore · profile)". The P2P
transport / signaling-privacy / transfer-reliability principles were replaced by
social-platform principles: API & realtime networking, media-centric
performance, optimistic-UX data integrity, and privacy/safety/trust. The design
system principle was repointed at the imported claude_design We36 tokens.

Two foundational decisions taken at ratification:
  - In-app primary language: ENGLISH (matches the design system's authored voice);
    full ARB i18n, Vietnamese as the first secondary locale (Principle XIV).
  - Backend: a backend-agnostic client speaking a custom, versioned REST/JSON API
    + a WebSocket realtime channel. The constitution governs the client and the
    API CONTRACT; concrete server technology is out of scope (Principle VIII).

Principles (15):
  I.    Privacy, Safety & Trust by Design        (was: Privacy-First P2P Architecture)
  II.   Media-Centric Performance & Resource Discipline (was: Direct Transfer & Data Minimization)
  III.  BLoC-Driven State Management             (carried)
  IV.   Code Quality & Dart Safety               (carried)
  V.    Result<T> Error Handling                 (carried, domain-adapted)
  VI.   Design System & Theming                  (repointed to claude_design We36 tokens)
  VII.  Cross-Platform Native Integration        (carried; iOS + Android)
  VIII. API & Realtime Architecture              (was: Transport & Signaling Architecture)
  IX.   Data Integrity, Caching & Optimistic UX  (was: Transfer Reliability & Data Integrity)
  X.    go_router Navigation Standards           (carried, IA-adapted + auth guard)
  XI.   Feature-First Modularity                 (carried)
  XII.  Testing Discipline                       (carried, mock-API instead of loopback)
  XIII. Simplicity & YAGNI                       (carried, MVP-scoped per brief)
  XIV.  Internationalization by Default          (carried; English-first UI)
  XV.   Dependency Hygiene                       (carried)

Templates Requiring Updates:
- .specify/templates/plan-template.md ✅ (generic Constitution Check section
  remains accurate; no inline principle references)
- .specify/templates/spec-template.md ✅
- CLAUDE.md ⚠ pending — to be created/expanded during Spec #001 to mirror Working Rules
- .claude/claude-app/ui-design-context.md ✅ (Principle VI defers UI detail to it)

Follow-up TODOs: None
================================================================================
-->

# We36 Constitution

> App Name: "We36" — cross-platform (iOS + Android, Flutter) **Instagram-style
> social media app** for sharing photos and video: **feed, stories, reels,
> direct messages, explore/search, and profiles**. Out of scope: monetization /
> commerce and livestreaming. The client speaks a custom, versioned **REST/JSON
> API** + a **WebSocket** realtime channel; the backend server technology is out
> of scope of this constitution. Fixed light & dark palette with a signature
> rose → violet gradient. UI source of truth:
> `.claude/claude-app/ui-design-context.md`.

## Core Principles

### I. Privacy, Safety & Trust by Design

A social app holds people's photos, identities, conversations, and social graph.
Privacy, account safety, and user trust MUST be designed into every layer — never
retrofitted.

- **Credentials** (passwords, access/refresh tokens, OAuth secrets) MUST be held
  in platform secure storage (iOS Keychain / Android Keystore via
  `flutter_secure_storage`) — NEVER in `SharedPreferences`, plaintext, or logs.
- **Account privacy** is a first-class state: a **private account**'s posts,
  stories, followers, and following MUST be withheld from non-approved viewers;
  the client MUST respect the server's visibility verdict and MUST NOT render
  withheld content from a stale cache.
- **Blocking & reporting** are first-class and MUST be reachable from every
  post, profile, comment, story, reel, and DM. A block MUST take effect in the
  UI immediately (optimistic) and be enforced by the server; blocked/`hidden`/
  `removed`/`reported` content states from the API MUST be honored.
- **Close friends** and other audience scopes MUST be enforced at render time —
  a story/post scoped to close friends MUST NOT leak to a wider audience through
  a caching or pagination bug.
- No passwords, tokens, message bodies, phone numbers, emails, or precise
  location MUST appear in logs, analytics, crash reports, or debug output.
- **Input validation** MUST occur at every boundary: deep links, API responses
  (treat every field as untrusted), pasted text, user-generated captions/
  comments/bios (link/script sanitization at display), and uploaded media type/
  size.
- **Permissions** (camera, photo/video library, microphone, notifications,
  location) MUST be requested contextually, at the moment of use, with a clear
  reason — never all up front — and the app MUST degrade gracefully when denied.

**Rationale**: Trust is the product. A single leaked private story, an
unenforced block, or a token in a log breaks it irreparably and is far costlier
than the feature that caused it. Designing safety in keeps it verifiable.

### II. Media-Centric Performance & Resource Discipline

We36 is photos and video first; the imagery is the star and the heaviest cost.
The app MUST stay smooth and bounded in memory while scrolling rich media.

- **Feeds MUST be paginated** with cursor-based (not offset) loading and MUST
  load lazily; an infinite list MUST NOT hold every decoded image in memory.
- **Remote images MUST be cached** (disk + memory) via a single caching image
  widget (`cached_network_image`) and MUST be decoded at a bounded resolution
  (`cacheWidth`/`memCacheWidth` sized to the layout, never full-res for a
  thumbnail). Post media uses a 4:5 aspect; grids use square thumbnails.
- **Video (reels / inline video)**: only the visible item plays; off-screen
  controllers MUST be paused and disposed; reels use a small preload window, not
  "load all". A controller MUST always be disposed.
- **Upload pipeline**: images MUST be resized/compressed client-side before
  upload; large videos MUST upload in a **resumable/chunked** fashion with
  progress and cancel; the UI MUST NOT block the main isolate during
  encode/upload.
- **No unbounded memory**: large media MUST be streamed, not fully buffered;
  picking many photos for a carousel MUST not OOM the app.
- **Offline-friendly**: the last-seen feed, profile, and DM list SHOULD render
  from cache instantly while a refresh runs (Principle IX).

**Rationale**: The most common failure mode of a media app is jank and OOM
crashes while scrolling. Pagination, bounded decode, and disciplined video
lifecycle are what make a rich feed feel native on a mid-range phone.

### III. BLoC-Driven State Management

All state management MUST use the BLoC pattern via `flutter_bloc`.
Unidirectional data flow is mandatory: Events → BLoC → State → UI. All Cubits
MUST follow the 4-state pattern.

- Every feature MUST manage state through Cubits (preferred) or Blocs.
- UI widgets MUST NOT contain business logic; they react to state only.
- State classes MUST be immutable using `@freezed` sealed classes.
- **Mandatory 4-state pattern** for all Cubits/Blocs:
  ```
  initial → loading → loaded({required T data}) → error({required AppFailure failure})
  ```
- Extended state variants MUST prefix the base state name (e.g.
  `loadedPaginating`, `loadedRefreshing`, `loadedSubmitting`) — NOT `success`,
  `failed`, `empty`.
- **Paginated lists** MUST model `loaded` with an explicit page cursor +
  `hasMore` + a `loadingMore`/`endReached` sub-flag — never an ad-hoc boolean
  soup or `setState`.
- Cubit-to-Cubit communication MUST go through shared repositories/services or
  streams — NEVER direct cubit references.
- Side effects (navigation, dialogs, toasts, haptics) MUST be triggered via
  `BlocListener`, never from `BlocBuilder`.
- All Cubits MUST be closed to prevent leaks; `bloc_lint` MUST be zero-violation.
- **DI registration**: shared/app-wide Cubits (session, theme, realtime) →
  `@lazySingleton`; screen-scoped Cubits → `@injectable`. BlocProvider MUST be
  page-scoped unless app-wide lifetime is explicitly required.

**Rationale**: The 4-state pattern gives every screen consistent loading/error
handling, and a social app is intrinsically about live, evolving state (feed
pages, like/follow toggles, typing indicators) — predictable transitions keep
that complexity reviewable.

### IV. Code Quality & Dart Safety

All code MUST use Dart strict analysis with null safety. Linting MUST follow
`very_good_analysis` standards with zero warnings.

- `very_good_analysis` rules MUST produce zero warnings.
- `bloc_lint` recommended rules MUST be enforced.
- Dart analysis MUST enable `strict-casts`, `strict-raw-types`,
  `strict-inference`.
- All state objects and API models MUST be immutable (freezed); JSON models MUST
  use generated (de)serialization, never hand-rolled `dynamic` digging at call
  sites.
- Every public API MUST have explicit return types and parameter types.
- Error messages shown to users MUST be actionable and non-technical.
- Code MUST be self-documenting; comments only where logic is non-obvious.
- Naming: files `snake_case.dart`; classes `PascalCase`; Cubits `{Feature}Cubit`;
  States `{Feature}State`.

**Rationale**: Null safety and immutability prevent whole categories of bugs.
Decoding untrusted JSON and juggling async social mutations is unforgiving of
silent type/state inconsistencies.

### V. Result\<T\> Error Handling

All async operations that can fail MUST return `Result<T>` instead of throwing.
Exceptions are reserved for truly exceptional (programmer-error) situations.

- Repository/service methods MUST return `Result<T>`.
- `AppFailure` sealed class MUST enumerate known failure modes, including:
  - `unauthenticated`, `sessionExpired`, `invalidCredentials`,
    `oauthCancelled`, `oauthFailed`
  - `forbidden` (e.g. private/blocked), `notFound`, `accountSuspended`
  - `validation({Map<String,String> fields})`, `conflict` (e.g. username taken),
    `rateLimited`
  - `uploadFailed`, `mediaTooLarge`, `unsupportedMedia`, `cameraUnavailable`,
    `permissionDenied`
  - `realtimeDisconnected`, `messageFailed`
  - `networkError`, `serverError`, `timeout`, `offline`
  - `unknown({String? message, Object? error})`
- Cubits MUST handle `Result<T>` via `.fold()` — emit `loaded` on success,
  `error` on failure. try/catch in Cubits is FORBIDDEN; repositories/services
  catch and wrap (including HTTP status → `AppFailure` mapping centralized in the
  API client).
- User-facing error text MUST come from `AppFailure` mapping (localized),
  NOT raw exception or HTTP messages. Form/validation failures MUST map back to
  the offending field.

**Rationale**: A social client fails in many ordinary ways (offline, token
expiry, private account, username taken, upload dropped). Making each an
explicit, named outcome forces graceful handling and clear messaging instead of
opaque crashes or generic "something went wrong".

### VI. Design System & Theming

The app MUST use a centralized design system whose tokens and components derive
from the imported **claude_design** project (`We36`), distilled in
`.claude/claude-app/ui-design-context.md`. All visual properties MUST come from
theme tokens — never hardcoded. Inputs, buttons, avatars, and cards MUST be built
through centralized factories/widgets; inline configuration is FORBIDDEN.

- **Fixed palette**: the app ships a single fixed light + dark palette. A
  user-facing color-scheme picker is FORBIDDEN; only light/dark/follow-system is
  allowed (Spec #012).
- **"Color earns its place"**: surfaces, feed, and chrome stay **clean and
  neutral**; saturated brand color appears ONLY on highlights — the primary CTA,
  story rings, the active nav icon, badges, and stickers. The brand gradient MUST
  NOT be used as a full-page wash (it would compete with user media).
- **Color**: use **semantic token aliases** (`accent`, `surface`, `surface-2`,
  `text-secondary`, `border`, `icon-active`, etc.) — NEVER hardcode hex at call
  sites. Brand rose `#FF4E64` + violet `#8B5CF6`; signature
  `gradient-brand` (rose→violet, 135°); `gradient-story` (amber→rose→violet)
  reserved for **unseen** story rings (seen rings desaturate to a flat border).
- **Typography**: **Plus Jakarta Sans** (display / logo / headings, extra-bold,
  tight tracking) + **Inter** (body / UI). The We36 wordmark is gradient-clipped
  Plus Jakarta Sans 800.
- **Spacing / radius / shadow / motion**: from the design tokens. Radius scale
  sm 8 / md 12 / lg 20 / full; pills are the default for interactive text
  elements. Shadows are soft, low-spread, **ink-tinted (never pure black)**.
  Press feedback = scale-down (buttons 0.97, icon buttons 0.88) on the spring
  curve.
- **Icons**: a single unified **Lucide** set via one icon dependency chosen at
  Spec #001 (outline default; a **solid** variant fills active states — home,
  like, save, reels). NEVER mix in Flutter `Icons`/`CupertinoIcons` or
  emoji-as-icon ad hoc.
- **Shared widgets**: reusable components (`Button` primary/secondary/ghost,
  `IconButton`, `Avatar` + story ring, `Badge`, `Tag`/hashtag chip, `PostCard`,
  `SearchBar`, `Switch`, `BottomNav`, `Toast`, `ActionSheet`, `Dialog`,
  `StoriesRail`) MUST be built once in `lib/core/presentation/` (Spec #001) and
  reused — duplicating their markup per feature is FORBIDDEN.
- **Toasts**: use the centralized toast utility (dark `ink` pill, colored dot
  icon, optional action) — NEVER call `ScaffoldMessenger.showSnackBar` directly.
- **Reduce Motion**: decorative/looping motion MUST degrade to a static state
  when Reduce Motion is on; there are NO infinite decorative loops by default.
- **Navigation IA**: bottom nav is **5 tabs** (Home / Explore / Reels / Messages
  / Profile). **Create** (post/story/reel) is a contextual action, not a tab.
  Full-screen flows (story/reel viewer, create-post, chat, comments) push
  nav-less routes. Auth/onboarding screens have no bottom nav.

**Rationale**: The product ships a deliberate, fixed visual identity built around
restraint — neutral chrome so user media pops. Centralized tokens and factories
keep light/dark correct and prevent the per-call-site drift that is the most
common source of visual inconsistency.

### VII. Cross-Platform Native Integration

The app targets **iOS and Android** and MUST feel native on both, following each
platform's conventions while sharing core logic in Dart.

- Platform-appropriate affordances MUST be used for alerts, action sheets, and
  pickers (Cupertino on iOS, Material on Android) without forking business logic.
- All phone screen sizes MUST be supported, including notch / Dynamic Island and
  Android display cutouts; tablets adapt responsively (the design ships a tablet
  layout). The status bar / safe areas MUST be respected on media-immersive
  screens (story/reel viewers go edge-to-edge with light status content).
- **Camera & media**: capture and library pick (photo + video, multi-select for
  carousels) MUST use the platform pickers; basic edit (crop, filter, brightness)
  runs client-side.
- **Push notifications** (likes, comments, follows, DMs, mentions) MUST be
  delivered via FCM (Android) / APNs (iOS), with contextual permission and
  deep-linking from a notification into the relevant screen.
- Inbound OS integrations MUST be supported where scoped: the **share sheet**
  ("Share to We36"), and **universal/app links + `we36://` deep links** for
  posts, profiles, hashtags, and story/reel content.
- Accessibility MUST be honored on both platforms: screen readers
  (VoiceOver/TalkBack), Dynamic Type / font scaling, Reduce Motion, sufficient
  contrast on media overlays (use protection gradients, not low-contrast text).
- Haptic feedback SHOULD be used for key moments (like, follow, post published,
  message sent, pull-to-refresh).

**Rationale**: A social app lives on engagement, which depends on the small
native touches — smooth pickers, real push, deep links that land in the right
place. Both platforms are first-class and their media/permission models differ
enough to respect explicitly.

### VIII. API & Realtime Architecture

The networking stack MUST be organized as clean layers behind repositories, and
every feature MUST consume the **same** centralized API client and realtime
channel rather than talking to HTTP/sockets directly.

- **Layers**: (1) a single **API client** (REST/JSON over `dio`) → (2)
  **repositories** (domain-typed, return `Result<T>`) → (3) Cubits. Widgets and
  Cubits MUST NEVER construct HTTP requests or touch the socket directly.
- **Auth interceptor**: the API client MUST attach the access token, and on
  `401` perform a **single-flight token refresh** (concurrent requests await one
  refresh, never N parallel refreshes); a failed refresh MUST emit
  `sessionExpired` and route to the auth flow exactly once.
- **Error mapping**: HTTP status + error body → `AppFailure` MUST happen in one
  place in the client; call sites never inspect status codes.
- **Versioned contract**: the REST + WebSocket message contract MUST be explicit
  and versioned; endpoint paths, query keys, and socket event names MUST be
  defined in **one** constants location — NEVER duplicated as string literals at
  call sites. The base URL MUST be per-flavor and centralized.
- **Realtime channel**: a single **WebSocket** connection (`web_socket_channel`)
  carries DM messages, typing/presence, and live notifications. It MUST own one
  connection with reconnect + exponential backoff + heartbeat, expose typed
  inbound/outbound events from one place, and degrade gracefully (the app stays
  usable read-only when realtime is down; `realtimeDisconnected` is surfaced
  quietly).
- **Pagination** MUST be cursor-based and standardized across feeds (one shared
  page-envelope type), so list Cubits and the shared paginated-list widget reuse
  it.
- **Backend boundary**: the concrete server (language, DB, CDN) is OUT OF SCOPE.
  The client depends on the **contract** only; a fake/in-memory implementation of
  every repository MUST exist so features are buildable and testable without a
  live server (Principle XII).

**Rationale**: Centralizing the client, auth refresh, error mapping, and the
single realtime socket is what keeps a dozen features from each reinventing
networking (and each getting token refresh subtly wrong). Depending on a contract
— not a server — lets the app and backend evolve independently and keeps CI
hardware-free.

### IX. Data Integrity, Caching & Optimistic UX

User actions MUST feel instant and MUST never corrupt the local view of the
social graph or content.

- **Optimistic updates** for cheap, reversible actions (like, save, follow,
  block) MUST update the UI immediately and **roll back** on server failure with
  a clear toast — never leave the UI showing a state the server rejected.
- **Idempotent mutations**: create-post, send-message, and like MUST carry a
  client-generated request/idempotency id so a retry after a flaky network does
  NOT double-post, double-send, or double-like.
- **Single source of truth**: a piece of content (a post's like count, a
  follow relationship) MUST have one canonical cached representation that all
  screens read; updating it in one place MUST reflect everywhere (e.g. via a
  reactive cache/stream), not be copied into each Cubit and drift.
- **Local cache** (feed, profile, DM list/threads, draft posts/comments) MUST be
  persisted (`drift` or `hive` — chosen at planning) so the app opens to content
  instantly; cache reads MUST be reconciled with a background refresh and
  de-duplicated across pages.
- **Drafts**: an in-progress post/comment/message MUST survive app backgrounding.
- Local-DB schema **migrations MUST be non-destructive and backward-compatible**;
  migration tests MUST cover every prior schema version, not just N-1.
- Malformed/partial API payloads MUST be handled gracefully (skip the bad item,
  surface a soft error) — one bad post MUST NOT crash the feed.

**Rationale**: Engagement depends on actions feeling instant, but "instant" must
not mean "wrong". Optimistic-with-rollback plus idempotency plus one canonical
cache is what makes the app feel fast while staying consistent with the server.

### X. go_router Navigation Standards

All navigation MUST use go_router with centralized route constants. Auth state
MUST gate the app, and deep links MUST be validated before processing.

- **Route constants**: centralized in an `AppRoutes` abstract final class —
  NEVER hardcode path strings.
- **Navigation**: ALWAYS use `context.go()` / `context.push()` / `context.pop()`
  — NEVER `Navigator.of(context)` directly.
- **Auth guard**: a `redirect` MUST send unauthenticated users to the auth flow
  and authenticated users away from it, driven by the app-wide session Cubit —
  no screen self-checks auth ad hoc.
- **Tab shell**: `StatefulShellRoute.indexedStack` for the 5 tabs (Home /
  Explore / Reels / Messages / Profile) with stable keys to prevent rebuilds and
  preserve per-tab scroll/stack.
- **Flow routes**: create-post, story/reel viewer, chat, comments, and full-image
  viewers are pushed full-screen routes that hide the bottom nav (per Principle
  VI's IA).
- **Deep links**: validate scheme and parameters before routing; reject malformed
  `we36://` links and unknown ids; route a notification/share/universal link to
  the correct destination (post, profile, hashtag, chat).
- **URL scheme**: `we36://` for deep links + universal/app links for shareable
  content.
- **Stacked modals**: when dismissing then opening, dismiss first and open in a
  post-frame callback — two modals MUST NOT be pushed in the same frame.

**Rationale**: Centralized routing + an auth guard prevent broken navigation and
ensure deep-link validation (a security boundary) and the logged-out/logged-in
split cannot be bypassed per-screen.

### XI. Feature-First Modularity

The codebase MUST be organized by feature using Clean Architecture. Each feature
MUST be independently developable and testable.

- Directory structure:
  ```
  lib/
    core/
      config/        # App + flavor config, API base URL, realtime endpoint
      constants/     # Routes, API endpoints, socket event names, asset keys
      di/            # get_it + injectable setup
      domain/        # Result<T>, AppFailure, AppCubit base, shared entities
      data/          # API client, interceptors, local cache DB + DAOs, realtime client
      presentation/  # Shared widget library + design-token consumers
      router/        # go_router config + auth guard + deep links
      services/      # SessionService, MediaUploadService, RealtimeService, etc.
      theme/         # AppColors + design tokens
      utils/         # AppLogger, formatters (counts, relative time)
    features/
      auth/  feed/  stories/  reels/  compose/  post/  explore/
      profile/  collections/  messaging/  notifications/  settings/
        data/         # Repository impls, data sources, DTOs
        domain/       # Models, use cases, repo interfaces
        presentation/ # Cubits, pages, widgets
  ```
- `lib/core/` MUST NOT import from `lib/features/*/`.
- `lib/features/<A>/` MUST NOT import internal files of `lib/features/<B>/`;
  cross-feature handoff goes through core types/router or DI.
- Domain layer MUST NOT import data-layer implementations.
- Repository → Repository dependency is FORBIDDEN; use a UseCase or Service to
  orchestrate.
- DI: `@lazySingleton` for services and shared cubits; `@injectable` for
  screen-scoped cubits; `@singleton` (eager) is FORBIDDEN.

**Rationale**: Clean boundaries let feed, messaging, profile, and compose evolve
independently and keep the API client, realtime channel, and cache in `core/`
free of feature coupling.

### XII. Testing Discipline

Unit tests are REQUIRED for business logic and data transformations. BLoC tests
are REQUIRED for all Cubits. Widget tests are REQUIRED for engagement-critical
flows.

- Unit tests MUST cover: JSON model (de)serialization, `AppFailure` mapping,
  pagination/cursor logic, optimistic-update + rollback logic, formatters (count
  abbreviation `38.4k`, relative time `2h`), and use cases.
- The app MUST be fully testable **without a live backend**: every repository
  MUST have a fake/in-memory implementation, and the API client error mapping
  MUST be tested against stubbed HTTP responses (no real network in CI).
- BLoC tests MUST cover all Cubits via `bloc_test` (load / paginate / error /
  optimistic toggle + rollback).
- Widget tests MUST cover: feed render + paginate, post card interactions
  (like/save/comment entry), create-post flow, profile + follow toggle, and the
  chat send path. **Golden tests** are RECOMMENDED for `PostCard`, `Avatar`
  (+ ring states), and the bottom nav, in light + dark.
- Realtime/DM logic MUST be tested against a fake socket (typed event in → state
  out), never a live connection.
- Coverage is NOT gated by a hard CI threshold; reviewers judge adequacy by
  critical-path coverage. Tests MUST be deterministic (no flakiness) and use
  `mocktail`.
- Standard command:
  `very_good test --test-randomize-ordering-seed random`.

**Rationale**: Fakes for every repository make the whole app exercisable in CI
without a server; golden tests guard the visual identity that is the product's
differentiator.

### XIII. Simplicity & YAGNI

The app MUST stay focused on its core purpose: sharing photos/video and keeping
up with people. Features MUST be built with minimum complexity; premature
abstractions are forbidden.

- Start with the simplest viable implementation per feature.
- **MVP feed is reverse-chronological** ("time-based"); a ranked/recommendation
  algorithm is explicitly deferred (post-v1.0) per the product brief.
- Out of scope for v1.0 (per brief): **monetization/commerce** and
  **livestreaming** — do NOT build them. Advanced items (nested-reply threads
  beyond one level, location maps, diverse story/DM reactions, automated content
  recommendation) are deferred until a spec explicitly scopes them.
- Do NOT add configurability, feature flags, or plugin systems unless a spec
  requires them.
- Prefer Flutter/Dart standard-library solutions over third-party packages when
  capability is equivalent.
- Package additions MUST be justified by a concrete current need.
- Three similar lines are better than a premature abstraction.

**Rationale**: An Instagram-class surface is enormous; shipping requires ruthless
scoping. The brief already drew the lines (time-based feed, no commerce, no
livestream) — honoring them is how v1.0 ships.

### XIV. Internationalization by Default

All user-facing strings MUST be internationalized via Flutter's ARB system. No
hardcoded UI strings.

- All user-facing text MUST live in ARB files under `lib/l10n/arb/`.
- `context.l10n` MUST be used to access localized strings.
- New strings MUST include `@description` annotations.
- Date, time, relative-time ("2h", "1d"), number, and **abbreviated-count**
  ("38.4k", "1.2M", "1,240 likes") formatting MUST use locale-aware `intl`
  formatters via shared helpers — NEVER hand-formatted at call sites.
- Error and validation messages MUST be localized (from `AppFailure` mapping).
- **Primary in-app UI language: English** (matching the design system's authored
  voice — friendly, warm, lowercase-leaning, second-person); Secondary:
  Vietnamese (first translated locale). Code, comments, docs, and commits are in
  English.

**Rationale**: The design was authored in English with a specific tone, so
English is the canonical UI; full ARB from day one keeps the app translatable
(Vietnamese first) without a costly retrofit.

### XV. Dependency Hygiene

When adding a new third-party package — or upgrading one — the version and
documentation MUST be fetched from the official source. Versions MUST NOT be
guessed, copied from training data, or carried over from unrelated projects.

- **Latest version sourcing**: before adding to `pubspec.yaml`, look up the
  latest stable on `pub.dev`; for native iOS pods use the CocoaPods Specs repo /
  upstream release page; for SPM/Gradle use upstream tags.
- **Official documentation**: consult the package's official docs for public API
  surface, breaking-change notes, transitive native dependencies, and minimum
  platform versions. Inferring API shape from memory is FORBIDDEN.
- **Native-heavy plugins**: camera/scanner, video player, image cropper, push
  (FCM/APNs), and secure storage pull in significant native code — their minimum
  iOS/Android versions, required permissions/entitlements, and transitive pods
  MUST be verified at plan time, before the Dart code is written.
- **Major-version upgrades**: review the CHANGELOG and migration guide BEFORE
  modifying `pubspec.yaml`; cite the breaking changes that affect We36 (or state
  that none do) in the PR/spec.
- **Lock files**: `pubspec.lock` and `ios/Podfile.lock` MUST be committed;
  unexpected churn signals an unintended transitive upgrade and MUST be reviewed.
- **Constraints**: new dependencies MUST use a caret constraint (`^X.Y.Z`)
  pinned to the latest compatible stable; `any`/open-ended ranges are FORBIDDEN.
- **No fictional packages**: every package MUST exist on the official registry
  under the exact name written; if not found, stop and ask the user rather than
  guessing a similar name.

**Rationale**: This stack leans on heavy native plugins (camera, video, push,
secure storage) where a wrong version or unverified transitive dependency
surfaces only at build/`pod install` time, after the Dart is written. A
30-second registry lookup at plan time prevents that rework.

## Technical Standards

### Platform & Stack

- **Framework**: Flutter (latest stable) with Dart (latest stable).
- **Target Platforms**: iOS + Android (phones; tablets adapt responsively).
  Desktop/web are post-v1.0.
- **Architecture**: Clean Architecture + MVVM, feature-first.
- **State Management**: Cubit (preferred) / BLoC via `flutter_bloc`.
- **Networking**: `dio` REST/JSON client + interceptors (auth/refresh/logging);
  `web_socket_channel` realtime channel. Backend = custom versioned API
  (server tech out of scope).
- **Auth**: email/phone + password and OAuth (Google/Apple); access + refresh
  tokens in `flutter_secure_storage`; single-flight refresh.
- **Local persistence / cache**: `drift` (SQLite) or `hive` (chosen at #001/#002
  planning) for feed/profile/DM cache + drafts.
- **Media**: `image_picker`/`file_picker` (pick), an image cropper + filter
  package (edit), `cached_network_image` (display), `video_player`/`chewie`
  (reels/inline video), client-side compression for upload.
- **Push**: FCM (+ APNs) via `firebase_messaging` (push transport only — not a
  general backend) + local notifications.
- **DI**: get_it + injectable (`@lazySingleton` / `@injectable`).
- **Router**: go_router with StatefulShellRoute + auth guard; scheme `we36://`.
- **Design**: fixed light/dark palette + design tokens from claude_design
  (`ui-design-context.md`); fonts **Plus Jakarta Sans** + **Inter** via
  google_fonts; **Lucide** icons; brand wordmark gradient-clipped.
- **Sharing / links**: `share_plus`, `app_links` (deep + universal links),
  `permission_handler`.
- **Linting**: very_good_analysis + bloc_lint (zero warnings).
- **Testing**: bloc_test, mocktail, very_good test (+ golden tests).
- **i18n**: Flutter ARB + intl (English primary, Vietnamese secondary).
- **Build Flavors**: development, production (per-flavor API base URL, realtime
  endpoint, bundle id).

### Core Domains

- **Auth & Onboarding**: splash, onboarding slides, sign in / sign up, forgot
  password, profile setup; session + token lifecycle.
- **Feed & Stories**: home feed (paginated), stories rail, story viewer, create
  story.
- **Reels**: vertical short-video feed; create reel.
- **Compose**: pick media → edit/filter → caption/tag/location → publish; upload
  pipeline.
- **Post & Comments**: post detail, like/save, comments + (one-level) replies,
  mentions.
- **Explore & Search**: explore grid, search users/hashtags/places, results,
  hashtag/location pages.
- **Profile & Follow**: my/other profile, follow/unfollow, followers/following,
  edit profile, saved collections.
- **Messaging (DM)**: conversation list, 1-1 chat (text, photo, shared post,
  stickers), realtime presence/typing.
- **Notifications**: activity feed (likes/comments/follows/mentions) + push.
- **Settings & Privacy**: account, private account, close friends, blocking,
  report, language, theme.

## Development Workflow

### Pre-Commit Checklist (MANDATORY)

```bash
dart format .                    # Format code
flutter analyze                  # Zero warnings
flutter test                     # All tests pass
dart run bloc_tools:bloc lint .  # Zero BLoC violations
```

### Testing Gates

All pull requests MUST pass:

1. All unit and BLoC tests pass.
2. All widget (and golden, where present) tests pass.
3. Static analysis with zero warnings (`flutter analyze`).
4. BLoC lint with zero violations.
5. Code formatting verified (`dart format`).

### Review Requirements

- All code changes MUST be reviewed before merge.
- Privacy/safety-sensitive changes (auth, tokens, secure storage, private-account
  enforcement, blocking, logging, deep links) MUST receive additional scrutiny
  against Principles I & X.
- New package additions MUST be justified and verified per Principle XV.
- Local cache schema changes MUST include migration verification.
- Networking changes (API client, auth refresh, realtime) MUST include tests
  against stubbed HTTP / a fake socket.

### Quality Checks

- Auth MUST be verified under: valid login, wrong password, expired session →
  refresh, refresh failure → re-auth, OAuth cancel, offline.
- Feed MUST be verified: first page, paginate, pull-to-refresh, empty state,
  one malformed item, offline-from-cache.
- Optimistic actions MUST be verified: like/follow/save success + server-failure
  rollback; idempotent retry does not duplicate.
- Media MUST be profiled: long feed scroll memory ceiling, reels video lifecycle
  (off-screen pause/dispose), large-video upload + cancel.
- Privacy MUST be re-verified whenever visibility/auth changes: private-account
  content withheld; a block hides content both ways; no secrets in logs.

## Governance

This constitution establishes non-negotiable principles for We36 development. All
implementation decisions MUST align with these principles. On any conflict
between this constitution and other guidance, the constitution wins; `CLAUDE.md`
provides runtime development guidance subordinate to it.

### Amendment Process

1. Proposed amendments MUST be documented with rationale.
2. Amendments MUST be reviewed for impact on existing code.
3. Breaking changes require a migration plan before approval.
4. Version MUST be incremented per semantic versioning:
   - MAJOR: principle removal or incompatible redefinition.
   - MINOR: new principle or material expansion.
   - PATCH: clarification or wording refinement.

### Compliance

- All pull requests MUST verify compliance with relevant principles.
- Complexity exceeding these standards MUST be explicitly justified.
- Deviations MUST be documented with rationale and approved by the project lead.
- Use `CLAUDE.md` for runtime development guidance and
  `.claude/claude-app/ui-design-context.md` for UI compliance.

**Version**: 1.0.0 | **Ratified**: 2026-06-30 | **Last Amended**: 2026-06-30
