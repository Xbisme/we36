import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/presentation/slots/save_to_collection_launcher.dart';
import 'package:we36/features/collections/presentation/widgets/save_to_collection_sheet.dart';

/// Concrete [SaveToCollectionLauncher] (#011) — opens the Save-to-collection
/// sheet. Registered so feed / post detail / reels can offer "Save to collection"
/// via `getIt<SaveToCollectionLauncher>()` without importing `features/collections`
/// (Constitution XI).
@LazySingleton(as: SaveToCollectionLauncher)
class SaveToCollectionLauncherImpl implements SaveToCollectionLauncher {
  const SaveToCollectionLauncherImpl();

  @override
  Future<void> open(BuildContext context, String postId) =>
      SaveToCollectionSheet.show(context, postId);
}
