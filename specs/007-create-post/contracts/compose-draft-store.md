# Contract: ComposeDraftStore (`lib/features/compose/data/compose_draft_store.dart`)

Persists the single in-progress compose draft to drift so it survives app kill/restart (FR-021, Q2).
Single impl (drift-backed) — no real/fake backend axis.

```dart
abstract interface class ComposeDraftStore {
  /// The current persisted draft, if any (for the restore prompt on compose entry).
  Future<ComposeDraft?> read();

  /// Upsert the single draft row (called on every meaningful mutation — crash-safety).
  Future<void> save(ComposeDraft draft);

  /// Clear on publish success or explicit discard.
  Future<void> clear();

  /// Reactive: emits null when no draft (drives the "resume?" affordance).
  Stream<ComposeDraft?> watch();
}
```

## Behavior

- Backed by the `ComposeDrafts` drift table (schema v4) — at most one row; `save` upserts, keyed so a
  new draft replaces any prior (single-draft, Q2).
- Serializes `ComposeDraft` to the `payload` JSON column (asset ids + per-item edit state + caption +
  metadata + idempotency key) — **no media bytes** stored (privacy + size, Constitution I).
- On restore, asset ids are re-resolved via `PhotoLibraryService`; an asset no longer present is
  dropped from the restored draft with a soft notice (malformed-tolerance, Constitution IX).
- Wiped by `AppDatabase.clearUserScoped()` on logout (Constitution I).
- `updatedAt` touched on every `save` for crash-recovery ordering.

## Migration

Schema **v3 → v4** adds `ComposeDrafts`; non-destructive `onUpgrade` (`if (from < 4) create`).
`test/core/data/cache/migration_test.dart` extended to cover v3→v4 (Constitution IX).
