import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'collection_detail_state.freezed.dart';

/// One collection's item grid (#011 US3; Constitution III 4-state).
@freezed
sealed class CollectionDetailState with _$CollectionDetailState {
  const factory CollectionDetailState.initial() = CollectionDetailInitial;

  const factory CollectionDetailState.loading() = CollectionDetailLoading;

  const factory CollectionDetailState.loaded({
    required List<ExploreItem> items,
    required bool hasMore,
    @Default(false) bool loadingMore,
  }) = CollectionDetailLoaded;

  const factory CollectionDetailState.error(AppFailure failure) =
      CollectionDetailError;
}
