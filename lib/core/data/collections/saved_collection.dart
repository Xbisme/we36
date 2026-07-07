import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_collection.freezed.dart';
part 'saved_collection.g.dart';

/// The sentinel id of the synthetic **"All saved"** default collection (R1). It
/// is a virtual view over the canonical saved set — not a stored backend
/// collection — so it is always present and cannot be renamed or deleted.
const String kAllSavedCollectionId = 'all';

/// The max length of a collection name (spec assumption; validated on
/// create/rename — names are not required to be unique).
const int kCollectionNameMaxLength = 50;

/// One collection card on the Saved screen (#011, B#011 `SavedCollectionDto`) —
/// a named grouping of saved posts/reels, or the synthetic "All saved" default
/// ([isDefault]). Reuses no other model; the underlying saved content is the
/// shipped canonical `Post`/`Reel` (via `ExploreItem`). Cached in the drift
/// `SavedCollections` table (the one canonical collections copy, Constitution IX).
@freezed
abstract class SavedCollection with _$SavedCollection {
  const factory SavedCollection({
    required String id,
    required String name,
    required int itemCount,
    required DateTime updatedAt,
    @Default(<String>[]) List<String> coverRefs,
    @Default(false) bool isDefault,
  }) = _SavedCollection;

  const SavedCollection._();

  factory SavedCollection.fromJson(Map<String, dynamic> json) =>
      _$SavedCollectionFromJson(json);

  /// The default "All saved" view can be neither renamed, deleted, nor cover-set.
  bool get canManage => !isDefault;

  /// No saved items yet (drives the empty-cover placeholder).
  bool get isEmpty => itemCount <= 0;

  /// Cover thumbnails to render in the quilt (at most 4).
  List<String> get coverThumbnails => coverRefs.take(4).toList();
}
