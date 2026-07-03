import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/post/presentation/cubit/comments_state.dart';
import 'package:we36/features/post/presentation/widgets/comment_input.dart';
import 'package:we36/features/post/presentation/widgets/comment_tile.dart';
import 'package:we36/features/reels/presentation/cubit/reel_comments_cubit.dart';

/// Open the reel comments as a modal bottom sheet over the (still-playing) reel
/// (#008, plan R7). Reuses the #006 comment widgets + a [ReelCommentsCubit] keyed
/// by [reelId]. When [commentsDisabled] the input is hidden (FR-015).
Future<void> showReelCommentsSheet(
  BuildContext context, {
  required String reelId,
  required bool commentsDisabled,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) {
        final cubit = getIt<ReelCommentsCubit>();
        unawaited(cubit.load(reelId));
        return cubit;
      },
      child: _ReelCommentsSheet(commentsDisabled: commentsDisabled),
    ),
  );
}

class _ReelCommentsSheet extends StatelessWidget {
  const _ReelCommentsSheet({required this.commentsDisabled});

  final bool commentsDisabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: tokens.border,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(l10n.commentsTitle, style: AppTypography.h3),
              ),
              Expanded(
                child: BlocBuilder<ReelCommentsCubit, CommentsState>(
                  builder: (context, state) =>
                      _body(context, state, scrollController),
                ),
              ),
              if (!commentsDisabled)
                _input(context)
              else
                _disabledNotice(context),
            ],
          ),
        );
      },
    );
  }

  Widget _body(
    BuildContext context,
    CommentsState state,
    ScrollController scrollController,
  ) {
    final l10n = context.l10n;
    return switch (state) {
      CommentsLoading() || CommentsInitial() => const Center(
        child: CircularProgressIndicator(),
      ),
      CommentsError() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.commentsError),
            TextButton(
              onPressed: () => context.read<ReelCommentsCubit>().retry(),
              child: Text(l10n.commentRetry),
            ),
          ],
        ),
      ),
      _ when state.comments.isEmpty => Center(child: Text(l10n.commentsEmpty)),
      _ => _list(context, state.comments, scrollController),
    };
  }

  Widget _list(
    BuildContext context,
    List<Comment> comments,
    ScrollController scrollController,
  ) {
    final cubit = context.read<ReelCommentsCubit>();
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
          unawaited(cubit.loadMore());
        }
        return false;
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: comments.length,
        itemBuilder: (context, i) {
          final c = comments[i];
          return CommentTile(
            comment: c,
            onLike: () => _run(context, () => cubit.toggleLike(c)),
            onReply: () => cubit.startReply(c),
            onMore: () => _more(context, c),
          );
        },
      ),
    );
  }

  Widget _input(BuildContext context) {
    final cubit = context.read<ReelCommentsCubit>();
    final replyContext = context.select<ReelCommentsCubit, ReplyContext?>(
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
            message: context.l10n.commentAddFailed,
            tone: ToastTone.error,
          );
        }
        return failure == null;
      },
    );
  }

  Widget _disabledNotice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        context.l10n.commentsDisabledNotice,
        textAlign: TextAlign.center,
        style: TextStyle(color: context.tokens.textSecondary),
      ),
    );
  }

  Future<void> _more(BuildContext context, Comment comment) async {
    final cubit = context.read<ReelCommentsCubit>();
    final failure = comment.isOwn
        ? await cubit.deleteComment(comment)
        : await cubit.reportComment(comment);
    if (!context.mounted) return;
    getIt<ToastService>().show(
      context,
      message: comment.isOwn
          ? (failure == null
                ? context.l10n.reelDeleted
                : context.l10n.commentDeleteFailed)
          : context.l10n.commentReported,
      tone: failure == null ? ToastTone.success : ToastTone.error,
    );
  }

  Future<void> _run(BuildContext context, Future<Object?> Function() op) async {
    final failure = await op();
    if (failure != null && context.mounted) {
      getIt<ToastService>().show(
        context,
        message: context.l10n.commentLikeFailed,
        tone: ToastTone.error,
      );
    }
  }
}
