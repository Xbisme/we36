import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/action_sheet.dart';
import 'package:we36/core/presentation/app_badge.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/max_width_box.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/slots/save_to_collection_launcher.dart';
import 'package:we36/core/presentation/stories_rail.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/wordmark.dart';
import 'package:we36/core/services/notifications/notifications_badge.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';
import 'package:we36/features/feed/presentation/widgets/feed_status_views.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';
import 'package:we36/features/stories/presentation/story_viewer_page.dart';

/// Home feed (Screen 7) — header (Wordmark + Activity + Messages) over a
/// paginated, reverse-chronological feed of [PostCard]s sourced from the
/// canonical drift stream via [FeedCubit]. Cache-first cold start, pull-to-
/// refresh, infinite scroll, empty/error states, optimistic like/save. The
/// stories rail slot above the feed is wired in #004 US4. Adaptive chrome
/// (bottom nav / sidebar rail / right rail) is provided by the AdaptiveShell.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    if (pos.pixels >= pos.maxScrollExtent - 600) {
      unawaited(context.read<FeedCubit>().loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _Header(),
          Expanded(
            child: MaxWidthBox(
              maxWidth: AppSpacing.feedMaxWidth,
              child: BlocBuilder<FeedCubit, FeedState>(
                builder: (context, state) => switch (state) {
                  FeedInitial() || FeedLoading() => const FeedSkeleton(),
                  FeedError(:final failure) => FeedErrorView(
                    failure: failure,
                    onRetry: context.read<FeedCubit>().retry,
                  ),
                  _ when state.posts.isEmpty => RefreshIndicator(
                    onRefresh: context.read<FeedCubit>().refresh,
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: const FeedEmptyView(),
                        ),
                      ),
                    ),
                  ),
                  _ => RefreshIndicator(
                    onRefresh: context.read<FeedCubit>().refresh,
                    child: _FeedList(scroll: _scroll, state: state),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    // Design B1: 52px header on a `surface` plate with a 1px bottom divider so
    // it reads as chrome above the `bgApp` feed (not blended into it).
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              const Wordmark(fontSize: 24),
              const Spacer(),
              // Contextual Create entry — a menu to compose a post / reel /
              // story (#005/#007/#008). Create is contextual, not a tab
              // (Constitution VI); on phone it lives as the header's `+`.
              AppIconButton(
                icon: AppIcons.plus,
                semanticLabel: l10n.navCreate,
                onPressed: () => unawaited(_showCreateMenu(context)),
              ),
              // Activity (Notifications, #013) — opens the Activity screen; an
              // unread state renders as a plain rose dot (design B1), never a
              // numeric badge. Streams from the core `NotificationsBadge` seam
              // (core→core, no features import; guarded for a minimal DI).
              StreamBuilder<int>(
                stream: getIt.isRegistered<NotificationsBadge>()
                    ? getIt<NotificationsBadge>().unreadCount
                    : null,
                initialData: 0,
                builder: (context, snap) {
                  final unread = snap.data ?? 0;
                  final button = AppIconButton(
                    icon: AppIcons.notification,
                    semanticLabel: l10n.feedActivity,
                    onPressed: () =>
                        unawaited(context.push(AppRoutes.notifications)),
                  );
                  if (unread == 0) return button;
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      button,
                      const Positioned(top: 8, right: 6, child: AppBadge()),
                    ],
                  );
                },
              ),
              // Messages stays an inert placeholder here — the real Messages tab
              // (#012) owns the conversation surface + its own badge.
              AppIconButton(
                icon: AppIcons.messages,
                semanticLabel: l10n.feedMessages,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contextual create menu (post / reel / story) opened from the home header.
Future<void> _showCreateMenu(BuildContext context) {
  final l10n = context.l10n;
  return showAppActionSheet(
    context,
    cancelLabel: l10n.reelComposeCancel,
    items: [
      ActionSheetItem(
        icon: AppIcons.plus,
        label: l10n.createPostLabel,
        onTap: () => unawaited(context.push(AppRoutes.composePick)),
      ),
      ActionSheetItem(
        icon: AppIcons.reels,
        label: l10n.createReelLabel,
        onTap: () => unawaited(context.push(AppRoutes.reelCompose)),
      ),
      ActionSheetItem(
        icon: AppIcons.camera,
        label: l10n.createStoryLabel,
        onTap: () => unawaited(context.push(AppRoutes.storyComposePick)),
      ),
    ],
  );
}

class _FeedList extends StatelessWidget {
  const _FeedList({required this.scroll, required this.state});

  final ScrollController scroll;
  final FeedState state;

  @override
  Widget build(BuildContext context) {
    final posts = state.posts;
    return ListView.builder(
      controller: scroll,
      // + storiesSlot(0) + footer(last)
      itemCount: posts.length + 2,
      itemBuilder: (context, i) {
        if (i == 0) {
          return const _StoriesRailSlot();
        }
        if (i == posts.length + 1) {
          return _Footer(state: state);
        }
        return _PostTile(post: posts[i - 1]);
      },
    );
  }
}

/// Stories rail above the feed (US4). Reads reels from [StoriesRailCubit];
/// tapping opens the story viewer at the tapped account. "Your story" with no
/// active segments is inert (FR-017).
class _StoriesRailSlot extends StatelessWidget {
  const _StoriesRailSlot();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesRailCubit, AppState<List<StoryReel>>>(
      builder: (context, state) {
        final reels = state.dataOrNull ?? const <StoryReel>[];
        if (reels.isEmpty) return const SizedBox.shrink();
        final l10n = context.l10n;
        final items = [
          for (final r in reels)
            StoryItem(
              label: r.isYou ? l10n.yourStory : r.username,
              image: r.avatarUrl == null || !r.avatarUrl!.startsWith('http')
                  ? null
                  : CachedNetworkImageProvider(r.avatarUrl!),
              seen: !r.hasUnseen,
              isYou: r.isYou,
            ),
        ];
        // StoriesRail renders its own `surface` plate + bottom divider, so no
        // extra Divider is added here (avoids a doubled 2px seam under the rail).
        return StoriesRail(
          items: items,
          onTap: (i) {
            final reel = reels[i];
            // "Your story" with no active segments → open the composer (#005).
            if (reel.isYou && reel.segments.isEmpty) {
              unawaited(context.push(AppRoutes.storyComposePick));
              return;
            }
            if (reel.segments.isEmpty) return; // inert (no active story)
            final openable = reels.where((r) => r.segments.isNotEmpty).toList();
            final start = openable.indexWhere(
              (r) => r.authorId == reel.authorId,
            );
            unawaited(
              context.push(
                AppRoutes.storyViewer,
                extra: StoryViewerArgs(
                  reels: openable,
                  startIndex: start < 0 ? 0 : start,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});
  final FeedState state;

  @override
  Widget build(BuildContext context) {
    if (state is FeedLoadedPaginating) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return const SizedBox(height: AppSpacing.xl);
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile({required this.post});
  final Post post;

  ImageProvider<Object>? _image(String? url, {required int width}) {
    if (url == null || !url.startsWith('http')) return null;
    return ResizeImage(CachedNetworkImageProvider(url), width: width);
  }

  Future<void> _onMutation(
    BuildContext context,
    Future<Result<EngagementState>> future,
    String failMessage,
  ) async {
    final result = await future;
    if (result.isErr && context.mounted) {
      getIt<ToastService>().show(
        context,
        message: failMessage,
        tone: ToastTone.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final counts = CountFormatter(locale);
    final time = RelativeTimeFormatter(
      labels: locale == 'vi'
          ? const RelativeTimeLabels.vi()
          : const RelativeTimeLabels.en(),
    );
    final cubit = context.read<FeedCubit>();

    return Padding(
      // Design B1 feed gutter: 8px horizontal (`12px 8px 0`).
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: PostCard(
        username: post.author.username ?? post.author.displayName ?? '',
        avatar: _image(post.author.avatarUrl, width: 96),
        media: _image(post.primaryImageUrl, width: 1080),
        mediaCarousel: post.imageUrls.length > 1
            ? post.imageUrls
                  .map((url) => _image(url, width: 1080))
                  .whereType<ImageProvider<Object>>()
                  .toList()
            : null,
        likesText: l10n.feedLikesCount(counts.format(post.likeCount)),
        caption: post.caption ?? '',
        location: post.location?.name,
        commentsText: post.commentCount > 0
            ? l10n.feedViewAllComments(counts.format(post.commentCount))
            : null,
        timeText: time.format(post.createdAt, now: DateTime.now()),
        liked: post.viewerHasLiked,
        saved: post.viewerHasSaved,
        onLike: () =>
            _onMutation(context, cubit.toggleLike(post), l10n.feedLikeFailed),
        onSave: () =>
            _onMutation(context, cubit.toggleSave(post), l10n.feedSaveFailed),
        onSaveLongPress: () => unawaited(
          getIt<SaveToCollectionLauncher>().open(context, post.id),
        ),
        onComment: () => context.push(AppRoutes.postDetailPath(post.id)),
      ),
    );
  }
}
