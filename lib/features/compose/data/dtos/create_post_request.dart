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

  Map<String, dynamic> toJson() => {
    'mediaIds': mediaIds,
    'idempotencyKey': idempotencyKey,
    if (caption.isNotEmpty) 'caption': caption,
    if (metadata.taggedUserIds.isNotEmpty)
      'taggedUserIds': metadata.taggedUserIds,
    if (metadata.location != null)
      'location': {
        'label': metadata.location!.label,
        if (metadata.location!.id != null) 'id': metadata.location!.id,
      },
    'commentsDisabled': metadata.commentsDisabled,
  };
}
