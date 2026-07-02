import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:we36/features/reels/presentation/cubit/reels_state.dart';
import 'package:we36/features/reels/presentation/playback/reel_playback_controller.dart';
import 'package:we36/features/reels/presentation/widgets/reel_view.dart';

/// The Reels tab (#008, Screen 10): a full-screen vertical `PageView` of reels.
/// Only the active reel plays (via [ReelPlaybackController]); off-screen reels are
/// paused + disposed (Constitution II). Reduce Motion disables autoplay (poster +
/// tap-to-play). Empty / loading / error-retry states come from the 4-state cubit.
class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  ReelPlaybackController? _playback;
  int _index = 0;
  bool _synced = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_playback == null) {
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      _playback = ReelPlaybackController(autoplay: !reduceMotion);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _playback?.dispose();
    super.dispose();
  }

  Future<void> _onPageChanged(int index, List<Reel> reels) async {
    _index = index;
    final cubit = context.read<ReelsCubit>();
    await _playback?.setActive(index, reels);
    if (index >= reels.length - 2) {
      await cubit.loadMore();
    }
  }

  /// After the first frame with reels present, activate the first reel once.
  void _syncActive(List<Reel> reels) {
    if (_synced || reels.isEmpty) return;
    _synced = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_playback?.setActive(_index.clamp(0, reels.length - 1), reels));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return ColoredBox(
      color: AppColors.darkBg,
      child: BlocBuilder<ReelsCubit, ReelsState>(
        builder: (context, state) {
          final reels = state.reels;
          if (reels.isNotEmpty) {
            _syncActive(reels);
            return _feed(context, reels, reduceMotion);
          }
          return switch (state) {
            ReelsError(:final failure) => _ErrorState(
              onRetry: () => context.read<ReelsCubit>().retry(),
              message: failure.toString(),
            ),
            ReelsLoading() || ReelsInitial() => const _LoadingState(),
            _ => const _EmptyState(),
          };
        },
      ),
    );
  }

  Widget _feed(BuildContext context, List<Reel> reels, bool reduceMotion) {
    final playback = _playback!;
    return RefreshIndicator(
      onRefresh: () => context.read<ReelsCubit>().refresh(),
      child: AnimatedBuilder(
        animation: playback,
        builder: (context, _) {
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            onPageChanged: (i) => _onPageChanged(i, reels),
            itemBuilder: (context, i) {
              final reel = reels[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  ReelView(
                    reel: reel,
                    player: playback.playerFor(i),
                    isActive: i == playback.activeIndex,
                    reduceMotion: reduceMotion,
                    isPaused: i == playback.activeIndex && playback.isPaused,
                    onTap: playback.togglePlayPause,
                  ),
                  _ReelOverlay(reel: reel),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Bottom-left author + caption + a processing badge (US1 minimal overlay; the
/// action rail + report arrive in US2).
class _ReelOverlay extends StatelessWidget {
  const _ReelOverlay({required this.reel});
  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          if (reel.isProcessing)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _ProcessingBadge(),
              ),
            ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${reel.author.username ?? 'someone'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  if (reel.caption != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Text(
                        reel.caption!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          context.l10n.reelProcessing,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: Colors.white),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(AppIcons.reels, color: Colors.white, size: 40),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.reelsEmpty,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.reelsEmptyHint,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry, required this.message});
  final VoidCallback onRetry;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.reelsError,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.reelRetry),
          ),
        ],
      ),
    );
  }
}
