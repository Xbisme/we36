import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/theme/app_colors_x.dart';

/// Reusable master/detail primitive (FR-014). On tablet width it renders the
/// list and detail panes side-by-side and swaps the detail IN PLACE on
/// selection (no route push); on phone width it pushes the detail full-screen.
/// Selection is preserved across a width change. Messages (#012) and Post
/// detail (#006) plug their content in later.
class TwoPaneScaffold<T> extends StatefulWidget {
  const TwoPaneScaffold({
    required this.items,
    required this.listBuilder,
    required this.detailBuilder,
    required this.detailTitle,
    this.listWidth = 360,
    this.emptyDetail,
    super.key,
  });

  final List<T> items;

  /// Builds the list pane. `onSelect` swaps the detail (tablet) or pushes it
  /// (phone); `selected` highlights the active row on tablet.
  final Widget Function(
    BuildContext context,
    void Function(T item) onSelect,
    T? selected,
  )
  listBuilder;

  /// Builds the detail pane / pushed page for a selected item.
  final Widget Function(BuildContext context, T item) detailBuilder;

  /// Title for the pushed detail route on phone.
  final String Function(T item) detailTitle;

  final double listWidth;

  /// Shown in the detail pane on tablet when nothing is selected.
  final Widget? emptyDetail;

  @override
  State<TwoPaneScaffold<T>> createState() => _TwoPaneScaffoldState<T>();
}

class _TwoPaneScaffoldState<T> extends State<TwoPaneScaffold<T>> {
  T? _selected;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= AppBreakpoints.tablet;
    final tokens = context.tokens;

    if (!isTablet) {
      // Phone: list only; selecting pushes the detail full-screen.
      return widget.listBuilder(context, _pushDetail, null);
    }

    // Tablet: side-by-side; selecting swaps the detail in place.
    return Row(
      children: [
        SizedBox(
          width: widget.listWidth,
          child: widget.listBuilder(
            context,
            (item) => setState(() => _selected = item),
            _selected,
          ),
        ),
        VerticalDivider(width: 1, color: tokens.divider),
        Expanded(
          child: _selected == null
              ? (widget.emptyDetail ?? const SizedBox.shrink())
              : widget.detailBuilder(context, _selected as T),
        ),
      ],
    );
  }

  void _pushDetail(T item) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(widget.detailTitle(item))),
            body: widget.detailBuilder(context, item),
          ),
        ),
      ),
    );
  }
}
