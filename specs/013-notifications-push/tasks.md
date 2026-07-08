---
description: "Task list for #013 Notifications & Push (We36 Flutter client)"
---

# Tasks: Notifications & Push

**Input**: Design documents from `specs/013-notifications-push/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/notifications-api.md](contracts/notifications-api.md), [contracts/realtime-events.md](contracts/realtime-events.md)

**Tests**: Included (the repo pre-commit gate requires `flutter test` green; every prior slice ships bloc/widget/golden/fake/redaction coverage). **Realtime is tested against `FakeRealtimeClient`** — typed `NotificationNew` in → cache/badge out (Constitution XII); never a live socket. **Push is tested against `FakePushService`** — scripted permission/token/inbound → state out; never real Firebase. Widget tests seed **stub cubits** — never real drift/socket/Firebase I/O inside `testWidgets` (the #009 gate learning). The New/This week/Earlier bucketing clock is **frozen** in tests (the post-#10 time-bomb learning).

**Organization**: Grouped by user story (US1–US6 from spec.md). Phase 2 builds the shared `core/data/notifications/` slice + the **drift v9→v10** (`Notifications`) cache, **corrects the #002 `notification.new` parser + wires the realtime fold** (`NotificationsRealtimeService`), stands up the **`PushService` seam** (real + fake), and the **`NotificationsBadge`** core→core seam — all stories consume these. **Backend B#013 is source-verified** (contracts written from `backend/src/modules/notifications`). Reuses the shipped `RealtimeClient`/`InboundEvent`/`SocketEvents` (#002, `notification.new` consumer wires live here), `RealtimeConnectionManager`/`SessionController` (#012), `CursorPage`/`PaginatedListCubit` (#002), the `ProfileRepository` follow toggle (#010) for follow-back, router deep-links (#004/#006/#008/#010), and the `MessagingBadge` seam pattern (#012). **New pub deps**: `firebase_core ^4.11.0`, `firebase_messaging ^16.4.1`, `flutter_local_notifications ^22.0.1`. **drift schema v9→v10 (additive).**

## Format: `[ID] [P?] [Story] Description with file path`

- **[P]**: parallelizable (different files, no dependency on an incomplete task).
- **[Story]**: US1–US6 (Setup/Foundational/Polish carry no story label).

---

## Phase 1: Setup (Shared Infrastructure)

- [ ] T001 Add push deps to `pubspec.yaml` — `firebase_core: ^4.11.0`, `firebase_messaging: ^16.4.1`, `flutter_local_notifications: ^22.0.1` (versions per [research.md](research.md) R1); run `flutter pub get`; commit `pubspec.lock`. Verify the resolved `pubspec.yaml` min-platform lines for the three plugins (Constitution XV) and record any that exceed T002's targets.
- [ ] T002 Clear native gates so the project compiles **without credentials** (per [research.md](research.md) R2): iOS — bump `IPHONEOS_DEPLOYMENT_TARGET` 13→**15** in `ios/Runner.xcodeproj/project.pbxproj` + `platform :ios, '15.0'` in `ios/Podfile`; add the **Push Notifications** capability + `remote-notification` UIBackgroundMode in `ios/Runner/Info.plist` (APNs entitlement file already exists from #003). Android — confirm `android/app/build.gradle.kts` `compileSdk`=35 + Java/Kotlin target 17, root AGP ≥8.11.1; add the `com.google.gms.google-services` plugin **commented/guarded** (applied with `google-services.json` at cutover). **Do NOT commit `GoogleService-Info.plist`/`google-services.json`** (deferred to #015, clarified Q2).
- [ ] T003 [P] Add notifications + devices endpoints to `lib/core/constants/api_endpoints.dart` per [contracts/notifications-api.md](contracts/notifications-api.md) — `notifications` (GET `/notifications`), `notificationsUnreadCount` (GET `/notifications/unread-count`), `notificationsRead` (POST `/notifications/read`), `devices` (POST `/devices`), `device(token)` (DELETE `/devices/{token}`). No inline literals. (The `notification.new` socket event name already lives in `socket_events.dart` — reused as-is.)
- [ ] T004 [P] Add the Activity route to `lib/core/constants/app_routes.dart` — `notifications = '/notifications'` + the `we36://notifications` deep-link mapping (validated). Activity is a nav-less pushed route (phone) / SidebarRail destination (tablet) — **not** a bottom-nav tab.
- [ ] T005 [P] Add EN+VI ARB keys in `lib/l10n/arb/app_en.arb` + `app_vi.arb` — TopBar "Activity"; section headers "New" / "This week" / "Earlier"; per-type summary templates (liked your post / commented / replied / mentioned you / started following you / requested to follow you / accepted your request; grouped "and {count} others"); follow-back "Follow"/"Following"/"Requested"; permission explainer title+body + "Turn on notifications" affordance; empty state; error+retry; unavailable/deleted-target label. `@description` on each.
- [ ] T006 [P] Scaffold folders per [plan.md](plan.md): `lib/core/data/notifications/`, `lib/core/services/{realtime,notifications,push}/` (new files), `lib/core/data/cache/tables/` + `daos/` (new files), and `lib/features/notifications/{domain/usecases,presentation/cubit,presentation/widgets}` with file placeholders.

