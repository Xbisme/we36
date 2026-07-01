import 'package:flutter/material.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Loading skeleton for the initial cold load with no cache (FR-005). A few
/// neutral placeholder cards — no shimmer loop (Constitution VI Reduce-Motion).
class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({this.count = 3, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      label: context.l10n.navHome,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        itemCount: count,
        itemBuilder: (context, _) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Box(
                    width: 36,
                    height: 36,
                    radius: 18,
                    color: tokens.surface2,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _Box(width: 120, height: 12, color: tokens.surface2),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AspectRatio(
                aspectRatio: 4 / 5,
                child: _Box(color: tokens.surface2, radius: AppRadius.lg),
              ),
              const SizedBox(height: AppSpacing.sm),
              _Box(width: 160, height: 12, color: tokens.surface2),
            ],
          ),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.color,
    this.width,
    this.height,
    this.radius = 8,
  });

  final Color color;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

/// Empty state — no posts from followed accounts (FR-005/FR-006).
class FeedEmptyView extends StatelessWidget {
  const FeedEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppIcons.home, size: 40, color: tokens.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.feedEmptyTitle,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.feedEmptyBody,
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state — first load failed with no cache; offers retry (FR-005).
class FeedErrorView extends StatelessWidget {
  const FeedErrorView({
    required this.failure,
    required this.onRetry,
    super.key,
  });

  final AppFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.feedErrorTitle,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              failure.toMessage(l10n),
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: l10n.feedRetry, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
