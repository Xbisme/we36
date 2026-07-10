import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/settings/presentation/cubit/blocked_accounts_cubit.dart';

/// Blocked-accounts management (#014 US3, FR-016). Lists blocked users with an
/// Unblock action (optimistic; rolled-back on failure toasts).
class BlockedAccountsPage extends StatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  StreamSubscription<AppFailure>? _errorSub;
  bool _wired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wired) return;
    _wired = true;
    final cubit = context.read<BlockedAccountsCubit>();
    unawaited(cubit.load());
    _errorSub = cubit.errors.listen((_) {
      if (!mounted) return;
      getIt<ToastService>().show(
        context,
        message: context.l10n.unblockFailed,
        tone: ToastTone.error,
      );
    });
  }

  @override
  void dispose() {
    unawaited(_errorSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final cubit = context.read<BlockedAccountsCubit>();

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: l10n.blockedTitle,
        large: true,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<BlockedAccountsCubit, AppState<List<UserSummary>>>(
        builder: (context, state) {
          return switch (state) {
            AppLoading() || AppInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
            AppError() => Center(
              child: Text(
                l10n.blockedError,
                style: AppTypography.label.copyWith(color: tokens.textPrimary),
              ),
            ),
            AppLoaded(:final data) =>
              data.isEmpty
                  ? _Empty(
                      title: l10n.blockedEmpty,
                      body: l10n.blockedEmptyBody,
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) => _BlockedRow(
                        user: data[i],
                        onUnblock: () => cubit.unblock(data[i]),
                      ),
                    ),
          };
        },
      ),
    );
  }
}

class _BlockedRow extends StatelessWidget {
  const _BlockedRow({required this.user, required this.onUnblock});

  final UserSummary user;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final name = user.displayName ?? user.username ?? '';
    final handle = user.username ?? user.id;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Avatar(
            size: 44,
            image: user.avatarUrl == null
                ? null
                : NetworkImage(user.avatarUrl!),
            semanticLabel: name,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              name.isEmpty ? '@$handle' : name,
              style: AppTypography.label.copyWith(color: tokens.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppButton(
            label: l10n.unblockAction,
            kind: AppButtonKind.secondary,
            size: AppButtonSize.sm,
            onPressed: onUnblock,
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTypography.label.copyWith(color: tokens.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
