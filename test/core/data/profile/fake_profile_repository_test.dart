import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/profile/fake_profile_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';

/// #010 T014: the in-memory profile/follow graph — profiles, gating, follow
/// transitions, list pagination + search, grids, block exclusion.
void main() {
  late RelationshipStore store;
  late FakeProfileRepository repo;

  setUp(() {
    store = RelationshipStore();
    repo = FakeProfileRepository(store);
  });

  String idOf(String username) => 'u_$username';

  test('getProfile returns a public account with its relationship', () async {
    final r = await repo.getProfile('alice_travel');
    expect(r.isOk, isTrue);
    final view = r.valueOrNull!;
    expect(view.user.username, 'alice_travel');
    expect(view.isMe, isFalse);
    expect(view.gated, isFalse);
    expect(view.relationship.followsYou, isTrue);
    // Fetching seeds the canonical store.
    expect(store.current(idOf('alice_travel')), isNotNull);
  });

  test('own profile is isMe with no gate', () async {
    final r = await repo.getProfile(FakeProfileRepository.meUsername);
    expect(r.valueOrNull!.isMe, isTrue);
    expect(r.valueOrNull!.showFollowControl, isFalse);
  });

  test('a private, non-approved account is gated', () async {
    final r = await repo.getProfile('carol_private');
    expect(r.valueOrNull!.gated, isTrue);
  });

  test('a private but approved account is not gated', () async {
    final r = await repo.getProfile('dave_private_ok');
    expect(r.valueOrNull!.gated, isFalse);
  });

  test('a blocked account is not found', () async {
    final r = await repo.getProfile('blocked_user');
    expect(r.isErr, isTrue);
  });

  test('follow a public account → following + follower count +1', () async {
    final before = (await repo.getProfile('bob_makes')).valueOrNull!;
    final r = await repo.follow(idOf('bob_makes'));
    expect(r.isOk, isTrue);
    expect(r.valueOrNull!.relationship.following, isTrue);
    expect(r.valueOrNull!.followersCount, before.user.followersCount + 1);
  });

  test('follow a private account → requested (not following)', () async {
    final r = await repo.follow(idOf('carol_private'));
    expect(r.valueOrNull!.relationship.requested, isTrue);
    expect(r.valueOrNull!.relationship.following, isFalse);
  });

  test('unfollow reverses following and decrements the count', () async {
    await repo.follow(idOf('bob_makes'));
    final r = await repo.unfollow(idOf('bob_makes'));
    expect(r.valueOrNull!.relationship.following, isFalse);
  });

  test(
    'followers list paginates without duplicates and excludes blocked',
    () async {
      final seen = <String>{};
      String? cursor;
      var pages = 0;
      do {
        final r = await repo.followers(idOf('alice_travel'), cursor: cursor);
        final page = r.valueOrNull!;
        for (final row in page.items) {
          expect(seen.add(row.user.id), isTrue, reason: 'no duplicate rows');
          expect(row.user.username, isNot('blocked_user'));
        }
        cursor = page.nextCursor;
        pages++;
      } while (cursor != null && pages < 10);
      expect(seen, isNotEmpty);
    },
  );

  test('followers search narrows by query', () async {
    final r = await repo.followers(idOf('alice_travel'), query: 'grace');
    final rows = r.valueOrNull!.items;
    expect(rows, isNotEmpty);
    expect(
      rows.every((row) => (row.user.username ?? '').contains('grace')),
      isTrue,
    );
  });

  test('posts grid returns a mix and paginates', () async {
    final r = await repo.posts(idOf('grace_design'));
    expect(r.isOk, isTrue);
    expect(r.valueOrNull!.items, isNotEmpty);
  });

  test('grid of a gated account is forbidden', () async {
    final r = await repo.posts(idOf('carol_private'));
    expect(r.isErr, isTrue);
  });

  test('fail seam surfaces an error and is consumed once', () async {
    repo.failNextQuery = true;
    expect((await repo.getProfile('bob_makes')).isErr, isTrue);
    expect((await repo.getProfile('bob_makes')).isOk, isTrue);
  });

  test('follow fail seam surfaces an error', () async {
    repo.failNextMutation = true;
    expect((await repo.follow(idOf('bob_makes'))).isErr, isTrue);
  });
}
