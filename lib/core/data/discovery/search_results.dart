import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/feed/post.dart';

part 'search_results.freezed.dart';
part 'search_results.g.dart';

/// The viewer's relationship toward an account (#009, B#009 `RelationshipStateDto`).
/// **Read-only** in Explore & Search — it drives the Follow/Requested/Following
/// label on a result row; the actual follow/unfollow action lands in #010, which
/// may promote this to the canonical `core` follow model (flagged for reuse).
@freezed
abstract class ViewerRelationship with _$ViewerRelationship {
  const factory ViewerRelationship({
    required bool following,
    required bool requested,
    required bool followsYou,
    required bool blocking,
  }) = _ViewerRelationship;

  const ViewerRelationship._();

  factory ViewerRelationship.fromJson(Map<String, dynamic> json) =>
      _$ViewerRelationshipFromJson(json);

  /// The read-only follow label to render for this account.
  FollowLabel get label => following
      ? FollowLabel.following
      : requested
      ? FollowLabel.requested
      : FollowLabel.follow;
}

/// The read-only follow label shown on an account result row.
enum FollowLabel { follow, requested, following }

/// An account search result / recent account (#009, B#009 `AccountResultDto` ==
/// `UserListItemDto { user, relationship }`). Reuses the shipped [UserSummary].
@freezed
abstract class AccountResult with _$AccountResult {
  const factory AccountResult({
    required UserSummary user,
    required ViewerRelationship relationship,
  }) = _AccountResult;

  factory AccountResult.fromJson(Map<String, dynamic> json) =>
      _$AccountResultFromJson(json);
}

/// A hashtag search result / hashtag-page identity (B#009 `HashtagResultDto`).
@freezed
abstract class HashtagResult with _$HashtagResult {
  const factory HashtagResult({
    required String tag,
    required int postCount,
  }) = _HashtagResult;

  factory HashtagResult.fromJson(Map<String, dynamic> json) =>
      _$HashtagResultFromJson(json);
}

/// A place search result (identity only; the page carries the grid + postCount).
/// B#009 `PlaceResultDto`.
@freezed
abstract class PlaceResult with _$PlaceResult {
  const factory PlaceResult({
    required String id,
    required String name,
    double? lat,
    double? lng,
  }) = _PlaceResult;

  factory PlaceResult.fromJson(Map<String, dynamic> json) =>
      _$PlaceResultFromJson(json);
}

/// The fixed, non-paginated blended `top` search snapshot (B#009 `SearchTopDto`):
/// a few of each type ranked by match quality. "see more" switches to a
/// single-type tab (which is cursor-paginated).
@freezed
abstract class SearchTop with _$SearchTop {
  const factory SearchTop({
    required List<AccountResult> accounts,
    required List<HashtagResult> hashtags,
    required List<PlaceResult> places,
  }) = _SearchTop;

  const SearchTop._();

  factory SearchTop.fromJson(Map<String, dynamic> json) =>
      _$SearchTopFromJson(json);

  /// True when no type matched (drives the empty state).
  bool get isEmpty => accounts.isEmpty && hashtags.isEmpty && places.isEmpty;
}
