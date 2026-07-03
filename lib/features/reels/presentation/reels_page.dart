import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/post/presentation/widgets/comment_text.dart';
import 'package:we36/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:we36/features/reels/presentation/cubit/reels_state.dart';
import 'package:we36/features/reels/presentation/playback/reel_audio_session.dart';
import 'package:we36/features/reels/presentation/playback/reel_playback_controller.dart';
import 'package:we36/features/reels/presentation/widgets/processing_badge.dart';
import 'package:we36/features/reels/presentation/widgets/reel_action_rail.dart';
import 'package:we36/features/reels/presentation/widgets/reel_comments_sheet.dart';
import 'package:we36/features/reels/presentation/widgets/reel_more_sheet.dart';
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

class _ReelsPageState extends State<ReelsPage> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  ReelPlaybackController? _playback;
  int _index = 0;
  bool _synced = false;
  bool _tabVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_playback == null) {
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      _playback = ReelPlaybackController(autoplay: !reduceMotion);
      // Honor the iOS silent switch for reel audio (FR / R3); no-op off iOS.
      unawaited(const ReelAudioSession().configureAmbient());
    }
    // The 5-tab shell is an IndexedStack, so switching tabs does NOT dispose this
    // page — go_router wraps the inactive branch in `TickerMode(enabled: false)`.
    // Track that flip to pause/resume playback, else reel audio keeps sounding
    // from the hidden tab.
    final tabVisible = TickerMode.valuesOf(context).enabled;
    if (tabVisible != _tabVisible) {
      _tabVisible = tabVisible;
      if (!tabVisible) {
        unawaited(_playback?.pauseAll());
      } else if (_synced) {
        unawaited(_playback?.resumeActive());
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause when the app leaves the foreground; resume the active reel on return
    // (only if the Reels tab is the visible one).
    if (state != AppLifecycleState.resumed) {
      unawaited(_playback?.pauseAll());
    } else if (_tabVisible && _synced) {
      unawaited(_playback?.resumeActive());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        unawaited(
          _playback?.setActive(_index.clamp(0, reels.length - 1), reels),
        );
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
    final pageView = RefreshIndicator(
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

    // Adaptive layout (FR-028): on tablet/iPad widths, center the reel in a
    // portrait 9:16 column against the dark background instead of stretching the
    // phone layout across the pane. Phones (<700) render full-bleed.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.tablet) return pageView;
        final columnWidth = (constraints.maxHeight * 9 / 16).clamp(
          0.0,
          constraints.maxWidth,
        );
        return Center(
          child: SizedBox(width: columnWidth, child: pageView),
        );
      },
    );
  }
}

/// Overlays the media surface: right-side action rail + bottom-left author +
/// caption + a processing badge. Wires like/save (optimistic via the cubit),
/// comment (bottom sheet), share/follow (surface-only Toast), and the overflow
/// (report / delete-own) — US2.
class _ReelOverlay extends StatelessWidget {
  const _ReelOverlay({required this.reel});
  final Reel reel;

  // Fake-mode ownership heuristic; real ownership resolves with session/#010.
  bool get _isOwn => reel.author.username == 'you';

  void _toast(
    BuildContext context,
    String message, {
    ToastTone tone = ToastTone.neutral,
  }) {
    getIt<ToastService>().show(context, message: message, tone: tone);
  }

  Future<void> _like(BuildContext context) async {
    final result = await context.read<ReelsCubit>().toggleLike(reel);
    if (result.isErr && context.mounted) {
      _toast(context, context.l10n.reelLikeFailed, tone: ToastTone.error);
    }
  }

  Future<void> _save(BuildContext context) async {
    final result = await context.read<ReelsCubit>().toggleSave(reel);
    if (result.isErr && context.mounted) {
      _toast(context, context.l10n.reelSaveFailed, tone: ToastTone.error);
    }
  }

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<ReelsCubit>();
    final result = await cubit.deleteReel(reel);
    if (!context.mounted) return;
    _toast(
      context,
      result.isOk ? context.l10n.reelDeleted : context.l10n.reelDeleteFailed,
      tone: result.isOk ? ToastTone.success : ToastTone.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Stack(
        children: [
          if (reel.isProcessing)
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: ProcessingBadge(),
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: AppSpacing.md,
                bottom: AppSpacing.xl,
              ),
              child: ReelActionRail(
                reel: reel,
                onLike: () => _like(context),
                onComment: () => showReelCommentsSheet(
                  context,
                  reelId: reel.id,
                  commentsDisabled: reel.commentsDisabled,
                ),
                onShare: () => _toast(context, l10n.reelShareAck),
                onSave: () => _save(context),
                onMore: () => showReelMoreSheet(
                  context,
                  isOwn: _isOwn,
                  onDeleteConfirmed: () => _delete(context),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                        if (!_isOwn) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _FollowButton(
                            onTap: () => _toast(context, l10n.reelFollowAck),
                          ),
                        ],
                      ],
                    ),
                    if (reel.caption != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      DefaultTextStyle(
                        style: const TextStyle(color: Colors.white),
                        child: CommentText(reel.caption!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Follow',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: const Text(
            'Follow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
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
