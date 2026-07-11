import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:we36/core/data/api/dev_media_url.dart';

/// A single reel's video player, abstracted so `ReelPlaybackController`'s
/// lifecycle logic (Constitution II) is unit-testable without a real platform
/// video. The real implementation wraps a [VideoPlayerController]; tests supply a
/// fake via [ReelPlayerFactory].
abstract interface class ReelPlayer {
  /// Initialize the underlying video (idempotent).
  Future<void> initialize();

  /// Start / resume playback.
  Future<void> play();

  /// Pause playback.
  Future<void> pause();

  /// Loop when the video reaches the end.
  Future<void> setLooping({required bool looping});

  /// Release all resources. A player MUST always be disposed (Constitution II).
  Future<void> dispose();

  bool get isInitialized;
  bool get isPlaying;

  /// The video's intrinsic aspect ratio (defaults to portrait 9:16 pre-init).
  double get aspectRatio;

  /// Build the render surface (cover-fitted). Only called once initialized.
  Widget buildView();
}

/// Creates a [ReelPlayer] for a playable rendition [url].
typedef ReelPlayerFactory = ReelPlayer Function(String url);

/// Default factory — a real [VideoPlayerController]-backed player.
ReelPlayer defaultReelPlayerFactory(String url) => VideoReelPlayer(url);

/// Real [ReelPlayer] wrapping a [VideoPlayerController] over a network rendition.
class VideoReelPlayer implements ReelPlayer {
  VideoReelPlayer(this._url);

  final String _url;
  VideoPlayerController? _controller;

  @override
  Future<void> initialize() async {
    if (_controller != null) return;
    // Rewrite a dev `localhost` rendition URL (which may come from the drift
    // cache, bypassing the API-response interceptor) to the LAN host so the
    // video loads on a physical device. No-op in prod / when unset.
    final url = rewriteLocalhostUrl(_url, DevMediaHost.host);
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller = controller;
    await controller.initialize();
  }

  @override
  Future<void> play() async => _controller?.play();

  @override
  Future<void> pause() async => _controller?.pause();

  @override
  Future<void> setLooping({required bool looping}) async =>
      _controller?.setLooping(looping);

  @override
  Future<void> dispose() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }

  @override
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  @override
  bool get isPlaying => _controller?.value.isPlaying ?? false;

  @override
  double get aspectRatio {
    final ratio = _controller?.value.aspectRatio ?? (9 / 16);
    return ratio <= 0 ? 9 / 16 : ratio;
  }

  @override
  Widget buildView() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }
    // Cover-fill the reel viewport regardless of the source aspect ratio.
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}
