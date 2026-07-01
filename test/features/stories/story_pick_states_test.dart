import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_state.dart';

/// US1 polish — the pick step's empty and permission-denied states (FR-016).
void main() {
  test('permission denied → error state (drives the open-settings UI)', () async {
    final cubit = StoryGalleryCubit(
      FakePhotoLibraryService(permission: PhotoPermission.denied),
    );
    await cubit.loadInitial();
    expect(cubit.state, isA<StoryGalleryError>());
    await cubit.close();
  });

  test('empty library → loaded with no assets (drives the empty state)', () async {
    final cubit = StoryGalleryCubit(FakePhotoLibraryService(assetCount: 0));
    await cubit.loadInitial();
    expect(cubit.state, isA<StoryGalleryLoaded>());
    expect(cubit.state.assets, isEmpty);
    await cubit.close();
  });

  test('granted → loaded with assets and single-select works', () async {
    final cubit = StoryGalleryCubit(FakePhotoLibraryService(assetCount: 5));
    await cubit.loadInitial();
    expect(cubit.state.assets, isNotEmpty);

    cubit.select('fake-asset-0');
    expect(cubit.state.selectedId, 'fake-asset-0');
    // Single-select: choosing another replaces.
    cubit.select('fake-asset-1');
    expect(cubit.state.selectedId, 'fake-asset-1');
    // Re-tapping clears.
    cubit.select('fake-asset-1');
    expect(cubit.state.selectedId, isNull);
    await cubit.close();
  });
}
