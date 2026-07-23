import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';

/// The Posts / Saved / Tagged tab selector on a profile (#010 FR-002/003).
/// Design D1/D2: icon glyphs (grid / bookmark / tagged) rather than text labels;
/// the active tab renders in the accent color (project icon convention) and
/// carries a `textPrimary` underline. Each tab stays screen-reader-selectable.
class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    required this.active,
    required this.onSelect,
    this.includeSaved = false,
    super.key,
  });

  final ProfileTab active;
  final ValueChanged<ProfileTab> onSelect;

  /// Show the owner-only **Saved** tab (#011) — only on my own profile.
  final bool includeSaved;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        _Tab(
          icon: LucideIcons.grid3X3,
          label: l10n.profileTabPosts,
          selected: active == ProfileTab.posts,
          onTap: () => onSelect(ProfileTab.posts),
        ),
        if (includeSaved)
          _Tab(
            icon: AppIcons.save,
            label: l10n.profileTabSaved,
            selected: active == ProfileTab.saved,
            onTap: () => onSelect(ProfileTab.saved),
          ),
        _Tab(
          icon: LucideIcons.squareUserRound,
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
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? tokens.textPrimary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Center(
              child: AppIcon(icon, size: 22, active: selected),
            ),
          ),
        ),
      ),
    );
  }
}
