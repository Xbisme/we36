import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';

part 'search_recent.freezed.dart';
part 'search_recent.g.dart';

/// The kind of a recent-search entry (B#009 `SearchRecentType`). Exactly one
/// target field is set per kind.
enum SearchRecentType { term, account, hashtag, place }

/// A resolved recent-search entry (#009, B#009 `SearchRecentDto`). Newest-first,
/// capped, not paginated. Exactly one of [term]/[account]/[hashtag]/[place] is
/// set, matching [type].
@freezed
abstract class SearchRecent with _$SearchRecent {
  const factory SearchRecent({
    required String id,
    required SearchRecentType type,
    required DateTime recordedAt,
    String? term,
    UserSummary? account,
    HashtagResult? hashtag,
    Place? place,
  }) = _SearchRecent;

  factory SearchRecent.fromJson(Map<String, dynamic> json) =>
      _$SearchRecentFromJson(json);
}

/// The `POST /me/search-recents` body (B#009 `RecordSearchRecentDto`): record a
/// recent when the viewer taps a result or submits a term. Exactly one target
/// must match [type] — build via the named constructors.
class RecordSearchRecent {
  const RecordSearchRecent._({
    required this.type,
    this.term,
    this.targetUserId,
    this.tag,
    this.placeId,
  });

  factory RecordSearchRecent.term(String term) =>
      RecordSearchRecent._(type: SearchRecentType.term, term: term);
  factory RecordSearchRecent.account(String userId) => RecordSearchRecent._(
    type: SearchRecentType.account,
    targetUserId: userId,
  );
  factory RecordSearchRecent.hashtag(String tag) =>
      RecordSearchRecent._(type: SearchRecentType.hashtag, tag: tag);
  factory RecordSearchRecent.place(String placeId) =>
      RecordSearchRecent._(type: SearchRecentType.place, placeId: placeId);

  final SearchRecentType type;
  final String? term;
  final String? targetUserId;
  final String? tag;
  final String? placeId;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    if (term != null) 'term': term,
    if (targetUserId != null) 'targetUserId': targetUserId,
    if (tag != null) 'tag': tag,
    if (placeId != null) 'placeId': placeId,
  };
}
