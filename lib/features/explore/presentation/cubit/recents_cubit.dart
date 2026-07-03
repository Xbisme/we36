import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/features/explore/domain/usecases/recents_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/recents_state.dart';

/// Drives recent searches (#009 US3; Constitution III/X). Recording is
/// dedupe-and-promote (the repository/backend is authoritative; the returned
/// entry is merged to the top). Delete/clear are optimistic — the list updates
/// immediately and reverts on failure.
@injectable
class RecentsCubit extends Cubit<RecentsState> {
  RecentsCubit(this._get, this._record, this._delete, this._clear)
    : super(const RecentsState.initial());

  final GetRecents _get;
  final RecordRecent _record;
  final DeleteRecent _delete;
  final ClearRecents _clear;

  Future<void> load() async {
    emit(const RecentsState.loading());
    final result = await _get();
    result.fold(
      (items) => emit(RecentsState.loaded(items)),
      (f) => emit(RecentsState.error(f)),
    );
  }

  /// Record a recent (tap a result / submit a term). Merges the resolved entry to
  /// the top, deduped by target. Silent on failure (recording is incidental).
  Future<void> record(RecordSearchRecent record) async {
    final result = await _record(record);
    final entry = result.valueOrNull;
    if (entry == null) return;
    final current = state.items;
    emit(
      RecentsState.loaded([
        entry,
        for (final r in current)
          if (r.id != entry.id && _key(r) != _keyOf(entry)) r,
      ]),
    );
  }

  /// Remove one recent (optimistic).
  Future<void> deleteRecent(String id) async {
    final prior = state.items;
    emit(RecentsState.loaded([...prior.where((r) => r.id != id)]));
    final result = await _delete(id);
    if (result.isErr) emit(RecentsState.loaded(prior)); // revert
  }

  /// Clear all recents (optimistic).
  Future<void> clearAll() async {
    final prior = state.items;
    emit(const RecentsState.loaded([]));
    final result = await _clear();
    if (result.isErr) emit(RecentsState.loaded(prior)); // revert
  }

  static String _keyOf(SearchRecent r) => _key(r);
  static String _key(SearchRecent r) => switch (r.type) {
    SearchRecentType.term => 'term:${r.term}',
    SearchRecentType.account => 'account:${r.account?.id}',
    SearchRecentType.hashtag => 'hashtag:${r.hashtag?.tag}',
    SearchRecentType.place => 'place:${r.place?.id}',
  };
}
