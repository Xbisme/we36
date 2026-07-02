import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/reels/reels_remote_data_source.dart';
import 'package:we36/core/data/reels/reels_repository_impl.dart';
import 'package:we36/core/domain/result.dart';

class _MockRemote extends Mock implements ReelsRemoteDataSource {}

/// Builds a reel whose single video is either still transcoding or ready.
Reel _reel({required bool ready}) => Reel(
  id: 'reel-1',
  author: const UserSummary(id: 'user-you', isVerified: false, username: 'you'),
  video: Media(
    id: 'm',
    kind: MediaKind.video,
    status: ready ? MediaStatus.ready : MediaStatus.processing,
    width: 720,
    height: 1280,
    variants: ready
        ? {
            'renditions': [
              {'url': 'https://cdn.example/reel-1/720p.mp4'},
            ],
            'poster': {'url': 'https://cdn.example/reel-1/poster.jpg'},
          }
        : null,
  ),
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 0,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  isVideoReady: ready,
  createdAt: DateTime.utc(2026, 7, 2),
);

void main() {
  late AppDatabase db;
  late _MockRemote remote;
  late ReelsRepositoryImpl repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    remote = _MockRemote();
    repo = ReelsRepositoryImpl(remote, db)
      // Zero interval keeps the background reconciliation loop instant in tests.
      ..pollInterval = Duration.zero
      ..pollMaxAttempts = 10;
  });
  tearDown(() => db.close());

  void stubCreate(Reel reel) => when(
    () => remote.create(videoMediaId: 'm', clientKey: 'k'),
  ).thenAnswer((_) async => Result<Reel>.ok(reel));

  Future<Reel?> topReel() async {
    final feed = await repo.watchReelsFeed().first;
    return feed.isEmpty ? null : feed.first;
  }

  Future<void> pumpUntilReady() async {
    for (var i = 0; i < 100; i++) {
      if ((await topReel())?.isVideoReady ?? false) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('createReel inserts the processing reel immediately, then reconciles to '
      'ready by polling GET /reels/:id', () async {
    stubCreate(_reel(ready: false));
    // First poll still processing; second poll returns the ready reel.
    var polls = 0;
    when(() => remote.getReel('reel-1')).thenAnswer((_) async {
      polls++;
      return Result<Reel>.ok(_reel(ready: polls >= 2));
    });

    final result = await repo.createReel(videoMediaId: 'm', clientKey: 'k');
    expect(result.isOk, isTrue);

    // Optimistic insert is visible right away, still processing (no playable URL).
    final optimistic = await topReel();
    expect(optimistic, isNotNull);
    expect(optimistic!.isVideoReady, isFalse);
    expect(optimistic.videoUrl, isNull);

    // The background poll flips it to ready and the canonical copy gains its URL.
    await pumpUntilReady();
    final reconciled = await topReel();
    expect(reconciled!.isVideoReady, isTrue);
    expect(reconciled.videoUrl, 'https://cdn.example/reel-1/720p.mp4');
    verify(() => remote.getReel('reel-1')).called(greaterThanOrEqualTo(2));
  });

  test('createReel does not poll when the video is already ready', () async {
    stubCreate(_reel(ready: true));

    final result = await repo.createReel(videoMediaId: 'm', clientKey: 'k');
    expect(result.isOk, isTrue);
    expect((await topReel())!.isVideoReady, isTrue);

    // Give any (unexpected) background loop a chance to run, then assert none did.
    await Future<void>.delayed(const Duration(milliseconds: 20));
    verifyNever(() => remote.getReel('reel-1'));
  });

  test('createReel stops polling when the video fails to process', () async {
    stubCreate(_reel(ready: false));
    when(() => remote.getReel('reel-1')).thenAnswer(
      (_) async => Result<Reel>.ok(
        _reel(ready: false).copyWith(
          video: _reel(ready: false).video.copyWith(status: MediaStatus.failed),
        ),
      ),
    );

    await repo.createReel(videoMediaId: 'm', clientKey: 'k');
    // Let the loop observe the failed status and terminate.
    await Future<void>.delayed(const Duration(milliseconds: 30));

    final row = await topReel();
    expect(row!.isVideoReady, isFalse);
    // One failed observation ends the loop — not the full attempt budget.
    verify(() => remote.getReel('reel-1')).called(1);
  });
}
