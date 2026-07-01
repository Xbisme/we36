import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/compose/domain/create_post_repository.dart';
import 'package:we36/features/compose/domain/models/media_ref.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';

/// In-memory create-post (the one that runs in `fake` mode). Synthesizes a
/// `Post` from the draft (author = the cached current user), writes it to the
/// canonical #004 `Posts` cache at feed top (FR-020), and dedupes on the
/// idempotency key so a retry never creates a duplicate (FR-018 / SC-003).
@LazySingleton(as: CreatePostRepository, env: ['fake'])
class FakeCreatePostRepository implements CreatePostRepository {
  FakeCreatePostRepository(this._db);

  final AppDatabase _db;
  final Map<String, Post> _created = {};

  static final RegExp _hashtag = RegExp(r'#(\w+)');

  @override
  Future<Result<Post>> createPost({
    required List<MediaRef> media,
    required String caption,
    required PostMetadata metadata,
    required String idempotencyKey,
  }) async {
    // Idempotency: a retry with the same key returns the same post (no dupe).
    final existing = _created[idempotencyKey];
    if (existing != null) return Result.ok(existing);

    final me = await _db.meProfileDao.get();
    final author = UserSummary(
      id: me?.id ?? 'me',
      username: me?.username ?? 'you',
      displayName: me?.displayName,
      isVerified: me?.isVerified ?? false,
    );

    final post = Post(
      id: idempotencyKey,
      author: author,
      media: [
        for (var i = 0; i < media.length; i++)
          PostMedia(
            position: i,
            media: Media(
              id: media[i].id,
              kind: MediaKind.image,
              status: MediaStatus.ready,
              width: media[i].width,
              height: media[i].height,
              variants: media[i].url == null ? null : {'display': media[i].url},
            ),
          ),
      ],
      hashtags: _hashtag.allMatches(caption).map((m) => m.group(1)!).toList(),
      taggedUsers: const [],
      commentsDisabled: metadata.commentsDisabled,
      likeCount: 0,
      saveCount: 0,
      commentCount: 0,
      viewerHasLiked: false,
      viewerHasSaved: false,
      createdAt: DateTime.now().toUtc(),
      caption: caption.isEmpty ? null : caption,
      location: metadata.location == null
          ? null
          : Place(
              id: metadata.location!.id ?? 'loc',
              name: metadata.location!.label,
            ),
    );

    await _db.postsDao.upsert(post);
    _created[idempotencyKey] = post;
    return Result.ok(post);
  }
}
