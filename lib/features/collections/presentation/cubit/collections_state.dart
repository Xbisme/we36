import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'collections_state.freezed.dart';

/// The Saved-tab collections grid (#011 US1; Constitution III 4-state). The
/// loaded state carries the cached collections list ("All saved" first) + an
/// offline hint when the background reconcile failed but the cache rendered.
@freezed
sealed class CollectionsState with _$CollectionsState {
  const CollectionsState._();

  const factory CollectionsState.initial() = CollectionsInitial;

  const factory CollectionsState.loading() = CollectionsLoading;

  const factory CollectionsState.loaded({
    required List<SavedCollection> collections,
    @Default(false) bool isOffline,
  }) = CollectionsLoaded;

  const factory CollectionsState.error(AppFailure failure) = CollectionsError;

  /// The named collections (everything except the "All saved" default).
  List<SavedCollection> get namedCollections => switch (this) {
    CollectionsLoaded(:final collections) =>
      collections.where((c) => !c.isDefault).toList(),
    _ => const [],
  };
}
