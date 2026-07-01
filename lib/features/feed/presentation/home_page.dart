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
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/max_width_box.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/stories_rail.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/wordmark.dart';
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
    final tokens = context.tokens;
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
                    child: _FeedList(
                      scroll: _scroll,
                      state: state,
                      dividerColor: tokens.divider,
                    ),
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
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            const Wordmark(fontSize: 24),
            const Spacer(),
            // Contextual Create entry (#007) — opens the full-screen compose
            // flow. (On tablet the Create action lives in the sidebar rail.)
            AppIconButton(
              icon: AppIcons.plus,
              semanticLabel: l10n.navCreate,
              onPressed: () => unawaited(context.push(AppRoutes.composePick)),
            ),
            // Activity + Messages are inert placeholders in #004 — they light up
            // with Notifications (#013) and Messages (#012). Unseen dot is fake.
            AppIconButton(
              icon: AppIcons.notification,
              semanticLabel: l10n.feedActivity,
              badgeCount: 2,
            ),
            AppIconButton(
              icon: AppIcons.messages,
              semanticLabel: l10n.feedMessages,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedList extends StatelessWidget {
  const _FeedList({
    required this.scroll,
    required this.state,
    required this.dividerColor,
  });

  final ScrollController scroll;
  final FeedState state;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    final posts = state.posts;
    return ListView.builder(
      controller: scroll,
      // + storiesSlot(0) + footer(last)
      itemCount: posts.length + 2,
      itemBuilder: (context, i) {
        if (i == 0) {
          return _StoriesRailSlot(dividerColor: dividerColor);
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
  const _StoriesRailSlot({required this.dividerColor});
  final Color dividerColor;

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
              seen: !r.hasUnseen,
              isYou: r.isYou,
            ),
        ];
        return Column(
          children: [
            StoriesRail(
              items: items,
              onTap: (i) {
                final reel = reels[i];
                if (reel.segments.isEmpty) return; // inert (no active story)
                final openable = reels
                    .where((r) => r.segments.isNotEmpty)
                    .toList();
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
            ),
            Divider(height: 1, color: dividerColor),
          ],
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
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
      ),
    );
  }
}
