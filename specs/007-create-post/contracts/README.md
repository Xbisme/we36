# Contracts: Create Post (Compose & Upload)

Client-side interface contracts for #007. The app runs DI `environment: 'fake'`; each contract has a
real seam (`env:['real']`, follows the documented backend B#007 shape) and an in-memory fake
(`env:['fake']`, the one that runs). `PhotoLibraryService` is a platform seam (env-agnostic real +
a test fake), not a backend seam.

| Contract | File | Layer | Env |
|---|---|---|---|
| Create-post repository | [create-post-repository.md](create-post-repository.md) | `features/compose/domain` + `data` | real + fake |
| Media-upload service | [media-upload-service.md](media-upload-service.md) | `core/services` | real + fake |
| Photo-library service | [photo-library-service.md](photo-library-service.md) | `core/services` | platform real + test fake |
| Compose-draft store | [compose-draft-store.md](compose-draft-store.md) | `features/compose/data` (drift) | single impl |

**Reused, not redefined**: `ApiClient` + interceptors + `FailureMapper` (#002), `Result<T>`/
`AppFailure` (#002), the canonical `Post` + `PostsDao` + `watchHomeFeed()` (#004), `AppDatabase`
migration harness (#002/#004).

**Backend B#007 seam (documented, not built here)**: `POST /media` (multipart, idempotent → media
ids/urls) and `POST /posts` (media ids + caption + metadata + idempotency key → created post).
Paths live in `core/constants/api_endpoints.dart`.
