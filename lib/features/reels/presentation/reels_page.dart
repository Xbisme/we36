import 'package:flutter/material.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_dimens.dart';

/// Reels placeholder. Phone = full-bleed dark; tablet = a centered 9:16 card on
/// a dark backdrop (per ui-design-context §Responsive).
class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final card = AspectRatio(
      aspectRatio: 9 / 16,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(isTablet ? AppRadius.lg : 0),
        ),
        child: const Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(AppIcons.like, color: Colors.white),
                SizedBox(height: AppSpacing.lg),
                AppIcon(AppIcons.comment, color: Colors.white),
                SizedBox(height: AppSpacing.lg),
                AppIcon(AppIcons.share, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );

    return ColoredBox(
      color: AppColors.darkBg,
      child: SafeArea(
        child: Stack(
          children: [
            if (isTablet)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 720),
                  child: card,
                ),
              )
            else
              Positioned.fill(child: card),
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Reels',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
