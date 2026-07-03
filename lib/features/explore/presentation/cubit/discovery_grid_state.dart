import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'discovery_grid_state.freezed.dart';

/// Whether the grid page is a hashtag or a place (drives the surface-only Follow
/// control, which is hashtag-only).
enum DiscoveryPageKind { hashtag, place }

/// State for a hashtag/place page (#009 US4; Constitution III 4-state). The
/// header (title + post count) plus the paginated content grid.
@freezed
sealed class DiscoveryGridState with _$DiscoveryGridState {
  const DiscoveryGridState._();

  const factory DiscoveryGridState.initial() = DiscoveryGridInitial;

  const factory DiscoveryGridState.loading() = DiscoveryGridLoading;

  const factory DiscoveryGridState.loaded({
    required DiscoveryPageKind kind,
    required String title,
    required int postCount,
    required List<ExploreItem> items,
    required bool hasMore,
    @Default(false) bool loadingMore,
  }) = DiscoveryGridLoaded;

  const factory DiscoveryGridState.error(AppFailure failure) =
      DiscoveryGridError;

  List<ExploreItem> get items => switch (this) {
    DiscoveryGridLoaded(:final items) => items,
    _ => const [],
  };
}
