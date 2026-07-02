import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/reels/domain/usecases/reel_engagement_usecases.dart';
import 'package:we36/features/reels/domain/usecases/reel_feed_usecases.dart';
import 'package:we36/features/reels/presentation/cubit/reels_state.dart';

/// Drives the reels feed (Constitution III/IX). The reel list is sourced from the
/// canonical drift stream ([WatchReelsFeed]) — the single render source — while
/// the cubit owns cursor/`hasMore` and the paginate/refresh transitions. Like/save
/// are optimistic in the repository and reflected here automatically via the
/// stream, so this cubit only reports mutation failures back for a toast.
@injectable
class ReelsCubit extends Cubit<ReelsState> {
  ReelsCubit(
    this._watchReels,
    this._loadReels,
    this._loadMoreReels,
    this._toggleLike,
    this._toggleSave,
  ) : super(const ReelsState.initial());

  final WatchReelsFeed _watchReels;
  final LoadReels _loadReels;
  final LoadMoreReels _loadMoreReels;
  final ToggleReelLike _toggleLike;
  final ToggleReelSave _toggleSave;

  StreamSubscription<List<Reel>>? _sub;
  List<Reel> _latest = const [];
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;

  /// Cache-first cold start: render cached reels instantly, then reconcile with a
  /// single background refresh.
  Future<void> loadInitial() async {
    if (_sub != null) return;
    _latest = await _watchReels().first;
    emit(
      _latest.isEmpty
          ? const ReelsState.loading()
          : ReelsState.loaded(_latest, hasMore: _hasMore),
    );
    _sub = _watchReels().listen(_onData);
    await _fetchFirstPage();
  }

  /// Passive cache updates (optimistic like/save, processing→ready flip,
  /// background refresh) repaint only while idle in a loaded state.
  void _onData(List<Reel> reels) {
    _latest = reels;
    if (state is ReelsLoaded) {
      emit(ReelsState.loaded(reels, hasMore: _hasMore));
    }
  }

  Future<void> _fetchFirstPage() async {
    final result = await _loadReels();
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      _latest = await _watchReels().first;
      emit(ReelsState.loaded(_latest, hasMore: _hasMore));
    } else if (_latest.isEmpty) {
      emit(ReelsState.error(result.failureOrNull!));
    } else {
      emit(ReelsState.loaded(_latest, hasMore: _hasMore));
    }
  }

  /// Re-attempt the first page from the error state.
  Future<void> retry() async {
    emit(const ReelsState.loading());
    await _fetchFirstPage();
  }

  /// Pull-to-refresh: reload from the top; a failed refresh quietly keeps cache.
  Future<void> refresh() async {
    emit(ReelsState.loadedRefreshing(_latest, hasMore: _hasMore));
    final result = await _loadReels();
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
    }
    _latest = await _watchReels().first;
    emit(ReelsState.loaded(_latest, hasMore: _hasMore));
  }

  /// Infinite scroll: append the next page; soft-fail keeps items.
  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null) return;
    if (state is! ReelsLoaded) return;
    _busy = true;
    emit(ReelsState.loadedPaginating(_latest, hasMore: _hasMore));
    final result = await _loadMoreReels(_cursor!);
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
    }
    _latest = await _watchReels().first;
    emit(ReelsState.loaded(_latest, hasMore: _hasMore));
    _busy = false;
  }

  /// Optimistic like (US2). The repository flips the canonical reel instantly
  /// (reflected via the stream) and reconciles/rolls back; the returned [Result]
  /// lets the page toast on failure.
  Future<Result<EngagementState>> toggleLike(Reel reel) =>
      _toggleLike(reel.id, like: !reel.viewerHasLiked);

  /// Optimistic save (US2).
  Future<Result<EngagementState>> toggleSave(Reel reel) =>
      _toggleSave(reel.id, save: !reel.viewerHasSaved);

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
