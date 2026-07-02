import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/features/reels/presentation/playback/reel_playback_controller.dart';
import 'package:we36/features/reels/presentation/playback/reel_player.dart';

/// A fake [ReelPlayer] that records play/pause/dispose without a real video.
class _FakePlayer implements ReelPlayer {
  bool initialized = false;
  bool playing = false;
  bool disposed = false;

  @override
  Future<void> initialize() async => initialized = true;
  @override
  Future<void> play() async => playing = true;
  @override
  Future<void> pause() async => playing = false;
  @override
  Future<void> setLooping({required bool looping}) async {}
  @override
  Future<void> dispose() async => disposed = true;
  @override
  bool get isInitialized => initialized;
  @override
  bool get isPlaying => playing;
  @override
  double get aspectRatio => 9 / 16;
  @override
  Widget buildView() => const SizedBox.shrink();
}

Reel _reel(int i, {bool ready = true}) => Reel(
  id: 'r$i',
  author: const UserSummary(id: 'u', username: 'you', isVerified: false),
  video: Media(
    id: 'm$i',
    kind: MediaKind.video,
    status: ready ? MediaStatus.ready : MediaStatus.processing,
    variants: ready
        ? {
            'renditions': [
              {'url': 'https://cdn.test/$i.mp4'},
            ],
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
  createdAt: DateTime.utc(2026, 7, 1, 12 - i),
);

void main() {
  final reels = List.generate(10, _reel);
  final created = <_FakePlayer>[];
  ReelPlayer factory(String url) {
    final p = _FakePlayer();
    created.add(p);
    return p;
  }

  setUp(created.clear);

  test('keeps at most (2*window + 1) players alive while scrolling', () async {
    final c = ReelPlaybackController(factory: factory);
    for (var i = 0; i < reels.length; i++) {
      await c.setActive(i, reels);
      expect(c.livePlayerCount, lessThanOrEqualTo(3)); // active ±1 (SC-002)
    }
    c.dispose();
  });

  test('only the active reel plays; others are paused (SC-003)', () async {
    final c = ReelPlaybackController(factory: factory);
    await c.setActive(1, reels);
    expect(c.playerFor(1)!.isPlaying, isTrue);
    expect(c.playerFor(0)!.isPlaying, isFalse);
    expect(c.playerFor(2)!.isPlaying, isFalse);
    c.dispose();
  });

  test('off-screen players are disposed when out of window', () async {
    final c = ReelPlaybackController(factory: factory);
    await c.setActive(0, reels);
    final firstPlayer = c.playerFor(0)! as _FakePlayer;
    await c.setActive(5, reels); // move far away
    expect(firstPlayer.disposed, isTrue);
    expect(c.playerFor(0), isNull);
    c.dispose();
  });

  test('a not-ready reel gets no player (poster shown)', () async {
    final processing = [_reel(0, ready: false), ...reels.skip(1)];
    final c = ReelPlaybackController(factory: factory);
    await c.setActive(0, processing);
    expect(c.playerFor(0), isNull);
    c.dispose();
  });

  test('autoplay:false does not play the active reel (Reduce Motion)', () async {
    final c = ReelPlaybackController(factory: factory, autoplay: false);
    await c.setActive(0, reels);
    expect(c.playerFor(0)!.isPlaying, isFalse);
    c.dispose();
  });

  test('togglePlayPause flips the active player', () async {
    final c = ReelPlaybackController(factory: factory);
    await c.setActive(0, reels);
    expect(c.playerFor(0)!.isPlaying, isTrue);
    await c.togglePlayPause();
    expect(c.playerFor(0)!.isPlaying, isFalse);
    expect(c.isPaused, isTrue);
    c.dispose();
  });
}
