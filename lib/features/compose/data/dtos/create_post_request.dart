import 'package:we36/features/compose/domain/models/post_metadata.dart';

/// Request body for `POST /posts` (B#007 seam). Isolates the wire shape so the
/// field names align to the backend contract without touching domain models.
class CreatePostRequest {
  const CreatePostRequest({
    required this.mediaIds,
    required this.caption,
    required this.metadata,
    required this.idempotencyKey,
  });

  final List<String> mediaIds;
  final String caption;
  final PostMetadata metadata;
  final String idempotencyKey;

  /// Wire body for `POST /posts`. The idempotency key travels in the
  /// `Idempotency-Key` **header** (not the body — the backend whitelists the body
  /// and rejects unknown fields). `location` uses the backend `PlaceInputDto`
  /// shape (`name` required).
  Map<String, dynamic> toJson() => {
    'mediaIds': mediaIds,
    if (caption.isNotEmpty) 'caption': caption,
    if (metadata.taggedUserIds.isNotEmpty)
      'taggedUserIds': metadata.taggedUserIds,
    if (metadata.location != null)
      'location': {'name': metadata.location!.label},
    'commentsDisabled': metadata.commentsDisabled,
  };
}
