import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/stories_repository_impl.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

class _MockApi extends Mock implements ApiClient {}

/// A `GET /stories/feed` tray: one self entry (skipped — the own reel is sourced
/// from [OwnStoryStore]) and one other author whose second story is still
/// processing (no delivery URL → skipped).
const Map<String, dynamic> _trayJson = {
  'items': [
    {
      'isSelf': true,
      'hasUnseen': false,
      'author': {'id': 'me', 'username': 'me'},
      'stories': [
        {
          'id': 's-self',
          'author': {'id': 'me'},
          'media': {
            'variants': {
              'renditions': [
                {'label': 'feed', 'url': 'https://cdn/self.webp'},
              ],
            },
          },
          'createdAt': '2026-07-02T09:00:00.000Z',
        },
      ],
    },
    {
      'isSelf': false,
      'hasUnseen': true,
      'author': {'id': 'u-maya', 'username': 'maya'},
      'stories': [
        {
          'id': 's1',
          'author': {'id': 'u-maya'},
          'media': {
            'variants': {
              'renditions': [
                {'label': 'feed', 'url': 'https://cdn/maya-1.webp'},
              ],
            },
          },
          'createdAt': '2026-07-02T10:00:00.000Z',
        },
        {
          'id': 's2',
          'author': {'id': 'u-maya'},
          'media': {'status': 'processing', 'variants': null},
          'createdAt': '2026-07-02T10:05:00.000Z',
        },
      ],
    },
  ],
};

StorySegment _ownSegment() => StorySegment(
  id: 'own-1',
  authorId: 'me',
  imageUrl: ownStoryImageUrl('own-1'),
  durationMs: 5000,
  position: 0,
  createdAt: DateTime.utc(2026, 7, 2, 11),
);

void main() {
  late AppDatabase db;
  late _MockApi api;
  late OwnStoryStore ownStore;
  late StoriesRepositoryImpl repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    api = _MockApi();
    // Freeze the clock just after the seeded segment (2026-07-02 11:00Z) so the
    // 24h TTL keeps the own "Your story" reel active regardless of wall-clock —
    // otherwise this rots the moment real time passes seed + kStoryTtl.
    ownStore = OwnStoryStore(clock: () => DateTime.utc(2026, 7, 2, 12));
    repo = StoriesRepositoryImpl(db, api, ownStore);
  });
  tearDown(() => db.close());

  void stubTray(Map<String, dynamic> json) {
    when(
      () => api.get<List<StoryReel>>(
        ApiEndpoints.storiesFeed,
        decode: any(named: 'decode'),
      ),
    ).thenAnswer((inv) async {
      final decode =
          inv.namedArguments[#decode] as List<StoryReel> Function(dynamic);
      return Result<List<StoryReel>>.ok(decode(json));
    });
  }

  test('maps the backend tray to other-author reels, skipping self and '
      'still-processing segments', () async {
    stubTray(_trayJson);

    final reels = (await repo.loadReels()).valueOrNull!;

    expect(reels, hasLength(1)); // self skipped
    final maya = reels.single;
    expect(maya.isYou, isFalse);
    expect(maya.username, 'maya');
    expect(maya.hasUnseen, isTrue);
    expect(maya.segments, hasLength(1)); // processing s2 skipped
    expect(maya.segments.single.imageUrl, 'https://cdn/maya-1.webp');
  });

  test('prepends the own "Your story" reel from OwnStoryStore', () async {
    stubTray(_trayJson);
    ownStore.add(_ownSegment());

    final reels = (await repo.loadReels()).valueOrNull!;

    expect(reels, hasLength(2));
    expect(reels.first.isYou, isTrue);
    expect(reels.first.segments.single.id, 'own-1');
    expect(reels.last.username, 'maya');
  });

  test('a tray fetch failure still surfaces the own reel', () async {
    when(
      () => api.get<List<StoryReel>>(
        ApiEndpoints.storiesFeed,
        decode: any(named: 'decode'),
      ),
    ).thenAnswer(
      (_) async => const Result<List<StoryReel>>.err(AppFailure.offline()),
    );
    ownStore.add(_ownSegment());

    final result = await repo.loadReels();
    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.single.isYou, isTrue);
  });

  test('a tray failure with no own story propagates the failure', () async {
    when(
      () => api.get<List<StoryReel>>(
        ApiEndpoints.storiesFeed,
        decode: any(named: 'decode'),
      ),
    ).thenAnswer(
      (_) async => const Result<List<StoryReel>>.err(AppFailure.offline()),
    );

    expect((await repo.loadReels()).isErr, isTrue);
  });
}
