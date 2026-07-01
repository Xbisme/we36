import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/compose/domain/models/media_ref.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';

/// Creates a post from already-uploaded media and writes it into the canonical
/// #004 `Posts` cache (FR-020). Upload orchestration lives in the `PublishPost`
/// use case (Constitution XI — no repo→repo). Idempotent via `idempotencyKey`
/// so a retry never creates a duplicate (FR-018).
// ignore: one_member_abstracts — an interface (not a typedef) so DI can bind a real/fake impl.
abstract interface class CreatePostRepository {
  Future<Result<Post>> createPost({
    required List<MediaRef> media,
    required String caption,
    required PostMetadata metadata,
    required String idempotencyKey,
  });
}

/// Aggregate publish lifecycle event emitted by the `PublishPost` use case
/// (progress across all items → succeeded | failed).
sealed class PublishEvent {
  const PublishEvent();
}

class PublishProgress extends PublishEvent {
  const PublishProgress(this.overallFraction);
  final double overallFraction;
}

class PublishSucceeded extends PublishEvent {
  const PublishSucceeded(this.post);
  final Post post;
}

class PublishFailed extends PublishEvent {
  const PublishFailed(this.failure);
  final AppFailure failure;
}
