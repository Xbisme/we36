import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/features/reels/presentation/playback/reel_player.dart';

/// The media surface for a single reel: the playing video when ready + active
/// (unless Reduce Motion), otherwise the still poster. Tapping toggles
/// play/pause (FR-005). A processing reel shows its poster + a paused glyph; the
/// author / caption / action rail are overlaid by the page.
class ReelView extends StatelessWidget {
  const ReelView({
    required this.reel,
    required this.player,
    required this.isActive,
    required this.reduceMotion,
    required this.isPaused,
    required this.onTap,
    super.key,
  });

  final Reel reel;
  final ReelPlayer? player;
  final bool isActive;
  final bool reduceMotion;
  final bool isPaused;
  final VoidCallback onTap;

  bool get _showVideo =>
      !reduceMotion &&
      isActive &&
      reel.isVideoReady &&
      (player?.isInitialized ?? false);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Reel by ${reel.author.username ?? 'someone'}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ColoredBox(
          color: AppColors.darkBg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_showVideo)
                player!.buildView()
              else
                _Poster(url: reel.posterUrl),
              // Show a play glyph when paused or when video isn't playing.
              if (!_showVideo || isPaused)
                const Center(
                  child: _PlayGlyph(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      // Offline placeholder surface (fake mode / no delivery URL yet).
      return const ColoredBox(color: AppColors.darkSurface);
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, _) => const ColoredBox(color: AppColors.darkSurface),
      errorWidget: (_, _, _) => const ColoredBox(color: AppColors.darkSurface),
    );
  }
}

class _PlayGlyph extends StatelessWidget {
  const _PlayGlyph();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Opacity(
        opacity: 0.85,
        child: AppIcon(AppIcons.reels, color: Colors.white, size: 56),
      ),
    );
  }
}
