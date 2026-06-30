import 'package:flutter/material.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/presentation/wordmark.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Generic nav-less placeholder for pre-auth + flow routes whose real screens
/// land in later specs (#003+). Shows a back affordance + title + wordmark.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.title,
    this.showBack = true,
    super.key,
  });

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: title,
              onBack: showBack ? () => Navigator.of(context).maybePop() : null,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Wordmark(fontSize: 34),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      style: AppTypography.body16.copyWith(
                        color: tokens.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
