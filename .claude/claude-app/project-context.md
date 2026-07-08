# We36 — Project Context

> Last updated: 2026-07-07 (#001–#011 all merged; **#011 Saved Collections ✅ MERGED** into `main` via **PR #11** (`ac7d83c`) — 51/51 tasks (US1–US5: Saved tab + collections grid, save-to-collection optimistic, open/curate, manage/rename/delete/cover, inclusive/adaptive; drift v7→v8). Next: **#012 Direct Messages (Realtime)**.)
> **Mục đích**: Snapshot tối thiểu để LLM/người đọc bắt đầu một session làm việc — context hiện tại, focus, links. Không chứa ship history hay alignment decisions.
>
> **Đọc file nào khi nào**:
> - Bắt đầu session mới hoặc onboarding → file này (snapshot) + `CLAUDE.md` (day-to-day reference, tạo ở #001).
> - Chuẩn bị họp spec mới → file này (current focus) + [`sdd-roadmap.md`](sdd-roadmap.md) (planning + dependency cho spec sắp làm).
> - Làm phần **giao diện** của bất kỳ spec nào → [`ui-design-context.md`](ui-design-context.md) (screens, tokens, components, navigation IA) — pull bản gốc từ claude_design MCP.
> - Cần hiểu vì sao spec X ra đời với scope Y → [`decisions/`](decisions/) (alignment per spec).
> - Cần biết spec nào đã ship khi nào → [`changelog.md`](changelog.md).

## Snapshot

- **App name**: We36.
- **Product**: Cross-platform (iOS + Android, Flutter) **Instagram-style social media app** — sharing photos & video: **feed, stories, reels, direct messages, explore/search, profiles**. Youthful, colorful-but-clean; signature **rose → violet** gradient.
- **Platforms**: iOS + Android phones **+ iPad / Android tablets** (Flutter; **adaptive layout** — same nav/routes/tokens, chrome adapts by width: phone bottom-nav `<700` ↔ tablet **SidebarRail** `≥700` + two-pane master/detail for Messages + Post detail). Desktop/web post-v1.0.
- **Backend**: a **backend-agnostic client** speaking a custom, **versioned REST/JSON API + WebSocket** realtime channel. Server tech (language/DB/CDN) is **out of scope** of the constitution — the app depends on the **contract** + has in-memory fakes for every repository.
- **Out of scope v1.0** (per brief): **monetization/commerce**, **livestreaming**, and a **ranked recommendation algorithm** (MVP feed = reverse-chronological).
- **Navigation**: auth-guarded split — pre-auth flow (no nav) + **5-tab bottom nav** (Home / Explore / Reels / Messages / Profile). **Create** (post/story/reel) is a contextual action, not a tab. On **tablet/iPad** the bottom nav becomes a **left sidebar rail** (adds Notifications + Create) + two-pane master/detail. 31 designed screens (+ tablet layouts) — see [`ui-design-context.md`](ui-design-context.md) §Responsive.
- **Theme**: fixed light & dark palette (no scheme picker — only light/dark/system). Brand rose `#FF4E64` + violet `#8B5CF6`; fonts **Plus Jakarta Sans** (display) + **Inter** (body); **Lucide** icons. Tokens imported from claude_design.
- **In-app language**: **English-first** (matches design voice) + full ARB i18n, **Vietnamese** first secondary locale.
- **Design source**: claude_design MCP project `We36` (projectId `f031b888-4810-473d-9879-9cb3968c577c`). Full UI context in [`ui-design-context.md`](ui-design-context.md).
- **Communication**: Vietnamese (spoken between user + Claude) · English for code, comments, documentation, commits, and **in-app UI copy**.

## How It Works (one-paragraph mental model)

The app is a clean-architecture Flutter client over a custom backend. A single **`dio` API client** (auth interceptor + single-flight token refresh + centralized error→`AppFailure` mapping) and one **WebSocket** realtime channel (DM, typing/presence, live notifications) sit behind **repositories** that return `Result<T>`. A **local cache** (drift/hive) lets the app open to content instantly; engagement actions (like/follow/save/send) are **optimistic with rollback** and **idempotent**. The UI is the imported We36 design system — neutral chrome so user media is the star, brand color only on highlights. Every repository has an **in-memory fake**, so the whole app builds and tests **without a live server**. See the Architecture Primer in [`sdd-roadmap.md`](sdd-roadmap.md).

## Current Focus

- **Now**: **Spec #011 Saved Collections ✅ MERGED** into `main` via **PR #11** (`ac7d83c`) — **51/51 tasks done** (US1–US5). The **save-and-organize** surface: the profile **Saved** tab + collections grid (US1), save-to-collection optimistic/idempotent (US2), open & curate a collection (US3), rename/delete/set-cover manage (US4), inclusive/adaptive (US5). Contract-driven on the shipped backend **B#011**; app still runs DI `environment: 'fake'` for hermetic tests.
  - **Built + verified**: `lib/features/collections/` (`collections`/`save_to_collection`/`collection_detail`/`collection_edit` 4-state cubits, usecases [collections/save-to-collection/collection-items/manage], `saved_collections_view`/`collection_detail_page`, widgets [`collection_card`/`collections_grid`/`save_to_collection_sheet`/`create_collection_dialog`/`collection_more_sheet`]) + `lib/core/data/collections/` (`SavedCollection` + `PostCollectionsMembership`/`PickerRow` freezed, `CollectionsRepository` real + `FakeCollectionsRepository`, remote source, `saved_collections_table` + `saved_collections_dao`). **Cross-feature render seam** (Constitution XI): `SavedTabSlot` in `core/presentation/slots/` (impl in `features/collections/`) so `features/profile` renders the Saved tab via `getIt<SavedTabSlot>()` — no direct cross-feature import. Reuses `Post`/`viewerHasSaved` + `FeedRepository.save` (#004), `ExploreItem`/`DiscoveryGrid` (#009), `CursorPage`/`PaginatedListCubit` (#002), `ProfileTabBar` (#010). "All saved" synthetic default first; optimistic file/unfile/create/rename/delete + cover auto-fallback (FR-010); full-unsave confirm-gated on `namedMembershipCount`. **drift schema v7→v8** (additive `SavedCollections` table, cleared on logout). No new pub dependency.
  - **Backend reconcile (`97ec1d8`)**: `contracts/collections-api.md` bound to the shipped **B#011** — endpoints under `/collections` (not `/me`), add-item body `{postId}`→204, cover a single **derived** `MediaDto`. Three backend deviations recorded for the real cutover: (1) collection **names unique**, (2) **no set-cover endpoint** (cover auto-derived), (3) **no per-post membership endpoint** (Save-to-collection files additively). Binds at `RealCollectionsRepository` cutover; app on fake mode.
  - **▶ Next**: start **#012 Direct Messages (Realtime)** (`git checkout -b 012-direct-messages` + `/speckit.specify`). Depends on #002 (WebSocket/`RealtimeClient` scaffold — **wired live for the first time here**) + #010 (social graph). Screens 25–28. Scope: DM list (unread/presence/typing preview), 1-1 chat over Socket.IO (text/photo/shared post/stickers), typing/presence, optimistic send + idempotency + delivery state, new-message compose; tablet = **two-pane master/detail** (list + chat). ⚠ Confirm `flutter test`/`flutter analyze` green on `main` before branching.
  - **⚠ Test gotcha (still applies)**: **widget tests must not drive real drift `NativeDatabase` I/O** — `await`ing a drift `.watch()`/query inside `testWidgets` **deadlocks** (faked-async never processes the real I/O; also `MemoryImage`/`video_player` + go_router hang `pumpAndSettle`). Seed a **stub cubit** with a fixed 4-state and pump that; keep drift-backed assertions in plain `test()` (real async) cubit/repo tests. Use fixed `pump(Duration)`, tall `surfaceSize` for lazy slivers. See `test/helpers/{feed,explore}_test_doubles.dart`.
- **Toolchain**: Flutter **3.44.4** / Dart **3.12.2** — the canonical baseline (bumped at #003). ⚠️ At #005 close (2026-07-02) this machine's global SDK at `/Users/ase/Development/flutter` was found stale at **3.41.7** and re-checked-out to 3.44.4 (`git checkout 3.44.4`); this also fixed a `flutter analyze` AOT-snapshot cache crash. The **long-deferred repo-wide golden refresh was executed** — all goldens regenerated under 3.44.4 (incl. the previously-uncommitted `test/features/stories/goldens/` baseline). No fvm/puro; `pubspec` still pins `sdk: ^3.11.5` (3.44.4 satisfies it).
- **#004 ✅ MERGED into `main`** via PR #4 (64/64 tasks; 206 tests). ⭐ First usable surface. Paginated feed + optimistic like/save + StoriesRail/viewer + drift v2→v3. Remaining trio siblings **#005 Create Story · #006 Post Detail** reuse #007's media pipeline (do after #007).
- **Done — #002 merged**: `ApiClient` + idempotency/auth/**single-flight refresh**/redacted-logging interceptors + `FailureMapper`; `CursorPage<T>` + 4-state `PaginatedListCubit`; **drift** cache base + reactive `.watch()`; `RealtimeClient` Socket.IO scaffold + fake; repository pattern + fakes (`User` slice). App runs DI `environment: 'fake'`; real impls annotated `env: ['real']` (auth real impls start landing in #003). 103 tests green.
- **Resolved at #002**: cache engine = **drift**; realtime = **`socket_io_client`** (constitution v1.0.2); cursor envelope shipped as `CursorPage<T>`.
- **To confirm at #003**: OAuth client ids/redirect schemes; OTP channel (email vs SMS) for forgot-password; avatar pick/crop package; token-refresh seam wiring (#002 `TokenStore`/`TokenRefresher`/`AuthEventsSink` fakes → real `flutter_secure_storage` impls); dev/prod API base URL + bundle ids (`app.we36` / `app.we36.dev` proposed).
- **Carried from #001**: bounded `cacheWidth`/`cached_network_image` for feed thumbnails (lands with media in #004); on-device VoiceOver/TalkBack + rotation recording (release gate at #015).
- **Active blockers**: none. `main`'s gate is green again (509 tests pass) after this session cleaned up the 4 unrelated post-#10 failures — see Current Focus.

## Spec Status

| # | Name | Status | Branch / merge |
|---|---|---|---|
| 001 | Project Foundation, Design System & Navigation | ✅ **Merged** | `001-project-foundation` (PR #1) |
| 002 | Networking, Cache & Realtime Core | ✅ **Merged** | `002-networking-core` (PR #2) |
| 003 | Auth & Onboarding | ✅ **Merged** | `003-auth-onboarding` (PR #3) |
| 004 | Home Feed & Stories ⭐ | ✅ **Merged** | `004-home-feed-stories` (PR #4) |
| 005 | Create Story & Tools | ✅ **Merged** (47/47) | `005-create-story` (PR #6) |
| 006 | Post Detail & Comments | ✅ **Merged** (46/46) | `006-post-comments` (PR #7) |
| 007 | Create Post (Compose & Upload) | ✅ **Merged** (62/62) | `007-create-post` (PR #5) |
| 008 | Reels | ✅ **Merged** (57/57) | `008-reels` (PR #8) |
| 009 | Explore & Search | ✅ **Merged** (54/54) | `009-explore-search` (PR #9) |
| 010 | Profile & Follow | ✅ **Merged** (57/57) | `010-profile-follow` (PR #10) |
| 011 | Saved Collections | ✅ **Merged** (51/51) | `011-collections` (PR #11) |
| 012 | Direct Messages (Realtime) | 🟡 **Next** | `012-direct-messages` |
| 013 | Notifications & Push | ⬜ Not started | `013-notifications-push` |
| 014 | Settings, Privacy & Safety | ⬜ Not started | `014-settings-privacy` |
| 015 | Polish & v1.0 Release | ⬜ Not started | `015-polish-v1-release` |

For per-spec scope + dependency see [`sdd-roadmap.md`](sdd-roadmap.md). For ship history see [`changelog.md`](changelog.md).

## Tech Stack (planned, concise)

- **Flutter** (latest stable) / **Dart** (latest stable).
- **Networking**: `dio` REST/JSON client + interceptors (auth/refresh/log); `web_socket_channel` realtime. Custom versioned backend (server out of scope).
- **Auth**: email/phone + password + OAuth (Google/Apple); tokens in `flutter_secure_storage`; single-flight refresh.
- **State**: `flutter_bloc` (+ `bloc_test`, `bloc_lint`) — BLoC/Cubit, 4-state via freezed sealed classes.
- **DI**: `get_it` + `injectable` + `injectable_generator`.
- **Router**: `go_router` with `StatefulShellRoute` + auth-guard redirect (`we36://` deep links + universal links).
- **Local cache**: `drift` (SQLite) or `hive` for feed/profile/DM/drafts (decide at #002).
- **Media**: `image_picker`/`file_picker` (pick), image cropper + filter (edit), `cached_network_image` (display), `video_player`/`chewie` (reels), client-side compress for upload.
- **Push**: `firebase_messaging` (+ APNs) + local notifications.
- **Theme / design system**: fixed `AppColors` light + dark + semantic tokens ported from claude_design (NO scheme picker). Fonts **Plus Jakarta Sans** + **Inter** via `google_fonts`. **Lucide** icons. `flutter_svg` for brand marks.
- **Codegen**: `freezed` + `json_serializable` + `build_runner`.
- **Utils**: `shared_preferences`, `package_info_plus`, `in_app_review`, a toast pkg, `intl`, `uuid`, `share_plus`, `app_links`, `permission_handler`.
- **Linting**: `very_good_analysis` · `bloc_lint`.
- **Testing**: `flutter_test`, `bloc_test`, `mocktail` (+ golden tests).
- **Flavors**: `dev` + `prod` (per-flavor API base URL, realtime endpoint, bundle id).
- **i18n**: Flutter ARB (`lib/l10n/arb/`) — English primary + Vietnamese.
- **Architecture**: Clean Architecture + MVVM, feature-first folders.

## Architecture Decisions (anchors)

- **One API client, one realtime socket** — every feature consumes them via repositories; widgets/Cubits never touch HTTP or the socket directly. Auth refresh is **single-flight**.
- **Backend-agnostic** — depend on the versioned **contract**, not server tech; every repository has an **in-memory fake** (app builds/tests without a server).
- **Optimistic + idempotent** — like/follow/save/send update instantly with rollback on failure; mutations carry a client request id so retries don't duplicate.
- **One canonical cached representation** per content item (reactive cache/stream) — no per-Cubit copies that drift.
- **"Color earns its place"** — neutral chrome/feed; brand color only on CTA / unseen story rings / active nav / badges / stickers; gradient never a full-page wash.
- **`lib/core/` MUST NOT import `lib/features/`** (cross-feature handoff via core types / router / DI).
- **BLoC pattern**: Events = plain sealed class, States = freezed 4-state; inject Use Cases (not Repos) into Cubits; BlocProvider page-scoped.
- **Toast** for all user-facing messages; **AppLogger** for all logging — never `print`/`debugPrint`; never log secrets.

## Repo Map (target after #001)

```
lib/
├── app/                      # App root widget + theme wiring (fixed light/dark palette)
├── bootstrap.dart            # Pre-runApp setup (DI, config)
├── main_dev.dart / main_prod.dart
├── core/                     # Shared infra (NO imports from features/)
│   ├── config/               # AppConfig, flavors, API base URL, realtime endpoint
│   ├── constants/            # Routes, API endpoints, socket event names, asset keys
│   ├── data/                 # dio API client + interceptors, cache DB + DAOs, realtime client
│   ├── di/                   # injectable graph
│   ├── domain/               # Result<T>, AppFailure, AppCubit base, shared entities, page envelope
│   ├── presentation/         # Shared widget library (Button, Avatar, PostCard, BottomNav, Toast…)
│   ├── router/               # go_router shell + auth guard + deep links
│   ├── services/             # SessionService, MediaUploadService, RealtimeService…
│   ├── theme/                # AppColors (light+dark) + design tokens
│   └── utils/                # AppLogger, formatters (count/relative-time)
├── features/
│   ├── auth/                 # Splash/onboarding/sign-in/up/forgot/setup (#003)
│   ├── feed/                 # Home feed (#004)
│   ├── stories/              # Stories rail + viewer + create (#004/#005)
│   ├── reels/                # Vertical video feed + create (#008)
│   ├── compose/              # Create post pick→edit→caption→upload (#007)
│   ├── post/                 # Post detail + comments (#006)
│   ├── explore/              # Explore grid + search (#009)
│   ├── profile/              # My/other profile + follow + edit (#010)
│   ├── collections/          # Saved collections (#011)
│   ├── messaging/            # DM list + chat (#012)
│   ├── notifications/        # Activity + push (#013)
│   └── settings/             # Settings + privacy + safety (#014)
└── l10n/arb/                 # English (primary) + Vietnamese

assets/brand/                 # We36 wordmark / logo marks (from claude_design)
specs/                        # SDD spec folders (each self-contained)
.claude/claude-app/           # Project meta (this file lives here)
├── project-context.md        # ← you are here
├── sdd-roadmap.md            # spec planning (dependency graph, scope per spec)
├── ui-design-context.md      # UI source of truth (screens, tokens, components, IA)
├── dev-workflow.md           # Speckit workflow conventions
├── changelog.md              # spec ship history (append-only)
└── decisions/                # alignment decisions per spec
```

## References

- **claude_design MCP project `We36`** — the UI/UX source of truth (projectId `f031b888-4810-473d-9879-9cb3968c577c`, connector `https://api.anthropic.com/v1/design/mcp`). Design system + 31 screen mockups. Distilled into [`ui-design-context.md`](ui-design-context.md); pull originals via `DesignSync` (auth: `/design-login`).
- **flutter_send_anytime (Safe Send)** (`/Users/ase/Documents/flutter_send_anytime`) — SDD methodology source: `.claude/` structure, Speckit per-spec workflow, Clean Architecture + BLoC conventions, design-token discipline. **Follow the methodology + technical patterns, NOT the product or UI/UX** (Safe Send is a P2P file-transfer app; We36 is a social network).

## Key Documents

| File | Vai trò |
|---|---|
| [`.specify/memory/constitution.md`](../../.specify/memory/constitution.md) | **Constitution v1.0.0** — 15 non-negotiable principles (authoritative; conflicts → constitution wins) |
| `CLAUDE.md` | Quick-reference for codebase day-to-day (created/expanded during #001) |
| [`sdd-roadmap.md`](sdd-roadmap.md) | Spec planning (dependency graph, scope per spec, timeline, architecture primer) |
| [`ui-design-context.md`](ui-design-context.md) | **UI source of truth** — screens, design tokens, components, navigation IA |
| [`dev-workflow.md`](dev-workflow.md) | Speckit workflow conventions + per-spec hygiene + commit style |
| [`changelog.md`](changelog.md) | Spec ship history (append-only) |
| [`decisions/`](decisions/) | Alignment decisions per spec |
