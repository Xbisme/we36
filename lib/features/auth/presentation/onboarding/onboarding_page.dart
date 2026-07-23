import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_shadows.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/auth/presentation/onboarding/onboarding_cubit.dart';

/// First-launch onboarding (Group A · Screen 2): intro slides shown only once.
/// "Get started" → Sign up; "Skip" → Sign in (spec FR-028, clarification).
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final slides = [
      (l10n.onboardTitle1, l10n.onboardBody1),
      (l10n.onboardTitle2, l10n.onboardBody2),
      (l10n.onboardTitle3, l10n.onboardBody3),
    ];

    return BlocProvider<OnboardingCubit>(
      create: (_) => getIt<OnboardingCubit>(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<OnboardingCubit>();
          return Scaffold(
            backgroundColor: tokens.bgApp,
            body: SafeArea(
              child: Padding(
                // Design outer gutter: 24 horizontal, small top, roomy bottom.
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            _leave(context, cubit, AppRoutes.signIn),
                        child: Text(
                          l10n.onboardSkip,
                          style: AppTypography.label.copyWith(
                            color: tokens.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        onPageChanged: cubit.setPage,
                        itemCount: slides.length,
                        itemBuilder: (context, i) =>
                            _Slide(title: slides[i].$1, body: slides[i].$2),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    BlocBuilder<OnboardingCubit, int>(
                      builder: (context, page) =>
                          _Dots(count: slides.length, active: page),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: l10n.onboardGetStarted,
                      fullWidth: true,
                      onPressed: () => _leave(context, cubit, AppRoutes.signUp),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _leave(BuildContext context, OnboardingCubit cubit, String route) {
    unawaited(cubit.finish());
    context.go(route);
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Photo card (design-specific 240×300 / radius-24). Brand gradient
        // stands in for the hero image until media assets land.
        Container(
          width: 240,
          height: 300,
          margin: const EdgeInsets.only(bottom: AppSpacing.xxl),
          decoration: BoxDecoration(
            gradient: AppGradients.brand,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.lg,
          ),
          child: const Stack(
            children: [
              Positioned(
                left: AppSpacing.md,
                bottom: AppSpacing.md,
                child: _FloatingPill(),
              ),
            ],
          ),
        ),
        Text(
          title,
          style: AppTypography.h2.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          body,
          textAlign: TextAlign.center,
          style: AppTypography.body16.copyWith(color: tokens.textSecondary),
        ),
      ],
    );
  }
}

/// Floating glass pill on the hero card ("reels · stories · feed"). Sits on the
/// media card, so it uses a fixed white/ink pairing regardless of theme.
class _FloatingPill extends StatelessWidget {
  const _FloatingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(AppIcons.camera, size: 14, color: AppColors.ink),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'reels · stories · feed',
            style: AppTypography.label.copyWith(
              fontSize: 12,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: isActive ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: isActive ? AppGradients.brand : null,
            color: isActive ? null : tokens.borderStrong,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        );
      }),
    );
  }
}
