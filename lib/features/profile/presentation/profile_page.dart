import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/max_width_box.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/auth/domain/usecases/sign_out.dart';

/// My-profile placeholder: header (avatar + stats), name/bio, actions, grid.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SafeArea(
      child: MaxWidthBox(
        maxWidth: AppSpacing.profileMaxWidth,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Row(
              children: [
                Avatar(size: 88, ring: AvatarRing.unseen),
                SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Stat(value: '248', label: 'posts'),
                      _Stat(value: '38.4k', label: 'followers'),
                      _Stat(value: '312', label: 'following'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'You',
              style: AppTypography.label.copyWith(color: tokens.textPrimary),
            ),
            Text(
              'making things · sharing moments',
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Edit profile',
                    kind: AppButtonKind.secondary,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Share profile',
                    kind: AppButtonKind.secondary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: 12,
              itemBuilder: (context, i) => ColoredBox(
                color: i.isEven ? tokens.surface2 : tokens.surfaceSunken,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Temporary logout affordance (#003 US1) — relocates to Settings (#014).
            AppButton(
              label: context.l10n.authSignOut,
              kind: AppButtonKind.ghost,
              fullWidth: true,
              onPressed: () => unawaited(getIt<SignOut>().call()),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.stat.copyWith(color: tokens.textPrimary),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: tokens.textSecondary),
        ),
      ],
    );
  }
}
