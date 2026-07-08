# We36 — Project Context

> Last updated: 2026-07-08 (#001–#011 merged; **#012 Direct Messages (Realtime) 🔵 IMPLEMENTED** on branch `012-direct-messages` (commit `4a8a69d`) — 59/59 tasks, **625 tests green**, `flutter analyze` clean; **pending PR/merge to `main`**. The full realtime DM surface (US1–US6): conversation list + 1-1 chat (optimistic/idempotent send, delivery/typing/presence) + rich content (photo/shared-post/sticker) + new-message + tablet two-pane. First live wiring of the #002 `RealtimeClient`. drift v8→v9.)
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

- **Now**: **Spec #012 Direct Messages (Realtime) 🔵 IMPLEMENTED** on branch `012-direct-messages` (commit `4a8a69d`) — **59/59 tasks**, **625 tests green**, `flutter analyze` clean, `dart format` clean. **Committed on the branch; pending PR/merge to `main`.** The **private 1-1 messaging** surface (Screens 25–28) + the **first live wiring of the realtime channel** (the #002 `RealtimeClient`/`SocketEvents` scaffold goes live). App still runs DI `environment: 'fake'` (zero-network, `FakeRealtimeClient` scripts realtime).
  - **Built + verified**: `lib/core/data/messaging/` (`Message`+`MessageKind`/`DeliveryState`/`MessageContent` union/`PostRef`, `Conversation` freezed; `MessagingRepository` real [`env:['real']`] + `FakeMessagingRepository` [`env:['fake']`], remote source, wire DTO mappers) + `lib/core/data/cache/` (`Conversations` + `Messages` tables/DAO — the latter doubles as the offline **outbox**) + `lib/core/services/realtime/` (`RealtimeConnectionManager` connect-on-auth/disconnect-on-logout + `MessagingRealtimeService` folds inbound → cache + transient typing/presence) + `lib/core/services/messaging/MessagingBadge` (core→core unread seam) + `lib/features/messaging/` (`conversations`/`chat`/`new_message`/`messaging_shell` 4-state cubits, usecases, `conversations_page`/`chat_page`/`new_message_page`/`messaging_shell`, widgets [`conversation_tile`/`active_now_rail`/`message_bubble`/`delivery_status`/`typing_indicator`/`chat_composer`/`shared_post_card`/`connection_banner`/`chat_photo_picker`]). **Cross-feature entry seam** (Constitution XI): `MessagingLauncher` in `core/presentation/slots/` (impl in `features/messaging/`) — profile "Message" + post "share to DM" route through it, no cross-feature import. Reuses `RealtimeClient`/`SocketEvents` (#002), `UserSummary` (#002/#010), #007 media pipeline (photo), sticker tray + `TwoPaneScaffold` (#001), `CursorPage`/`PaginatedListCubit` (#002).
  - **Architecture**: **REST-send + inbound-authoritative socket** (idempotent via `clientKey`; the fire-and-forget `RealtimeClient.send()` can't ack, R1); one canonical cached copy per conversation/message; optimistic + delivery `sending→sent→delivered→read` (collapses if backend omits *delivered*); outbox flush on reconnect; **drift schema v8→v9** (additive, wiped on logout). **No new pub dependency.** SessionController now brings the socket up/down. Backend B#012 shapes are **DERIVED** in `contracts/` (reconcile at dev-backend cutover — echo-own-send? delivered real? conversations paginated? send field names? open-or-create?).
  - **Clarifications locked**: any non-blocked user messageable, **no requests-inbox** (→#014) · delivery 4-state w/ graceful collapse · **coarse presence** (Active now + typing, no last-seen) · photo = quick **pick→upload→send** (no editor).
  - **▶ Next**: open a PR for `012-direct-messages` → merge to `main` (add the #012 changelog entry at merge); then **#013 Notifications & Push** (`RealtimeClient` `notification.new` + FCM/APNs). ⚠ Same drift/socket test gotcha applies (see below).
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
| 012 | Direct Messages (Realtime) | 🔵 **Implemented** (59/59, 625 tests; pending commit/PR) | `012-direct-messages` |
| 013 | Notifications & Push | 🟡 **Next** | `013-notifications-push` |
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
