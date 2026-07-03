import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'explore_state.freezed.dart';

/// Explore grid state (#009 US2; Constitution III 4-state + extended variants).
/// The item list is sourced from the canonical drift stream; the cubit owns
/// cursor/`hasMore` and the paginate/refresh flags. `isOffline` marks a
/// cache-only render after a failed refresh.
@freezed
sealed class ExploreState with _$ExploreState {
  const ExploreState._();

  const factory ExploreState.initial() = ExploreInitial;

  const factory ExploreState.loading() = ExploreLoading;

  const factory ExploreState.loaded(
    List<ExploreItem> items, {
    required bool hasMore,
    @Default(false) bool loadingMore,
    @Default(false) bool isOffline,
  }) = ExploreLoaded;

  const factory ExploreState.error(AppFailure failure) = ExploreError;

  List<ExploreItem> get items => switch (this) {
    ExploreLoaded(:final items) => items,
    _ => const [],
  };

  bool get hasMore => switch (this) {
    ExploreLoaded(:final hasMore) => hasMore,
    _ => false,
  };
}
