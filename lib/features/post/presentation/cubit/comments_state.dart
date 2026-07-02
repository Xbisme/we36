import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'comments_state.freezed.dart';

/// The comment being replied to (US3). Held while composing a reply so the
/// input targets the top-level ancestor and shows a "Replying to @handle"
/// banner. `null` = composing a top-level comment.
@freezed
abstract class ReplyContext with _$ReplyContext {
  const factory ReplyContext({
    required String parentId,
    required String handle,
  }) = _ReplyContext;
}

/// Post detail + comments state (Constitution III 4-state + extended variants
/// prefixing the base name). The canonical [post] drives `PostCard` + the
/// `commentCount` (reactively via `watchPost`, so feed and detail never diverge);
/// [comments] is the flattened oldest-first display list (top-level with their
/// one-level replies interleaved, indented via [Comment.isReply]).
@freezed
sealed class CommentsState with _$CommentsState {
  const CommentsState._();

  const factory CommentsState.initial() = CommentsInitial;

  const factory CommentsState.loading() = CommentsLoading;

  const factory CommentsState.loaded({
    required Post? post,
    required List<Comment> comments,
    required bool hasMore,
    String? nextCursor,
    ReplyContext? replyContext,
  }) = CommentsLoaded;

  const factory CommentsState.loadedPaginating({
    required Post? post,
    required List<Comment> comments,
    required bool hasMore,
    String? nextCursor,
    ReplyContext? replyContext,
  }) = CommentsLoadedPaginating;

  const factory CommentsState.error(AppFailure failure) = CommentsError;

  /// The comments to render (empty in non-populated states).
  List<Comment> get comments => switch (this) {
    CommentsLoaded(:final comments) => comments,
    CommentsLoadedPaginating(:final comments) => comments,
    _ => const [],
  };

  Post? get post => switch (this) {
    CommentsLoaded(:final post) => post,
    CommentsLoadedPaginating(:final post) => post,
    _ => null,
  };

  bool get hasMore => switch (this) {
    CommentsLoaded(:final hasMore) => hasMore,
    CommentsLoadedPaginating(:final hasMore) => hasMore,
    _ => false,
  };

  ReplyContext? get replyContext => switch (this) {
    CommentsLoaded(:final replyContext) => replyContext,
    CommentsLoadedPaginating(:final replyContext) => replyContext,
    _ => null,
  };

  /// Commenting turned off on the post → hide the input (FR-012).
  bool get commentsDisabled => post?.commentsDisabled ?? false;

  bool get isPopulated => comments.isNotEmpty;
}
