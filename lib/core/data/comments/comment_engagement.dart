import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_engagement.freezed.dart';
part 'comment_engagement.g.dart';

/// Returned by comment like/unlike so the client reconciles the optimistic UI
/// with server-authoritative counts (target-state, mirrors the feed
/// `EngagementState` — plan R6).
@freezed
abstract class CommentEngagement with _$CommentEngagement {
  const factory CommentEngagement({
    required int likeCount,
    required bool viewerHasLiked,
  }) = _CommentEngagement;

  factory CommentEngagement.fromJson(Map<String, dynamic> json) =>
      _$CommentEngagementFromJson(json);
}
