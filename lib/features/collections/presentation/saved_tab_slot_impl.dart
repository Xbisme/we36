import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/slots/saved_tab_slot.dart';
import 'package:we36/features/collections/presentation/cubit/collections_cubit.dart';
import 'package:we36/features/collections/presentation/saved_collections_view.dart';

/// Concrete [SavedTabSlot] (#011) — provides the profile's owner-only Saved tab
/// body (its own `BlocProvider`/`CollectionsCubit`). Registered so
/// `features/profile` renders it via `getIt<SavedTabSlot>()` without importing
/// `features/collections` (Constitution XI).
@LazySingleton(as: SavedTabSlot)
class SavedTabSlotImpl implements SavedTabSlot {
  const SavedTabSlotImpl();

  @override
  Widget build(BuildContext context) => BlocProvider<CollectionsCubit>(
    create: (_) {
      final cubit = getIt<CollectionsCubit>();
      unawaited(cubit.loadInitial());
      return cubit;
    },
    child: const SavedCollectionsView(),
  );
}
