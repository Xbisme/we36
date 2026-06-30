import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/router/two_pane_scaffold.dart';

import '../../helpers/pump_app.dart';

Widget _demo() => Scaffold(
  body: TwoPaneScaffold<int>(
    items: const [1, 2, 3],
    detailTitle: (i) => 'Item $i',
    emptyDetail: const Text('empty'),
    listBuilder: (context, onSelect, selected) => ListView(
      children: [
        for (final i in const [1, 2, 3])
          ListTile(
            key: ValueKey('row-$i'),
            title: Text('Item $i'),
            selected: i == selected,
            onTap: () => onSelect(i),
          ),
      ],
    ),
    detailBuilder: (context, i) => Text('Detail $i'),
  ),
);

void main() {
  group('TwoPaneScaffold (FR-014)', () {
    testWidgets('tablet shows both panes; selection swaps in place (no push)', (
      tester,
    ) async {
      await pumpApp(tester, _demo(), surfaceSize: const Size(1000, 800));
      expect(find.text('empty'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('row-2')));
      await tester.pumpAndSettle();

      // Detail rendered in-place; list still visible (no full-screen push).
      expect(find.text('Detail 2'), findsOneWidget);
      expect(find.byKey(const ValueKey('row-1')), findsOneWidget);
    });

    testWidgets('phone pushes the detail full-screen', (tester) async {
      await pumpApp(tester, _demo(), surfaceSize: const Size(400, 800));
      // No detail until a selection is pushed.
      expect(find.text('Detail 3'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('row-3')));
      await tester.pumpAndSettle();

      expect(find.text('Detail 3'), findsOneWidget);
      // List row is no longer visible — it was pushed over.
      expect(find.byKey(const ValueKey('row-1')), findsNothing);
    });
  });
}
