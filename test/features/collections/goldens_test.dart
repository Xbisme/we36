import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/collections/presentation/widgets/collection_card.dart';
import 'package:we36/features/collections/presentation/widgets/collections_grid.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/collections_test_doubles.dart';

/// #011 US5 (T046): goldens for the Saved surface widgets, light + dark. Cover
/// thumbnails go through `CachedNetworkImage` → the cache manager needs
/// `path_provider`; stub its channel so covers resolve to the neutral error
/// placeholder deterministically (no network in tests).
void main() {
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => Directory.systemTemp.path,
        );
  });
  Widget frame(
    Widget child, {
    required bool dark,
    Size size = const Size(240, 320),
  }) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: dark ? AppTheme.dark : AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );

  // No cover refs → the neutral placeholder quilt (avoids CachedNetworkImage /
  // network in goldens; keeps them deterministic).
  SavedCollection food() => SavedCollection(
    id: 'col_food',
    name: 'Food',
    itemCount: 23,
    updatedAt: DateTime.utc(2026),
  );

  SavedCollection emptyCol() => SavedCollection(
    id: 'col_new',
    name: 'New board',
    itemCount: 0,
    updatedAt: DateTime.utc(2026),
  );

  for (final dark in [false, true]) {
    final suffix = dark ? 'dark' : 'light';

    testWidgets('collection_card_$suffix', (tester) async {
      await tester.pumpWidget(
        frame(
          CollectionCard(collection: food(), onTap: () {}),
          dark: dark,
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(CollectionCard),
        matchesGoldenFile('goldens/collection_card_$suffix.png'),
      );
    });

    testWidgets('collection_card_empty_$suffix', (tester) async {
      await tester.pumpWidget(
        frame(
          CollectionCard(collection: emptyCol(), onTap: () {}),
          dark: dark,
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(CollectionCard),
        matchesGoldenFile('goldens/collection_card_empty_$suffix.png'),
      );
    });

    testWidgets('collections_grid_$suffix', (tester) async {
      await tester.pumpWidget(
        frame(
          CollectionsGrid(
            collections: [
              for (final c in stubCollections())
                c.copyWith(coverRefs: const []),
            ],
            onTapCollection: (_) {},
          ),
          dark: dark,
          size: const Size(360, 520),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(CollectionsGrid),
        matchesGoldenFile('goldens/collections_grid_$suffix.png'),
      );
    });
  }
}
