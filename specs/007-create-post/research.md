# Phase 0 Research: Create Post (Compose & Upload)

> All package versions verified against live pub.dev pages on **2026-07-01** (Constitution XV).
> Target toolchain: Flutter 3.44.4 / Dart 3.12.2.

## R1 — Custom in-app gallery picker (multi-select + selection order)

**Decision**: `photo_manager ^3.9.0` + `photo_manager_image_provider ^2.2.0`.

**Rationale**: The design (Screen 11) is a **custom** 4-column grid with selection-order badges, a
square live preview, a "Carousel" badge, and a "Recents" source label. This requires our own grid
UI over raw device albums/assets — exactly what `photo_manager` provides (`PhotoManager`,
`AssetPathEntity`, `AssetEntity`, `getAssetListPaged`), with `photo_manager_image_provider`
(`AssetEntityImage`) supplying bounded-resolution thumbnails. Single native plugin family (one
publisher), keeps the UI 100% ours, and aligns with the shared-component discipline.

**Alternatives rejected**:
- `image_picker ^1.2.3` — only opens the **OS picker**; `pickMultiImage()` returns `List<XFile>` with
  no custom grid and no controllable selection-order UI. Fails the custom-design requirement.
- `wechat_assets_picker ^10.1.2` — a **prebuilt** Instagram-like picker; capable but its UI would
  fight our exact design, and it is itself built on `photo_manager` + pulls `extended_image`/
  `provider`/`video_player`. Going direct to `photo_manager` is a smaller surface with full control.

**Native requirements (wire once)**: iOS `NSPhotoLibraryUsageDescription` (Info.plist); Android 13+
`READ_MEDIA_IMAGES` (AndroidManifest). Min iOS 9 / Android API 16 — well under our floors. Permission
requested contextually via `PhotoManager.requestPermissionExtend()` (Constitution I/VII).

**Justification for a native plugin (Constitution XIII/XV)**: reading device albums requires platform
photo-library APIs; Flutter stdlib has no equivalent. Unavoidable → justified.

## R2 — In-app crop to 4:5 (custom chrome, not native cropper)

**Decision**: `crop_your_image ^2.0.0`.

**Rationale**: Pure-Flutter `Crop` widget + `CropController`; lock ratio with `aspectRatio: 4/5`;
custom overlay/corner-dot builders let us match the design chrome. **Zero native footprint**; its only
dependency is the pure-Dart `image` package we already adopt in R3. Result delivered via `onCropped →
CropResult` (success/failure).

**Alternative rejected**: `image_cropper ^12.2.1` renders **native** cropper UIs (uCrop / TOCropView
Controller) that cannot match our custom design and require `UCropActivity` manifest registration.

**Breaking-change note (v2.0.0)**: `onCropped` returns a `CropResult` object (not raw `Uint8List`);
errors implement `Exception`; `initialRectBuilder` replaces `initialArea`/`initialSize`; `onMoved`
gains an `imageRect` arg. Integrate against the v2 API from the start.

## R3 — Bake preset filters + brightness/contrast/warmth into output pixels

**Decision**: Flutter built-in `ColorFilter.matrix` / `ColorMatrix` for the **live preview** (no
package); `image ^4.9.1` (pure-Dart) to **bake** the same matrix into exported bytes on an isolate.

**Rationale**: Live preview is a raster color-matrix applied by the GPU via `ColorFiltered` — instant
(<100 ms, SC-002), no re-decode, no package. For export we must burn the matrix into pixels; `image`
is the de-facto pure-Dart choice (`decodeImage`, `copyResize`, `encodeJpg(quality:)`, `Command`
isolate API). Preset filters (Original / Warm / Lux / Mono / Fade) are each a fixed 4×5 matrix;
brightness/contrast/warmth compose additional matrices.

**Fidelity note**: `image` has no single arbitrary 4×5-matrix primitive matching Flutter's
`ColorMatrix`. To guarantee the baked result matches the preview pixel-for-pixel, implement the exact
4×5 matrix multiply over `img.Image` pixels (a small pure-Dart loop) rather than approximating with
`adjustColor`. Run it via `Command().executeThread()` to keep the main isolate jank-free.

## R4 — Client-side compression before upload

**Decision**: Reuse `image ^4.9.1` (`copyResize` + `encodeJpg(quality:)`, on the isolate) — **no new
native plugin**.

**Rationale**: The bake step (R3) already runs `image` on an isolate and produces the final pixels;
resizing + JPEG-encoding at a target quality there yields upload-ready bytes with zero additional
native footprint (Constitution XIII "prefer existing dependency when equivalent").

**Deferred fallback**: `flutter_image_compress ^2.4.0` (native, faster on full-res photos, supports
WebP/HEIC). Adopt **only** if profiling on a mid-range device shows the isolate `image` encode is too
slow/janky for the upload path. Note: ~18-month release cadence — smoke-build on Flutter 3.44 before
committing if adopted.

## R5 — Upload lifecycle (progress / cancel / resume / idempotency)

**Decision**: A `MediaUploadService` (core) wraps `dio` for the real seam: multipart/chunked upload
with an `onSendProgress` stream, a `CancelToken` for cancel, and **in-session** retry/resume
(FR-018a — no persistent background queue for v1.0, per clarification). The create-post call carries a
**client-generated uuid v7 idempotency key** (reused across retries) so duplicates never occur
(FR-018, Constitution IX). The fake simulates deterministic progress ticks + injectable cancel/fail
hooks so tests exercise every branch zero-network.

**Rationale**: Matches the #002 `ApiClient` layering (interceptors already attach idempotency + auth);
keeping upload in a core service makes the pipeline reusable by #005/#006. App-kill mid-upload relies
on the persisted draft (R6) + idempotency for a clean re-publish, avoiding the cost of a persistent
background-upload queue.

## R6 — Draft persistence (survive app kill/restart)

**Decision**: A single-row `ComposeDrafts` drift table (schema **v3 → v4**) storing the serialized
draft: ordered selected **asset ids** (photo_manager ids are stable/re-resolvable — no need to copy
bytes), per-item edit state (crop rect + filter id + brightness/contrast/warmth), caption, tagged
people, location, comments-disabled flag, and the idempotency key. Restored on compose entry via a
keep/discard prompt; cleared on publish success or explicit discard; wiped by `clearUserScoped()` on
logout.

**Rationale**: Storing asset ids + edit params (not media bytes) keeps the draft tiny and privacy-safe
(Constitution I) while satisfying FR-021 + Q2 (persist single draft across restart). Non-destructive
`onUpgrade` with a v3→v4 migration test (Constitution IX). A multi-draft library is out of scope (Q2).

## R7 — Backend seam (fake-mode until B#007)

**Decision**: Mirror the #004 pattern — define the real seam against a documented B#007 contract
(`POST /media` for upload → media ids/urls; `POST /posts` for create-post carrying media ids + caption
+ metadata + idempotency key) annotated `env:['real']`, plus an in-memory fake annotated `env:['fake']`
that actually runs. Endpoints centralized in `core/constants/api_endpoints.dart`.

**Rationale**: Keeps the app zero-network buildable/testable now (Constitution VIII/XII) and lets the
real impl drop in when B#007 lands, exactly as `FeedRepository` did in #004. On publish success the
repository writes the new post into the #004 `Posts` cache (single canonical representation, FR-020).

## Open items for planning follow-through (not blocking)

- Exact create-post request/response field names align to B#007 when finalized; DTOs isolate this.
- Whether "tag people" / "add location" use a real search (needs social graph / places) or a
  lightweight local picker in v1.0 — defaulted to a **simple picker** per spec scope; wired to real
  sources in later specs.
