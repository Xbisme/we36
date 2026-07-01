import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/toast.dart';
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
import 'package:we36/features/compose/presentation/pages/caption_page.dart';
import 'package:we36/features/compose/presentation/pages/pick_page.dart';
import 'package:we36/features/compose/presentation/widgets/selection_badge.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Synchronous baker (no compute isolate) so widget flows settle deterministically —
/// bake fidelity is covered by the unit test (T011).
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
    gallery = GalleryCubit(FakePhotoLibraryService(assetCount: 6));
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
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });

  tearDown(() async {
    await gallery.close();
    await compose.close();
    await db.close();
    await getIt.reset();
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

  // Fixed-duration pumps: the grid holds real MemoryImages whose async decode
  // would hang pumpAndSettle. We only need the widget tree, not painted pixels.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('pick page: grid renders and selecting shows an order badge', (
    tester,
  ) async {
    await gallery.loadInitial();
    await tester.pumpWidget(host(const PickPage()));
    await settle(tester);

    expect(find.byType(Image), findsWidgets); // grid rendered
    expect(find.byType(SelectionBadge), findsWidgets); // a badge per cell
    expect(find.text('1'), findsNothing); // nothing selected yet

    await tester.tap(find.byType(Image).first);
    await settle(tester);

    // One selected cell now carries a "1" order badge.
    expect(find.text('1'), findsOneWidget);
    expect(gallery.state.selectedIds, hasLength(1));
  });

  testWidgets('caption page: shows the thumbnail, caption field, and Share', (
    tester,
  ) async {
    await compose.startFromAssets(['fake-asset-0']);
    await tester.pumpWidget(host(const CaptionPage()));
    await settle(tester);

    expect(find.text('Share'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    // Typing routes into the draft (caption is carried to publish — see T021).
    await tester.enterText(find.byType(TextField), 'hello');
    await settle(tester);
    expect(compose.state.draftOrNull?.caption, 'hello');
  });
}
