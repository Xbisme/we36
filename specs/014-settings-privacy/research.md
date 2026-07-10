# Research: Settings, Privacy & Safety (#014)

**Date**: 2026-07-10 · **Branch**: `014-settings-privacy`

Phase 0 output. Every open decision from the spec/Technical Context resolved below, plus the client-seam and backend-contract findings that shape the plan. Backend facts are **source-verified** against `backend/src/modules/...` + `backend/prisma/schema.prisma` (not derived) — consistent with the B#012/#013 reconcile discipline.

---

## D1 — Backend is already complete for this surface (bind, don't build a contract)

**Decision**: Treat #014 as a **contract-driven client** over the existing backend settings/privacy/safety modules. The client repositories bind to real, shipped endpoints; the app keeps running DI `environment: 'fake'` (zero-network) for hermetic tests, with `env:['real']` impls source-reconciled now.

**Rationale**: The backend implements a one-stop settings model plus follow-requests, block/unblock, report, close-friends, activity-status, 2FA, and data-export. Only one read endpoint is missing (D5).

**Key endpoints (all under `/v1`, bearer auth, error envelope `{error:{code,message,details}}`, cursor envelope `{items,nextCursor,hasMore}`):**

| Capability | Endpoint | Shape |
|---|---|---|
| Read settings | `GET /me/settings` | `SettingsView` (isPrivate, activityStatusVisible, twoFactorEnabled, closeFriendsCount, notifications{…}) |
| Update settings | `PATCH /me/settings` | partial `{isPrivate?, activityStatusVisible?, notifications?}` → `SettingsView` |
| Private toggle (also) | `PATCH /me` | `{isPrivate}` → `MeProfileDto` (delegates to same source of truth) |
| List follow-requests | `GET /me/follow-requests` | items `FollowRequestDto{requester:UserSummary, requestedAt}` |
| Accept request | `POST /me/follow-requests/:userId/accept` | → `RelationshipStateDto` |
| Reject request | `POST /me/follow-requests/:userId/reject` | 204 |
| Block | `POST /users/:id/block` | → `RelationshipStateDto` |
| Unblock | `DELETE /users/:id/block` | → `RelationshipStateDto` |
| Report | `POST /reports` (202) | `{targetType, targetId, reason, note?}` → `{accepted:true}` |
| Close friends list | `GET /me/close-friends` | items `UserSummaryDto` |
| Add close friend | `POST /me/close-friends/:userId` | 204 (guard: target must follow you) |
| Remove close friend | `DELETE /me/close-friends/:userId` | 204 |

`RelationshipStateDto = {following, requested, followsYou, blocking}` — the same shape the client already models as `ViewerRelationship`.

