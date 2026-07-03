# Phase 1 Data Model: Profile & Follow (#010)

Client-side domain models for `core/data/profile/` (+ the reused shipped models). All are freezed; DTOs deserialize from the B#010 envelope (`contracts/profile-api.md`). **No drift table is added** — the canonical relationship is the in-memory `RelationshipStore`; my-profile identity uses the existing `MeProfiles` cache.

## Reused (shipped — unchanged)

| Model | Source | Role in #010 |
|---|---|---|
| `MeProfile` | `core/data/me` (#003) | Editable identity for Edit profile: `displayName`, `username`, `avatarMediaId`, `bio`, `website`, `pronouns`, `isPrivate`. Cached in `MeProfiles`; header identity via `watchMe()`. |
| `User` | `core/data/user` (#002) | Public account: `id`, `username`, `displayName`, `isPrivate`, `isVerified`, `followersCount`, `followingCount`, `postsCount`, `avatarUrl?`, `bio?`. Wrapped by `ProfileView`. |
| `UserSummary` | `core/data/feed` (#004) | Lightweight author (`id`, `username`, `displayName`, `avatarUrl`, `isVerified`) — used in `AccountRow`. |
| `ViewerRelationship` | `core/data/discovery` (#009) | `following`, `requested`, `followsYou`, `blocking` + `FollowLabel` (`follow`/`following`/`requested`). **The follow entity #010 mutates.** |
| `ExploreItem` | `core/data/discovery` (#009) | Kind-tagged `Post`\|`Reel` — the Posts/Tagged grid cell (reels marked). |
| `CursorPage<T>` | `core/domain` (#002) | Envelope for followers/following + posts/tagged grids. |

## New models (`core/data/profile/`)

### ProfileView

The full render model for one profile (my own or another's), joining identity + counts + the viewer's relationship + server gating.

| Field | Type | Notes |
|---|---|---|
| `user` | `User` | Identity + counts (posts/followers/following). |
| `relationship` | `ViewerRelationship` | The viewer↔account state (drives the Follow control + "Follows you"). For `isMe` it is a self-relationship (no follow control). |
| `isMe` | `bool` | True when this is the signed-in person's own profile (renders Edit profile instead of Follow). |
| `gated` | `bool` | Server-authoritative: true when the content grid + connection lists must be gated ("This account is private"). Never client-derived (R6). |

- **Derivations**: `showFollowControl => !isMe`; `showPrivateGate => gated`; `canOpenConnections => !gated`.
- **Validation**: exactly one identity; counts are non-negative; `gated` implies the grids/lists are not rendered regardless of any cached items.

### AccountRow

One entry in a followers/following list (and reusable for any account list).

| Field | Type | Notes |
|---|---|---|
| `user` | `UserSummary` | Avatar + name/handle + verification. |
| `relationship` | `ViewerRelationship` | Drives the row's Follow/Following control (read-write; same optimistic path as the profile). |

- **Validation**: blocked accounts are never present (server-filtered — FR-016); the viewer's own row never renders a follow control.

### RelationshipStore (in-memory, not a model)

`@lazySingleton` canonical holder — `Map<String userId, ViewerRelationship>` + a per-key broadcast stream.

| Method | Behavior |
|---|---|
| `watch(userId) → Stream<ViewerRelationship?>` | Reactive read; emits current + on every change. |
| `seed(userId, rel)` | Populate/replace from a fetched `ProfileView` / `AccountRow`. |
| `apply(userId, ViewerRelationship Function(ViewerRelationship)) ` | Optimistic mutate (follow/unfollow/withdraw) + notify watchers; used for the rollback too. |
| `clear()` | On logout (session-scoped). |

## Follow state machine (viewer-side)

```
                 Follow (public, instant)
   ┌─────────┐ ───────────────────────────▶ ┌───────────┐
   │ Follow  │                               │ Following │
   │ (none)  │ ◀─────────────────────────── │           │
   └─────────┘   Unfollow (confirm dialog)   └───────────┘
        │  ▲
        │  │ Withdraw (confirm dialog)
        ▼  │
   ┌───────────┐
   │ Requested │   (Follow on a PRIVATE account → Requested, not Following;
   └───────────┘    server approval out of band → Following on next reconcile)
```

- `following` and `requested` are mutually exclusive; `blocking` short-circuits everything (the account is not returned).
- The label rendered = `ViewerRelationship.label` (existing getter).
- Counts move with the transition: entering Following/Requested → +1 to the account's `followersCount` and the viewer's own `followingCount`; leaving → −1 (both reconciled by the server).

## Edit-profile form (transient view model — cubit state, not persisted)

| Field | Source | Constraint |
|---|---|---|
| `displayName` | `MeProfile.displayName` | non-empty (FR-025) |
| `username` | `MeProfile.username` | live availability via `/auth/check-username`; blocks Save while checking/taken/invalid (FR-022) |
| `pronouns` | `MeProfile.pronouns` | optional, free text |
| `website` | `MeProfile.website` | optional; well-formed URL when present (FR-025) |
| `bio` | `MeProfile.bio` | optional; length cap per contract |
| `avatarMediaId` | `MeProfile.avatarMediaId` | replaced by the #007 upload's `mediaId`; unchanged on cancel/fail (FR-023) |

- `dirty` flag drives the discard-confirm (FR-025); `usernameStatus ∈ {idle, checking, available, taken, invalid}` gates Save.

## Cubit states (freezed 4-state)

| Cubit | States (base + extended) |
|---|---|
| `MyProfileCubit` | `initial` / `loading` / `loaded(ProfileView, grid, activeTab, isOffline)` / `error` |
| `ProfileCubit` (other) | `initial` / `loading` / `loaded(ProfileView, grid, activeTab)` / `error` |
| `FollowCubit` | `loaded(ViewerRelationship, busy)` — thin, watches `RelationshipStore` (no initial/loading needed; seeded) |
| `FollowListCubit` | `initial` / `loading` / `loaded(List<AccountRow>, hasMore, query, tab)` / `error` (over `PaginatedListCubit`) |
| `EditProfileCubit` | `initial` / `loading` / `editing(form, usernameStatus, saving, avatarUploading)` / `error` |

## Entity relationships

```
ProfileView ── user ──▶ User (counts)
      │
      ├── relationship ──▶ ViewerRelationship ◀── canonical ── RelationshipStore ──▶ watched by FollowCubit + FollowListCubit
      │
      └── grid ──▶ CursorPage<ExploreItem>  (Posts | Tagged; gated ⇒ absent)

FollowListPage ──▶ CursorPage<AccountRow> (followers | following) ── each row.relationship seeds RelationshipStore

EditProfileCubit ──▶ MeRepository.updateProfile(MeProfile') ──▶ MeProfiles cache ──▶ watchMe() ──▶ MyProfile header
```
