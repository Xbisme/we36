import 'package:flutter/material.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/compose/domain/models/filter_matrices.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';

/// Horizontal preset-filter strip (Screen 12). Each chip previews the active
/// photo under that preset's colour matrix; the selected preset carries a rose
/// border — brand colour earns its place on selection only (Constitution VI).
class FilterRow extends StatelessWidget {
  const FilterRow({
    required this.preview,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  /// Thumbnail of the active photo (each chip re-tints it via `ColorFilter`).
  final ImageProvider preview;

  final FilterPreset selected;
  final ValueChanged<FilterPreset> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: FilterPreset.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          final preset = FilterPreset.values[i];
          return _FilterChip(
            preset: preset,
            preview: preview,
            selected: preset == selected,
            label: _label(context, preset),
            onTap: () => onSelect(preset),
          );
        },
      ),
    );
  }

  static String _label(BuildContext context, FilterPreset preset) {
    final l10n = context.l10n;
    return switch (preset) {
      FilterPreset.original => l10n.composeFilterOriginal,
      FilterPreset.warm => l10n.composeFilterWarm,
      FilterPreset.lux => l10n.composeFilterLux,
      FilterPreset.mono => l10n.composeFilterMono,
      FilterPreset.fade => l10n.composeFilterFade,
    };
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.preset,
    required this.preview,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final FilterPreset preset;
  final ImageProvider preview;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Pressable(
      onTap: onTap,
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: selected ? tokens.accent : tokens.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md - 1),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    FilterMatrices.forPreset(preset),
                  ),
                  child: Image(image: preview, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: selected ? tokens.accent : tokens.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
