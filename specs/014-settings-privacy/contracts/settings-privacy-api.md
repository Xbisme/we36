# Contract: Settings, Privacy & Safety API (B#014)

**Status**: Source-verified against `backend/src/modules/...` + `backend/prisma/schema.prisma` on 2026-07-10 (except the one flagged gap). All paths under `/v1`, bearer auth, error envelope `{error:{code,message,details}}`, cursor envelope `{items, nextCursor, hasMore}` (`?cursor=&limit=`, default 20).

Endpoint/event names go in `lib/core/constants/api_endpoints.dart` (and `socket_events.dart` for presence) — never inline literals (Constitution VIII).

---

## Settings read/write

### `GET /me/settings` → `SettingsView`
```
{
  "isPrivate": bool,
  "activityStatusVisible": bool,
  "twoFactorEnabled": bool,           // read-only here
  "closeFriendsCount": int,           // read-only
  "notifications": {
    "likes": bool, "comments": bool, "mentions": bool,
    "follows": bool, "followRequests": bool, "directMessages": bool,
    "globalMute": bool,
    "quietHours": { "start": int, "end": int, "timezone": string } | null
  }
}
```

### `PATCH /me/settings` → `SettingsView`
Partial body: `{ isPrivate?, activityStatusVisible?, notifications?{…partial} }`.
- Switching `isPrivate: false` (→ public) **auto-accepts all pending follow requests** server-side.
- `activityStatusVisible` is **reciprocal** — off hides you AND blinds you to others' presence.

### `PATCH /me` → `MeProfileDto` (alt private-toggle path)
Body `{ isPrivate }`. Same source of truth as `/me/settings`. Client uses `/me/settings` as the single settings surface.

---

## Follow requests (private-account approval)

Source: `backend/src/modules/social/`.

- `GET /me/follow-requests?cursor=&limit=` → `{ items: FollowRequestDto[], nextCursor, hasMore }`
  `FollowRequestDto = { requester: UserSummaryDto, requestedAt: string(date-time) }`
- `POST /me/follow-requests/:userId/accept` (200) → `RelationshipStateDto`
- `POST /me/follow-requests/:userId/reject` (204). Missing → `NOT_FOUND`.

`RelationshipStateDto = { following: bool, requested: bool, followsYou: bool, blocking: bool }` → maps to existing `ViewerRelationship`.

Follow of a private account: `POST /users/:id/follow` returns `FollowResultDto{relationship{requested:true,following:false}, followersCount}`; public → `following:true`.

---

## Blocking

- `POST /users/:id/block` (200) → `RelationshipStateDto`
- `DELETE /users/:id/block` (200) → `RelationshipStateDto`
- Server semantics (`social.service.ts` `blockTx`): **atomic bidirectional sever** — removes follows both directions + cancels pending requests; block masked as `NOT_FOUND` on follow attempts either way; unblock does **not** restore follows.

### `GET /me/blocks?cursor=&limit=` → `BlockedUserPageDto` — IMPLEMENTED (B#014)
Added to the social module (`social.controller`/`service`/`repository`, `dto/blocked-user.dto.ts`): a cursor page `{ items: UserSummaryDto[], nextCursor, hasMore }` of the accounts the signed-in user has blocked, newest-first keyset over the `Block` table, with avatar URLs resolved via `MediaService.resolveAvatarUrls` — mirrors the followers/following list. The client `RealBlockRepository.listBlocked()` binds to it directly.

---

## Report

Source: `backend/src/modules/moderation/`.

- `POST /reports` (**202**) → `ReportAckDto { accepted: true }` (acknowledgement only — never reveals outcome; idempotent per (reporter, target); vanished target = graceful ack).
- Body `ReportCreateDto`:
```
{
  "targetType": ReportTargetType,   // post|reel|comment|story|user|message
  "targetId": string(uuid),
  "reason": ReportReason,           // see enum
  "note": string(≤500)?             // #014 sends none (no free-text, FR-019)
}
```
- **`ReportReason`** enum (client MUST match): `spam · nudityOrSexual · harassmentOrBullying · hateSpeech · violence · selfHarm · falseInformation · intellectualProperty · other`.

---

## Close friends

Source: `backend/src/modules/stories/close-friends.controller.ts`.

- `GET /me/close-friends?cursor=&limit=` → `{ items: UserSummaryDto[], nextCursor, hasMore }` (newest-added first, block-scrubbed)
- `POST /me/close-friends/:userId` (204) — idempotent. Guard: target **must currently follow you** else `VALIDATION`; blocked → `NOT_FOUND`; self → `VALIDATION`.
- `DELETE /me/close-friends/:userId` (204) — idempotent.

Consumed by stories via `StoryAudience.closeFriends` (#005). `closeFriendsCount` also surfaced on `SettingsView`.

---

## Activity status / presence (reciprocal)

- Flag `activityStatusVisible` on `SettingsView` (write via `PATCH /me/settings`).
- Backend gate `ActivityStatusService.canView(viewer, target)` = true only if **both** visible; presence WS fan-out `filterViewers` before emit; conversation DTO `otherUserPresence = {online:false,lastActiveAt:null}` when not viewable.
- Socket events (existing, `lib/core/constants/socket_events.dart`): inbound `presence.update {userId, online, lastActiveAt}`, `typing {conversationId, userId, isTyping}`; outbound `presence.ping`, `typing.start/stop`. No new events for #014 — the toggle changes what the server sends you.

---

## Out of scope for #014 (backend exists — entry-only client)

Recorded so a later spec can wire without backend work:
- **2FA**: `POST /me/2fa/enroll` → `{otpauthUri, recoveryCodes[]}`; `POST /me/2fa/confirm {code}` (204); `POST /me/2fa/disable {password?,code?}` (204); login `MfaChallenge{mfaRequired,mfaToken}` + verify. Errors `TWO_FACTOR_REQUIRED`/`TWO_FACTOR_INVALID`.
- **Data export**: `POST /me/export` (202) → `DataExportRequestDto{id,status,downloadUrl?,expiresAt?,createdAt}` (throttle 3/day); `GET /me/export`, `GET /me/export/:id`. `DataExportStatus = pending|ready|failed`.
- **Account deletion**: `DELETE /me {password?,code?}` → `{deactivatedAt, deletionScheduledAt}`; `POST /me/reactivate` (204). (#014 surfaces at most an entry; deletion pipeline out of scope.)

---

## Client binding checklist (per repository)

Each new repository ships a real impl (`env:['real']`) + in-memory fake (`env:['fake']`, the one that runs in tests). Idempotent mutations carry the Idempotency-Key header via the existing interceptor. All errors flow through `FailureMapper → AppFailure`.

| Repository | Binds |
|---|---|
| `SettingsRepository` | GET/PATCH `/me/settings` |
| `FollowRequestsRepository` | GET `/me/follow-requests`, accept, reject |
| `BlockRepository` | POST/DELETE `/users/:id/block`; **listBlocked → pending `GET /me/blocks`** |
| `ReportRepository` | POST `/reports` |
| `CloseFriendsRepository` | GET/POST/DELETE `/me/close-friends` |
