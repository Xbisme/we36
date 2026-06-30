import 'package:flutter/material.dart';
import 'package:we36/core/router/two_pane_scaffold.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Demonstrates the master/detail primitive: side-by-side on tablet (swap in
/// place), push on phone (SC-003).
class TwoPaneDemoPage extends StatelessWidget {
  const TwoPaneDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List<int>.generate(8, (i) => i + 1);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.devTwoPaneTitle)),
      body: TwoPaneScaffold<int>(
        items: items,
        detailTitle: (i) => 'Item $i',
        emptyDetail: _Empty(),
        listBuilder: (context, onSelect, selected) {
          final tokens = context.tokens;
          return ListView(
            children: [
              for (final i in items)
                Material(
                  color: i == selected ? tokens.accentSoft : null,
                  child: ListTile(
                    title: Text('Item $i'),
                    selected: i == selected,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          );
        },
        detailBuilder: (context, i) => Center(
          child: Text(
            'Detail of item $i',
            style: AppTypography.h3.copyWith(color: context.tokens.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.selectAnItem,
        style: AppTypography.body16.copyWith(
          color: context.tokens.textTertiary,
        ),
      ),
    );
  }
}
