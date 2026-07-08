import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/notifications/presentation/widgets/follow_back_button.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

void main() {
  Widget host(Future<bool> Function() onFollowBack) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(child: FollowBackButton(onFollowBack: onFollowBack)),
    ),
  );

  testWidgets('optimistically flips Follow → Following on success', (
    tester,
  ) async {
    var called = 0;
    await tester.pumpWidget(
      host(() async {
        called++;
        return true;
      }),
    );
    expect(find.text('Follow back'), findsOneWidget);

    await tester.tap(find.text('Follow back'));
    await tester.pump(); // optimistic flip
    expect(find.text('Following'), findsOneWidget);

    await tester.pump(); // await result resolves
    expect(find.text('Following'), findsOneWidget);
    expect(called, 1);
  });

  testWidgets('reverts to Follow when the request fails', (tester) async {
    await tester.pumpWidget(host(() async => false));

    await tester.tap(find.text('Follow back'));
    await tester.pump(); // optimistic flip + async failure resolves → revert
    await tester.pump();
    // Rolled back to the follow-back CTA.
    expect(find.text('Follow back'), findsOneWidget);
    expect(find.text('Following'), findsNothing);
  });
}
