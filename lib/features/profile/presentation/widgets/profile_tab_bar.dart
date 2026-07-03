import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';

/// The Posts / Tagged tab selector on a profile (#010 FR-002/003). Active tab
/// carries a brand underline; each tab is a labeled, screen-reader-selectable
/// control.
class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    required this.active,
    required this.onSelect,
    super.key,
  });

  final ProfileTab active;
  final ValueChanged<ProfileTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        _Tab(
          label: l10n.profileTabPosts,
          selected: active == ProfileTab.posts,
          onTap: () => onSelect(ProfileTab.posts),
        ),
        _Tab(
          label: l10n.profileTabTagged,
          selected: active == ProfileTab.tagged,
          onTap: () => onSelect(ProfileTab.tagged),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? tokens.accent : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.label.copyWith(
                color: selected ? tokens.textPrimary : tokens.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