---

## Phase 2: Foundational (data slice + drift v10 + realtime fold + push seam — BLOCKS all user stories)

### Models

- [ ] T007 [P] `NotificationEntry` + `NotificationType` (enum: `like,comment,reply,mention,follow,followRequest,followAccepted,unknown`) + `ActorCard` + `NotificationTarget` + `TargetKind` (enum: `post,reel,comment,user`) freezed+json in `lib/core/data/notifications/notification_entry.dart` per [data-model.md](data-model.md); derivations `andOthersCount` (`actorCount-1`), `isActionable`, `hasThumbnail`; nullable `target` → degraded flag.
- [ ] T008 [P] DTO mappers + push value objects in `lib/core/data/notifications/notifications_dto.dart` — `notificationEntryFromDto`/`actorCardFromDto`/`notificationTargetFromDto` (null-safe; unknown enum → `unknown`), `registerDeviceBody(platform, token)`; and `PushPermissionStatus`/`PushTapData`/`PushForegroundData`/`RegisteredDevice` value objects in `lib/core/services/push/push_models.dart`. Tolerant decode (no `dynamic` digging at call sites).

### drift v9 → v10

- [ ] T009 [P] `Notifications` drift table in `lib/core/data/cache/tables/notifications_table.dart` (id PK text, type text, actorsJson text, actorCount int, targetJson text nullable, isRead bool, createdAt datetime, updatedAt datetime) + index `(updatedAt DESC, id DESC)`.
- [ ] T010 `NotificationsDao` in `lib/core/data/cache/daos/notifications_dao.dart` — `watchFeed()` (order `updatedAt` desc, `id` desc), `page(cursor?, limit)` (keyset for `PaginatedListCubit`), `upsertEntry`/`upsertAll` (dedupe by `id`), `markAllReadLocal(DateTime lastReadAt)` (flip cached `isRead` for entries with `updatedAt ≤ marker`), `clearUserScoped()`; map rows ↔ `NotificationEntry` (decode JSON). Unread count is NOT derived here (server marker — R5).
- [ ] T011 Bump `lib/core/data/cache/app_database.dart` — register the `Notifications` table + `NotificationsDao`; `schemaVersion` **9→10**; additive migration (`m.createTable(notifications)` + index), no backfill; add `NotificationsDao.clearUserScoped()` to `AppDatabase.clearUserScoped()`.

### Repository + remote source + fakes

