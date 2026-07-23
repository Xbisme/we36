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
import 'package:we36/features/settings/presentation/cubit/close_friends_cubit.dart';

/// Close-friends management (#014 US4, FR-021/022/023): view + remove members,
/// add via a candidate picker. Feeds the stories close-friends audience (#005).
class CloseFriendsPage extends StatefulWidget {
  const CloseFriendsPage({super.key});

  @override
  State<CloseFriendsPage> createState() => _CloseFriendsPageState();
}

class _CloseFriendsPageState extends State<CloseFriendsPage> {
  StreamSubscription<AppFailure>? _errorSub;
  bool _wired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wired) return;
    _wired = true;
    final cubit = context.read<CloseFriendsCubit>();
    unawaited(cubit.load());
    _errorSub = cubit.errors.listen((_) {
      if (!mounted) return;
      getIt<ToastService>().show(
        context,
        message: context.l10n.closeFriendsUpdateFailed,
        tone: ToastTone.error,
      );
    });
  }

  @override
  void dispose() {
    unawaited(_errorSub?.cancel());
    super.dispose();
  }

  Future<void> _openPicker() async {
    final cubit = context.read<CloseFriendsCubit>();
    final candidates = (await cubit.candidates()).valueOrNull?.items ?? [];
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.tokens.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _AddPicker(candidates: candidates, cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final cubit = context.read<CloseFriendsCubit>();

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: l10n.settingsCloseFriends,
        large: true,
        onBack: () => context.pop(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => unawaited(_openPicker()),
        backgroundColor: tokens.accent,
        foregroundColor: tokens.textOnBrand,
        label: Text(l10n.closeFriendsAdd),
      ),
      body: BlocBuilder<CloseFriendsCubit, AppState<List<UserSummary>>>(
        builder: (context, state) {
          return switch (state) {
            AppLoading() || AppInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
            AppError() => Center(
              child: Text(
                l10n.closeFriendsError,
                style: AppTypography.label.copyWith(color: tokens.textPrimary),
              ),
            ),
            AppLoaded(:final data) => ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: Text(
                    l10n.closeFriendsSubtitle,
                    style: AppTypography.caption.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ),
                if (data.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Text(
                      l10n.closeFriendsEmptyBody,
                      style: AppTypography.body16.copyWith(
                        color: tokens.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...data.map(
                    (u) => _MemberRow(
                      user: u,
                      trailingLabel: l10n.closeFriendsRemove,
                      onTap: () => cubit.remove(u),
                    ),
                  ),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _AddPicker extends StatelessWidget {
  const _AddPicker({required this.candidates, required this.cubit});

  final List<UserSummary> candidates;
  final CloseFriendsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                l10n.closeFriendsAddTitle,
                style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              ),
            ),
            if (candidates.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l10n.closeFriendsPickerEmpty,
                  style: AppTypography.body16.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: candidates
                      .map(
                        (u) => _MemberRow(
                          user: u,
                          trailingLabel: l10n.closeFriendsAdd,
                          onTap: () {
                            unawaited(cubit.add(u));
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.user,
    required this.trailingLabel,
    required this.onTap,
  });

  final UserSummary user;
  final String trailingLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
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
            label: trailingLabel,
            kind: AppButtonKind.secondary,
            size: AppButtonSize.sm,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
