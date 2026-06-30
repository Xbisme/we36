# Spec #003 — Auth & Onboarding · Alignment Decisions

> Pre-`/speckit.specify` alignment session (2026-06-30). Source of truth for the contract is the **already-implemented** backend `we36-backend` B#002 Auth & Identity (`specs/002-auth-identity/contracts/openapi.yaml`, base path `/v1`).

## Context correction
- The backend auth feature is **fully implemented** (NestJS 11 + Postgres + Redis), not roadmap-only as initially assumed. All `/v1/auth/*` + `/v1/me/*` endpoints are live and tested. Client #003 builds against the real contract.

## Decisions

| # | Topic | Decision | Rationale / contract fact |
|---|---|---|---|
| 1 | **Identifier** | **Email-only** for login + register; **no phone field** in #003 UI | Backend `register`/`login` accept `email`+`password` only; `phone` is stored-only, never used for login/verify. Phone (+ SMS verify) deferred to a later spec when backend supports it. |
| 2 | **Forgot password** | **Email 6-digit OTP** → verify → set new password | Backend `POST /auth/forgot` issues a **6-digit** numeric OTP (TTL 10 min, max 5 attempts). Design Screen 5 shows 4 OTP boxes → **must change to 6**. |
| 3 | **OAuth** | **Google + Apple** in #003 | Backend `POST /auth/oauth/{google\|apple}` accepts a provider `idToken`, verifies via JWKS, create-or-link. Apple required on iOS once any third-party social login is offered (App Store 4.8). |
| 4 | **Profile setup** | Required: **username** (live `check-username`) + **display name**; **bio** optional. **No avatar** in #003 | `POST /me/setup` requires username+displayName; bio/avatarMediaId optional. **Avatar upload deferred to B#003 Media** (no image-upload endpoint yet) → omit avatar from Screen 6 for now. |
| 5 | **Session** | access (JWT ~15 min) + refresh (opaque, rotating, 30-day sliding) in `flutter_secure_storage`; wire to #002 `TokenStore`/`TokenRefresher`/`AuthEventsSink` seams; single-flight refresh on `SESSION_EXPIRED`; logout calls `POST /auth/logout` + clears storage + resets auth-guard | Contract: `{accessToken, refreshToken, expiresIn, tokenType:"Bearer"}`. Refresh reuse → family revoke → `SESSION_EXPIRED`. |
| 6 | **Onboarding slides** | First-launch only; flag persisted locally (`shared_preferences`) | Not auth state — UX gate before sign-in. |

## Contract anchors (for `/speckit.plan` `contracts/`)
- Base path **`/v1`**. Auth header `Authorization: Bearer <accessToken>`.
- Endpoints: `POST /auth/register|login|refresh|logout|forgot|reset|check-username`, `POST /auth/oauth/{provider}`, `GET /me`, `POST /me/setup`, `PATCH /me`.
- Error envelope `{error:{code,message,details}}` (already handled by #002 `FailureMapper`). Codes: `UNAUTHENTICATED, INVALID_CREDENTIALS, SESSION_EXPIRED, OAUTH_FAILED, CONFLICT, VALIDATION, RATE_LIMITED`.
- `MeProfile`: `id, username?, displayName?, email, avatarMediaId?, bio?, website?, pronouns?, isPrivate, isVerified, profileCompleted, createdAt`. `username`/`displayName` are null until setup → drives the **post-login redirect to profile-setup** when `profileCompleted == false`.
- Username rule: `[a-z0-9._]`, 3–30 chars, no leading/trailing dot, case-insensitive.
- Rate limits surface as `RATE_LIMITED` (429 + `Retry-After`); login lockout 5 fails / 15 min → show a friendly "try again in N" Toast.

## Design deltas to apply (update `ui-design-context.md` during #003)
- Screen 3 (Sign in): identifier label "Email/phone" → **"Email"**.
- Screen 4 (Sign up): **remove** the "Phone (optional)" field.
- Screen 5 (Forgot password): **4 OTP boxes → 6**.
- Screen 6 (Profile setup): **remove avatar** (104px + camera badge) for #003; keep username/display name/bio. Re-introduce avatar when B#003 Media + client compose pipeline land.

## Deferred (NOT in #003)
- Phone/SMS verification, email verification flow, avatar upload, 2FA, account deletion/data export/settings surface, public profile (`GET /users/{username}`).
