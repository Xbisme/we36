import 'package:freezed_annotation/freezed_annotation.dart';
// Unrestricted import: the generated `.freezed.dart` part needs the
// `$UserSummaryCopyWith` extension for the nested `requester` field.
import 'package:we36/core/data/feed/post.dart';

part 'follow_request.freezed.dart';

/// An incoming pending request to follow the private-account owner (#014, US2).
/// The owner Approves (→ the requester becomes a follower) or Declines it.
@freezed
abstract class FollowRequest with _$FollowRequest {
  const factory FollowRequest({
    required UserSummary requester,
    required DateTime requestedAt,
  }) = _FollowRequest;
}
