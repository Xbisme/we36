import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/features/profile/domain/usecases/follow_list_usecases.dart';
import 'package:we36/features/profile/domain/usecases/follow_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_state.dart';

/// Drives a profile's followers/following list (#010 US3). Loads a tab (cursor +
/// server-side search), and toggles a row's Follow control **optimistically**
/// through the canonical [RelationshipStore] (SC-004) with rollback.
@injectable
class FollowListCubit extends Cubit<FollowListState> {
  FollowListCubit(this._load, this._follow, this._store)
    : super(const FollowListState.initial());

  final LoadConnections _load;
  final FollowAction _follow;
  final RelationshipStore _store;

  String _userId = '';
  FollowConnTab _tab = FollowConnTab.followers;
  String _query = '';
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;

  Future<void> init(String userId, FollowConnTab tab) async {
    _userId = userId;
    _tab = tab;
    await _reload();
  }

  Future<void> switchTab(FollowConnTab tab) async {
    if (tab == _tab) return;
    _tab = tab;
    await _reload();
  }

  Future<void> search(String query) async {
    if (query == _query) return;
    _query = query;
    await _reload();
  }

  Future<void> _reload() async {
    emit(const FollowListState.loading());
    _cursor = null;
    _hasMore = true;
    final res = await _load(_userId, _tab, query: _query);
    if (res.isErr) {
      emit(FollowListState.error(res.failureOrNull!));
      return;
    }
    final page = res.valueOrNull!;
    for (final r in page.items) {
      _store.seed(r.user.id, r.relationship);
    }
    _cursor = page.nextCursor;
    _hasMore = page.hasMore;
    emit(
      FollowListState.loaded(
        tab: _tab,
        rows: page.items,
        hasMore: _hasMore,
        query: _query,
      ),
    );
  }

  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null) return;
    final s = state;
    if (s is! FollowListLoaded) return;
    _busy = true;
    final res = await _load(_userId, _tab, cursor: _cursor, query: _query);
    final page = res.valueOrNull;
    if (page != null) {
      for (final r in page.items) {
        _store.seed(r.user.id, r.relationship);
      }
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      emit(s.copyWith(rows: [...s.rows, ...page.items], hasMore: _hasMore));
    }
    _busy = false;
  }

  Future<bool> followRow(String userId) async {
    final prev = _rowRelationship(userId);
    _mutateRow(userId, (r) => r.copyWith(following: true));
    final res = await _follow.follow(userId, isPrivate: false);
    return _settleRow(userId, res.isOk, prev);
  }

  Future<bool> unfollowRow(String userId) async {
    final prev = _rowRelationship(userId);
    _mutateRow(userId, (r) => r.copyWith(following: false, requested: false));
    final res = await _follow.unfollow(userId);
    return _settleRow(userId, res.isOk, prev);
  }

  bool _settleRow(String userId, bool ok, ViewerRelationship? prev) {
    if (!ok) {
      if (prev != null) _mutateRow(userId, (_) => prev);
      return false;
    }
    // Reconcile from the canonical store (server-authoritative).
    final current = _store.current(userId);
    if (current != null) _mutateRow(userId, (_) => current);
    return true;
  }

  ViewerRelationship? _rowRelationship(String userId) {
    final s = state;
    if (s is FollowListLoaded) {
      for (final r in s.rows) {
        if (r.user.id == userId) return r.relationship;
      }
    }
    return _store.current(userId);
  }

  void _mutateRow(
    String userId,
    ViewerRelationship Function(ViewerRelationship current) mutator,
  ) {
    final s = state;
    if (s is! FollowListLoaded) return;
    emit(
      s.copyWith(
        rows: [
          for (final r in s.rows)
            if (r.user.id == userId)
              r.copyWith(relationship: mutator(r.relationship))
            else
              r,
        ],
      ),
    );
  }
}
