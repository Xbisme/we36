import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/collections/presentation/cubit/collections_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collections_state.dart';
import 'package:we36/features/collections/presentation/saved_collections_view.dart';
import 'package:we36/features/collections/presentation/widgets/collection_card.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/collections_test_doubles.dart';

/// #011 T025: the Saved-collections view renders the grid + cards + create action,
/// and the fully-empty / error states. Driven by a seeded stub cubit (no drift).
void main() {
  Widget host(CollectionsState state) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider<CollectionsCubit>.value(
        value: StubCollectionsCubit(state),
        child: const SavedCollectionsView(),
      ),
    ),
  );

  testWidgets(
    'renders collection cards with "All saved" first + create action',
    (tester) async {
      tester.view.physicalSize = const Size(400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        host(CollectionsState.loaded(collections: stubCollections())),
      );
      await tester.pump();

      expect(find.byType(CollectionCard), findsNWidgets(3));
      expect(find.text('All saved'), findsWidgets);
      expect(find.text('Food'), findsOneWidget);
      // The create (+) action is present (semantic label).
      expect(find.bySemanticsLabel('New collection'), findsOneWidget);
    },
  );

  testWidgets('shows the empty state when nothing is saved', (tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      host(
        CollectionsState.loaded(
          collections: [
            SavedCollection(
              id: kAllSavedCollectionId,
              name: 'All saved',
              itemCount: 0,
              isDefault: true,
              updatedAt: DateTime.utc(2026),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CollectionCard), findsNothing);
    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  testWidgets('shows an error state with retry', (tester) async {
    await tester.pumpWidget(
      host(const CollectionsState.error(AppFailure.offline())),
    );
    await tester.pump();

    expect(find.text('Retry'), findsOneWidget);
  });
}
