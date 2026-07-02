import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/features/reels/presentation/playback/reel_player.dart';

/// Disciplined video lifecycle for the reels feed (Constitution II, SC-002/003).
///
/// Keeps at most a small, bounded window of [ReelPlayer]s alive — the active
/// reel plus [window] neighbours in each direction — so scrolling a long feed
/// never accumulates players. Only the active reel plays (looping); every other
/// player is paused; players outside the window are disposed. A reel whose video
/// is not ready (or has no rendition) gets no player (its poster is shown).
///
/// A [ChangeNotifier] so the page can rebuild reel views as players initialize /
/// change play state.
class ReelPlaybackController extends ChangeNotifier {
  ReelPlaybackController({
    ReelPlayerFactory factory = defaultReelPlayerFactory,
    this.window = 1,
    this.autoplay = true,
  }) : _factory = factory;

  final ReelPlayerFactory _factory;

  /// Neighbours to keep initialized on each side of the active reel.
  final int window;

  /// When false (e.g. Reduce Motion), the active reel is not auto-played.
  final bool autoplay;

  final Map<int, ReelPlayer> _players = {};
  int _active = 0;
  bool _paused = false;

  /// Active feed index.
  int get activeIndex => _active;

  /// Whether the active reel is user-paused.
  bool get isPaused => _paused;

  /// Number of live players (test hook for the memory ceiling, SC-002).
  @visibleForTesting
  int get livePlayerCount => _players.length;

  /// The player for [index], or null when that reel has no video (poster shown).
  ReelPlayer? playerFor(int index) => _players[index];

  /// Move the active reel to [index] over [reels]: initialize the window,
  /// play the active (unless [autoplay] is off), pause the rest, dispose anything
  /// outside the window.
  Future<void> setActive(int index, List<Reel> reels) async {
    _active = index;
    _paused = false;
    final keep = <int>{
      for (var i = index - window; i <= index + window; i++)
        if (i >= 0 && i < reels.length) i,
    };

    // Dispose players that fell outside the window.
    final drop = _players.keys.where((i) => !keep.contains(i)).toList();
    for (final i in drop) {
      await _players.remove(i)?.dispose();
    }

    // Ensure a player exists + is initialized for each in-window playable reel.
    for (final i in keep) {
      final url = reels[i].videoUrl;
      if (url == null) continue; // processing / no rendition → poster only
      if (_players.containsKey(i)) continue;
      final player = _factory(url);
      _players[i] = player;
      await player.initialize();
      await player.setLooping(looping: true);
    }

    // Play the active reel; pause every other live player.
    for (final entry in _players.entries) {
      if (entry.key == index && autoplay) {
        await entry.value.play();
      } else {
        await entry.value.pause();
      }
    }
    notifyListeners();
  }

  /// Tap-to-toggle the active reel (FR-005).
  Future<void> togglePlayPause() async {
    final player = _players[_active];
    if (player == null) return;
    if (player.isPlaying) {
      await player.pause();
      _paused = true;
    } else {
      await player.play();
      _paused = false;
    }
    notifyListeners();
  }

  /// Pause everything (e.g. leaving the tab / sheet opened over the feed).
  Future<void> pauseAll() async {
    for (final player in _players.values) {
      await player.pause();
    }
    _paused = true;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      unawaited(player.dispose());
    }
    _players.clear();
    super.dispose();
  }
}
