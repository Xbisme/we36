# Phase 1 Data Model: Create Post (Compose & Upload)

> Domain models (freezed), the drift schema bump (v3 → v4), and Cubit state shapes.
> Reuses the #004 canonical cached `Post`; adds no second post representation.

## Domain models (`lib/features/compose/domain/models/`)

### `ComposeDraft` (freezed)

The in-progress post being built — the single source the flow mutates and the unit persisted.

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Local draft id (uuid v7). |
| `idempotencyKey` | `String` | uuid v7 generated at draft creation; reused for every publish attempt (FR-018). |
| `items` | `List<SelectedMediaItem>` | Ordered; length 1..10 (carousel cap). |
| `caption` | `String` | ≤ 2,200 chars; may be empty (FR-012/015). |
| `metadata` | `PostMetadata` | Tag people / location / comments-disabled (FR-013/014). |
| `createdAt` | `DateTime` | For restore prompt context. |

Validation: `items.isNotEmpty` to leave the pick step; `items.length <= 10`; `caption.length <= 2200`.

### `SelectedMediaItem` (freezed)

One chosen photo plus its per-photo edit state and carousel position (Q4 — per-photo edits).

| Field | Type | Notes |
|---|---|---|
| `assetId` | `String` | Stable `photo_manager` asset id (re-resolvable; no bytes stored). |
| `order` | `int` | Position in the carousel. |
| `edit` | `MediaEditState` | Crop + filter + adjustments for this photo. |

### `MediaEditState` (freezed)

| Field | Type | Notes |
|---|---|---|
| `cropRect` | `Rect?` | Normalized crop to the 4:5 aspect; null = full-frame 4:5 default. |
| `filter` | `FilterPreset` | `original` \| `warm` \| `lux` \| `mono` \| `fade` (enum). |
| `brightness` | `double` | −1.0..1.0, default 0. |
| `contrast` | `double` | −1.0..1.0, default 0. |
| `warmth` | `double` | −1.0..1.0, default 0. |

`FilterPreset` maps to a fixed 4×5 color matrix (shared const table used by both the live
`ColorFilter.matrix` preview and the `image` bake — one source of truth for fidelity, R3).

### `PostMetadata` (freezed)

| Field | Type | Notes |
|---|---|---|
| `taggedUserIds` | `List<String>` | Simple picker in v1.0 (spec scope). |
| `location` | `PlaceRef?` | `{id?, label}` — lightweight in v1.0. |
| `commentsDisabled` | `bool` | Default false (FR-014). |

> "Also share to Stories" and "Add music" are **hidden** in v1.0 (clarification Q5) — no fields.

### `UploadProgress` (freezed) — transient, not persisted

| Field | Type | Notes |
|---|---|---|
| `sentBytes` | `int` | |
| `totalBytes` | `int` | |
| `fraction` | `double` | 0.0..1.0 for the progress bar (FR-017). |
| `itemIndex` | `int` | Which carousel item is uploading. |

## Published post → reuse #004 `Post`

On publish success the `CreatePostRepository` writes the created post into the existing #004 `Posts`
drift table (canonical cached representation). The Home feed's `watchHomeFeed()` reactively repaints
with the new post at top (FR-020) — **no new post entity, no per-Cubit copy** (Constitution IX).

## Drift schema change (v3 → v4)

**New table `ComposeDrafts`** — at most one row (the single persisted in-progress draft, R6/Q2):

| Column | Type | Notes |
|---|---|---|
| `id` | text, PK | Draft id. |
| `idempotencyKey` | text | Reused across publish retries. |
| `payload` | text (JSON) | Serialized `ComposeDraft` (items + edits + caption + metadata). |
| `createdAt` | datetime | |
| `updatedAt` | datetime | Touched on every mutation for crash-safety. |

- **Migration**: non-destructive `onUpgrade` — `if (from < 4) create ComposeDrafts;` (Constitution IX).
  `migration_test.dart` extended to cover **v3 → v4** (and the existing v1→v2→v3 chain still passes).
- **Privacy**: `clearUserScoped()` extended to delete the draft row on logout (Constitution I).
- **Rationale for JSON payload**: the draft is a single opaque unit read/written whole; a JSON blob
  avoids over-normalizing transient edit state into many columns (YAGNI, Constitution XIII).

## Cubit state shapes (`lib/features/compose/presentation/cubit/`)

### `GalleryState` (freezed 4-state) — the pick grid

- `initial`
- `loading` (permission + first page)
- `loaded({ List<AssetRef> assets, bool hasMore, List<String> selectedIds })`
- `loadedPaginating(...)` — appending the next page (Constitution III paginated variant)
- `error({ AppFailure failure })` — includes `permissionDenied` → explanatory state + settings CTA (FR-007)

### `ComposeState` (freezed 4-state) — the flow (pick→edit→caption→publish)

- `initial`
- `loading` — restoring a persisted draft
- `loaded({ ComposeDraft draft, int activeItemIndex })` — editing/captioning
- `loadedUploading({ ComposeDraft draft, UploadProgress progress })` — publish in flight (cancelable)
- `error({ AppFailure failure, ComposeDraft draft })` — upload/publish failed; retains draft for retry (FR-019)

Transitions: select in `GalleryCubit` → build `ComposeDraft` → edit per item → caption → `publish()`
emits `loadedUploading` (progress stream) → success writes to `Posts` cache + clears draft + pops
flow; failure emits `error` (draft kept). Cancel from `loadedUploading` aborts and returns to `loaded`
with selection/edits intact (FR-017). Back-out mid-flow → keep/discard dialog (FR-021).

## Failure modes (reused `AppFailure` — no new variants)

`permissionDenied` (gallery), `unsupportedMedia` (undecodable file), `mediaTooLarge`, `uploadFailed`,
`offline`, `networkError`, `timeout`, `serverError`, `validation` (caption/field). All already
enumerated in the #002 `AppFailure` sealed class (Constitution V).
