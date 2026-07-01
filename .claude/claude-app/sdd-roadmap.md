# We36 v1.0 — Spec Roadmap (SDD Roadmap)

> Goal v1.0: Ship a cross-platform (iOS + Android, Flutter) **Instagram-style social media app** — **feed, stories, reels, direct messages, explore/search, and profiles**. The client speaks a custom, versioned **REST/JSON API + WebSocket** realtime channel (backend server tech out of scope). **Out of scope v1.0**: monetization/commerce, livestreaming, and a ranked recommendation algorithm (MVP feed is reverse-chronological). Fixed light & dark palette, signature rose → violet gradient. **In-app language: English-first** (full i18n, Vietnamese secondary).
>
> **Vai trò file này**: pure planning — dependency graph, scope per spec, timeline, optimal order. Current status của các spec sống ở [`project-context.md`](project-context.md). Ship history sống ở [`changelog.md`](changelog.md). Alignment decisions sống ở [`decisions/`](decisions/). **Giao diện** (screens, tokens, components, navigation IA) sống ở [`ui-design-context.md`](ui-design-context.md) — đọc trước mọi phần UI/UX của spec.
>
> Last updated: 2026-07-01 (#001–#004 merged into `main`. **#007 Create Post 🔵 in progress** on branch `007-create-post` — 31/62 tasks, US1 MVP done. Resume at US2; see `specs/007-create-post/tasks.md`. #005/#006 follow #007 — they reuse its media pipeline.)

---

## SDD Workflow For Each Spec

```
/speckit.specify → /speckit.clarify → /speckit.plan → /speckit.tasks → /speckit.analyze → /speckit.implement
```

Each spec creates: branch `NNN-feature-name`, folder `specs/NNN-feature-name/`. See [`dev-workflow.md`](dev-workflow.md) for the full per-spec flow.

---

## Architecture Primer (read before #002)

We36 is a **client app over a custom backend**, organized in clean layers that every feature shares:

1. **API client** — a single `dio`-based REST/JSON client with an **auth interceptor** (attaches the access token; on `401` does a **single-flight refresh**), centralized HTTP→`AppFailure` error mapping, and per-flavor base URL. No feature touches HTTP directly.
2. **Realtime channel** — one **WebSocket** connection (`web_socket_channel`) for DM messages, typing/presence, and live notifications: reconnect + backoff + heartbeat, typed events in one place. The app stays usable read-only when realtime is down.
3. **Repositories** — domain-typed, return `Result<T>`, sit between the API/realtime/cache and the Cubits. Every repository has a **fake/in-memory implementation** so the whole app is buildable + testable **without a live server** (Constitution VIII/XII).
4. **Local cache** — feed/profile/DM/drafts persisted (`drift` or `hive`, chosen at planning) so the app opens to content instantly; reads reconciled with a background refresh; one canonical cached representation per content item (Constitution IX).

> **Why #001 → #002 → #003 are the blocking foundation**: #001 builds the design-system shell + navigation, #002 builds the networking/cache/realtime core (with fakes), #003 builds auth/session (the gate every other feature sits behind). Every later feature is a new screen + repository on top of this spine.

> **Navigation IA (per [`ui-design-context.md`](ui-design-context.md))**: an **auth-guarded** split — a pre-auth flow (no nav) and a **5-tab bottom nav** (Home / Explore / Reels / Messages / Profile). **Create** (post/story/reel) is a contextual action, not a tab. Full-screen flows (viewers, compose, chat, comments) hide the bottom nav. 31 designed screens across A–G groups.

> **Adaptive (phones + tablets/iPad)**: same nav model/routes/tokens, chrome adapts by **width** — phones (`<700`) use the bottom nav; tablets/iPad (`≥700`) use a **left sidebar rail** + two-pane **master/detail** for Messages + Post detail + responsive grids (see [`ui-design-context.md`](ui-design-context.md) §Responsive). The adaptive shell is built in **#001**; the two-pane variants land with their features (**#012** Messages, **#006** Post detail).

---

## Dependency Graph

```
Spec #001: Project Foundation, Design System & Navigation   ← FOUNDATION (blocking)
   (5-tab shell + auth-flow shell, fixed light/dark tokens,
    shared widgets [Button/Avatar/PostCard/BottomNav/Toast…],
    Result/AppFailure/AppCubit, DI, router + auth-guard skeleton, l10n EN+VI)
    │
    ▼
Spec #002: Networking, Cache & Realtime Core                ← SPINE (blocking)
   (dio API client + auth/refresh interceptor + error mapping,
    cursor pagination envelope, WebSocket realtime client,
    local cache DB, repository base + fakes — no UI)
    │
    ▼
Spec #003: Auth & Onboarding                                ← GATE (blocking)
   (splash/onboarding/sign-in/sign-up/forgot/profile-setup,
    OAuth Google/Apple, session + token lifecycle, secure
    storage, auth-guard redirect)
    │
    ▼
Spec #004: Home Feed & Stories          ⭐ first usable surface
   (paginated feed, PostCard, like/save optimistic, stories
    rail + story viewer)
    │
    ├───────────────┬───────────────┬───────────────┐
    ▼               ▼               ▼               ▼
Spec #005        Spec #006        Spec #007        Spec #008
Create Story     Post Detail &    Create Post      Reels
& Story tools    Comments         (pick→edit→      (vertical video
                 (+ replies,       caption→publish; feed + create)
                  mentions)        media upload)
    └───────────────┴───────┬───────┴───────────────┘
                            ▼
                    Spec #009: Explore & Search
                    (explore grid, search users/tags/places,
                     results tabs, hashtag/location pages)
                            │
                            ▼
                    Spec #010: Profile & Follow
                    (my/other profile, follow/unfollow,
                     followers list, edit profile)
                            │
                            ▼
                    Spec #011: Saved Collections
                            │
                            ▼
                    Spec #012: Direct Messages (realtime)
                    (conversation list, 1-1 chat, share post,
                     stickers, typing/presence)
                            │
                            ▼
                    Spec #013: Notifications & Push
                    (activity feed + FCM/APNs deep-linking)
                            │
                            ▼
                    Spec #014: Settings, Privacy & Safety
                    (account, private account, close friends,
                     blocking, report, language, theme)
                            │
                            ▼
                    Spec #015: Polish & v1.0 Release
```

---

## Spec Details

> Status legend: ⬜ Not started · 🟡 Next · 🔵 In progress · ✅ Merged. All specs below are ⬜ until work begins.

### Spec #001: Project Foundation, Design System & Navigation  ✅
- **Depends on**: none (foundation).
- **Design**: [`ui-design-context.md`](ui-design-context.md) — Navigation IA + Design Tokens + Shared Components are the build spec.
- **Scope**: Clean Architecture folders (`core/` + `features/`); 2 flavors (dev/prod) + entry points; **auth-guarded router** skeleton (pre-auth flow vs 5-tab `StatefulShellRoute`) with placeholder tab pages; **adaptive shell** (phone bottom-nav `<700` ↔ tablet/iPad **SidebarRail** `≥700`, compact/full by `≥980`) + a reusable **two-pane/master-detail** primitive (used by #006/#012); **fixed light & dark design-token layer** (semantic aliases, Plus Jakarta Sans + Inter, spacing/radius/shadow/motion, gradients) ported from claude_design; **shared widget library** built once (`Button`, `IconButton`, `Icon`[Lucide], `Avatar`+ring, `Badge`, `Tag`, `PostCard`, `SearchBar`, `Switch`, `BottomNav`, `SidebarRail`, `StoriesRail`, `TopBar`, `PaneHeader`, `Wordmark`, `Toast`, `ActionSheet`, `Dialog`); foundation primitives (`Result<T>`, `AppFailure`, `AppCubit<T>` 4-state, `AppLogger`, formatters [count/relative-time]); DI; l10n ARB **English primary + Vietnamese**.
- **New packages**: `flutter_bloc`, `get_it`, `injectable`, `go_router`, `freezed`, `json_serializable`, `build_runner`, a Lucide icon pkg, `google_fonts`, `cached_network_image`, `intl`, a toast pkg, `flutter_svg`, `very_good_analysis`.
- **Out of scope**: any networking, auth, real data.

### Spec #002: Networking, Cache & Realtime Core  ✅
- **Depends on**: #001 ✅. **Blocking**: all data features.
- **Scope**: `dio` API client + interceptors (auth token attach, **single-flight refresh**, logging-without-secrets); centralized HTTP→`AppFailure` mapping; **cursor pagination envelope** + a shared paginated-list controller; **WebSocket realtime client** (reconnect/backoff/heartbeat, typed events) — scaffold, wired by #012/#013; **local cache DB** (`drift`/`hive`) + DAO base; **repository base + in-memory fakes** so the app runs without a server; centralized endpoint + socket-event constants; per-flavor base URL/realtime endpoint.
- **New packages**: `dio`, `web_socket_channel`, `flutter_secure_storage`, `drift`(+`drift_flutter`/`drift_dev`) **or** `hive` (decide at plan), `uuid`.
- **Out of scope**: any screen, auth UI, real endpoints (contract + fakes only).

### Spec #003: Auth & Onboarding  ✅
- **Depends on**: #001 ✅, #002 ✅. **Blocking**: everything behind the gate.
- **Design**: Group A (Splash, Onboarding, Sign in, Sign up, Forgot password, Profile setup).
- **Scope**: email/phone + password sign in/up; **OAuth Google/Apple**; forgot-password + OTP; first-run profile setup (username/display name/bio/avatar); **session service** (access+refresh tokens in secure storage, single-flight refresh, logout); **auth-guard redirect**; onboarding slides (first-launch only).
- **New packages**: `google_sign_in`, `sign_in_with_apple`, image pick/crop for avatar.
- **Out of scope**: feed, profile content.

### Spec #004: Home Feed & Stories  ⭐  ✅
- **Depends on**: #002, #003.
- **Design**: Screens 7 (Home feed + StoriesRail), 8 (Story viewer).
- **Scope**: paginated reverse-chronological feed; `PostCard` wired; **optimistic** like/save (+ rollback); stories rail + full-screen story viewer (progress segments, reply/like/share); pull-to-refresh; empty/offline-from-cache states. First usable surface.
- **Out of scope**: creating posts/stories (#005/#007), comments (#006).

### Spec #005: Create Story & Story Tools  🟡
- **Depends on**: #004 ✅.
- **Design**: Screen 9 (Create story).
- **Scope**: capture/pick → sticker/text overlay → publish to Your story / Close friends; 24h expiry model client-side; upload via the #002/#007 media pipeline.
- **Out of scope**: post compose (#007), reels (#008).

### Spec #006: Post Detail & Comments  🟡
- **Depends on**: #004 ✅.
- **Design**: Screens 14 (Post detail), 15 (Comments); tablet = **two-pane** (media + comments sidebar).
- **Scope**: post detail; comments list + **one-level replies** + mentions + quick-emoji + comment compose (optimistic add); like a comment; report/delete via action sheet. On tablet/iPad render the **master/detail two-pane** (media pane + info/comments pane) via the #001 primitive; phone keeps push.
- **Out of scope**: nested reply threads beyond one level (deferred).

### Spec #007: Create Post (Compose & Upload)  🔵 (in progress — 31/62, US1 MVP done)
- **Depends on**: #004 ✅, #002 ✅ (upload).
- **Design**: Screens 11–13 (pick → edit/filter → caption).
- **Scope**: multi-select media pick (carousel), crop + filter + brightness/contrast/warmth, caption/hashtag/tag-people/location/music + "also share to Stories"/"turn off comments"; **client-side compress + resumable/chunked upload** with progress/cancel; idempotent create.
- **New packages**: image cropper + filter pkg, video compress (verify at plan).
- **Out of scope**: reels-specific create (#008).

### Spec #008: Reels  ⬜
- **Depends on**: #002, #004, #007 (shares upload).
- **Design**: Screen 10 (Reels).
- **Scope**: vertical short-video feed (PageView), **disciplined video lifecycle** (only visible plays; off-screen pause+dispose; small preload window — Constitution II); action rail (like/comment/share/save), follow, caption; create reel.
- **New packages**: `video_player`(+`chewie`), `visibility_detector` (verify at plan).
- **Out of scope**: ranked reel recommendation.

### Spec #009: Explore & Search  ⬜
- **Depends on**: #004.
- **Design**: Screens 16–19 (Explore grid, Search, Results, Hashtag/place).
- **Scope**: explore grid (quilted, reels markers); search users/hashtags/places with recents + clear; results tabs (Top/Accounts/Tags/Places); hashtag/location pages (follow tag, Top/Recent/Reels). MVP explore = simple non-personalized grid.
- **Out of scope**: personalized recommendation algorithm (deferred).

### Spec #010: Profile & Follow  ⬜
- **Depends on**: #004, #006.
- **Design**: Screens 20–23 (My/Other profile, Followers, Edit profile).
- **Scope**: my + other profile (stats, bio, grid); **follow/unfollow optimistic**; followers/following lists with search; edit profile; private-account view (request to follow). Share profile link.
- **Out of scope**: collections (#011).

### Spec #011: Saved Collections  ⬜
- **Depends on**: #006 (save action), #010.
- **Design**: Screen 24 (Saved collections).
- **Scope**: save posts into named collections; collections grid; add/remove; the profile "saved" tab.

### Spec #012: Direct Messages (Realtime)  ⬜
- **Depends on**: #002 (realtime), #010.
- **Design**: Screens 25–28 (DM list, Chat, New message, Sticker picker); tablet = **split view** (conversation list + chat pane).
- **Scope**: conversation list (unread, presence, typing preview); 1-1 chat over the **WebSocket** channel (text, photo, **shared post**, stickers); typing/presence; optimistic send + idempotency + delivery state; new-message compose. On tablet/iPad render the **master/detail two-pane** (list + active chat side-by-side, selecting a chat swaps the pane — no push) via the #001 primitive; phone keeps push.
- **Out of scope**: group chats, calls (deferred).

### Spec #013: Notifications & Push  ⬜
- **Depends on**: #002 (realtime), #004/#006/#010 (activity sources).
- **Design**: Screen 29 (Activity).
- **Scope**: activity feed (likes/comments/follows/mentions, New / This week) with follow-back; **FCM/APNs push** + contextual permission + deep-link a notification into its screen; in-app live notifications via realtime.
- **New packages**: `firebase_messaging`, `firebase_core`, local notifications.
- **Out of scope**: notification-preference granularity beyond Settings (#014).

### Spec #014: Settings, Privacy & Safety  ⬜
- **Depends on**: most prior specs.
- **Design**: Screens 30–32 (Settings, Privacy & security, Report/block).
- **Scope**: account settings; **private account**; **close friends** list; **blocking** + **report** flows (enforced in UI immediately); activity status; two-factor entry; language (EN/VI/system); theme (light/dark/system — palette fixed); download-your-data entry; about/version.
- **New packages**: `shared_preferences`, `package_info_plus`, `in_app_review`.
- **Out of scope**: full account-deletion backend flow (surface only).

### Spec #015: Polish & v1.0 Release  ⬜
- **Depends on**: all.
- **Scope**: resilience sweep (offline, token-expiry, realtime-drop, upload-retry, malformed payloads); **media performance** (long-scroll memory ceiling, reels video lifecycle, large-video upload) profiled; accessibility (VoiceOver/TalkBack, Dynamic Type, Reduce Motion, media-overlay contrast); haptics; dark-mode sweep; **security pass** (no secrets in logs, secure storage, private-account + block enforcement, deep-link validation); golden-test pass; build config (obfuscation, signing, provisioning); App Store + Play metadata, privacy/data-safety forms.
- **New packages**: none expected.

---

## Timeline (1 Developer, indicative)

| Spec | Name | Estimate | Cumulative |
|---|---|---|---|
| #001 | Foundation, Design System & Navigation | 1.5 weeks | Wk 1–2 |
| #002 | Networking, Cache & Realtime Core | 1.5 weeks | Wk 2–3 |
| #003 | Auth & Onboarding | 1.5 weeks | Wk 4–5 |
| #004 | Home Feed & Stories ⭐ | 1.5 weeks | Wk 5–6 |
| #005 | Create Story & Tools | 1 week | Wk 7 |
| #006 | Post Detail & Comments | 1 week | Wk 8 |
| #007 | Create Post (Compose & Upload) | 1.5 weeks | Wk 8–9 |
| #008 | Reels | 1.5 weeks | Wk 10–11 |
| #009 | Explore & Search | 1 week | Wk 11–12 |
| #010 | Profile & Follow | 1.5 weeks | Wk 12–13 |
| #011 | Saved Collections | 0.5 weeks | Wk 13 |
| #012 | Direct Messages (Realtime) | 2 weeks | Wk 14–15 |
| #013 | Notifications & Push | 1 week | Wk 16 |
| #014 | Settings, Privacy & Safety | 1.5 weeks | Wk 17–18 |
| #015 | Polish & v1.0 Release | 2 weeks | Wk 18–20 |
| | **Total** | **~20 weeks** | |

### ⭐ First-usable Checkpoint: After Spec #004

App can: log in, see a paginated feed of posts + stories, like/save, view stories. → Start dogfooding against a dev backend.

---

## Optimal Order (1 Developer)

#001 → #002 → #003 → #004 ⭐ → #005/#006/#007 (content creation + engagement, parallelizable) → #008 (reels) → #009 → #010 → #011 → #012 (DM, heaviest realtime lift) → #013 → #014 → #015

The content-creation trio (#005 story / #006 comments / #007 post) all hang off the feed (#004) and reuse the media-upload pipeline first built in #007 — sequence #007 early within the trio. Realtime (#012 DM, #013 notifications) lands after the social graph (#010) so messages/activity have real people to address.

---

## Post-v1.0 Features (v1.1+)

- Ranked / recommendation feed + personalized explore.
- Group chats; audio/video calls.
- Nested reply threads (multi-level); diverse story/DM reactions.
- Location maps; collaborative posts; polls.
- Desktop / web targets.
- Creator tools (out-of-scope commerce/monetization, livestream).
