import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/presentation/action_sheet.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/slots/save_to_collection_launcher.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';
import 'package:we36/features/post/presentation/cubit/comments_state.dart';
import 'package:we36/features/post/presentation/widgets/comment_input.dart';
import 'package:we36/features/post/presentation/widgets/comment_tile.dart';

/// Post detail (Screen 14) + comments (Screen 15). Full-screen nav-less on
/// phones; the tablet two-column split lands in US6. The canonical post +
/// comment list are driven by [CommentsCubit] (reactive `commentCount`).
class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tokens.bgApp,
      appBar: TopBar(title: context.l10n.postTitle),
      body: SafeArea(
        top: false,
        child: BlocBuilder<CommentsCubit, CommentsState>(
          builder: (context, state) => switch (state) {
            CommentsInitial() || CommentsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CommentsError(:final failure) => _ErrorState(failure: failure),
            _ => const PostDetailBody(),
          },
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.failure});

  final Object failure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.commentsError, style: AppTypography.label),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: l10n.commentRetry,
            size: AppButtonSize.sm,
            onPressed: () => context.read<CommentsCubit>().retry(),
          ),
        ],
      ),
    );
  }
}

/// Loaded post-detail body: the post header, the comment list, and (US2) the
/// input. Extracted so US6 can embed it as the right pane of the tablet split.
class PostDetailBody extends StatefulWidget {
  const PostDetailBody({super.key});

  @override
  State<PostDetailBody> createState() => _PostDetailBodyState();
}

