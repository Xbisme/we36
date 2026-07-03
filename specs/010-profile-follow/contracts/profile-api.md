# Profile API Contract (client-consumed subset of B#010)

> **Derived, not authoritative.** These shapes are inferred from the We36 backend conventions already in use (#002–#009): base `/v1`, success envelope `{ "data": … }` (+ `meta` for cursors), error envelope `{ "error": { "code", "message", "details? } }` mapped by `FailureMapper` → `AppFailure`, cursor pagination via `?cursor=&limit=` → `CursorPage<T>` (`{ data:[…], meta:{ nextCursor } }`), and idempotent mutations via a client `Idempotency-Key` header. **Reconcile every path/field below against the shipped B#010 contract before implementation.** No spec requirement depends on a specific path — only on the capability.

Shared DTO fragments (already shipped): `UserDto` → `User`, `UserSummaryDto` → `UserSummary`, `ViewerRelationshipDto` → `ViewerRelationship` (`{following, requested, followsYou, blocking}`), `ExploreItemDto` → `ExploreItem`, `MediaDto` → `Media`.

---

## 1. Get profile by handle — `GET /users/{username}`

Extends the #002 reference slice to return the full view + the viewer's relationship + gating.

**Response `data`** (`ProfileView`):
```json
{
  "user": { "id": "u_alice", "username": "alice", "displayName": "Alice",
            "isPrivate": false, "isVerified": true,
            "followersCount": 1240, "followingCount": 311, "postsCount": 87,
            "avatarUrl": "https://…", "bio": "…" },
  "relationship": { "following": false, "requested": false, "followsYou": true, "blocking": false },
  "isMe": false,
  "gated": false
}
```
- `gated=true` when the account is private and the viewer is not an approved follower (server-authoritative). When `gated`, the grid + connection-list endpoints return `403 PRIVATE_ACCOUNT` (or empty) — the client shows `PrivateGate` and blocks connection navigation.
- A blocked account (`blocking` either direction) is **not returned**: `404 NOT_FOUND` (client shows a generic empty/error state).
- `isMe=true` for the signed-in person's own handle (also reachable via the counts on `GET /me`).

## 2. My profile counts — `GET /me`  *(existing; may already include counts)*

`GET /me` returns the `MeProfile` identity (shipped). If it does not already carry `postsCount`/`followersCount`/`followingCount`, the client fetches the own `ProfileView` via `GET /users/{myUsername}` (`isMe=true`) for the counts. **Confirm which endpoint owns the own-profile counts.**

## 3. Follow / unfollow — `POST` / `DELETE /users/{id}/follow`

Idempotent (client `Idempotency-Key`). Mirrors the like/save toggle shape (#004).

- `POST` → follow (public: `following=true`; private: `requested=true`). No-op if already in that state.
- `DELETE` → unfollow **or** withdraw a pending request. No-op if not following/requested.

**Response `data`** (the updated relationship + reconciled counts):
```json
{
  "relationship": { "following": true, "requested": false, "followsYou": true, "blocking": false },
  "followersCount": 1241
}
```
- A retry with the same `Idempotency-Key` returns the current relationship (exactly one net change — SC-003).
- `403 PRIVATE_ACCOUNT` never occurs on follow itself (following a private account is allowed → Requested); `409`/`4xx` codes map to `AppFailure` and trigger the client rollback.

## 4. Followers / following — `GET /users/{id}/followers` · `GET /users/{id}/following`

Cursor-paginated. `?cursor=&limit=&q=` (`q` = optional server-side search within the list — FR-015).

**Response** `CursorPage<AccountRow>`:
```json
{ "data": [ { "user": { "id":"u_bob", "username":"bob", "displayName":"Bob", "avatarUrl":"…", "isVerified":false },
             "relationship": { "following": true, "requested": false, "followsYou": false, "blocking": false } } ],
  "meta": { "nextCursor": "…" } }
```
- Blocked accounts are server-filtered (never in `data` — FR-016).
- When the target profile is `gated`, these return `403 PRIVATE_ACCOUNT` → the client never navigates here (counts non-tappable — R6).

## 5. Profile grids — `GET /users/{id}/posts` · `GET /users/{id}/tagged`

Cursor-paginated `CursorPage<ExploreItem>` (same item shape as explore/hashtag grids; reels marked).
```json
{ "data": [ { "kind": "post", "post": { … } }, { "kind": "reel", "reel": { … } } ],
  "meta": { "nextCursor": "…" } }
```
- `gated` profile → `403 PRIVATE_ACCOUNT` (client shows `PrivateGate`).
- `tagged` returns posts the user is tagged in (read-only — managing tags is out of scope).

## 6. Update my profile — `PATCH /me`

Partial update of the editable identity. Idempotent by nature (last-write-wins on the fields sent).

**Request body** (only changed fields):
```json
{ "displayName": "Alice A.", "username": "alice", "pronouns": "she/her",
  "website": "https://alice.example", "bio": "…", "avatarMediaId": "med_123" }
```
- `avatarMediaId` is the `mediaId` returned by the shipped media pipeline (`POST /media/uploads` → `PUT` bytes → `POST /media/{id}/finalize`), reused from #007.
- `409 USERNAME_TAKEN` when the handle was claimed between check and save (FR-022) → client surfaces the message, no write.

**Response `data`**: the updated `MeProfile` (client updates the `MeProfiles` cache → `watchMe` repaints the header).

## 7. Username availability — `GET /auth/check-username?username=…`  *(existing #003)*

Reused verbatim for Edit profile's live availability (`{ available: bool }`).

---

## Error codes consumed (mapped by `FailureMapper`)

| HTTP / `code` | `AppFailure` | Client behavior |
|---|---|---|
| `404 NOT_FOUND` | `notFound` | Profile empty/error state (removed/blocked account). |
| `403 PRIVATE_ACCOUNT` | `forbidden` | Show `PrivateGate`; block connection navigation. |
| `409 USERNAME_TAKEN` | `conflict` | Inline username error; block Save. |
| `401 SESSION_EXPIRED` | (single-flight refresh) | Handled by the shared interceptor. |
| network/timeout | `offline`/`timeout` | Optimistic rollback + Toast; profile falls back to cache where available. |

## Surface-only in #010 (no endpoint)

Message (→ #012), Share profile, Report, Block are UI acknowledgements only in this feature — no B#010 call. (Block enforcement + reporting land in #014; the backend already excludes blocked accounts from the lists above.)
