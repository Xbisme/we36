import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/user/user.dart';

part 'profile_view.freezed.dart';
part 'profile_view.g.dart';

/// The full render model for one profile — my own or another's (#010, B#010
/// `ProfileViewDto`). Joins the shipped [User] (identity + counts) with the
/// viewer's [ViewerRelationship] (#009) and a server-authoritative [gated] flag.
/// The client never re-derives visibility; it renders what the API returns.
@freezed
abstract class ProfileView with _$ProfileView {
  const factory ProfileView({
    required User user,
    required ViewerRelationship relationship,
    @Default(false) bool isMe,
    @Default(false) bool gated,
  }) = _ProfileView;

  const ProfileView._();

  factory ProfileView.fromJson(Map<String, dynamic> json) =>
      _$ProfileViewFromJson(json);

  /// A Follow control is shown only on another person's profile (FR-012).
  bool get showFollowControl => !isMe;

  /// The content grid + connection lists are replaced by the private gate.
  bool get showPrivateGate => gated;

  /// Followers/following are navigable only when the profile is not gated (R6).
  bool get canOpenConnections => !gated;
}

/// The result of a follow/unfollow mutation (#010): the updated relationship plus
/// the viewed account's reconciled follower count (B#010 `FollowResultDto`).
@freezed
abstract class FollowResult with _$FollowResult {
  const factory FollowResult({
    required ViewerRelationship relationship,
    required int followersCount,
  }) = _FollowResult;

  factory FollowResult.fromJson(Map<String, dynamic> json) =>
      _$FollowResultFromJson(json);
}