class _PostDetailBodyState extends State<PostDetailBody> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
      unawaited(context.read<CommentsCubit>().loadMore());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Comment action sheet (US5): delete own (with confirm) or report other.
  Future<void> _showActions(BuildContext context, Comment comment) async {
    final cubit = context.read<CommentsCubit>();
    final l10n = context.l10n;
    await showAppActionSheet(
      context,
      cancelLabel: l10n.commentActionsCancel,
      items: [
        if (comment.isOwn)
          ActionSheetItem(
            icon: AppIcons.close,
            label: l10n.commentDelete,
            destructive: true,
            onTap: () => unawaited(_confirmDelete(context, cubit, comment)),
          )
        else
          ActionSheetItem(
            icon: AppIcons.more,
            label: l10n.commentReport,
            onTap: () => unawaited(_report(context, cubit, comment)),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CommentsCubit cubit,
    Comment comment,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showAppDialog(
      context,
      title: l10n.commentDeleteConfirmTitle,
      body: l10n.commentDeleteConfirmBody,
      primaryLabel: l10n.commentDeleteConfirm,
      secondaryLabel: l10n.commentDeleteCancel,
      destructive: true,
    );
    if (!confirmed) return;
    final failure = await cubit.deleteComment(comment);
    if (failure != null && context.mounted) {
      getIt<ToastService>().show(
        context,
        message: l10n.commentDeleteFailed,
        tone: ToastTone.error,
      );
    }
  }

  Future<void> _report(
    BuildContext context,
    CommentsCubit cubit,
    Comment comment,
  ) async {
    final l10n = context.l10n;
    await cubit.reportComment(comment);
    if (context.mounted) {
      getIt<ToastService>().show(
        context,
        message: l10n.commentReported,
        tone: ToastTone.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final counts = CountFormatter(locale);
    final time = RelativeTimeFormatter(
      labels: locale == 'vi'
          ? const RelativeTimeLabels.vi()
          : const RelativeTimeLabels.en(),
    );
    final state = context.watch<CommentsCubit>().state;
    final post = state.post;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet/iPad: single-post two-column split (media | comments); phone:
        // pushed full-screen column with the post as the scroll header (R5/FR-018).
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
        if (!isTablet) {
          return _commentsColumn(
            context,
            counts,
            time,
            includeMediaHeader: true,
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _MediaPane(post: post, key: const Key('post-media-pane')),
            ),
            SizedBox(
              width: 400,
              child: _commentsColumn(
                context,
                counts,
                time,
                includeMediaHeader: false,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _commentsColumn(
    BuildContext context,
    CountFormatter counts,
    RelativeTimeFormatter time, {
    required bool includeMediaHeader,
  }) {
    final state = context.watch<CommentsCubit>().state;
    final post = state.post;
    final comments = state.comments;
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            controller: _scroll,
            slivers: [
              if (post != null && includeMediaHeader)
                SliverToBoxAdapter(
                  child: _PostHeader(post: post, counts: counts, time: time),
                )
              else if (post != null)
                SliverToBoxAdapter(child: _AuthorHeader(post: post)),
              if (comments.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyComments(),
                )
              else
                SliverList.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    final cubit = context.read<CommentsCubit>();
                    final c = comments[i];
                    return CommentTile(
                      comment: c,
                      onReply: () => cubit.startReply(c),
                      onLike: () => unawaited(cubit.toggleLike(c)),
                      onMore: () => unawaited(_showActions(context, c)),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            ],
          ),
        ),
        _InputArea(commentsDisabled: state.commentsDisabled),
      ],
    );
  }
}

/// The bottom input area: the composer, or a read-only notice when commenting
/// is turned off (FR-012). Delete/report actions land in US5.
class _InputArea extends StatelessWidget {
  const _InputArea({required this.commentsDisabled});
  final bool commentsDisabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    if (commentsDisabled) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: tokens.surface,
          border: Border(top: BorderSide(color: tokens.divider)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.commentsDisabledNotice,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: tokens.textSecondary,
              ),
            ),
          ),
        ),
      );
    }
    final cubit = context.read<CommentsCubit>();
    final replyContext = context.select<CommentsCubit, ReplyContext?>(
      (c) => c.state.replyContext,
    );
    return CommentInput(
      replyContext: replyContext,
      onCancelReply: cubit.cancelReply,
      onSubmit: (text) async {
        final failure = await cubit.addComment(text);
        if (failure != null && context.mounted) {
          getIt<ToastService>().show(
            context,
            message: l10n.commentAddFailed,
            tone: ToastTone.error,
          );
        }
        return failure == null;
      },
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.post,
    required this.counts,
    required this.time,
  });

  final Post post;
  final CountFormatter counts;
  final RelativeTimeFormatter time;

  ImageProvider<Object>? _image(String? url, {required int width}) {
    if (url == null || !url.startsWith('http')) return null;
    return ResizeImage(CachedNetworkImageProvider(url), width: width);
  }

  Future<void> _run(
    BuildContext context,
    Future<AppFailure?> Function() op,
    String failMessage,
  ) async {
    final failure = await op();
    if (failure != null && context.mounted) {
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
    final cubit = context.read<CommentsCubit>();
    // Full carousel for multi-photo posts (single frame for one image).
    final carousel = post.imageUrls
        .map((u) => _image(u, width: 1080))
        .whereType<ImageProvider<Object>>()
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: PostCard(
        username: post.author.username ?? post.author.displayName ?? '',
        avatar: _image(post.author.avatarUrl, width: 96),
        media: _image(post.primaryImageUrl, width: 1080),
        mediaCarousel: carousel.length > 1 ? carousel : null,
        likesText: l10n.feedLikesCount(counts.format(post.likeCount)),
        caption: post.caption ?? '',
        location: post.location?.name,
        commentsText: post.commentCount > 0
            ? l10n.feedViewAllComments(counts.format(post.commentCount))
            : null,
        timeText: time.format(post.createdAt, now: DateTime.now()),
        liked: post.viewerHasLiked,
        saved: post.viewerHasSaved,
        onLike: () => unawaited(
          _run(context, cubit.togglePostLike, l10n.commentLikeFailed),
        ),
        onSave: () => unawaited(
          _run(context, cubit.togglePostSave, l10n.commentLikeFailed),
        ),
        onSaveLongPress: () => unawaited(
          getIt<SaveToCollectionLauncher>().open(context, post.id),
        ),
        onShare: () => getIt<ToastService>().show(
          context,
          message: l10n.reelShareAck,
        ),
      ),
    );
  }
}

class _EmptyComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.commentsEmpty, style: AppTypography.label),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.commentsEmptyHint,
            style: AppTypography.caption.copyWith(color: tokens.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Left pane on tablet: the post media on a dark canvas, `contain` (Screen 14
/// `TabletPostDetail`).
class _MediaPane extends StatelessWidget {
  const _MediaPane({required this.post, super.key});
  final Post? post;

  @override
  Widget build(BuildContext context) {
    final url = post?.primaryImageUrl;
    final image = (url != null && url.startsWith('http'))
        ? CachedNetworkImageProvider(url)
        : null;
    return ColoredBox(
      color: const Color(0xFF0E0E1A),
      child: Center(
        child: image == null
            ? const SizedBox.shrink()
            : Image(image: image, fit: BoxFit.contain),
      ),
    );
  }
}

/// Compact author header for the tablet right pane (media lives in the left
/// pane, so the full `PostCard` header is omitted there).
class _AuthorHeader extends StatelessWidget {
  const _AuthorHeader({required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final avatarUrl = post.author.avatarUrl;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Avatar(
            size: 36,
            image: (avatarUrl != null && avatarUrl.startsWith('http'))
                ? CachedNetworkImageProvider(avatarUrl)
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author.username ?? post.author.displayName ?? '',
                  style: AppTypography.label.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
                if ((post.caption ?? '').isNotEmpty)
                  Text(
                    post.caption!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
