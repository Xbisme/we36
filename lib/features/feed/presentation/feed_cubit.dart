import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/feed/domain/usecases/feed_usecases.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';

/// Drives the home feed (Constitution III/IX). The post list is sourced from the
/// canonical drift stream ([WatchFeed]) — the single render source — while the
/// cubit owns cursor/`hasMore` and the paginate/refresh transitions. Like/save
/// are optimistic in the repository and reflected here automatically via the
/// stream, so this cubit only reports mutation failures back for a toast.
@injectable
class FeedCubit extends Cubit<FeedState> {
  FeedCubit(
    this._watchFeed,
    this._loadFeed,
    this._loadMoreFeed,
    this._toggleLike,
    this._toggleSave,
  ) : super(const FeedState.initial());

  final WatchFeed _watchFeed;
  final LoadFeed _loadFeed;
  final LoadMoreFeed _loadMoreFeed;
  final ToggleLike _toggleLike;
  final ToggleSave _toggleSave;

  StreamSubscription<List<Post>>? _sub;
  List<Post> _latest = const [];
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;

  /// Cache-first cold start (FR-004): render cached posts instantly, then
  /// reconcile with a single background refresh.
  Future<void> loadInitial() async {
    if (_sub != null) return;
    _latest = await _watchFeed().first;
    emit(
      _latest.isEmpty
          ? const FeedState.loading()
          : FeedState.loaded(_latest, hasMore: _hasMore),
    );
    _sub = _watchFeed().listen(_onData);
    await _fetchFirstPage();
  }

  /// Passive cache updates (optimistic like/save, background refresh) repaint
  /// only while idle in a loaded state; controlled transitions emit themselves.
  void _onData(List<Post> posts) {
    _latest = posts;
    if (state is FeedLoaded) {
      emit(FeedState.loaded(posts, hasMore: _hasMore));
    }
  }

  Future<void> _fetchFirstPage() async {
    final result = await _loadFeed();
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      _latest = await _watchFeed().first;
      emit(FeedState.loaded(_latest, hasMore: _hasMore));
    } else if (_latest.isEmpty) {
      // No cache to fall back on → surface the error with retry (FR-005).
      emit(FeedState.error(result.failureOrNull!));
    } else {
      // Cache present → serve it, surface the refresh failure quietly.
      emit(FeedState.loaded(_latest, hasMore: _hasMore));
    }
  }

  /// Re-attempt the first page from the error state (FR-005).
  Future<void> retry() async {
    emit(const FeedState.loading());
    await _fetchFirstPage();
  }

  /// Pull-to-refresh (FR-003): reload from the top; a failed refresh quietly
  /// keeps the cache.
  Future<void> refresh() async {
    emit(FeedState.loadedRefreshing(_latest, hasMore: _hasMore));
    final result = await _loadFeed();
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
    }
    _latest = await _watchFeed().first;
    emit(FeedState.loaded(_latest, hasMore: _hasMore));
  }

  /// Infinite scroll (FR-002): append the next page; soft-fail keeps items.
  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null) return;
    if (state is! FeedLoaded) return;
    _busy = true;
    emit(FeedState.loadedPaginating(_latest, hasMore: _hasMore));
    final result = await _loadMoreFeed(_cursor!);
    if (result.isOk) {
      final page = result.valueOrNull!;
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
    }
    _latest = await _watchFeed().first;
    emit(FeedState.loaded(_latest, hasMore: _hasMore));
    _busy = false;
  }

  /// Optimistic like (US2). The repository flips the canonical post instantly
  /// (reflected via the stream) and reconciles/rolls back; the returned
  /// [Result] lets the page toast on failure.
  Future<Result<EngagementState>> toggleLike(Post post) =>
      _toggleLike(post.id, like: !post.viewerHasLiked);

  /// Optimistic save (US3).
  Future<Result<EngagementState>> toggleSave(Post post) =>
      _toggleSave(post.id, save: !post.viewerHasSaved);

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
