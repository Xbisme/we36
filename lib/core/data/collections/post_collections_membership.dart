import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/collections/saved_collection.dart';

part 'post_collections_membership.freezed.dart';
part 'post_collections_membership.g.dart';

/// One row in the Save-to-collection picker: a collection plus whether the post
/// is currently filed in it.
@freezed
abstract class CollectionPickerRow with _$CollectionPickerRow {
  const factory CollectionPickerRow({
    required SavedCollection collection,
    required bool contains,
  }) = _CollectionPickerRow;

  factory CollectionPickerRow.fromJson(Map<String, dynamic> json) =>
      _$CollectionPickerRowFromJson(json);
}

/// The state the **Save-to-collection** sheet needs for one post (#011): whether
/// it is saved at all, and which named collections it belongs to. Drives the
/// picker checkmarks and the full-unsave confirm gate (R4 — confirm only when the
/// post is in ≥1 named collection).
@freezed
abstract class PostCollectionsMembership with _$PostCollectionsMembership {
  const factory PostCollectionsMembership({
    required String postId,
    required bool isSaved,
    @Default(<CollectionPickerRow>[]) List<CollectionPickerRow> collections,
  }) = _PostCollectionsMembership;

  const PostCollectionsMembership._();

  factory PostCollectionsMembership.fromJson(Map<String, dynamic> json) =>
      _$PostCollectionsMembershipFromJson(json);

  /// The number of **named** collections (excluding "All saved") the post is in —
  /// the full unsave confirms only when this is ≥ 1 (FR-008 / R4).
  int get namedMembershipCount =>
      collections.where((r) => r.contains && !r.collection.isDefault).length;
}
