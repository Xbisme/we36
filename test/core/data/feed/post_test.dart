import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';

Map<String, dynamic> _postJson(String id) => {
  'id': id,
  'author': {
    'id': 'u1',
    'username': 'maya',
    'displayName': 'Maya',
    'avatarUrl': 'https://cdn/we36/u1.jpg',
    'isVerified': true,
  },
  'media': [
    {
      'position': 0,
      'media': {
        'id': 'm1',
        'kind': 'image',
        'status': 'ready',
        'width': 800,
        'height': 1000,
        'variants': {'display': 'https://cdn/we36/m1.jpg'},
      },
    },
  ],
  'caption': 'golden hour',
  'location': null,
  'hashtags': <String>['goldenhour'],
  'taggedUsers': <dynamic>[],
  'commentsDisabled': false,
  'likeCount': 128,
  'saveCount': 4,
  'commentCount': 3,
  'viewerHasLiked': false,
  'viewerHasSaved': false,
  'createdAt': '2026-07-01T12:00:00.000Z',
};

void main() {
  group('Post JSON', () {
    test('round-trips a contract-shaped post', () {
      final post = Post.fromJson(_postJson('post-1'));
      expect(post.id, 'post-1');
      expect(post.author.username, 'maya');
      expect(post.author.isVerified, isTrue);
      expect(post.media.single.media.kind, MediaKind.image);
      expect(post.media.single.media.status, MediaStatus.ready);
      expect(post.likeCount, 128);
      expect(post.viewerHasLiked, isFalse);
      expect(post.createdAt.isUtc, isTrue);

      // toJson → fromJson is stable.
      final again = Post.fromJson(post.toJson());
      expect(again, post);
    });

    test('primaryImageUrl resolves the first ready image display variant', () {
      final post = Post.fromJson(_postJson('post-2'));
      expect(post.primaryImageUrl, 'https://cdn/we36/m1.jpg');
    });

    test(
      'primaryImageUrl is null when the first media is still processing',
      () {
        final json = _postJson('post-3');
        final firstMedia =
            (json['media']! as List).first as Map<String, dynamic>;
        (firstMedia['media']! as Map<String, dynamic>)['status'] = 'processing';
        final post = Post.fromJson(json);
        expect(post.primaryImageUrl, isNull);
      },
    );
  });

  group('EngagementState JSON', () {
    test('round-trips', () {
      final e = EngagementState.fromJson(const {
        'postId': 'p1',
        'likeCount': 10,
        'saveCount': 2,
        'viewerHasLiked': true,
        'viewerHasSaved': false,
      });
      expect(e.postId, 'p1');
      expect(e.viewerHasLiked, isTrue);
    });
  });

  group('CursorPage<Post> malformed tolerance (FR-006)', () {
    test('skips one bad item and keeps the rest', () {
      final page = CursorPage<Post>.fromJson({
        'items': [
          _postJson('good-1'),
          {'id': 'bad', 'author': 'not-an-object'}, // malformed → skipped
          _postJson('good-2'),
        ],
        'nextCursor': 'c2',
        'hasMore': true,
      }, Post.fromJson);

      expect(page.items.map((p) => p.id), ['good-1', 'good-2']);
      expect(page.nextCursor, 'c2');
      expect(page.hasMore, isTrue);
    });
  });
}
