# Quickstart / Validation — Notifications & Push (#013)

How to prove #013 works end-to-end. The app runs DI `environment: 'fake'` (zero-network, **no Firebase**) for all automated validation; `env:'real'` binds the shipped B#013 endpoints/events at cutover. Implementation lives in `tasks.md`; this is the run/validation guide.

## Prerequisites
- Repo baseline: Flutter 3.44.4 / Dart 3.12.2.
- `flutter pub get` after T001 adds `firebase_core ^4.11.0`, `firebase_messaging ^16.4.1`, `flutter_local_notifications ^22.0.1`.
- Native gates cleared (T002, compiles without credentials): iOS target 15, Android compileSdk 35 / Java 17 / AGP 8.11.1+. `GoogleService-Info.plist` / `google-services.json` are **NOT** committed — real on-device push is verified at cutover/#015.

## Gate (must pass before commit — Constitution)
```bash
dart format .
flutter analyze                  # zero warnings (bar the 2 pre-existing pubspec-sort infos)
flutter test                     # all pass, incl. the new #013 suites
dart run bloc_tools:bloc lint .  # zero violations (no local CLI — see follow-ups)
```

## Automated validation scenarios (fake mode — authoritative)

1. **Activity feed renders grouped, sectioned, newest-first** (US1 / SC-001, SC-002)
   - Seed the fake repo with entries of every `NotificationType` incl. a grouped like (`actorCount>1`), a comment, a follow, and one with `target == null`.
   - `test()` (real async, drift-backed): `NotificationsCubit` loads → `loaded` with sections **New / This week / Earlier** (clock frozen), grouped row shows "and N others", the null-target entry is present and flagged degraded.
   - Widget (stub cubit, fixed 4-state): `NotificationsPage` shows section headers, unread accent on unread rows, a follow-back button on the follow row, a thumbnail on the like row. Golden: grouped row, follow-back row, empty state (light+dark).

2. **Pagination** (US1 / FR-004): fake yields ≥2 keyset pages; scrolling loads page 2 via `PaginatedListCubit` (`loadingMore` → `loaded`, `hasMore=false` at end). No deadlock (drift-backed assertion in `test()`, not `testWidgets`).

3. **Mark-all-read clears the badge** (US1/US3 / SC-003): open the feed → `POST /notifications/read` (fake) → `NotificationsBadge.unreadCount` emits 0; re-open → stays 0 until a new event.

4. **Live `notification.new` folds once** (US4 / SC-004, FR-013): `FakeRealtimeClient.emitInbound(NotificationNew(entry, unreadCount:5))` → new entry at top of `watchFeed()`, badge → 5, **no banner/toast**. Emit the **same** entry again → still one row, count not double-bumped (exactly once).

5. **Offline / realtime down** (US4 / SC-005): with the feed cached, force `RtDisconnected` → feed still renders from drift + last-known count; reconnect → reconciles, no crash.

6. **Push permission gate** (US2 / FR-014, FR-019): first `NotificationsPage` open → explainer → `PushService.requestPermission()`. `FakePushService.scriptPermission(granted)` → `RegisterDevice` called (`POST /devices`). Script `denied` → no register, no renag on re-open; the subtle affordance is present.

7. **Device register/unregister lifecycle** (US2 / SC-006): on auth with permission granted, `SessionController` registers the fake token; on logout, `DELETE /devices/:token` is called (idempotent) and the notifications cache is cleared (`clearUserScoped`).

8. **Coarse push deep-link** (US5 / FR-018): `FakePushService.emitTap({kind:'like', notificationId})` → routes to Activity; `emitTap({kind:'message'})` → routes to Messages. In-app row tap (full entry) → post detail / profile precisely.

9. **Follow-back optimistic** (US5 / FR-020): tap follow-back on a follow row → instant flip (reuses #010 toggle), rollback on scripted failure, idempotent retry → exactly one follow.

10. **Log redaction** (FR-023 / SC-007): assert no push token and no private content reach `AppLogger` across register, fold, and tap paths.

11. **Inclusive & adaptive** (US6 / SC-009): screen-reader labels on rows/actions; 2× text scale no clipping; light/dark; phone (Home-header bell entry) vs tablet (SidebarRail item, centered list) reflow.

12. **Migration** (FR-025 / Constitution IX): drift v9 → v10 additive migration test green; `clearUserScoped` wipes `Notifications`.

## Manual / on-device (deferred to cutover / #015 — not gating)
Real FCM/APNs receipt on a device (foreground + background + killed), notification tap cold-start deep-link, and permission dialogs with real credentials — verified when the Firebase project + APNs key + native config land. Automated fake-mode coverage above is authoritative for the merge.
