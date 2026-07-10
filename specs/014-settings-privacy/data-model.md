# Data Model: Settings, Privacy & Safety (#014)

**Date**: 2026-07-10 · Phase 1 output. Client-side domain models + stores. All models are `@freezed` immutable (Constitution IV); JSON via generated (de)serialization on the DTOs (Constitution VIII). No new drift table (research D9) — persistence is device-scoped prefs (shared_preferences) + on-demand fetch + session in-memory stores.

---

## Domain models (new — `lib/core/data/settings/` unless noted)

### AccountSettings
The one-stop settings read model (mirrors backend `SettingsView`). Canonical in-memory copy fed by `GET /me/settings`, mutated optimistically on `PATCH`.

| Field | Type | Notes |
|---|---|---|
| isPrivate | `bool` | private-account flag (also on `MeProfile`) |
| activityStatusVisible | `bool` | reciprocal presence visibility (Q3) |
| twoFactorEnabled | `bool` | read-only here (toggled via `/me/2fa/*`; entry-only in #014) |
| closeFriendsCount | `int` | read-only convenience count |
| notifications | `NotificationPrefs` | on/off toggles only (granularity → future spec) |

### NotificationPrefs
Booleans matching backend `notifications{…}`: `likes, comments, mentions, follows, followRequests, directMessages, globalMute`. (`quietHours` object is out of scope for #014 UI — surfaced/ignored; keep the field nullable for round-trip fidelity.)

### FollowRequest (`lib/core/data/social/` or `.../profile/`)
An incoming pending request to follow the private-account owner.

| Field | Type | Notes |
|---|---|---|
| requester | `UserSummary` | avatar, name, username (existing #002/#010 model) |
| requestedAt | `DateTime` | for relative-time display |

State: a request is `pending` until Approve (→ becomes a follower; owner `followersCount += 1`) or Decline (→ removed, no count change). Optimistic; rollback on failure (FR-011). Idempotent (FR-012).

### ReportDraft (`lib/core/data/moderation/`)
Ephemeral (not cached). Fields: `targetType (ReportTargetType)`, `targetId (String)`, `reason (ReportReason)`. Submit → `ReportAck{accepted:true}` (surface-only).

- **ReportTargetType** enum: `post, reel, comment, story, user, message`.
- **ReportReason** enum (backend-aligned, research D2): `spam, nudityOrSexual, harassmentOrBullying, hateSpeech, violence, selfHarm, falseInformation, intellectualProperty, other`.

### CloseFriend (reuse `UserSummary`)
The close-friends list items are `UserSummary` (no new model). Membership add/remove is a mutation, not a stored entity on the client.

### AppPreferences (device-scoped — `lib/core/services/preferences/`)
Not from the API. Persisted via `shared_preferences` (survives logout, research D7).

| Field | Type | Values |
|---|---|---|
| themeMode | `ThemeMode` | light / dark / system (default system) |
| locale | `Locale?` | en / vi / null=system (default system) |

### AppInfo (About — via `package_info_plus`)
`appName`, `version`, `buildNumber` (read at runtime; not persisted).

---

## Canonical stores & reactive state

### RelationshipStore (REUSED, `lib/core/data/profile/relationship_store.dart`)
Existing session store keyed by userId holding `ViewerRelationship{following, requested, followsYou, blocking}`. #014 mutates it on:
- **Accept follow-request** → target's `following` set true where relevant (their edge to me), owner follower count via `FollowResult`.
- **Block** → `blocking=true`, `following=false`, `followsYou=false` (mutual sever, FR-015), `requested=false`.
- **Unblock** → `blocking=false` (does NOT restore follow, FR-016).

### BlockedUsersStore (NEW — core, `lib/core/data/moderation/blocked_users_store.dart`)
`@lazySingleton`, session-scoped, in-memory. The cross-feature seam (research D4).

- `Stream<Set<String>> get blockedIds`
- `bool isBlocked(String userId)`
- `void add(String userId)` / `void remove(String userId)` (optimistic; caller rolls back on failure)
- `void clear()` — called from `SessionController._clearSession()` on logout (FR-033)

Consumers (feed, search, messaging, notifications) filter authors reactively against `blockedIds` so blocked content vanishes in-session (FR-014). No cross-feature import — features depend on this core store.

### AppSettingsCubit (NEW — `lib/features/settings/presentation/cubit/` or core)
`@lazySingleton` app-level. Holds `{ThemeMode, Locale?}` sourced from `AppPreferences`; `We36App` reads it to drive `MaterialApp.router` `themeMode:`/`locale:`. Simple emitting cubit (not the 4-state async pattern — no fetch), setters persist to `AppPreferences`.

---

## Cubits (feature — `lib/features/settings/presentation/cubit/`)

All feature cubits use the mandatory 4-state pattern (Constitution III): `initial → loading → loaded(data) → error(failure)`, extended variants prefixed (`loadedSubmitting`, `loadedPaginating`).

| Cubit | Loads | Mutations |
|---|---|---|
| `SettingsCubit` | `GET /me/settings` → `AccountSettings` | toggle private / activity-status / notification prefs (optimistic PATCH + rollback) |
| `FollowRequestsCubit` | `GET /me/follow-requests` (paginated) | accept / decline (optimistic, updates RelationshipStore) |
| `BlockedAccountsCubit` | `GET /me/blocks` *(pending B#014)* / fake | unblock (optimistic) |
| `CloseFriendsCubit` | `GET /me/close-friends` (paginated) | add / remove (optimistic; add guarded "must follow you") |
| `ReportCubit` | — | submit report → ack (surface-only) |
| `AppSettingsCubit` | `AppPreferences` (theme/locale) | set theme / set locale (persist) |

`ReportSheet` may be stateless-with-a-tiny-cubit or a lightweight submit; kept minimal.

---

## DTOs & mappers (`.../data/**/dto/`)

One DTO per wire shape with generated `fromJson`/`toJson`, mapped to the domain model (never `dynamic`-dug at call sites, Constitution IV):
`SettingsViewDto`, `FollowRequestDto` (+ `FollowRequestPageDto`), `RelationshipStateDto` (→ existing `ViewerRelationship`), `ReportCreateDto` + `ReportAckDto`, `UserSummaryDto` (reuse), `MeProfileDto` (reuse for `isPrivate` write via `PATCH /me`).

---

## Validation & failure mapping (Constitution V)

- Add close friend when target doesn't follow you → backend `VALIDATION` → friendly message ("They need to follow you first").
- Approve/decline a vanished request → `NOT_FOUND` → silently reconcile (remove row), per Edge Cases.
- Block/unblock/report offline → `offline`/`networkError` → optimistic rollback + toast.
- Report on deleted target → backend graceful ack (202) → show acknowledgement anyway.
- All mapped through the central `FailureMapper` → `AppFailure`; user text localized (EN+VI).

---

## Logout wipe (FR-033)

Added to `SessionController._clearSession()`: `_blockedUsers.clear()` (+ any new session store). **Exempt**: `AppPreferences` (theme/locale) — device-scoped, survives logout (like `onboardingSeen`).
