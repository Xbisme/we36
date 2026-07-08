import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/services/push/push_models.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:we36/features/notifications/presentation/cubit/push_permission_cubit.dart';
import 'package:we36/features/notifications/presentation/widgets/follow_back_button.dart';
import 'package:we36/features/notifications/presentation/widgets/notification_section_header.dart';
import 'package:we36/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:we36/features/notifications/presentation/widgets/push_permission_prompt.dart';

/// The Activity screen (#013, Screen 29) — the grouped, time-sectioned
/// notification feed. Nav-less pushed route (phone, from the Home-header bell) /
/// SidebarRail destination (tablet). The `NotificationsCubit` is provided by the
/// router; this page loads it on mount. Opening marks all read (FR-008); rows
/// deep-link to their target; pull-to-refresh + infinite scroll.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<NotificationsCubit>().loadInitial());
    // Contextual permission: read status on first open; the affordance (not an
    // auto-prompt) invites opt-in (FR-014).
    unawaited(context.read<PushPermissionCubit>().ensure());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: TopBar(
        title: l10n.activityTitle,
        large: true,
        // Navigator.canPop works without a GoRouter in scope (tests); the pop
        // itself routes through go_router.
        onBack: Navigator.of(context).canPop() ? () => context.pop() : null,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) => switch (state) {
            NotificationsInitial() || NotificationsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            NotificationsError() => _ErrorState(
              onRetry: context.read<NotificationsCubit>().retry,
            ),
            NotificationsLoaded(:final sections) when sections.isEmpty =>
              const _EmptyState(),
            NotificationsLoaded() => _Feed(state: state),
          },
        ),
      ),
    );
  }
}

class _Feed extends StatelessWidget {
  const _Feed({required this.state});

  final NotificationsLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    final content = RefreshIndicator(
      onRefresh: cubit.refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 400 &&
              state.hasMore &&
              !state.loadingMore) {
            unawaited(cubit.loadMore());
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<PushPermissionCubit, PushPermissionStatus>(
                builder: (context, status) =>
                    status == PushPermissionStatus.granted
                    ? const SizedBox.shrink()
                    : PushPermissionPrompt(
                        onEnable: () => unawaited(
                          context.read<PushPermissionCubit>().request(),
                        ),
                      ),
              ),
            ),
            for (final group in state.sections) ...[
              SliverToBoxAdapter(
                child: NotificationSectionHeader(section: group.section),
              ),
              SliverList.builder(
                itemCount: group.entries.length,
                itemBuilder: (context, i) {
                  final entry = group.entries[i];
                  // Follow / follow-accepted rows carry an inline follow-back
                  // (US5); follow-request rows are route-only (approval → #014).
                  final canFollowBack =
                      entry.type == NotificationType.follow ||
                      entry.type == NotificationType.followAccepted;
                  final actorId = entry.leadActor?.id;
                  return NotificationTile(
                    entry: entry,
                    onTap: () => _openTarget(context, entry),
                    trailing: canFollowBack && actorId != null
                        ? FollowBackButton(
                            onFollowBack: () => cubit.followBack(actorId),
                          )
                        : null,
                  );
                },
              ),
            ],
            if (state.loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
    // Tablet: centre the list at a comfortable reading width (design §Responsive).
    if (MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: content,
        ),
      );
    }
    return content;
  }

  /// Deep-link a tapped row to its target (Constitution X — validated).
  void _openTarget(BuildContext context, NotificationEntry entry) {
    final target = entry.target;
    // Follow / follow-accepted / follow-request / user targets → the actor's
    // profile (by handle). Request approval itself is deferred to #014 (Q1).
    if (entry.isFollowType || target?.kind == TargetKind.user) {
      final handle = entry.leadActor?.username;
      if (handle != null && handle.isNotEmpty) {
        unawaited(context.push(AppRoutes.userProfilePath(handle)));
      }
      return;
    }
    if (target == null) return; // degraded (unreachable — tile disables tap)
    // Post / reel / comment → the post detail (comment focuses its owning post).
    final postId = target.postId ?? target.id;
    if (postId.isNotEmpty) {
      unawaited(context.push(AppRoutes.postDetailPath(postId)));
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const SizedBox(height: 120),
        Text(
          l10n.activityEmptyTitle,
          textAlign: TextAlign.center,
          style: AppTypography.h3.copyWith(color: tokens.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.activityEmptyBody,
          textAlign: TextAlign.center,
          style: AppTypography.body16.copyWith(color: tokens.textSecondary),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.activityError,
            style: AppTypography.body16.copyWith(color: tokens.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(label: l10n.activityRetry, onPressed: onRetry),
        ],
      ),
    );
  }
}