- [ ] T012 `NotificationsRepository` interface in `lib/core/data/notifications/notifications_repository.dart` — `Stream<List<NotificationEntry>> watchFeed()`; `Result<CursorPage<NotificationEntry>> loadPage(String? cursor)`; `Result<void> refresh()`; `Result<int> fetchUnreadCount()`; `Result<void> markAllRead()`; `void foldLiveEntry(NotificationEntry entry, int unreadCount)`; `Result<RegisteredDevice> registerDevice(String platform, String token)`; `Result<void> unregisterDevice(String token)`.
- [ ] T013 `NotificationsRemoteDataSource` in `lib/core/data/notifications/notifications_remote_data_source.dart` — `ApiClient` calls per [contracts/notifications-api.md](contracts/notifications-api.md) (list/unread-count/read; devices register/unregister); returns typed DTOs/`Result`.
- [ ] T014 `NotificationsRepositoryImpl` `@LazySingleton(as: NotificationsRepository, env: ['real'])` in `lib/core/data/notifications/notifications_repository_impl.dart` — `loadPage`/`refresh` fetch → `NotificationsDao.upsertAll`; `watchFeed` is a reactive `.watch()` read (one canonical copy); `markAllRead` calls `POST /notifications/read` then `markAllReadLocal(now)` optimistically; `fetchUnreadCount` → `GET /unread-count`; `foldLiveEntry` upserts (dedupe by id); device register/unregister via the remote source; `Result`/`FailureMapper`.
- [ ] T015 `FakeNotificationsRepository` `@LazySingleton(as: NotificationsRepository, env: ['fake'])` in `lib/core/data/notifications/fake_notifications_repository.dart` — in-memory graph: seeded entries of every type incl. a grouped like (`actorCount>1`), a null-target entry, mixed read/unread across time buckets (≥2 keyset pages); `fail-next` seam for error/rollback; drives `FakeRealtimeClient` to script `NotificationNew`; scripted unread count + device register/unregister capture. **No fixed wall-clock** (inject a clock / pass timestamps).

### Realtime fold + badge seam

- [ ] T016 Correct the #002 scaffold in `lib/core/data/realtime/realtime_event.dart` per [contracts/realtime-events.md](contracts/realtime-events.md) — widen `NotificationNew` to `{required Map<String,dynamic> entry; required int unreadCount}` and fix the `notification.new` parse to read `data['entry']` + `data['unreadCount']` (was the non-existent `data['notification']`). Keep `MessagingRealtimeService`'s ignore-case compiling (it destructures nothing).
- [ ] T017 `NotificationsRealtimeService` `@LazySingleton` in `lib/core/services/realtime/notifications_realtime_service.dart` — sole `RealtimeClient.events` subscriber for `NotificationNew`: parse `entry` → `NotificationEntry` (malformed → skip w/ redacted warn), `NotificationsDao.upsertEntry` (dedupe by id → exactly once), push `unreadCount` to the badge seam. No banner/toast (Q4). Constructed at boot (like `MessagingRealtimeService`) so it listens before the first event.
- [ ] T018 [P] `NotificationsBadge` core seam `@LazySingleton` in `lib/core/services/notifications/notifications_badge.dart` — exposes `Stream<int> unreadCount` (last-known: seeded by `fetchUnreadCount`, bumped by `NotificationsRealtimeService`, reset to 0 on mark-all-read). A **core→core** read so `core/presentation` (Home header + SidebarRail) never imports `features/notifications` (Constitution XI; mirrors `MessagingBadge`). Depends on T017.

### Push seam

- [ ] T019 [P] `PushService` abstract in `lib/core/services/push/push_service.dart` — `requestPermission()`/`currentStatus()` → `PushPermissionStatus`; `Stream<String> tokenStream`; `Stream<PushTapData> onNotificationTap`; `Stream<PushForegroundData> onForegroundMessage` (per [research.md](research.md) R4).
- [ ] T020 `FirebasePushService` `@LazySingleton(as: PushService, env: ['real'])` in `lib/core/services/push/firebase_push_service.dart` — wraps `firebase_messaging` (permission, `onTokenRefresh`, `onMessage`/`onMessageOpenedApp`/`getInitialMessage`) + `flutter_local_notifications` for foreground display; **`Firebase.initializeApp()` guarded on config presence** (no-op/skip when absent so `env:'fake'` and CI never init Firebase). Maps `{kind, notificationId?}` → `PushTapData`. No token in logs.
- [ ] T021 [P] `FakePushService` `@LazySingleton(as: PushService, env: ['fake'])` in `lib/core/services/push/fake_push_service.dart` — controllable: `scriptPermission(status)`, `emitToken(t)`, `emitTap(PushTapData)`, `emitForeground(...)`; zero network, no Firebase.

### Build + foundational tests

