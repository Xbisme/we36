import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/collections/presentation/cubit/collections_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collections_state.dart';
import 'package:we36/features/collections/presentation/saved_collections_view.dart';
import 'package:we36/features/collections/presentation/widgets/collection_card.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/collections_test_doubles.dart';

/// #011 US5: the Saved surface is accessible (labelled cards), legible at large
/// text, and reflows across phone/tablet widths (centered-mobile fallback).
void main() {
  Widget host(Size size, {double textScale = 1.0}) => MediaQuery(
    data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<CollectionsCubit>.value(
          value: StubCollectionsCubit(
            CollectionsState.loaded(collections: stubCollections()),
          ),
          child: const SavedCollectionsView(),
        ),
      ),
    ),
  );

  testWidgets('collection cards expose a screen-reader label', (tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(host(const Size(400, 1600)));
    await tester.pump();

    // "All saved, 6 saved" / "Food, 3 saved" — labelled cards.
    expect(find.bySemanticsLabel(RegExp('saved')), findsWidgets);
    expect(find.byType(CollectionCard), findsNWidgets(3));
  });

  testWidgets('renders at 2x text scale without overflow', (tester) async {
    tester.view.physicalSize = const Size(400, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(host(const Size(400, 2000), textScale: 2));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(CollectionCard), findsNWidgets(3));
  });

  testWidgets('renders at phone and tablet widths (centered-mobile fallback)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(host(const Size(1200, 2000)));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(CollectionCard), findsNWidgets(3));
  });
}
