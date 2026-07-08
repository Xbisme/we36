import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/notifications/domain/usecases/notifications_usecases.dart';

/// A time-section header on the Activity feed (#013 US1) — New / This week /
/// Earlier.
class NotificationSectionHeader extends StatelessWidget {
  const NotificationSectionHeader({required this.section, super.key});

  final ActivitySection section;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final label = switch (section) {
      ActivitySection.isNew => l10n.activitySectionNew,
      ActivitySection.thisWeek => l10n.activitySectionThisWeek,
      ActivitySection.earlier => l10n.activitySectionEarlier,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Semantics(
        header: true,
        child: Text(
          label,
          style: AppTypography.label.copyWith(color: tokens.textPrimary),
        ),
      ),
    );
  }
}
