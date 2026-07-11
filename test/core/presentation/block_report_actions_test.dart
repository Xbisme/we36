import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/moderation/report.dart';
import 'package:we36/core/presentation/block_report_actions.dart';
import 'package:we36/core/presentation/report_sheet.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #014 T071: block + report are reachable via the shared core seams that the DM
/// chat overflow and story viewer use (`showBlockReportActions`), and the report
/// reason picker offers the fixed backend-aligned set (`showReportSheet`).
Widget _harness(void Function(BuildContext) onTap) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: AppTheme.light,
  home: Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () => onTap(context),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('showBlockReportActions offers Report + Block', (tester) async {
    await tester.pumpWidget(
      _harness(
        (c) => showBlockReportActions(c, userId: 'u1', username: 'alice'),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Report'), findsOneWidget);
    expect(find.text('Block'), findsOneWidget);
  });

  testWidgets('showReportSheet lists the fixed 9-reason set', (tester) async {
    await tester.pumpWidget(
      _harness(
        (c) => showReportSheet(
          c,
          targetType: ReportTargetType.user,
          targetId: 'u1',
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // A few representative reasons from the backend-aligned set (FR-019).
    expect(find.text('Spam'), findsOneWidget);
    expect(find.text('Hate speech'), findsOneWidget);
    expect(find.text('Intellectual-property violation'), findsOneWidget);
    expect(find.text('Something else'), findsOneWidget);
  });
}
