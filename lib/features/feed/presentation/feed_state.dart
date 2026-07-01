import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'feed_state.freezed.dart';

/// Home feed state (Constitution III 4-state + extended variants prefixing the
/// base name). The post list is sourced from the canonical drift stream; the
/// cubit owns cursor/`hasMore` and the in-flight paginate/refresh flags.
@freezed
sealed class FeedState with _$FeedState {
  const FeedState._();

  /// Nothing loaded yet.
  const factory FeedState.initial() = FeedInitial;

  /// First load in flight with no cache to show.
  const factory FeedState.loading() = FeedLoading;

  /// Populated feed (idle).
  const factory FeedState.loaded(List<Post> posts, {required bool hasMore}) =
      FeedLoaded;

  /// Load-more in flight — retains the current posts.
  const factory FeedState.loadedPaginating(
    List<Post> posts, {
    required bool hasMore,
  }) = FeedLoadedPaginating;

  /// Pull-to-refresh in flight — retains the current posts.
  const factory FeedState.loadedRefreshing(
    List<Post> posts, {
    required bool hasMore,
  }) = FeedLoadedRefreshing;

  /// First load failed with no cache to fall back on.
  const factory FeedState.error(AppFailure failure) = FeedError;

  /// The posts to render (empty in non-populated states).
  List<Post> get posts => switch (this) {
    FeedLoaded(:final posts) => posts,
    FeedLoadedPaginating(:final posts) => posts,
    FeedLoadedRefreshing(:final posts) => posts,
    _ => const [],
  };

  bool get hasMore => switch (this) {
    FeedLoaded(:final hasMore) => hasMore,
    FeedLoadedPaginating(:final hasMore) => hasMore,
    FeedLoadedRefreshing(:final hasMore) => hasMore,
    _ => false,
  };

  bool get isPopulated => posts.isNotEmpty;
}