**Alternatives considered**: Deriving a provisional contract (as #012 did before reconcile) — rejected because the real source is present and verifiable now, so we bind to truth directly.

---

## D2 — Report reason enum: reconcile the client to backend truth

**Decision**: The client report-reason set MUST match the backend `ReportReason` enum exactly: `spam · nudityOrSexual · harassmentOrBullying · hateSpeech · violence · selfHarm · falseInformation · intellectualProperty · other`. `ReportTargetType` = `post · reel · comment · story · user · message`.

**Rationale**: The clarify session (Q4) locked "fixed set, no free-text" but proposed "Scam/fraud"; the backend has no `scam/fraud` value and does have `intellectualProperty`. Sending an unknown enum would fail validation. Spec **FR-019 updated** to the backend set.

**Alternatives**: Keep the spec's wording and map at the edge — rejected; a client reason with no backend value is unshippable.

---

## D3 — Follow-request inbox is new client work (no client model exists)

**Decision**: Build a new `FollowRequestsRepository` (real+fake) + a `FollowRequests` cubit + inbox page. Accept/decline are optimistic; on accept, update the canonical `RelationshipStore` and the owner's follower count.

**Rationale**: Client seam scan found **no incoming-request model** — only the outbound `ViewerRelationship.requested` bool (viewer-side "I requested to follow them"). The owner-side inbox is entirely unbuilt, though the backend endpoints exist.

**Idempotency**: accept/reject carry an Idempotency-Key header (existing interceptor); a retried accept yields exactly one follower (FR-012, backend is idempotent too).

---

## D4 — Blocking: reuse `RelationshipStore.blocking`; hide content via a new core `BlockedUsersStore`

**Decision**:
- Block/unblock through a new `BlockRepository` (real+fake). On success, optimistically flip `ViewerRelationship.blocking` in the canonical `RelationshipStore` and **sever the follow both ways** locally (matches backend `blockTx`).
- Introduce a **core session-scoped `BlockedUsersStore`** (`@lazySingleton`, in-memory, reactive `Stream<Set<String>>`, `clear()` on logout) as the cross-feature seam. Feed / search / messaging / notifications read it to **filter blocked authors reactively** so content vanishes in-session without a reload (FR-014), honoring Constitution XI (no cross-feature imports — features depend on a core store, not on `features/settings`).
- On block, also purge already-cached rows for that author from the relevant caches where cheap (e.g. conversation list), so the UI updates immediately.

**Rationale**: FR-014 requires blocked content to disappear immediately across surfaces already shipped. A single core store that every feature filters against is the one-canonical-representation approach (Constitution IX) and avoids each feature re-implementing block logic.

**Alternatives**: Purge-and-refetch every cache on block — rejected (heavier, flickers, needs network). Per-feature block checks — rejected (cross-feature coupling, drift).

---

## D5 — Blocked-accounts list: backend GAP → fake-complete now, flag `GET /me/blocks` for B#014 cutover

**Decision**: Build the "Blocked accounts" management screen (FR-016) fully against the **fake** repository. The **real** `BlockRepository.listBlocked()` binds to a **`GET /me/blocks` endpoint that does not yet exist** — record it as a **required backend addition (B#014 deviation)**, exactly as prior specs recorded backend deviations for cutover (#011 set-cover, #012 shapes). Since the app ships in fake mode, this binds only at real-backend cutover.

**Rationale**: Block/unblock **writes** exist; there is **no list-blocked read**. Rather than scope out the management screen, we build it against the fake and gate the real read behind a documented pending endpoint.

**Alternatives**: (a) Scope out the blocked-list screen — rejected (FR-016 wants unblock management; poor UX to block with no way to review). (b) Reconstruct the list client-side from observed `blocking` flags — rejected (not authoritative). Flagging a backend addition is the honest, contract-driven choice.

---

## D6 — Activity status: one `SettingsRepository` write + reciprocal UI gate

**Decision**: The activity-status toggle writes `activityStatusVisible` via `PATCH /me/settings`. The client reflects the **reciprocal** rule (Q3): while off, suppress the user's own presence emission intent AND hide others' active-now/typing in the messaging surfaces (active-now rail, green dots, typing indicators, chat-header presence).

**Rationale**: The backend already enforces reciprocity (`ActivityStatusService.canView` requires *both* parties visible; `filterViewers` gates fan-out; conversation DTO returns `{online:false}` when not viewable). The client mainly needs to (a) own the toggle, (b) optimistically suppress locally for instant feedback so the setting feels immediate even before the next presence frame.

**Alternatives**: Pure client-side gate with no backend write — rejected (non-persistent, not honored across devices).

---

## D7 — Language & Theme: device-scoped prefs via a new `AppPreferences` seam + app-level listenable

**Decision**:
- Add device-scoped persistence for `ThemeMode` (light/dark/system) and `Locale` (en/vi/system) by extending the existing `shared_preferences` seam (`LocalFlags` pattern) into an `AppPreferences` service (`@LazySingleton(as: AppPreferences)`), keys additive to the existing non-secret flags.
- Introduce an app-level `AppSettingsCubit` (`@lazySingleton`, 4-state not required — it holds `{ThemeMode, Locale?}` and is a simple `Cubit`/`ChangeNotifier`) that `We36App` reads to drive `MaterialApp.router`'s `themeMode:` and `locale:`. `We36App` becomes stateful/provider-wrapped (today it is a `StatelessWidget` with both hardcoded to system).
- These prefs are **exempt from the logout wipe** (FR-027/FR-033) — they live beside `onboardingSeen`, which already survives logout.

**Rationale**: No `ThemeCubit` or persisted theme/locale exists today. The `LocalFlags`/`SharedPreferencesAsync` pattern is the established device-scoped-preference seam and already models "survives logout".

**Alternatives**: Account-scoped/server-synced prefs — rejected by Q5 (device-scoped). A full settings-in-drift table — rejected (YAGNI; prefs are a couple of scalars).

---

## D8 — Close friends: new `CloseFriendsRepository`, no drift table

**Decision**: Build a `CloseFriendsRepository` (real+fake) binding `GET/POST/DELETE /me/close-friends`. Add/remove idempotent; add guarded by "must follow you" (surface the backend `VALIDATION` failure as a friendly message). Membership is fetched on demand (cursor list) — **no persistence/drift table**; a session-scoped in-memory reflection is enough for the management screen and for the stories audience already shipped (`StoryAudience.closeFriends`).

**Rationale**: Backend owns the authoritative list; the screen is opened on demand and does not need offline cold-start. Matches the #010 relationship_store choice (no drift change).

---

## D9 — No drift schema change (stays v10)

**Decision**: **No new drift table**; `AppDatabase.schemaVersion` stays **10**. All new #014 state (settings view, follow-requests, blocked set, close-friends) is either fetched on demand or held in session-scoped in-memory stores cleared on logout via `SessionController._clearSession()`.

**Rationale**: None of these lists need instant offline cold-start; persisting them would add a migration for no user-visible benefit (Constitution XIII YAGNI). This mirrors #010 (relationship state in-memory, drift unchanged). Logout-clearing is handled by adding `BlockedUsersStore.clear()` (and any other new session store) to the existing `_clearSession()` list — the exact hook #012/#013 used.

**Alternatives**: A `Settings`/`Blocks` drift table (v10→v11) — rejected; no offline requirement, and device prefs (theme/locale) live in shared_preferences not drift.

---

## D10 — 2FA & download-your-data stay entry-only (client scope), despite backend readiness

**Decision**: Ship **entry-point screens only** for Two-factor authentication and Download-your-data (FR-029), per spec Out-of-Scope. Note in the plan that the backend fully supports both (`/me/2fa/*`, `/me/export`, `DELETE /me`) so a later spec can wire the full flows without backend work.

**Rationale**: Spec explicitly scopes these as entry-only; Constitution XIII (YAGNI) says don't build beyond the spec. Recording backend readiness prevents a future "is the backend there?" investigation.

---

## D11 — New dependency: `package_info_plus` only

**Decision**: Add **`package_info_plus`** (About → app name/version/build). Pin the latest stable caret constraint from pub.dev at implementation T001 (Constitution XV). `shared_preferences` is already in the tree (#003). **`in_app_review` is NOT added** — the About surface shows version/links only; no "rate us" entry is in scope (YAGNI; defer to #015 if ever wanted).

**Rationale**: Only genuine new capability is reading the app version/build. `package_info_plus` is the FlutterCommunity standard; low native footprint (no new permissions/entitlements). Verify latest version + platform mins at T001 before editing `pubspec.yaml`.

**Alternatives**: Hand-roll a generated version constant — rejected (drifts from the real build number).

---

## Reused seams (no rework)

- **`RelationshipStore`** (`lib/core/data/profile/relationship_store.dart`) — canonical `ViewerRelationship{following,requested,followsYou,blocking}`; `apply()` optimistic + rollback; `clear()` on logout. Reused for accept-request and block.
- **`ProfileRepository.follow/unfollow`** + `FollowResult{relationship,followersCount}` — the optimistic-toggle precedent for accept/decline.
- **Messaging presence/typing** (`MessagingRealtimeService.presence/typing`, `active_now_rail`, `conversation_tile`, chat header) — the surfaces an activity-status toggle gates.
- **`StoryAudience.closeFriends`** (#005) — the consumer of the close-friends list this spec manages.
- **`SessionController._clearSession()`** — the ordered logout side-effect list; add new session-store `.clear()` calls here (pattern set by #012 realtime disconnect + #013 push unregister).
- **`LocalFlags`/`SharedPreferencesAsync`** (`local_flags.dart`) — device-scoped preference seam extended for theme/locale.
- **Shared widgets**: `AppSwitch`, `showAppActionSheet`/`ActionSheetItem`, `showAppDialog`, `Pressable`, `AppButton(danger)`, `AppIconButton`, `ToastService`, `Avatar`, `TopBar`, `MaxWidthBox` (tablet centering). Build a small `SettingsRow` + `SettingsSectionHeader` (none exists) composed from these.
- **Surface-only stubs to wire real**: profile more-sheet block/report toasts (`user_profile_page.dart:83`), reel more-sheet report (`reel_more_sheet.dart`), comment report endpoint. #014 replaces the toasts with real repository calls.
- **Router**: `AppRoutes.settings = '/settings'` already declared and wired to a `PlaceholderPage`; entry is the profile gear (`my_profile_page.dart:215`). #014 swaps the placeholder for the real settings page and adds child routes (block list, close friends, privacy, 2FA-entry, etc.).
- **DI env pattern**: `@LazySingleton(as: X, env: ['real'])` + `@LazySingleton(as: X, env: ['fake'])`; run build_runner after adding.

## Open items carried to /speckit.tasks

- Confirm `package_info_plus` latest stable + platform mins at T001 (Constitution XV).
- Record **B#014 backend addition: `GET /me/blocks`** in `contracts/` for real-backend cutover (D5).
- Decide the exact child-route set under `/settings` at design (block-list, close-friends, privacy&security, report is a modal not a route).
