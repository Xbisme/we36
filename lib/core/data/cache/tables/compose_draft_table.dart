import 'package:drift/drift.dart';

/// Persisted single in-progress compose draft (#007, FR-021 / Q2). At most one
/// row — a new draft replaces any prior. The draft body is stored as a JSON
/// [payload] (selected asset ids + per-item edit state + caption + metadata +
/// idempotency key) — **no media bytes** (privacy + size, Constitution I). Wiped
/// on logout via `clearUserScoped()`. Row class `ComposeDraftRow`.
@DataClassName('ComposeDraftRow')
class ComposeDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get idempotencyKey => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
