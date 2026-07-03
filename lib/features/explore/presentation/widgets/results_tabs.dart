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
    return Row(
      children: [
        for (final tab in SearchTab.values)
          Expanded(
            child: Semantics(
              button: true,
              selected: tab == active,
              label: labels[tab],
              excludeSemantics: true,
              child: InkWell(
                onTap: () => onSelect(tab),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Column(
                    children: [
                      Text(
                        labels[tab] ?? '',
                        style: AppTypography.label.copyWith(
                          color: tab == active
                              ? tokens.textPrimary
                              : tokens.textTertiary,
                          fontWeight: tab == active
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        height: 2,
                        width: 28,
                        color: tab == active
                            ? tokens.accent
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
