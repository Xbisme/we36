# Implementation Plan: Notifications & Push

**Branch**: `013-notifications-push` | **Date**: 2026-07-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/013-notifications-push/spec.md`

## Summary

Build the We36 client **Activity** surface (Screen 29) — the grouped notification feed of likes/comments/replies/mentions/follows — plus **real push delivery**, as a new `features/notifications/` presentation layer over a new `core/data/notifications/` data slice, and **wire the realtime `notification.new` channel for the first time** (the second live consumer of the #002 `RealtimeClient`, after #012 DM brought the socket up). The backend notifications module is **already shipped** (`backend/src/modules/notifications` + `backend/src/jobs`), so the client is built **contract-first** against the verified real shapes (see [contracts/](contracts/)).

People get: an **Activity screen** (TopBar "Activity" large; sections **New (today) / This week / Earlier**, newest-first within each; rows render server-**grouped** entries — "Alice and N others" — with actor avatars, per-type summary text, a target thumbnail or an inline **follow-back** control, relative time; unread rows carry an accent), tap-to-**deep-link** to the target (post/reel/comment → post detail; follow/mention-user → profile), **mark-all-read on open** clearing the badge, an **unread badge** on the Activity entry point (Home-header bell on phone, SidebarRail "Notifications" item on tablet), **live** fold of `notification.new` into the canonical cache (badge + feed update silently, no banner — clarified), and **push** (permission requested on first Activity open, device token register/unregister via REST, system notification on backend push, coarse deep-link on tap). Plus inclusive/adaptive hardening.

**Realtime wiring**: a new `@lazySingleton` **`NotificationsRealtimeService`** subscribes to `RealtimeClient.events` and folds the `NotificationNew` inbound event into the canonical drift notifications cache + the unread-count seam — Cubits/widgets never touch the socket (Constitution VIII). The #002 scaffold parses `notification.new` into a `NotificationNew` event but currently reads a non-existent `data['notification']` key; **#013 corrects the parser + event to carry the real `{entry, unreadCount}` payload** (the #012 scaffold-reconciliation pattern). The connection lifecycle is already owned by the shipped `RealtimeConnectionManager`/`SessionController` — no new connection code.

**Push wiring**: a new `PushService` seam in `core/services/push/` — a **real `firebase_messaging` binding** (`env:['real']`) that requests permission, reads/rotates the FCM/APNs token, and surfaces foreground/tapped notifications, plus an **in-memory `FakePushService`** (`env:['fake']`) so the whole surface is testable with **zero network and no Firebase** (the app's current `env:'fake'` run never initializes Firebase). Device register/unregister goes over REST (`POST /devices`, `DELETE /devices/:token`) through the shared `ApiClient`, driven by `SessionController` on auth/logout. **Native credential provisioning (Firebase project + `GoogleService-Info.plist`/`google-services.json` + APNs key) is deferred to real-backend cutover / #015** (clarified Q2); on-device push receipt is verified then. **New pub dependencies**: `firebase_core ^4.11.0`, `firebase_messaging ^16.4.1`, `flutter_local_notifications ^22.0.1` (native gates in [research.md](research.md)).

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (repo baseline; `pubspec` floor `sdk: ^3.11.5`).

**Primary Dependencies**: `flutter_bloc` (4-state freezed Cubits), `get_it`+`injectable` (DI, `env:['real'|'fake']`), `go_router` (new `AppRoutes.notifications` + `we36://notifications` deep-link; Activity is a pushed nav-less route from the Home-header bell on phone / a SidebarRail destination on tablet — **not** a bottom-nav tab), `dio` via the shared `ApiClient` + interceptors + `FailureMapper`, **`socket_io_client`** via the shipped `RealtimeClient` (the `notification.new` consumer wires live here), `freezed`+`json_serializable`, `drift` (one new table + DAO, reactive `.watch()`), `cached_network_image` (bounded actor-avatar/thumbnail decode), `lucide_icons_flutter` via `AppIcon`, `intl` via relative-time formatters. **New**: `firebase_core`/`firebase_messaging` (push transport) + `flutter_local_notifications` (foreground/local presentation). Reuses `CursorPage<T>`+`PaginatedListCubit<T>` (#002), `RealtimeConnectionManager`/`SessionController` (#012), the `MessagingBadge` core→core seam pattern (#012 → new `NotificationsBadge`), `UserSummary`/`ProfileRepository` follow toggle (#010) for follow-back, and the router deep-link targets for post/reel/comment/profile (#004/#006/#008/#010).

