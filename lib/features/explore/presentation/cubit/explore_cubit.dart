import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/features/explore/domain/usecases/explore_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/explore_state.dart';

/// Drives the Explore grid (#009 US2; Constitution II/III/IX). Items come from the
/// canonical drift stream ([WatchExplore]) — the single render source, so the grid
/// opens to cached content instantly (offline cold start) — while the cubit owns
/// cursor/`hasMore` and the paginate/refresh transitions.
@injectable
class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit(this._watch, this._loadFirst, this._loadNext)
    : super(const ExploreState.initial());

  final WatchExplore _watch;
  final LoadExploreFirst _loadFirst;
  final LoadExploreNext _loadNext;

  StreamSubscription<List<ExploreItem>>? _sub;
  List<ExploreItem> _latest = const [];
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;

  /// Cache-first cold start: render the persisted grid instantly, then reconcile
  /// with a single background refresh.
  Future<void> loadInitial() async {
    if (_sub != null) return;
    _latest = await _watch().first;
    emit(
      _latest.isEmpty
          ? const ExploreState.loading()
          : ExploreState.loaded(_latest, hasMore: _hasMore),
    );
    _sub = _watch().listen(_onData);
    await _fetchFirstPage();
  }

  void _onData(List<ExploreItem> items) {
    _latest = items;
    if (state is ExploreLoaded) {
      emit(
        (state as ExploreLoaded).copyWith(items: items, hasMore: _hasMore),
      );
    }
  }

  Future<void> _fetchFirstPage() async {
    final result = await _loadFirst();
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      _latest = await _watch().first;
      emit(ExploreState.loaded(_latest, hasMore: _hasMore));
    } else if (_latest.isEmpty) {
      emit(ExploreState.error(result.failureOrNull!));
    } else {
      // Keep the cached grid but flag offline (FR-027).
      emit(ExploreState.loaded(_latest, hasMore: _hasMore, isOffline: true));
    }
  }

  /// Re-attempt the first page from the error state.
  Future<void> retry() async {
    emit(const ExploreState.loading());
    await _fetchFirstPage();
  }

  /// Pull-to-refresh: reload from the top; a failed refresh keeps the cache.
  Future<void> refresh() async {
    final result = await _loadFirst();
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
    }
    _latest = await _watch().first;
    emit(
      ExploreState.loaded(
        _latest,
        hasMore: _hasMore,
        isOffline: result.isErr,
      ),
    );
  }

  /// Infinite scroll: append the next page; soft-fail keeps items.
  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null) return;
    if (state is! ExploreLoaded) return;
    _busy = true;
    emit((state as ExploreLoaded).copyWith(loadingMore: true));
    final result = await _loadNext(_cursor!);
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
    }
    _latest = await _watch().first;
    emit(ExploreState.loaded(_latest, hasMore: _hasMore));
    _busy = false;
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
