import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/core/data/discovery/search_recent.dart';

/// Proves the #009 discovery data slice on the deterministic fake (zero-network):
/// explore paging + cache write, search matching + block/private rules, hashtag/
/// place pages, and recents dedupe-and-promote/delete/clear.
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
  });

  tearDown(() => db.close());

  group('explore grid', () {
    test(
      'first page replaces the cache; next appends (reactive read)',
      () async {
        final first = await repo.loadExploreFirst();
        expect(first.isOk, isTrue);
        expect(first.valueOrNull!.items, hasLength(6));
        expect(first.valueOrNull!.hasMore, isTrue);

        // The cache reflects the first page.
        expect(await repo.watchExplore().first, hasLength(6));

        final next = await repo.loadExploreNext(first.valueOrNull!.nextCursor!);
        expect(next.isOk, isTrue);
        // Cache now holds both pages, in order, no duplicates.
        final cached = await repo.watchExplore().first;
        expect(cached, hasLength(12));
        expect(cached.map((e) => e.id).toSet(), hasLength(12));
      },
    );

    test('grid mixes posts and reels (reel items marked)', () async {
      await repo.loadExploreFirst();
      final items = await repo.watchExplore().first;
      expect(items.any((e) => e.kind == ExploreItemKind.reel), isTrue);
      expect(items.any((e) => e.kind == ExploreItemKind.post), isTrue);
      final reel = items.firstWhere((e) => e.isReel);
      expect(reel.reel, isNotNull);
    });

    test('failNextQuery surfaces an error and keeps the cache', () async {
      await repo.loadExploreFirst();
      repo.failNextQuery = true;
      final result = await repo.loadExploreNext('6');
      expect(result.isErr, isTrue);
      expect(await repo.watchExplore().first, hasLength(6)); // unchanged
    });
  });

  group('search', () {
    test(
      'accounts match by prefix/substring, case/accent-insensitive',
      () async {
        final r = await repo.searchAccounts('ALI'); // uppercase → alice/alicia
        final names = r.valueOrNull!.items.map((a) => a.user.username).toList();
        expect(names, containsAll(<String>['alice_travel', 'alicia_makes']));
      },
    );

    test('blocked accounts never appear', () async {
      final r = await repo.searchAccounts('blocked');
      expect(r.valueOrNull!.items, isEmpty);
    });

    test('a private account is findable by handle', () async {
      final r = await repo.searchAccounts('bob_private');
      expect(r.valueOrNull!.items.single.user.username, 'bob_private');
      expect(r.valueOrNull!.items.single.relationship.requested, isTrue);
    });

    test('tags and places match their own type only', () async {
      final tags = await repo.searchTags('sun');
      expect(tags.valueOrNull!.items.map((h) => h.tag), contains('sunset'));
      final places = await repo.searchPlaces('sun');
      expect(
        places.valueOrNull!.items.map((p) => p.name),
        contains('Sunset Beach'),
      );
    });

    test('top is a fixed blended snapshot (≤3 per type)', () async {
      final top = await repo.searchTop('s');
      final t = top.valueOrNull!;
      expect(t.accounts.length, lessThanOrEqualTo(3));
      expect(t.hashtags.length, lessThanOrEqualTo(3));
      expect(t.places.length, lessThanOrEqualTo(3));
    });
  });

  group('hashtag / place pages', () {
    test('hashtag page carries the tag + postCount + grid', () async {
      final r = await repo.hashtagPage('travel');
      expect(r.valueOrNull!.tag, 'travel');
      expect(r.valueOrNull!.postCount, greaterThan(0));
      expect(r.valueOrNull!.page.items, isNotEmpty);
    });

    test('place page carries the place identity + grid', () async {
      final r = await repo.placePage('place-da-nang');
      expect(r.valueOrNull!.name, 'Da Nang');
      expect(r.valueOrNull!.page.items, isNotEmpty);
    });
  });

  group('recents (dedupe-and-promote)', () {
    test('record promotes an existing entry instead of duplicating', () async {
      await repo.recordRecent(RecordSearchRecent.term('sunset'));
      await repo.recordRecent(RecordSearchRecent.hashtag('travel'));
      await repo.recordRecent(RecordSearchRecent.term('sunset')); // repeat

      final list = (await repo.recents()).valueOrNull!;
      expect(list, hasLength(2)); // no duplicate
      expect(list.first.term, 'sunset'); // promoted to top
    });

    test('delete removes one; clear empties all', () async {
      await repo.recordRecent(RecordSearchRecent.term('a'));
      final second = await repo.recordRecent(RecordSearchRecent.term('b'));
      await repo.deleteRecent(second.valueOrNull!.id);
      expect((await repo.recents()).valueOrNull!.map((r) => r.term), ['a']);

      await repo.clearRecents();
      expect((await repo.recents()).valueOrNull, isEmpty);
    });

    test('failNextMutation surfaces an error', () async {
      repo.failNextMutation = true;
      final r = await repo.recordRecent(RecordSearchRecent.term('x'));
      expect(r.isErr, isTrue);
    });
  });
}
