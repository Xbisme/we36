import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'reels_state.freezed.dart';

/// Reels feed state (Constitution III 4-state + extended variants prefixing the
/// base name). The reel list is sourced from the canonical drift stream; the
/// cubit owns cursor/`hasMore` and the in-flight paginate/refresh flags.
@freezed
sealed class ReelsState with _$ReelsState {
  const ReelsState._();

  const factory ReelsState.initial() = ReelsInitial;

  const factory ReelsState.loading() = ReelsLoading;

  const factory ReelsState.loaded(List<Reel> reels, {required bool hasMore}) =
      ReelsLoaded;

  const factory ReelsState.loadedPaginating(
    List<Reel> reels, {
    required bool hasMore,
  }) = ReelsLoadedPaginating;

  const factory ReelsState.loadedRefreshing(
    List<Reel> reels, {
    required bool hasMore,
  }) = ReelsLoadedRefreshing;

  const factory ReelsState.error(AppFailure failure) = ReelsError;

  /// The reels to render (empty in non-populated states).
  List<Reel> get reels => switch (this) {
    ReelsLoaded(:final reels) => reels,
    ReelsLoadedPaginating(:final reels) => reels,
    ReelsLoadedRefreshing(:final reels) => reels,
    _ => const [],
  };

  bool get hasMore => switch (this) {
    ReelsLoaded(:final hasMore) => hasMore,
    ReelsLoadedPaginating(:final hasMore) => hasMore,
    ReelsLoadedRefreshing(:final hasMore) => hasMore,
    _ => false,
  };

  bool get isPopulated => reels.isNotEmpty;
}