- [ ] T022 Run `dart run build_runner build --delete-conflicting-outputs`; verify DI resolves `NotificationsRepository` (`env:['fake']` for the app; `['real']` annotated), `NotificationsRealtimeService`, `NotificationsBadge`, `PushService` (fake), and the drift **v10** schema compiles.
- [ ] T023 [P] drift migration test **v9→v10** (additive; `Notifications` created; `clearUserScoped` wipes it) in `test/core/data/cache/notifications_migration_test.dart` — extend the existing migration harness.
- [ ] T024 [P] Foundational unit tests in `test/core/data/notifications/` — DTO decode (every type + null target + unknown enum + null avatar); `NotificationsDao` upsert dedupe-by-id + keyset paging + `markAllReadLocal`; `realtime_event` parses the real `{entry, unreadCount}` payload (regression for the T016 fix).

**Checkpoint**: Foundation ready — the notifications data slice, drift v10, realtime fold, badge seam, and push seam exist and resolve. User stories can now proceed.

---

## Phase 3: User Story 1 - Activity feed (Priority: P1) 🎯 MVP

**Goal**: The Activity screen (Screen 29) — grouped, sectioned (New/This week/Earlier) notification feed, cursor-paginated, tap-to-deep-link, mark-all-read on open.

**Independent Test**: Seed entries of every type (grouped, null-target); open the Activity screen → sections render newest-first with grouping, unread accent, thumbnails/follow-back; scroll loads page 2; a null-target row is degraded/non-tappable; tapping routes to the right target; opening marks all read.

### Tests for User Story 1

- [ ] T025 [P] [US1] `NotificationsCubit` bloc tests in `test/features/notifications/notifications_cubit_test.dart` (drift-backed, real async `test()`): load → `loaded` with New/This week/Earlier sections (frozen clock); pagination (≥2 pages, `loadingMore`→`loaded`, `hasMore=false`); null-target degraded flag; mark-all-read on open resets the badge (SC-003); error→retry.
- [ ] T026 [P] [US1] `NotificationsPage` widget tests in `test/features/notifications/notifications_page_test.dart` (stub cubit, fixed 4-state): section headers, grouped row "and N others", unread accent, thumbnail vs follow-back row, empty state, error+retry; tall `surfaceSize`; fixed `pump(Duration)` (no real drift I/O).
- [ ] T027 [P] [US1] Goldens (light+dark) in `test/features/notifications/goldens/` — grouped row, single like row, follow-back row, empty state.

### Implementation for User Story 1

- [ ] T028 [P] [US1] `notifications_usecases.dart` in `lib/features/notifications/domain/usecases/` — `WatchFeed`, `LoadPage(cursor)`, `Refresh`, `MarkAllRead`, `SectionEntries(entries, clock)` (bucket by `updatedAt` → New/This week/Earlier). Inject use cases (not the repo) into the Cubit.
- [ ] T029 [US1] `NotificationsCubit` + `NotificationsState` (freezed 4-state over `PaginatedListCubit`) in `lib/features/notifications/presentation/cubit/` — `loaded(sections, hasMore, loadingMore, isOffline)`; watches drift `watchFeed()` (one source); `loadInitial`/`loadMore`/`refresh`/`markAllRead`; injectable clock for sectioning (frozen in tests).
- [ ] T030 [P] [US1] `notification_tile.dart` in `lib/features/notifications/presentation/widgets/` — actor avatar(s) + `Avatar` fallback (null avatarUrl), bold-actor summary text (per-type l10n + grouped), relative time, target thumbnail OR follow-back slot, unread accent; **degraded/non-tappable** when `target==null`.
- [ ] T031 [P] [US1] `notification_section_header.dart` in `lib/features/notifications/presentation/widgets/` — New / This week / Earlier.
- [ ] T032 [US1] `NotificationsPage` (Screen 29) in `lib/features/notifications/presentation/notifications_page.dart` — `TopBar` large "Activity"; sectioned `CustomScrollView`; pagination on scroll; **pull-to-refresh** (`RefreshIndicator` → `refresh`, FR-004); empty/loading/error-retry; **on open → `markAllRead`** (clears badge); centered max ~620 on tablet (`AppBreakpoints`). Page-scoped `BlocProvider`.
- [ ] T033 [US1] Tap deep-link in `notification_tile`/page → `context.push` via `core/router`: post/reel → post detail; comment/reply/mention(comment) → post detail focused on comment; follow/followAccepted/mention(user) → profile; validate before navigating (Constitution X). No cross-feature import (router only).
- [ ] T034 [US1] Entry point (phone): add the **Activity bell** to the Home header in `lib/core/presentation/` (Home top bar) — `AppIcon(notification)` in the tap area, `onTap → context.push(AppRoutes.notifications)`; register the `AppRoutes.notifications` route in `lib/core/router/app_router.dart` binding `NotificationsPage`. (Badge dot added in US3.)

