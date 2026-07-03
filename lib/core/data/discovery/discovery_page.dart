import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';

/// A hashtag page (#009, B#009 `HashtagPageDto`): the tag identity + total post
/// count + one cursor page of the permitted posts+reels. A single grid — no
/// Top/Recent/Reels tabs (backend returns one feed; see spec Clarifications).
class HashtagPage {
  const HashtagPage({
    required this.tag,
    required this.postCount,
    required this.page,
  });

  factory HashtagPage.fromJson(Map<String, dynamic> json) => HashtagPage(
    tag: json['tag'] as String,
    postCount: (json['postCount'] as num?)?.toInt() ?? 0,
    page: CursorPage<ExploreItem>.fromJson(json, ExploreItem.fromJson),
  );

  final String tag;
  final int postCount;
  final CursorPage<ExploreItem> page;
}

/// A place page (#009, B#009 `PlacePageDto`): place identity + details + visible
/// post count + one cursor page of the permitted content.
class PlacePage {
  const PlacePage({
    required this.id,
    required this.name,
    required this.postCount,
    required this.page,
    this.lat,
    this.lng,
  });

  factory PlacePage.fromJson(Map<String, dynamic> json) => PlacePage(
    id: json['id'] as String,
    name: json['name'] as String,
    lat: (json['lat'] as num?)?.toDouble(),
    lng: (json['lng'] as num?)?.toDouble(),
    postCount: (json['postCount'] as num?)?.toInt() ?? 0,
    page: CursorPage<ExploreItem>.fromJson(json, ExploreItem.fromJson),
  );

  final String id;
  final String name;
  final double? lat;
  final double? lng;
  final int postCount;
  final CursorPage<ExploreItem> page;
}
