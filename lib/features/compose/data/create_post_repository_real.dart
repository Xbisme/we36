import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/compose/data/dtos/create_post_request.dart';
import 'package:we36/features/compose/domain/create_post_repository.dart';
import 'package:we36/features/compose/domain/models/media_ref.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';

/// Real seam (B#007) — never exercised while the app runs `fake`. Creates the
/// post via the shared `ApiClient` (idempotent) and writes the returned `Post`
/// into the canonical #004 `Posts` cache at feed top (FR-020). The
/// `idempotencyKey` is carried in the body for server-side dedup; header-level
/// key reuse across retries is finalized at the B#007 cutover.
@LazySingleton(as: CreatePostRepository, env: ['real'])
class RealCreatePostRepository implements CreatePostRepository {
  RealCreatePostRepository(this._api, this._db);

  final ApiClient _api;
  final AppDatabase _db;

  @override
  Future<Result<Post>> createPost({
    required List<MediaRef> media,
    required String caption,
    required PostMetadata metadata,
    required String idempotencyKey,
  }) async {
    final request = CreatePostRequest(
      mediaIds: media.map((m) => m.id).toList(),
      caption: caption,
      metadata: metadata,
      idempotencyKey: idempotencyKey,
    );
    final result = await _api.post<Post>(
      ApiEndpoints.posts,
      body: request.toJson(),
      decode: (json) => Post.fromJson(json as Map<String, dynamic>),
      idempotencyKey: idempotencyKey,
    );
    if (result.isOk) {
      await _db.postsDao.upsert(result.valueOrNull!);
    }
    return result;
  }
}
