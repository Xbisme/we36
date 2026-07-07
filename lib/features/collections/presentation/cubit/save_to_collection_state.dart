import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'save_to_collection_state.freezed.dart';

/// The Save-to-collection sheet (#011 US2; Constitution III 4-state). The loaded
/// state carries the post's membership across collections; `creating` is true
/// while a new collection is being created inline.
@freezed
sealed class SaveToCollectionState with _$SaveToCollectionState {
  const factory SaveToCollectionState.initial() = SaveToCollectionInitial;

  const factory SaveToCollectionState.loading() = SaveToCollectionLoading;

  const factory SaveToCollectionState.loaded({
    required PostCollectionsMembership membership,
    @Default(false) bool creating,
  }) = SaveToCollectionLoaded;

  const factory SaveToCollectionState.error(AppFailure failure) =
      SaveToCollectionError;
}
