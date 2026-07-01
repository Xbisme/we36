# Contracts — Create Story & Story Tools (#005)

Client-side seams (Dart interfaces) for a **fake-first** feature. There is **no backend stories
contract yet**; the real seams are registered for DI-graph completeness and are inert until a future
backend stories spec lands (mirrors the #002 scaffold approach).

| Contract | File | Kind |
|---|---|---|
| Create-story repository (upload + persist own segment) | [create-story-repository.md](create-story-repository.md) | backend seam (real inert / fake runs) |
| Story image composer (WYSIWYG 9:16 flatten) | [story-image-composer.md](story-image-composer.md) | core service |
| Own-story store (shared session own-reel) | [own-story-store.md](own-story-store.md) | core in-memory store |
| Reused pipeline (photo-library + media-upload) | [reused-pipeline.md](reused-pipeline.md) | reference to #007 seams |

All methods return `Result<T>` (Constitution V). Errors map through the #002 `FailureMapper` to the
enumerated `AppFailure` set — no new failure codes are introduced.
