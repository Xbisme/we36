import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/moderation/block_actions.dart';
import 'package:we36/core/data/moderation/block_repository.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';

/// Lists the accounts the signed-in person has blocked (#014, US3) and lets them
/// unblock (optimistic removal + rollback + toast). Seeds the canonical
/// `BlockedUsersStore` from the fetched page.
@injectable
class BlockedAccountsCubit extends AppCubit<List<UserSummary>> {
  BlockedAccountsCubit(this._repo, this._blockActions, this._blocked);

  final BlockRepository _repo;
  final BlockActions _blockActions;
  final BlockedUsersStore _blocked;
  final StreamController<AppFailure> _errors =
      StreamController<AppFailure>.broadcast();

  /// Transient failures from a rolled-back unblock (page → toast).
  Stream<AppFailure> get errors => _errors.stream;

  Future<void> load() async {
    emitLoading();
    final result = await _repo.listBlocked();
    if (isClosed) return;
    result.fold((page) {
      _blocked.seed(page.items.map((u) => u.id));
      emitLoaded(page.items);
    }, emitError);
  }

  Future<void> unblock(UserSummary user) async {
    final current = state.dataOrNull;
    if (current == null) return;
    final next = current.where((u) => u.id != user.id).toList(growable: false);
    emitLoaded(next);

    final result = await _blockActions.unblock(user.id);
    if (isClosed) return;
    result.fold((_) {}, (failure) {
      emitLoaded(current); // rollback
      _errors.add(failure);
    });
  }

  @override
  Future<void> close() {
    unawaited(_errors.close());
    return super.close();
  }
}
