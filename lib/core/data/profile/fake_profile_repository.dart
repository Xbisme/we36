import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/data/profile/profile_repository.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory [ProfileRepository] (`fake` env): a small self-contained social
/// graph — public/private/verified/blocked/follows-you accounts with seeded
/// posts, tagged, followers and following — so the app builds/tests zero-network
/// (Constitution VIII). Honors gating + block exclusion; seeds the canonical
/// [RelationshipStore] like the real impl. Fail seams drive rollback tests.
@LazySingleton(as: ProfileRepository, env: ['fake'])
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this._relationships) {
    _seed();
  }

  final RelationshipStore _relationships;

  /// The signed-in person's own handle (getProfile → `isMe`). Matches the fake
  /// auth backend's demo account so the own profile resolves in fake mode.
  static const String meUsername = 'demo';

  /// Test seams: fail the next read / next mutation once.
  bool failNextQuery = false;
  bool failNextMutation = false;

  static const int _pageSize = 6;

  final Map<String, User> _users = {};
  final Map<String, ViewerRelationship> _rel = {};
  final Set<String> _blocked = {};
  final Set<String> _approvedPrivate =
      {}; // private accounts the viewer may see

  void _seed() {
    // (username, verified, private, followsYou, following, approvedFollower, blocked)
    const seed = <(String, bool, bool, bool, bool, bool, bool)>[
      ('alice_travel', true, false, true, false, false, false),
      ('bob_makes', false, false, false, false, false, false),
      ('carol_private', false, true, false, false, false, false),
      ('dave_private_ok', false, true, false, true, true, false),
      ('erin_verified', true, false, true, true, false, false),
      ('frank_photos', false, false, false, false, false, false),
      ('grace_design', true, false, false, false, false, false),
      ('heidi_food', false, false, true, false, false, false),
      ('ivan_reels', false, false, false, true, false, false),
      ('judy_art', false, false, false, false, false, false),
      ('blocked_user', false, false, false, false, false, true),
    ];
    for (final (i, row) in seed.indexed) {
      final (
        username,
        verified,
        private,
        followsYou,
        following,
        approved,
        blocked,
      ) = row;
      final id = 'u_$username';
      _users[id] = User(
        id: id,
        username: username,
        displayName: _cap(username),
        isPrivate: private,
        isVerified: verified,
        followersCount: 100 + i * 37,
        followingCount: 40 + i * 11,
        postsCount: private && !approved ? 0 : 3 + i,
        bio: 'Just here for the photos.',
      );
      _rel[id] = ViewerRelationship(
        following: following,
        requested: false,
        followsYou: followsYou,
        blocking: blocked,
      );
      if (blocked) _blocked.add(id);
      if (approved) _approvedPrivate.add(id);
    }
    // The signed-in person's own account.
    _users['u_$meUsername'] = const User(
      id: 'u_$meUsername',
      username: meUsername,
      displayName: 'You',
      isPrivate: false,
      isVerified: false,
      followersCount: 220,
      followingCount: 180,
      postsCount: 12,
      bio: 'This is me.',
    );
  }

  bool _isMe(String username) => username == meUsername;

  bool _gated(User user) =>
      user.isPrivate &&
      !(_rel[user.id]?.following ?? false) &&
      !_approvedPrivate.contains(user.id);

  @override
  Future<Result<ProfileView>> getProfile(String username) async {
    if (_takeFailQuery()) return const Result.err(AppFailure.offline());
    final user = _userByHandle(username);
    if (user == null || _blocked.contains(user.id)) {
      return const Result.err(AppFailure.notFound());
    }
    final isMe = _isMe(username);
    final rel = isMe
        ? const ViewerRelationship(
            following: false,
            requested: false,
            followsYou: false,
            blocking: false,
          )
        : _rel[user.id]!;
    if (!isMe) _relationships.seed(user.id, rel);
    return Result.ok(
      ProfileView(
        user: user,
        relationship: rel,
        isMe: isMe,
        gated: !isMe && _gated(user),
      ),
    );
  }

  @override
  Future<Result<FollowResult>> follow(
    String userId, {
    String? idempotencyKey,
  }) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    final user = _users[userId];
    final cur = _rel[userId];
    if (user == null || cur == null || _blocked.contains(userId)) {
      return const Result.err(AppFailure.notFound());
    }
    // No-op if already following/requested (idempotent).
    if (!cur.following && !cur.requested) {
      _rel[userId] = user.isPrivate && !_approvedPrivate.contains(userId)
          ? cur.copyWith(requested: true)
          : cur.copyWith(following: true);
      _users[userId] = user.copyWith(
        followersCount: user.followersCount + (user.isPrivate ? 0 : 1),
      );
    }
    _relationships
      ..seed(userId, _rel[userId]!)
      ..notifyFollowChanged();
    return Result.ok(
      FollowResult(
        relationship: _rel[userId]!,
        followersCount: _users[userId]!.followersCount,
      ),
    );
  }

  @override
  Future<Result<FollowResult>> unfollow(
    String userId, {
    String? idempotencyKey,
  }) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    final user = _users[userId];
    final cur = _rel[userId];
    if (user == null || cur == null) {
      return const Result.err(AppFailure.notFound());
    }
    final wasFollowing = cur.following;
    if (cur.following || cur.requested) {
      _rel[userId] = cur.copyWith(following: false, requested: false);
      if (wasFollowing) {
        _users[userId] = user.copyWith(
          followersCount: (user.followersCount - 1).clamp(
            0,
            user.followersCount,
          ),
        );
      }
    }
    _relationships
      ..seed(userId, _rel[userId]!)
      ..notifyFollowChanged();
    return Result.ok(
      FollowResult(
        relationship: _rel[userId]!,
        followersCount: _users[userId]!.followersCount,
      ),
    );
  }

  @override
  Future<Result<CursorPage<AccountRow>>> followers(
    String userId, {
    String? cursor,
    String? query,
  }) => _accountsPage(cursor, query);

  @override
  Future<Result<CursorPage<AccountRow>>> following(
    String userId, {
    String? cursor,
    String? query,
  }) => _accountsPage(cursor, query);

  Future<Result<CursorPage<AccountRow>>> _accountsPage(
    String? cursor,
    String? query,
  ) async {
    if (_takeFailQuery()) return const Result.err(AppFailure.offline());
    final q = (query ?? '').trim().toLowerCase();
    final rows = _users.values
        .where((u) => !_blocked.contains(u.id) && u.username != meUsername)
        .where(
          (u) =>
              q.isEmpty ||
              u.username.toLowerCase().contains(q) ||
              u.displayName.toLowerCase().contains(q),
        )
        .map(
          (u) => AccountRow(
            user: UserSummary(
              id: u.id,
              username: u.username,
              displayName: u.displayName,
              avatarUrl: u.avatarUrl,
              isVerified: u.isVerified,
            ),
            relationship: _rel[u.id]!,
          ),
        )
        .toList();
    for (final row in rows) {
      _relationships.seed(row.user.id, row.relationship);
    }
    return Result.ok(_paginate(rows, cursor));
  }

  @override
  Future<Result<CursorPage<ExploreItem>>> posts(
    String userId, {
    String? cursor,
  }) => _gridPage(userId, cursor, tagged: false);

  @override
  Future<Result<CursorPage<ExploreItem>>> tagged(
    String userId, {
    String? cursor,
  }) => _gridPage(userId, cursor, tagged: true);

  Future<Result<CursorPage<ExploreItem>>> _gridPage(
    String userId,
    String? cursor, {
    required bool tagged,
  }) async {
    if (_takeFailQuery()) return const Result.err(AppFailure.offline());
    final user = _users[userId];
    if (user == null || _blocked.contains(userId)) {
      return const Result.err(AppFailure.notFound());
    }
    if (userId != 'u_$meUsername' && _gated(user)) {
      return const Result.err(AppFailure.forbidden());
    }
    final count = tagged ? 4 : user.postsCount;
    final items = List<ExploreItem>.generate(
      count,
      (i) => _item(user, i, tagged: tagged),
    );
    return Result.ok(_paginate(items, cursor));
  }

  ExploreItem _item(User author, int i, {required bool tagged}) {
    final summary = UserSummary(
      id: author.id,
      username: author.username,
      displayName: author.displayName,
      isVerified: author.isVerified,
    );
    final createdAt = DateTime.utc(2026, 7).subtract(Duration(hours: i));
    if (i.isOdd) {
      return ExploreItem(
        kind: ExploreItemKind.reel,
        reel: Reel(
          id: '${author.id}-${tagged ? 'tag' : 'reel'}-$i',
          author: summary,
          video: const Media(
            id: 'm',
            kind: MediaKind.video,
            status: MediaStatus.ready,
            width: 720,
            height: 1280,
          ),
          hashtags: const [],
          taggedUsers: const [],
          commentsDisabled: false,
          likeCount: 10 + i,
          saveCount: i,
          commentCount: i % 3,
          viewerHasLiked: false,
          viewerHasSaved: false,
          isVideoReady: true,
          createdAt: createdAt,
        ),
      );
    }
    return ExploreItem(
      kind: ExploreItemKind.post,
      post: Post(
        id: '${author.id}-${tagged ? 'tag' : 'post'}-$i',
        author: summary,
        media: const [
          PostMedia(
            position: 0,
            media: Media(
              id: 'm',
              kind: MediaKind.image,
              status: MediaStatus.ready,
              width: 1080,
              height: 1350,
            ),
          ),
        ],
        hashtags: const [],
        taggedUsers: const [],
        commentsDisabled: false,
        likeCount: 20 + i,
        saveCount: i,
        commentCount: i % 4,
        viewerHasLiked: false,
        viewerHasSaved: false,
        createdAt: createdAt,
      ),
    );
  }

  CursorPage<T> _paginate<T>(List<T> all, String? cursor) {
    final offset = int.tryParse(cursor ?? '') ?? 0;
    final slice = all.skip(offset).take(_pageSize).toList();
    final next = offset + _pageSize;
    final hasMore = next < all.length;
    return CursorPage<T>(
      items: slice,
      nextCursor: hasMore ? '$next' : null,
      hasMore: hasMore,
    );
  }

  User? _userByHandle(String username) {
    for (final u in _users.values) {
      if (u.username == username) return u;
    }
    return null;
  }

  bool _takeFailQuery() {
    if (!failNextQuery) return false;
    failNextQuery = false;
    return true;
  }

  bool _takeFailMutation() {
    if (!failNextMutation) return false;
    failNextMutation = false;
    return true;
  }

  static String _cap(String s) => s
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
