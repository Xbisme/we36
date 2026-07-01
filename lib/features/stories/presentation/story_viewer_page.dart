import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';
import 'package:we36/features/stories/presentation/story_viewer_cubit.dart';
import 'package:we36/features/stories/presentation/story_viewer_state.dart';

/// Navigation payload for the story viewer route (passed as go_router `extra`).
class StoryViewerArgs {
  const StoryViewerArgs({required this.reels, required this.startIndex});
  final List<StoryReel> reels;
  final int startIndex;
}

/// Full-screen, edge-to-edge story viewer (Screen 8, US5): segmented progress,
/// author header + close, tap-forward/back, press-hold to pause, optimistic like,
/// and inert "Send message"/share controls (live in #012). Seen-state persists.
class StoryViewerPage extends StatelessWidget {
  const StoryViewerPage({required this.reels, this.startIndex = 0, super.key});

  final List<StoryReel> reels;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryViewerCubit>(
      create: (_) => getIt<StoryViewerCubit>()..open(reels, startIndex),
      child: const _StoryViewerView(),
    );
  }
}

class _StoryViewerView extends StatefulWidget {
  const _StoryViewerView();

  @override
  State<_StoryViewerView> createState() => _StoryViewerViewState();
}

class _StoryViewerViewState extends State<_StoryViewerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  String? _segmentKey;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<StoryViewerCubit>().next();
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sync(context.read<StoryViewerCubit>().state);
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  /// Reconcile the progress controller with playback state. The controller
  /// always runs on real per-segment timing (`durationMs`) so auto-advance
  /// works identically under Reduce-Motion — only the *visual* sweep is
  /// suppressed there, by the segment bar rendering (FR-033).
  void _sync(StoryViewerState state) {
    final seg = state.currentSegment;
    if (seg == null) return;
    final key = '${state.reelIndex}:${state.segmentIndex}';
    if (key != _segmentKey) {
      _segmentKey = key;
      _progress
        ..stop()
        ..duration = Duration(milliseconds: seg.durationMs)
        ..value = 0;
      if (!state.paused) unawaited(_progress.forward());
      return;
    }
    if (state.paused) {
      _progress.stop();
    } else if (!_progress.isAnimating && _progress.value < 1) {
      unawaited(_progress.forward());
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<StoryViewerCubit, StoryViewerState>(
        listenWhen: (p, n) =>
            p.reelIndex != n.reelIndex ||
            p.segmentIndex != n.segmentIndex ||
            p.paused != n.paused ||
            n.closed,
        listener: (context, state) {
          if (state.closed) {
            if (state.unavailable) {
              getIt<ToastService>().show(
                context,
                message: context.l10n.storyUnavailable,
              );
            }
            if (context.canPop()) context.pop();
            return;
          }
          _sync(state);
        },
        builder: (context, state) {
          final seg = state.currentSegment;
          final reel = state.currentReel;
          if (seg == null || reel == null) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: Stack(
              children: [
                Positioned.fill(child: _StoryImage(url: seg.imageUrl)),
                // Bottom protection gradient for legibility.
                const Positioned.fill(child: _ProtectionGradient()),
                _TapZones(
                  onPrevious: context.read<StoryViewerCubit>().previous,
                  onNext: context.read<StoryViewerCubit>().next,
                  onHold: context.read<StoryViewerCubit>().pause,
                  onRelease: context.read<StoryViewerCubit>().resume,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      _SegmentBars(
                        count: reel.segments.length,
                        activeIndex: state.segmentIndex,
                        progress: _progress,
                        reduceMotion: reduceMotion,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ViewerHeader(reel: reel, segment: seg),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _ViewerFooter(liked: seg.viewerHasLiked),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StoryImage extends StatelessWidget {
  const _StoryImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    placeholder: (_, _) => const ColoredBox(color: Colors.black),
    errorWidget: (_, _, _) => const ColoredBox(color: Colors.black),
  );
}

class _ProtectionGradient extends StatelessWidget {
  const _ProtectionGradient();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [Colors.black54, Colors.transparent],
      ),
    ),
  );
}

class _SegmentBars extends StatelessWidget {
  const _SegmentBars({
    required this.count,
    required this.activeIndex,
    required this.progress,
    required this.reduceMotion,
  });

  final int count;
  final int activeIndex;
  final Animation<double> progress;

  /// When true the active bar shows as fully filled and static (no sweep) —
  /// auto-advance timing still runs underneath (FR-033).
  final bool reduceMotion;

  Widget _activeBar() {
    if (reduceMotion) {
      return const ColoredBox(color: Colors.white);
    }
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) => LinearProgressIndicator(
        value: progress.value,
        backgroundColor: Colors.white.withValues(alpha: 0.3),
        valueColor: const AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 3,
                  child: i < activeIndex
                      ? const ColoredBox(color: Colors.white)
                      : i > activeIndex
                      ? ColoredBox(color: Colors.white.withValues(alpha: 0.3))
                      : _activeBar(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ViewerHeader extends StatelessWidget {
  const _ViewerHeader({required this.reel, required this.segment});
  final StoryReel reel;
  final StorySegment segment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final time = RelativeTimeFormatter(
      labels: locale == 'vi'
          ? const RelativeTimeLabels.vi()
          : const RelativeTimeLabels.en(),
    );
    return Row(
      children: [
        Avatar(size: 32, semanticLabel: reel.username),
        const SizedBox(width: AppSpacing.sm),
        Text(
          reel.username,
          style: AppTypography.label.copyWith(color: Colors.white),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          time.format(segment.createdAt, now: DateTime.now()),
          style: AppTypography.caption.copyWith(color: Colors.white70),
        ),
        const Spacer(),
        Semantics(
          button: true,
          label: l10n.storyClose,
          child: IconButton(
            icon: const AppIcon(AppIcons.close, size: 26, color: Colors.white),
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
        ),
      ],
    );
  }
}

class _ViewerFooter extends StatelessWidget {
  const _ViewerFooter({required this.liked});
  final bool liked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          // Inert reply field — becomes live with Direct Messages (#012).
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white54),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.storySendMessage,
                style: AppTypography.body16.copyWith(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: AppIcon(
              AppIcons.like,
              size: 26,
              active: liked,
              color: liked ? Colors.redAccent : Colors.white,
            ),
            onPressed: () => context.read<StoryViewerCubit>().likeCurrent(),
          ),
          // Inert in #004 — sharing lands with DMs (#012).
          const IconButton(
            icon: AppIcon(AppIcons.share, size: 26, color: Colors.white),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class _TapZones extends StatelessWidget {
  const _TapZones({
    required this.onPrevious,
    required this.onNext,
    required this.onHold,
    required this.onRelease,
  });

  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onHold;
  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Row(
        children: [
          Expanded(
            child: _Zone(
              onTap: onPrevious,
              onHold: onHold,
              onRelease: onRelease,
            ),
          ),
          Expanded(
            flex: 2,
            child: _Zone(onTap: onNext, onHold: onHold, onRelease: onRelease),
          ),
        ],
      ),
    );
  }
}

class _Zone extends StatelessWidget {
  const _Zone({
    required this.onTap,
    required this.onHold,
    required this.onRelease,
  });

  final VoidCallback onTap;
  final VoidCallback onHold;
  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    onLongPressStart: (_) => onHold(),
    onLongPressEnd: (_) => onRelease(),
  );
}
