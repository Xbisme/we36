# Contracts — Spec #003 Auth & Onboarding

The client consumes the **already-implemented** backend contract; it does not define a new one.

- **[auth-openapi.yaml](auth-openapi.yaml)** — the `/v1` auth + `me` slice, copied verbatim from `we36-backend/specs/002-auth-identity/contracts/openapi.yaml` (the human-reviewed companion to the NestJS-generated OpenAPI). This is the source of truth for endpoint paths, request/response shapes, status codes, and error codes the Dart DTOs in `core/data/auth/dto/` + `MeProfile` must match.

## Endpoint → client mapping (base URL already includes `/v1`)

| Method & path | Client call | Maps to |
|---|---|---|
| `POST /auth/register` | `AuthRepository.register` | `Session` |
| `POST /auth/login` | `AuthRepository.login` | `Session` |
| `POST /auth/oauth/{google\|apple}` | `AuthRepository.oauth` | `Session` |
| `POST /auth/refresh` | `RealTokenRefresher` / `AuthRepository.refresh` | `Session` (single-flight) |
| `POST /auth/logout` | `AuthRepository.logout` | 204 idempotent |
| `POST /auth/forgot` | `AuthRepository.requestPasswordReset` | `{devCode?}` (dev only) |
| `POST /auth/reset` | `AuthRepository.resetPassword` | 204 |
| `POST /auth/check-username` | `AuthRepository.checkUsername` | `CheckUsernameResponse` |
| `GET /me` | `MeRepository.getMe` | `MeProfile` |
| `POST /me/setup` | `MeRepository.setupProfile` | `MeProfile` |
| `PATCH /me` | `MeRepository.updateMe` | `MeProfile` |

## Error codes (already mapped in `FailureMapper`, #002)

`UNAUTHENTICATED` · `INVALID_CREDENTIALS` · `SESSION_EXPIRED` · `OAUTH_FAILED` · `CONFLICT` · `VALIDATION` (with `details` field map) · `RATE_LIMITED` (+ `Retry-After`). No new mapping needed; verify the auth flows surface them correctly.

## Constants to add to `ApiEndpoints` (relative to the `/v1` base)

`/auth/register`, `/auth/login`, `/auth/oauth/{provider}`, `/auth/refresh` (exists), `/auth/logout`, `/auth/forgot`, `/auth/reset`, `/auth/check-username`, `/me` (exists), `/me/setup`. Never inline these literals (Constitution VIII).