**Storage**: **drift schema v9→v10** — one new table **`Notifications`** (id PK, type, actors json [ordered `ActorCard` list], actorCount, target json nullable [`kind`/id/postId/thumbnailUrl], isRead, createdAt, updatedAt) as the one canonical cached representation, watched reactively by the feed + badge. Server-owned grouping/read state is cached verbatim (the client does not regroup). **Unread count** is derived from the server (`GET /notifications/unread-count` + the `unreadCount` on each `notification.new`) held in a small transient/last-known store surfaced by `NotificationsBadge`; the count is NOT recomputed client-side from rows (read state is a server `lastReadAt` marker, not per-row). The table is user-scoped and **wiped on logout** via `clearUserScoped()` (wired into `SessionController._db.clearUserScoped()`). Registered device tokens are **not** cached locally (credential hygiene — held only in the push SDK + the backend registry).

**Testing**: `flutter_test` + `bloc_test` + `mocktail` (fakes) + golden tests. Cubit/logic: feed load + offline-from-cache + pagination (cursor, ≥2 pages) + sectioning (New/This week/Earlier) + grouped-entry render + deleted-target degraded row; mark-all-read clears the badge (SC-003); live `notification.new` fold → new entry at top + badge bump with **duplicate suppression** (exactly once, SC-004/FR-013); follow-back optimistic + rollback (reuses #010); permission-gate (first Activity open, no renag); device register on grant + unregister on logout (idempotent); coarse push deep-link routing (feed→Activity, message→Messages). **Realtime tested against `FakeRealtimeClient`** (typed `NotificationNew` in → cache/badge out), never a live socket. **Push tested against `FakePushService`** (scripted permission result + token + inbound push → state out), never real Firebase. Widget tests seed **stub cubits** with a fixed 4-state — never real drift/socket/Firebase I/O inside `testWidgets` (the #009 gate learning); any clock-dependent seam (the New/This week/Earlier bucketing) is **frozen via an injectable clock** in tests (the post-#10 time-bomb learning). Log-redaction test (no push tokens, no private content) + a11y/text-scale/adaptive + goldens (Activity row grouped/single, follow-back row, empty state, light+dark).

**Target Platform**: iOS + Android phones + iPad/Android tablets. Phone = Activity pushed nav-less from the Home-header bell; tablet/iPad (`≥700`) = SidebarRail "Notifications" destination, list centered max ~620 (design §Responsive TabletNotifications). Real push requires **iOS 15+ deployment target** (Firebase 16.x/4.x drops iOS 13/14) and **Android compileSdk 35 / Java 17 / AGP 8.11.1+** (flutter_local_notifications 22.x) — native gates in research.

**Project Type**: Mobile app (Flutter client) over a custom REST + Socket.IO backend; **backend B#013 is already shipped and source-verified** — the app runs `env:['fake']` for hermetic tests, `env:['real']` binds the shipped endpoints/events at cutover.

**Performance Goals**: Activity feed renders from cache in < 1 s on warm open (SC-001); live `notification.new` reflects in the badge/feed within 2 s, no manual refresh (SC-004); actor avatars/thumbnails decode at a bounded `cacheWidth`; 60 fps feed scroll with bounded memory over ≥2 pages; one realtime connection (no per-screen sockets); one push SDK init (guarded, only in `env:'real'` with config present).

**Constraints**: Cubits/widgets never touch `dio`/the socket/Firebase (repositories + `NotificationsRealtimeService` + `PushService` only); one canonical cached copy per notification (dedupe by server id — no per-Cubit drift); the client renders server grouping/read state and computes neither; mark-all-read is the only read mutation (no per-row toggle); realtime degrades to read-from-cache (`realtimeDisconnected` quiet); coarse cold-push deep-link (no `GET /notifications/:id` exists — backend contract limit); no push token or private content in logs (`AppLogger` redacted); all messages via Toast; semantic tokens only; `lib/core/` must not import `lib/features/`; notification preferences are server-enforced and **out of scope** here (client settings UI → #014).

**Scale/Scope**: 1 designed screen (29); ~2–3 Cubits (`NotificationsCubit` feed over `PaginatedListCubit`; the badge rides a `NotificationsBadge` stream seam, not a Cubit; an optional `PushPermissionCubit`/controller for the permission gate); 1 new repository (+ real + fake) + 1 remote data source; 1 new drift table/DAO (v10); 1 new `@lazySingleton` core realtime service (`NotificationsRealtimeService`) + 1 push seam (`PushService` real + fake) + 1 badge seam (`NotificationsBadge`); ~4 new client models (`NotificationEntry`(+`NotificationType`), `ActorCard`, `NotificationTarget`, `UnreadCount`/live-event wrapper); reuses the #010 follow toggle, the router deep-links, and the badge-seam pattern verbatim; extends `RealtimeClient` inbound parsing for the real `notification.new` payload; new native config (iOS min-target bump, Android compileSdk, push entitlements) gated to cutover.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I Privacy/Safety & Trust**: **Push tokens are credentials** — never displayed, never logged, never cached in app storage (held only in the push SDK + backend registry); log-redaction test covers tokens + private content (FR-023). Notification **permission requested contextually** (first Activity open, with a value explainer — never cold start), degrades gracefully when denied, no renag (FR-014/FR-019 — Principle I permissions rule). Block/self-suppression + notification-preference gating are **server verdicts** the client renders as-is (backend suppresses; the client enforces nothing extra). Deleted/hidden targets render degraded, never leak a dead link (FR-006). Deep links validated before routing (FR-018, Principle X). ✅
- **II Media discipline**: Actor avatars + target thumbnails decode at a bounded `cacheWidth` via `cached_network_image`; the feed paginates (cursor) and never holds every decoded image; no video. ✅
- **III BLoC 4-state**: Events plain / states freezed `initial/loading/loaded/error`; the feed reuses `PaginatedListCubit` (`loaded` + cursor + `hasMore` + `loadingMore`). Use Cases injected into Cubits, not repos. Page-scoped `BlocProvider`; `@injectable` screen cubits; `@lazySingleton` repo/DAO/services (`NotificationsRealtimeService`, `PushService`, `NotificationsBadge`). Cubit↔Cubit only via shared repo/service/streams. ✅
- **IV/VIII One API client + one realtime socket behind repos**: All HTTP via the shared `ApiClient`; the **one** realtime connection (shipped `RealtimeClient`, owned by `RealtimeConnectionManager`) gains a second inbound subscriber `NotificationsRealtimeService`. Widgets/Cubits touch neither `dio` nor the socket nor Firebase. New REST endpoints + the (existing) `notification.new` event name live in `core/constants/{api_endpoints,socket_events}.dart` — no inline literals. `notification.new` parser corrected to the real `{entry, unreadCount}` shape. Single-flight refresh + centralized `FailureMapper` reused. ✅
- **V Result/AppFailure**: Repo returns `Result<T>`; `realtimeDisconnected`/`permissionDenied`/`networkError`/`serverError` map centrally → Toast. try/catch forbidden in Cubits. ✅
- **VI Design discipline**: Reuse `TopBar` (large "Activity"), `Avatar`, `AppButton` (follow-back = secondary/`Following` state), `AppIcon` (`notification` bell + solid-active), the `Badge` (rose dot/count), `CountFormatter`/relative-time; semantic tokens only; **"color earns its place"** — neutral rows, brand accent only on the unread accent + follow-back CTA + the bell badge; the bell uses the `notification` Lucide glyph (outline default, solid/dot when unread). No banner surface (clarified: silent live update). ✅
- **VII Adaptive & native**: Activity is the **Home-header bell** (phone) vs a **SidebarRail first-class item** (tablet ≥700), list centered max ~620 on tablet (design §Responsive); **push notifications via FCM/APNs** with contextual permission + coarse deep-linking (Principle VII push rule). Haptic optional on follow-back. ✅
- **IX Data integrity / optimistic / one canonical copy**: Live `notification.new` folded into **one canonical** drift copy (dedupe by server id → exactly once, SC-004/FR-013); the feed + badge both read it. Follow-back is optimistic with rollback (reuses #010). Non-destructive additive v9→v10 migration; migration test covers v9→v10. Malformed inbound/API payloads skipped gracefully (one bad entry never crashes the feed, FR-006). ✅
- **X go_router**: New `AppRoutes.notifications` + `we36://notifications` deep-link, validated. Activity is a nav-less pushed route (phone) / SidebarRail destination (tablet); push-tap routing validated before navigation (coarse: feed→Activity, message→Messages). ✅
- **XI Feature-first**: New `features/notifications/` + `core/data/notifications/` + one `core/services/realtime/` service + one `core/services/push/` seam + one `core/services/notifications/` badge seam + one `core/data/cache/` table. `core/` never imports `features/`. The Activity **badge** is a **core→core** read (`NotificationsBadge` in `core/services`, mirroring `MessagingBadge`) so `core/presentation` (Home header + SidebarRail) never imports `features/notifications`. Follow-back reuses `ProfileRepository` via a use case; deep-links via `core/router`. ✅
- **XII Testing**: Every repository + the realtime client + the push SDK have fakes; `FakeRealtimeClient` scripts `NotificationNew` (typed event in → cache/badge out); `FakePushService` scripts permission/token/inbound push; no live socket, no real Firebase in CI. Widget tests seed stub cubits (no real drift/socket/Firebase in `testWidgets`); the New/This week/Earlier clock is frozen. ✅
- **XIII/XV Simplicity / deps**: **Three new pub dependencies justified** by the push requirement (`firebase_core`/`firebase_messaging` = FCM/APNs transport per Constitution Technical Standards; `flutter_local_notifications` = foreground/local presentation) — versions sourced from pub.dev (research R1), native platform gates verified at plan time (iOS 15+ target, Android compileSdk 35 / Java 17 / AGP 8.11.1+ — research R2). Out-of-scope items (notification-preference UI, follow-request approval, message-requests inbox, precise cold-push deep-link, email/SMS) are NOT built. ✅
- **XIV i18n**: All copy (summary templates per type, section headers, permission explainer, empty/error) in EN+VI ARB; relative-time via shared `intl` helper. ✅

**Result: PASS** — three deliberate choices justified in Complexity Tracking (three new push deps + native config; a new drift table; correcting the #002 `notification.new` scaffold parser).

## Project Structure

### Documentation (this feature)

```text
specs/013-notifications-push/
├── plan.md              # This file
├── research.md          # Phase 0 output (push deps + native gates, realtime payload fix, badge placement, permission gate, deep-link, sectioning)
├── data-model.md        # Phase 1 output (client models, drift v9→v10, DTO mapping)
├── quickstart.md        # Phase 1 output (validation scenarios)
├── contracts/
│   ├── notifications-api.md   # Client-consumed B#013 REST subset (SOURCE-VERIFIED against backend)
│   └── realtime-events.md     # notification.new usage + the real {entry, unreadCount} payload + parser fix
└── tasks.md             # /speckit.tasks output (later)
```

### Source Code (repository root)

```text
lib/core/constants/
├── api_endpoints.dart                       # EXTEND: notifications list / unread-count / read; devices register / unregister
└── socket_events.dart                        # (already has notificationNew — reused as-is)

lib/core/data/realtime/
└── realtime_event.dart                       # FIX: notification.new parser → carry real {entry, unreadCount}; NotificationNew(entry, unreadCount)

lib/core/data/notifications/                  # NEW data slice
├── notification_entry.dart                   # NotificationEntry + NotificationType enum (freezed) + ActorCard + NotificationTarget (+ TargetKind) + json DTO mappers
├── notifications_repository.dart             # interface (Result<T>): watchFeed/loadPage(cursor)/refresh, watchUnreadCount, markAllRead, foldLiveEvent
├── notifications_repository_impl.dart        # @LazySingleton(as:…, env:['real']) → ApiClient(list/unread/read) + NotificationsDao(cache)
├── fake_notifications_repository.dart        # @LazySingleton(as:…, env:['fake']) → in-memory graph; drives FakeRealtimeClient NotificationNew
└── notifications_remote_data_source.dart     # ApiClient calls → Result

lib/core/data/cache/
├── tables/notifications_table.dart           # NEW drift table (v10)
└── daos/notifications_dao.dart               # NEW DAO: watchFeed()/page(cursor), upsertEntry(dedupe by id), markAllReadLocal(lastReadAt), clearUserScoped()
   (app_database.dart: schemaVersion 9→10 + additive migration; register table + DAO; add DAO to clearUserScoped())

lib/core/services/realtime/
└── notifications_realtime_service.dart       # NEW @LazySingleton — subscribes RealtimeClient.events → folds NotificationNew into cache + unread seam

lib/core/services/notifications/
└── notifications_badge.dart                  # NEW @LazySingleton — core→core unread-count stream for the Home-header bell + SidebarRail (mirrors MessagingBadge)

lib/core/services/push/                       # NEW push seam
├── push_service.dart                         # abstract PushService (requestPermission → status, tokenStream, foreground/tap message streams)
├── firebase_push_service.dart                # @LazySingleton(as: PushService, env:['real']) → firebase_messaging + flutter_local_notifications (init guarded on config presence)
└── fake_push_service.dart                    # @LazySingleton(as: PushService, env:['fake']) → scripted permission/token/inbound; zero network, no Firebase

lib/features/notifications/
├── domain/usecases/
│   ├── notifications_usecases.dart           # WatchFeed / LoadPage (cursor) / Refresh / MarkAllRead / FollowBack(reuse #010) / SectionEntries(clock)
│   └── push_usecases.dart                    # EnsurePushPermission (first Activity open) / RegisterDevice / UnregisterDevice / RoutePushTap
├── presentation/
│   ├── cubit/
│   │   ├── notifications_cubit(.dart/_state)       # feed over PaginatedListCubit: watch drift + fold live; loaded(sections, hasMore, isOffline)
│   │   └── push_permission_cubit(.dart/_state)     # permission gate state (asked?/granted?/affordance)
│   ├── notifications_page.dart               # Screen 29 — TopBar "Activity" large; New/This week/Earlier sections; centered on tablet
│   └── widgets/
│       ├── notification_tile.dart            # avatar(s) + "<b>user</b> action" summary + time + thumbnail | follow-back button; unread accent; deleted-target degraded
│       ├── notification_section_header.dart  # New / This week / Earlier
│       ├── follow_back_button.dart           # reuses #010 follow toggle (optimistic) — Follow/Following/Requested
│       └── push_permission_prompt.dart       # value explainer → system prompt; subtle re-offer affordance
└── (route added to core/router/app_router.dart + AppRoutes.notifications; Home-header bell + SidebarRail Notifications item wired to open it)

lib/core/presentation/                        # EXTEND (core→core, no features import)
├── (Home header) top bar bell → getIt-guarded NotificationsBadge stream → Badge dot/count; onTap → context.push(AppRoutes.notifications)
└── router/adaptive_shell.dart                # SidebarRail "Notifications" first-class item + badge (mirrors the messages badge block)

lib/core/services/session/session_controller.dart   # EXTEND: on authenticated → PushService.ensureRegistered (if permission granted); on logout → PushService.unregister (+ existing clearUserScoped now clears notifications)

# Native config (gated to cutover / #015 — Constitution XV; compiles now, on-device receipt verified later):
ios/Runner/Info.plist + Runner.xcodeproj                 # IPHONEOS_DEPLOYMENT_TARGET 13 → 15; push background mode / APNs entitlement; GoogleService-Info.plist (at cutover)
android/app/build.gradle.kts + android/build.gradle.kts  # compileSdk 35 / Java 17 / AGP 8.11.1+; google-services plugin + google-services.json (at cutover)
```

**Structure Decision**: Feature-first (matches #004–#012). A new `features/notifications/` presentation layer over a thin `core/data/notifications/` slice, plus **core-owned wiring**: the `notification.new` subscriber (`NotificationsRealtimeService`) and the push seam (`PushService`) live in `core/services` (the socket + push transport are `core/` concerns — Constitution VIII/XI — not a feature's). The Activity **entry point is not a bottom-nav tab** (the 5 tabs are fixed: Home/Explore/Reels/Messages/Profile): on phone it is the **Home-header bell** opening a pushed `NotificationsPage`; on tablet it is a **first-class SidebarRail item**. Its **unread badge** rides the `NotificationsBadge` core→core stream (mirroring `MessagingBadge`) so `core/presentation` never imports `features/notifications`. Live `notification.new` folds into the canonical drift cache so the feed + badge react to one source. Follow-back reuses the shipped `ProfileRepository` follow toggle via a use case; push register/unregister is driven by `SessionController`.

## Complexity Tracking

| Choice | Why Needed | Simpler Alternative Rejected Because |
|--------|------------|-------------------------------------|
| **Three new push dependencies** (`firebase_core`, `firebase_messaging`, `flutter_local_notifications`) + native config (iOS 15 target, Android compileSdk 35/Java 17/AGP 8.11.1+) | Real push is a headline of the spec (US2) and Constitution VII mandates FCM/APNs delivery; `firebase_messaging` is the only supported FCM/APNs transport, `firebase_core` is its required host, and `flutter_local_notifications` presents foreground/local notifications the OS won't auto-show. Versions + native gates sourced at plan time (research R1/R2). | No pure-Dart FCM/APNs client exists; a raw socket-only "notification" cannot wake a backgrounded/killed app. The push binding is isolated behind a `PushService` seam with a fake, so the deps never touch tests and the app's `env:'fake'` run never initializes Firebase — keeping CI hardware/credential-free (Constitution XII). |
| **One new drift table** (`Notifications`, v9→v10) | The Activity feed must render offline-from-cache on cold start and be the one canonical copy that both the feed and the badge react to when a live `notification.new` arrives (Constitution IX). | An in-memory store cannot satisfy offline cold-start; recomputing from rows can't derive the unread count (read state is a server `lastReadAt` marker, not per-row) — persisting the server-grouped entries is the #004/#009/#012 precedent for canonical content. |
| **Correcting the #002 `notification.new` scaffold parser** | #002 shipped the parser reading `data['notification']`, but the source-verified backend emits `{entry, unreadCount}` (no `notification` key); left as-is the live event would always fold an empty payload. #013 is the first consumer and must reconcile it (the #012 scaffold-reconciliation precedent). | Adapting the client to the wrong scaffold shape would silently break live notifications; a mapping shim would hide a contract mismatch instead of fixing the one typed parse point. |
