import 'package:flutter/material.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// A hashtag search/recent row (#009 US1): `#` glyph + tag + post count; tap →
/// hashtag page.
class HashtagResultRow extends StatelessWidget {
  const HashtagResultRow({
    required this.result,
    required this.onTap,
    super.key,
  });

  final HashtagResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final counts = CountFormatter(Localizations.localeOf(context).toString());
    return _DiscoveryRow(
      leadingText: '#',
      title: '#${result.tag}',
      subtitle: '${counts.format(result.postCount)} ${context.l10n.postsLabel}',
      onTap: onTap,
      leadingColor: tokens.accent,
    );
  }
}

/// A place search/recent row (#009 US1): location glyph + name; tap → place page.
class PlaceResultRow extends StatelessWidget {
  const PlaceResultRow({required this.result, required this.onTap, super.key});

  final PlaceResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _DiscoveryRow(
      leadingIcon: AppIcons.location,
      title: result.name,
      onTap: onTap,
    );
  }
}

class _DiscoveryRow extends StatelessWidget {
  const _DiscoveryRow({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.leadingIcon,
    this.leadingText,
    this.leadingColor,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final String? leadingText;
  final Color? leadingColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      label: subtitle == null ? title : '$title, $subtitle',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tokens.surface2,
                  shape: BoxShape.circle,
                ),
                child: leadingText != null
                    ? Text(
                        leadingText!,
                        style: AppTypography.h3.copyWith(
                          color: leadingColor ?? tokens.textSecondary,
                        ),
                      )
                    : AppIcon(
                        leadingIcon ?? AppIcons.search,
                        size: 20,
                        color: tokens.textSecondary,
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTypography.caption.copyWith(
                          color: tokens.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
