import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// Compact comment-author projection (B#comments `UserSummary`). Kept distinct
/// from the feed's `UserSummary` so the comments slice does not depend on feed
/// internals (Constitution IX; plan R1).
@freezed
abstract class CommentAuthor with _$CommentAuthor {
  const factory CommentAuthor({
    required String id,
    required bool isVerified,
    String? username,
    String? displayName,
    String? avatarUrl,
  }) = _CommentAuthor;

  factory CommentAuthor.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorFromJson(json);
}

/// One entry in a post's conversation — a top-level comment (`parentId == null`)
/// or a **one-level** reply (`parentId` = the top-level ancestor). A pending
/// optimistic entry carries `pending: true` + a client `clientKey` (UUIDv7) so
/// the confirmed server entry reconciles against it (plan R6). Client-only
/// fields are not serialized.
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String postId,
    required CommentAuthor author,
    // Backend `CommentDto` names the content `body`.
    @JsonKey(name: 'body') required String text,
    required DateTime createdAt,
    required int likeCount,
    required bool viewerHasLiked,
    // Not sent by the backend — derived at render (author == current user).
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isOwn,
    @Default(0) int replyCount,
    String? parentId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool pending,
    @JsonKey(includeFromJson: false, includeToJson: false) String? clientKey,
  }) = _Comment;

  const Comment._();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  /// Maximum comment length (clarify 2026-07-02, FR-013).
  static const int maxLength = 2200;

  /// A reply attaches to a top-level ancestor.
  bool get isReply => parentId != null;
}
