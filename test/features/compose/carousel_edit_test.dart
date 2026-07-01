import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/pages/edit_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

class _SyncImageProcessing extends ImageProcessingService {
  const _SyncImageProcessing();
  @override
  Future<Result<Uint8List>> bake({
    required Uint8List source,
    required MediaEditState edit,
    int targetWidth = ImageProcessingService.defaultTargetWidth,
    int quality = ImageProcessingService.defaultQuality,
  }) async => Result.ok(source);
}

void main() {
  late AppDatabase db;
  late GalleryCubit gallery;
  late ComposeCubit compose;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    gallery = GalleryCubit(FakePhotoLibraryService());
    compose = ComposeCubit(
      PublishPost(
        FakePhotoLibraryService(),
        const _SyncImageProcessing(),
        FakeMediaUploadService()..stepDelay = Duration.zero,
        FakeCreatePostRepository(db),
      ),
      ComposeDraftStore(db),
      IdempotencyKeys(),
    );
  });

  tearDown(() async {
    await gallery.close();
    await compose.close();
    await db.close();
  });

  Widget host(Widget child) => MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: gallery),
        BlocProvider.value(value: compose),
      ],
      child: child,
    ),
  );

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets(
    'each carousel item keeps its own edit as the active item switches',
    (tester) async {
      await compose.startFromAssets(['fake-asset-0', 'fake-asset-1']);
      await tester.pumpWidget(host(const EditPage()));
      await settle(tester);

      // Item 0 active → apply Warm.
      await tester.tap(find.text('Warm'));
      await settle(tester);
      expect(
        compose.state.draftOrNull!.items[0].edit.filter,
        FilterPreset.warm,
      );

      // Switch to item 1 via the thumbnail strip → apply Mono.
      await tester.tap(find.bySemanticsLabel('Photo 2'));
      await settle(tester);
      await tester.tap(find.text('Mono'));
      await settle(tester);

      final items = compose.state.draftOrNull!.items;
      expect(items[0].edit.filter, FilterPreset.warm); // unchanged
      expect(items[1].edit.filter, FilterPreset.mono); // per-photo edit
    },
  );
}
