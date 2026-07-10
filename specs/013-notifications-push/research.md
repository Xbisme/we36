# Phase 0 Research — Notifications & Push (#013)

All NEEDS CLARIFICATION resolved. Decisions the plan/tasks depend on. Package versions sourced from pub.dev at plan time (Constitution XV); backend shapes source-verified against `backend/src/modules/notifications` + `backend/src/jobs`.

---

## R1 — Push dependencies & versions (Constitution XV)

**Decision**: Add three new pub dependencies, caret-pinned to the latest stable sourced from pub.dev on 2026-07-08:

| Package | Version | Role |
|---|---|---|
| `firebase_core` | `^4.11.0` | Required host for any FlutterFire plugin; `Firebase.initializeApp()`. |
| `firebase_messaging` | `^16.4.1` | FCM (Android) / APNs (iOS) token + inbound message transport (Constitution VII/Technical Standards). |
| `flutter_local_notifications` | `^22.0.1` | Present a notification while the app is foregrounded (FCM does not auto-display foreground messages) + any local/channel setup. |

**Rationale**: `firebase_messaging` is the canonical FCM/APNs transport the constitution names; `firebase_core` is its mandatory host; `flutter_local_notifications` covers foreground presentation the OS suppresses. All three are isolated behind the `PushService` seam (R4) so they never enter the fake/test graph.

**Alternatives considered**: pure-Dart push (none exists for FCM/APNs); socket-only "notifications" (rejected — cannot wake a backgrounded/killed app, which is the entire point of US2).

**Note**: `firebase_messaging` did not expose min-platform in the pub.dev summary; verify the exact minimums from the installed `pubspec.yaml` during T001 (`flutter pub get` then inspect). See R2 for the native gates that are already known to bite.

---

## R2 — Native platform gates (verify at T001/T002, before Dart)

**Decision**: This branch bumps native config but **defers credential provisioning** to cutover/#015 (clarified Q2). Gates to clear so the project still compiles:

- **iOS deployment target**: currently `IPHONEOS_DEPLOYMENT_TARGET = 13.0` (set at #003). Current FlutterFire (`firebase_core 4.x` / `firebase_messaging 16.x`) drops iOS 13/14 — **bump to iOS 15.0** in `Runner.xcodeproj` + `ios/Podfile` `platform :ios, '15.0'`. Add the **Push Notifications** capability + `remote-notification` background mode + APNs entitlement (entitlement file already exists from #003 Sign in with Apple).
- **Android**: `flutter_local_notifications 22.x` requires **compileSdk 35, Java 17, AGP 8.11.1+**. The app uses `compileSdk = flutter.compileSdkVersion` (Flutter 3.44 → 35 ✓) and `minSdk = maxOf(24, …)` (Firebase needs ≥23 ✓). **Verify** the module `compileOptions`/`kotlinOptions` are Java 17 and the root AGP is ≥8.11.1; add the `com.google.gms.google-services` plugin (applied at cutover with `google-services.json`).
- **Firebase init guard**: `Firebase.initializeApp()` throws without a platform options file. The **real `PushService` binding must guard init on config presence** and is only constructed in `env:['real']`; the app's current `env:'fake'` run (and all tests) use `FakePushService` and **never initialize Firebase**, so the branch stays green with no credentials committed.

**Rationale**: Constitution XV mandates verifying native mins for push plugins at plan time — a wrong iOS target or missing compileSdk surfaces only at `pod install`/Gradle after the Dart is written.

**Alternatives considered**: committing placeholder Firebase config (rejected — risks a partially-real init path in fake mode; the seam + env split is cleaner and matches #003's OAuth/secure-storage pattern).

---

## R3 — Realtime `notification.new` payload + the #002 parser fix

**Decision**: Correct the shipped scaffold to the **source-verified** payload. The backend emits (`notification-fanout.processor.ts` → `RealtimePublisher.emitToUsers([recipientId], 'notification.new', payload)`):

```jsonc
{ "entry": { /* full NotificationEntryDto */ }, "unreadCount": 7 }
```

The #002 parser (`realtime_event.dart`) currently does `NotificationNew(data['notification'] ?? {})` — there is **no** `notification` key, so it would always fold `{}`. #013 changes the parse to `NotificationNew(entry: (data['entry'] as Map).cast(), unreadCount: data['unreadCount'] as int? ?? 0)` and widens the `NotificationNew` event accordingly. `NotificationsRealtimeService` (R5) then upserts `entry` into the drift cache (dedupe by `entry.id`) and pushes `unreadCount` to the badge seam.

**Rationale**: #012 established the pattern of reconciling the inert #002 socket scaffold against real backend source at the point of first live use, rather than trusting the guessed scaffold shape. This is the single typed parse point, so the fix is contained.

**Alternatives considered**: a mapping shim in the service (rejected — hides a real contract mismatch at the wrong layer; the parser is the one place event shapes belong).

---

## R4 — Push seam design (`PushService`, real + fake)

**Decision**: An abstract `PushService` in `core/services/push/`:

```
abstract class PushService {
  Future<PushPermissionStatus> requestPermission();   // notDetermined/granted/denied
  Future<PushPermissionStatus> currentStatus();
  Stream<String> get tokenStream;                      // FCM/APNs token + rotations (register via REST)
  Stream<PushTapData> get onNotificationTap;           // {kind, notificationId?} → coarse deep-link
  Stream<PushForegroundData> get onForegroundMessage;  // presented via flutter_local_notifications
}
```

- `FirebasePushService` (`env:['real']`) wraps `firebase_messaging` (permission, `onTokenRefresh`, `onMessage`/`onMessageOpenedApp`, `getInitialMessage`) + `flutter_local_notifications` for foreground display; init guarded on config presence (R2).
- `FakePushService` (`env:['fake']`) exposes controllable seams (`emitToken`, `emitTap`, `scriptPermission`) for tests — zero network, no Firebase.

Device register/unregister is **REST**, not the push SDK: the `tokenStream` feeds `RegisterDevice` (`POST /devices`), and `SessionController` calls `UnregisterDevice` (`DELETE /devices/:token`) on logout.

**Rationale**: Mirrors the #002/#003 seam pattern (real impl behind `env:['real']`, fake drives hermetic tests). Keeps Cubits/widgets off Firebase (Constitution VIII spirit — one transport behind a repo/service).

**Alternatives considered**: calling `firebase_messaging` directly from a Cubit (rejected — untestable without Firebase, violates the seam discipline).

---

## R5 — Realtime service, badge seam, and unread-count source of truth

**Decision**: A new `@lazySingleton NotificationsRealtimeService` (mirrors `MessagingRealtimeService`) is the **sole** `RealtimeClient.events` subscriber for `NotificationNew`: it upserts `entry` into the `Notifications` drift cache (dedupe by id → exactly once, SC-004/FR-013) and pushes `unreadCount` onto the badge. A new `@lazySingleton NotificationsBadge` (mirrors `MessagingBadge`) exposes `Stream<int> unreadCount` for the Home-header bell + SidebarRail — a **core→core** read so `core/presentation` never imports `features/notifications`.

**Unread count = server-owned**: read state is a single server `lastReadAt` marker (not per-row), so the client does **not** recompute the count from cached rows. The badge streams the last-known count, updated by (a) `GET /notifications/unread-count` on load/refresh, (b) `unreadCount` on each `notification.new`, and (c) reset to 0 optimistically on mark-all-read (open). The count is held in a tiny in-memory store in the service (not persisted; re-fetched on launch).

**Rationale**: One canonical cache + a core→core badge seam is the shipped #012 pattern; deriving the count server-side avoids client/server drift given the marker-based read model.

**Alternatives considered**: computing unread from `isRead` rows (rejected — `isRead` is per-entry-vs-marker, and a mark-all-read advances the marker without rewriting rows, so a client count would drift).

---

## R6 — Activity entry point, badge placement & sectioning

**Decision** (from `ui-design-context.md`): Activity is **not** a bottom-nav tab. On **phone** it is the **Home-header bell** (top-right, beside the Messages icon) → pushes a nav-less `NotificationsPage`; the unread **badge is a rose dot/count on the bell**. On **tablet/iPad (≥700)** it is a **first-class SidebarRail item** ("Notifications", added to the rail alongside Create), badge on the rail item; the list is centered max ~620 (design §Responsive TabletNotifications).

**Sectioning** (clarified Q5): **New (today) / This week (last 7 days) / Earlier**, newest-first within each; the design labels "New / This week" are extended with "Earlier" for older items. Bucketing uses an **injectable clock** (frozen in tests — the post-#10 time-bomb learning). Unread rows carry an accent driven by server `isRead` (independent of the time bucket).

**Rationale**: Matches the imported design + the roadmap "New / This week"; the badge seam already has a proven home in `adaptive_shell.dart` (messages badge) to mirror.

**Alternatives considered**: adding Activity as a 6th bottom tab (rejected — violates the fixed 5-tab IA, Constitution VI/X).

---

## R7 — Permission gate & coarse deep-link

**Decision**:
- **Permission** (clarified Q3): request on **first Activity-screen open** — a value explainer (`push_permission_prompt`) then the system prompt via `PushService.requestPermission()`. If denied/skipped, **no renag**; re-offer only via a subtle in-screen affordance. A local flag (reuse the `LocalFlags`/`shared_preferences` seam) records "asked" so it fires once.
- **Deep-link** (clarified; backend limit): push `data = {kind, notificationId?}` and there is **no `GET /notifications/:id`**, so a **cold push tap** routes coarsely — `kind == 'message'` → Messages; any feed kind → the Activity screen. **In-app** `notification.new` entries carry the full `entry`, so tapping a **row** deep-links precisely (post/reel/comment → post detail; follow/mention-user → profile) via `core/router`. `RoutePushTap` validates `kind` before navigating (Constitution X).

**Rationale**: Honors the verified backend contract (thin push payload, no by-id fetch) without inventing a lookup; matches Principle I's contextual-permission rule.

**Alternatives considered**: precise cold-push deep-link (rejected — would require a backend `GET /notifications/:id` that does not exist; deferred until the backend adds it).

---

## R8 — Follow-back reuse & scope guards

**Decision**: The follow-back / follow-request rows reuse the shipped **#010** `ProfileRepository` follow toggle via a `FollowBack` use case (optimistic + rollback, idempotent) — no new relationship code. Per clarified Q1, **follow-request approval is deferred to #014**: a "requested to follow you" row renders + deep-links to the requester's profile, with **no inline approve/decline**. Per the spec, **notification-preference UI is out of scope** (server-enforced; #014).

**Rationale**: Additive reuse keeps #013 scoped; both boundaries were locked in `/speckit.clarify`.

**Alternatives considered**: inline approve (rejected at Q1); client preference UI (out of scope).
