# Contract: Error Envelope → AppFailure

The client maps **every** error to a typed `AppFailure` in one place (`FailureMapper`). Call sites
never inspect HTTP status. The backend `code` values are contract-stable — never renamed.

## Error envelope (backend)

```json
{ "error": { "code": "VALIDATION", "message": "Validation failed", "details": { "username": "already taken" } } }
```

## Mapping table

| Source (`code` or fault) | HTTP | `AppFailure` | Notes |
|---|---|---|---|
| `UNAUTHENTICATED` | 401 | `unauthenticated()` | no/!valid token |
| `INVALID_CREDENTIALS` | 401 | `invalidCredentials()` | login |
| `SESSION_EXPIRED` | 401 | `sessionExpired()` | triggers single-flight refresh first (see below) |
| `OAUTH_FAILED` | 401 | `oauthFailed()` | |
| `FORBIDDEN` | 403 | `forbidden()` | private/blocked |
| `NOT_FOUND` | 404 | `notFound()` | |
| `CONFLICT` | 409 | `conflict()` | e.g. username taken |
| `VALIDATION` | 422 | `validation(fields: details)` | `details` → field map |
| `RATE_LIMITED` | 429 | `rateLimited(retryAfter:)` | parse `Retry-After` header (seconds) |
| `MEDIA_TOO_LARGE` | 413 | `mediaTooLarge()` | |
| `UNSUPPORTED_MEDIA` | 415 | `unsupportedMedia()` | |
| `UPLOAD_FAILED` | 422 | `uploadFailed()` | |
| `SERVER_ERROR` | 500 | `serverError()` | |
| connect/receive/send timeout | — | `timeout()` | `DioExceptionType.*Timeout` |
| connection error / DNS / no route | — | `networkError()` | offline inferred (no connectivity service) |
| request cancelled | — | `unknown(message:'cancelled')` | |
| body not the envelope / unparseable | 4xx/5xx | `serverError()` else `unknown()` | never crash on bad JSON |
| `code` outside the catalog | any | `unknown(message: message)` | preserve message |

## Single-flight refresh on 401 `SESSION_EXPIRED`

1. Response is 401 with body code `SESSION_EXPIRED` and the request is not the refresh call itself.
2. If no refresh in flight → start one via `TokenRefresher.refresh()`; else `await` the in-flight future.
3. On refresh **success** → retry the original request **once** with the new token; return its result.
4. On refresh **failure** (or retried request 401 again) → resolve to `sessionExpired()` and emit
   `AuthEventsSink.onUnauthenticated()` **exactly once** across all waiters. No loop.

## Rules

- Exactly one automatic retry exists (the post-refresh retry). No transient 5xx/timeout auto-retry.
- `validation` MUST carry the `details` field map so forms can map errors back to fields.
- The mapper is pure + unit-tested against stubbed `dio` responses (no network).
