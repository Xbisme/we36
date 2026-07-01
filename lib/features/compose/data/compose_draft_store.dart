import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/compose_draft_dao.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';

/// Persists the single in-progress compose draft to drift so it survives app
/// kill/restart (FR-021, Q2). Serializes [ComposeDraft] to a JSON payload — no
/// media bytes (Constitution I). Cleared on publish success / explicit discard
/// (and on logout via `clearUserScoped`).
@lazySingleton
class ComposeDraftStore {
  ComposeDraftStore(this._db);

  final AppDatabase _db;
  ComposeDraftDao get _dao => _db.composeDraftDao;

  /// The current persisted draft, if any (for the restore prompt).
  Future<ComposeDraft?> read() async {
    final row = await _dao.current();
    return row == null ? null : _decode(row);
  }

  /// Reactive current draft (null when none) — drives the resume affordance.
  Stream<ComposeDraft?> watch() =>
      _dao.watchCurrent().map((row) => row == null ? null : _decode(row));

  /// Upsert the single draft (called on every meaningful mutation).
  Future<void> save(ComposeDraft draft) async {
    final now = DateTime.now().toUtc();
    await _dao.save(
      ComposeDraftRow(
        id: draft.id,
        idempotencyKey: draft.idempotencyKey,
        payload: jsonEncode(draft.toJson()),
        createdAt: draft.createdAt,
        updatedAt: now,
      ),
    );
  }

  /// Clear on publish success or explicit discard.
  Future<void> clear() => _dao.clear();

  ComposeDraft _decode(ComposeDraftRow row) =>
      ComposeDraft.fromJson(jsonDecode(row.payload) as Map<String, dynamic>);
}
