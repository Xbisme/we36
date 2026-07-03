import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';

part 'explore_item.freezed.dart';
part 'explore_item.g.dart';

/// Which content a discovery-grid cell carries.
enum ExploreItemKind { post, reel }

/// One cell of a discovery grid (Explore, hashtag page, place page): a kind-tagged
/// [Post] or [Reel] (#009, B#009 `ExploreItemDto`). Exactly one of [post]/[reel]
/// is set, matching [kind], so the tile renders the right cell and can navigate
/// into the full item. Reuses the shipped #004 [Post] / #008 [Reel] models
/// unchanged (Constitution XI, core→core).
@freezed
abstract class ExploreItem with _$ExploreItem {
  const factory ExploreItem({
    required ExploreItemKind kind,
    Post? post,
    Reel? reel,
  }) = _ExploreItem;

  const ExploreItem._();

  factory ExploreItem.fromJson(Map<String, dynamic> json) =>
      _$ExploreItemFromJson(json);

  /// True when this cell is a reel (drives the reels marker glyph).
  bool get isReel => kind == ExploreItemKind.reel;

  /// The underlying post/reel id (stable per cell).
  String get id => (isReel ? reel?.id : post?.id) ?? '';

  /// The content author.
  UserSummary get author =>
      isReel ? reel!.author : post!.author;

  /// The tile thumbnail delivery URL (primary post image, or the reel poster),
  /// or null when unavailable (placeholder surface).
  String? get thumbnailUrl =>
      isReel ? reel?.posterUrl : post?.primaryImageUrl;
}
