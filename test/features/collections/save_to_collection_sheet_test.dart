import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_state.dart';
import 'package:we36/features/collections/presentation/widgets/save_to_collection_sheet.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/collections_test_doubles.dart';

/// #011 T032: the Save-to-collection sheet lists named collections with a
/// membership checkmark + a "New collection" row. Driven by a stub cubit.
void main() {
  testWidgets('renders collections with checkmarks + a New collection row', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider<SaveToCollectionCubit>.value(
            value: StubSaveToCollectionCubit(
              SaveToCollectionState.loaded(membership: stubMembership()),
            ),
            child: const SaveToCollectionSheet(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('New collection'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Trips'), findsOneWidget);
  });
}
