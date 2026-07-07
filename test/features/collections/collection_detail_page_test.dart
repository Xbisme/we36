import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/collections/presentation/collection_detail_page.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_state.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/collections_test_doubles.dart';
import '../../helpers/explore_test_doubles.dart';

/// #011 T039: the collection-detail view renders the item grid (reels marked) and
/// the empty state. Driven by a seeded stub cubit (no drift I/O).
void main() {
  Widget host(CollectionDetailState state, {SavedCollection? collection}) =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<CollectionDetailCubit>.value(
          value: StubCollectionDetailCubit(state),
          child: CollectionDetailView(
            collectionId: collection?.id ?? 'col_food',
            collection: collection,
          ),
        ),
      );

  testWidgets('renders the item grid for a collection', (tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      host(
        CollectionDetailState.loaded(
          items: stubExploreItems(count: 6),
          hasMore: false,
        ),
        collection: SavedCollection(
          id: 'col_food',
          name: 'Food',
          itemCount: 6,
          updatedAt: DateTime.utc(2026),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Food'), findsOneWidget);
    expect(find.byType(DiscoveryGridTile), findsWidgets);
  });

  testWidgets('shows the empty state for an empty collection', (tester) async {
    await tester.pumpWidget(
      host(const CollectionDetailState.loaded(items: [], hasMore: false)),
    );
    await tester.pump();

    expect(find.text('No posts in this collection yet'), findsOneWidget);
  });
}