**Checkpoint**: The Activity feed is fully usable — MVP shippable.

---

## Phase 4: User Story 2 - Push (Priority: P2)

**Goal**: Permission on first Activity open, device register/unregister, receive push, coarse deep-link on tap.

**Independent Test**: First Activity open → explainer → permission prompt; grant → device registered (`POST /devices`); deny → no register, no renag; logout → `DELETE /devices/:token`; a push tap routes coarsely (feed→Activity, message→Messages).

### Tests for User Story 2

- [ ] T035 [P] [US2] Push-gate + lifecycle tests in `test/features/notifications/push_permission_cubit_test.dart` + `test/core/services/push/` (FakePushService): first-open prompt once (asked-flag, no renag); grant → `RegisterDevice`; token rotation → re-register; logout → `UnregisterDevice` (idempotent); deny → no register.
- [ ] T036 [P] [US2] Coarse deep-link routing test — `emitTap({kind:'like',notificationId})` → Activity; `emitTap({kind:'message'})` → Messages; validated `kind`.

### Implementation for User Story 2

- [ ] T037 [P] [US2] `push_usecases.dart` in `lib/features/notifications/domain/usecases/` — `EnsurePushPermission` (first Activity open; reads/sets a `LocalFlags` "asked" bit), `RegisterDevice` (token → `POST /devices`), `UnregisterDevice` (`DELETE /devices/:token`), `RoutePushTap(PushTapData)` (coarse: message→Messages, else→Activity; validate).
- [ ] T038 [US2] `PushPermissionCubit` + state in `lib/features/notifications/presentation/cubit/` — drives explainer → `PushService.requestPermission()` → register on grant; exposes the "not granted" affordance state; no renag.
- [ ] T039 [P] [US2] `push_permission_prompt.dart` in `lib/features/notifications/presentation/widgets/` — value explainer sheet + the subtle "Turn on notifications" in-screen affordance (shown when not granted). Toast on outcome (no `ScaffoldMessenger`).
- [ ] T040 [US2] Wire the permission gate into `NotificationsPage` first-open (`EnsurePushPermission`) and subscribe `PushService.tokenStream` → `RegisterDevice`; wire `PushService.onNotificationTap` → `RoutePushTap` at app root (tap handling incl. `getInitialMessage` cold-start).
- [ ] T041 [US2] Extend `lib/core/services/session/session_controller.dart` — on logout/forced-logout → `PushService`/`UnregisterDevice` for the current token (idempotent), before token clear. (Cache clear already covered by T011's `clearUserScoped`.) No feature import — go through a small `core/services/push` hook or a DI-provided callback.

**Checkpoint**: Push registration + permission + coarse deep-link work (real receipt verified at cutover).

---

## Phase 5: User Story 3 - Unread badge (Priority: P2)

**Goal**: An unread badge on the Activity entry point (Home-header bell + SidebarRail item), driven by the one authoritative count, live-updating, clearing on open.

**Independent Test**: Set unread count → bell/rail badge shows it; emit `notification.new` → badge increments live; open Activity → badge clears.

### Tests for User Story 3

- [ ] T042 [P] [US3] `NotificationsBadge` tests in `test/core/services/notifications/notifications_badge_test.dart` — seeds from `fetchUnreadCount`; live `NotificationNew` bumps the stream; mark-all-read resets to 0; dedup live event does not double-bump (SC-004).

### Implementation for User Story 3

- [ ] T043 [US3] Wire the badge on the phone Home-header bell (`lib/core/presentation/` Home top bar) — `StreamBuilder` on `getIt`-guarded `NotificationsBadge.unreadCount` → rose `Badge` dot/count on the `AppIcon(notification)` (mirrors the messages-badge guard pattern).
- [ ] T044 [US3] Add the tablet SidebarRail **Notifications** first-class item + badge in `lib/core/router/adaptive_shell.dart` — new rail destination opening `AppRoutes.notifications`, badge from `NotificationsBadge` (mirror the existing `MessagingBadge` block). Phone bottom nav unchanged (Activity is not a tab).

**Checkpoint**: The ambient unread badge is live on phone + tablet.

---

## Phase 6: User Story 4 - Live in-app notifications (Priority: P3)

**Goal**: Live `notification.new` folds into the feed + badge silently (no banner); usable from cache when realtime is down.

**Independent Test**: With the feed open, emit a live event → new entry at top + badge bump, no banner; emit the same again → exactly once; drop realtime → renders from cache, reconciles on reconnect.

### Tests for User Story 4

- [ ] T045 [P] [US4] Live-fold tests in `test/core/services/realtime/notifications_realtime_service_test.dart` — `FakeRealtimeClient.emitInbound(NotificationNew(entry, unreadCount))` → drift upsert + badge bump; duplicate emit → one row, no double count (SC-004/FR-013); malformed payload skipped (no crash).
- [ ] T046 [P] [US4] Offline/reconnect test — feed renders from cache under `RtDisconnected`; reconciles on reconnect (SC-005).

### Implementation for User Story 4

- [ ] T047 [US4] Ensure the open `NotificationsCubit` reflects live folds — since `watchFeed()` is the one source, verify a live `NotificationNew` (folded by `NotificationsRealtimeService`) surfaces at the top without manual refresh and updates the badge; **no banner/toast** (Q4). Add the quiet offline affordance from `RealtimeConnectionManager.connectionState` (reuse the #012 pattern) to the Activity TopBar.

**Checkpoint**: Notifications feel live; the surface degrades gracefully offline.

---

## Phase 7: User Story 5 - Act on a notification (follow back) (Priority: P3)

**Goal**: Follow back a new follower inline; follow-request rows route to the profile (approval deferred to #014, Q1).

**Independent Test**: A follow row's inline control follows optimistically (rollback on failure, idempotent); a follow-request row deep-links to the requester's profile with no inline approve.

### Tests for User Story 5

- [ ] T048 [P] [US5] Follow-back tests in `test/features/notifications/follow_back_test.dart` — optimistic flip + rollback on failure + idempotent retry (reuses #010 toggle); follow-request row is route-only (no approve control).

### Implementation for User Story 5

- [ ] T049 [P] [US5] `FollowBack` use case in `lib/features/notifications/domain/usecases/notifications_usecases.dart` — delegates to the shipped `ProfileRepository` follow toggle (optimistic, idempotent). No new relationship code.
- [ ] T050 [US5] `follow_back_button.dart` in `lib/features/notifications/presentation/widgets/` — Follow / Following / Requested states (reuse the #010 follow button styling); wired into `notification_tile` for `follow`/`followAccepted` rows; `followRequest` renders route-only (tap → requester profile), **no approve/decline** (Q1).

**Checkpoint**: Follow-back works from the feed; request approval correctly deferred.

---

## Phase 8: User Story 6 - Inclusive & adaptive (Priority: P3)

**Goal**: Screen-reader labels, large text, light/dark, phone↔tablet reflow across the Activity surface.

**Independent Test**: Screen reader announces each row (actors/type/target/time) + each action; 2× text no clipping; light/dark correct; phone (Home-bell entry) vs tablet (SidebarRail, centered list) reflow.

### Tests / hardening for User Story 6

- [ ] T051 [P] [US6] a11y + text-scale + adaptive widget tests in `test/features/notifications/notifications_a11y_test.dart` — `Semantics` labels on rows/follow-back/bell; 2× `textScaler` no overflow; phone vs tablet layout (`AppBreakpoints`).
- [ ] T052 [P] [US6] Log-redaction test in `test/features/notifications/notifications_redaction_test.dart` — no push token, no private content across register/fold/tap paths; no `print`/`debugPrint`.
- [ ] T053 [US6] Add `Semantics` + text-scaling + light/dark polish to `notification_tile`/`section_header`/`follow_back_button`/`push_permission_prompt`/the Home-header bell + SidebarRail item; verify Reduce-Motion (no decorative loops).

**Checkpoint**: The surface is release-quality inclusive/adaptive.

---

## Phase 9: Polish & Cross-Cutting Concerns

- [ ] T054 [P] Run [quickstart.md](quickstart.md) fake-mode validation scenarios 1–12; fix any gaps.
- [ ] T055 Pre-commit gate: `dart format .`, `flutter analyze` (zero warnings bar the 2 pre-existing pubspec-sort infos), `flutter test` (all green incl. new #013 suites), `dart run bloc_tools:bloc lint .` (or note no local CLI).
- [ ] T056 [P] Sync project docs at merge — add the #013 changelog entry (`.claude/claude-app/changelog.md`), flip #013→✅ / #014→🟡 in `project-context.md` + `sdd-roadmap.md`, and record the cutover follow-ups (Firebase project + APNs key + `GoogleService-Info.plist`/`google-services.json` + on-device push receipt → #015; `RealNotificationsRepository` already source-reconciled to B#013).

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: no dependencies — start immediately. T001 (deps) before T002 (native gates need the plugins resolved) before T022 (build).
- **Foundational (Phase 2)**: depends on Setup — **BLOCKS all user stories**. Order: models (T007–T008) → drift (T009–T011) → repo/remote/fakes (T012–T015) → realtime fix+fold+badge (T016–T018) → push seam (T019–T021) → build (T022) → foundational tests (T023–T024).
- **US1 (Phase 3)**: after Foundational — MVP.
- **US2 (Phase 4)**: after Foundational; the permission gate hooks `NotificationsPage` first-open (soft dep on T032).
- **US3 (Phase 5)**: after Foundational (badge seam T018); wires into the US1 entry point (T034) + adaptive shell.
- **US4 (Phase 6)**: after Foundational (T017); verifies live behavior in the US1 feed.
- **US5 (Phase 7)**: after Foundational; wires into the US1 tile (T030).
- **US6 (Phase 8)**: after US1–US5 UI exists (hardens all).
- **Polish (Phase 9)**: after all desired stories.

### Within Each User Story

- Tests before implementation (repo gate); models before services before UI; deep-link/entry wiring after the page exists.

### Parallel Opportunities

- Setup: T003/T004/T005/T006 in parallel (after T001/T002).
- Foundational: T007/T008/T009 in parallel; T018/T019/T021 in parallel; T023/T024 in parallel.
- US1: T025/T026/T027 (tests) in parallel; T028/T030/T031 in parallel.
- Across stories once Foundational is done: US1/US2/US4/US5 are largely independent; US3 depends on the US1 entry point.

---

## Parallel Example: User Story 1

```bash
# Tests for US1 together:
Task: "NotificationsCubit bloc tests in test/features/notifications/notifications_cubit_test.dart"
Task: "NotificationsPage widget tests in test/features/notifications/notifications_page_test.dart"
Task: "Goldens in test/features/notifications/goldens/"

# Then parallel impl:
Task: "notifications_usecases.dart"
Task: "notification_tile.dart"
Task: "notification_section_header.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 only)

1. Phase 1 Setup → 2. Phase 2 Foundational (CRITICAL — blocks all) → 3. Phase 3 US1 → **STOP & VALIDATE** the Activity feed independently → demo.

### Incremental Delivery

Foundation → US1 (Activity feed, MVP) → US2 (push) → US3 (badge) → US4 (live) → US5 (follow-back) → US6 (inclusive/adaptive) → Polish. Each story adds value without breaking the previous.

---

## Notes

- **[P]** = different files, no dependency on an incomplete task.
- Backend B#013 is **source-verified** — the `env:['real']` impls bind the shipped endpoints/events; final smoke at dev-backend cutover.
- Real Firebase push receipt (foreground/background/killed) + credentials are **deferred to #015** (clarified Q2); automated fake-mode coverage is authoritative for merge.
- The #002 `notification.new` parser fix (T016) is the one contract reconciliation this branch needs — regression-locked by T024.
- Commit after each task or logical group; stop at any checkpoint to validate a story independently.
