import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/features/explore/presentation/cubit/search_state.dart';

/// The Top / Accounts / Tags / Places tab bar for Search results (#009 US1,
/// Screen 18). The active tab is underlined in the brand accent.
class ResultsTabs extends StatelessWidget {
  const ResultsTabs({
    required this.active,
    required this.labels,
    required this.onSelect,
    super.key,
  });

  final SearchTab active;
  final Map<SearchTab, String> labels;
  final ValueChanged<SearchTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    // Left-aligned, intrinsic-width tabs on a divider-underlined row; the active
    // underline hugs its own label rather than spanning an equal column
    // (explore.jsx C3).
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            for (final tab in SearchTab.values) ...[
              if (tab != SearchTab.values.first) const SizedBox(width: 22),
              _Tab(
                label: labels[tab] ?? '',
                active: tab == active,
                onTap: () => onSelect(tab),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    color: active ? tokens.textPrimary : tokens.textSecondary,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Container(
                height: 2,
                color: active ? tokens.accent : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
