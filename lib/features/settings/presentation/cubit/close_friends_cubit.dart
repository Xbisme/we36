import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/close_friends/close_friends_repository.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Close-friends list management (#014, US4). Loads the members and applies
/// **optimistic** add/remove (rollback + toast on failure — e.g. the backend
/// "must follow you" validation). Feeds the stories close-friends audience.
@injectable
class CloseFriendsCubit extends AppCubit<List<UserSummary>> {
  CloseFriendsCubit(this._repo);

  final CloseFriendsRepository _repo;
  final StreamController<AppFailure> _errors =
      StreamController<AppFailure>.broadcast();

  /// Transient failures from a rolled-back add/remove (page → toast).
  Stream<AppFailure> get errors => _errors.stream;

  Future<void> load() async {
    emitLoading();
    final result = await _repo.list();
    if (isClosed) return;
    result.fold((page) => emitLoaded(page.items), emitError);
  }

  /// Candidate accounts for the add picker (people who follow you).
  Future<Result<CursorPage<UserSummary>>> candidates() => _repo.candidates();

  Future<void> add(UserSummary user) async {
    final current = state.dataOrNull;
    if (current == null || current.any((u) => u.id == user.id)) return;
    emitLoaded([user, ...current]);
    final failure = (await _repo.add(user.id)).failureOrNull;
    if (isClosed) return;
    if (failure != null) {
      emitLoaded(current);
      _errors.add(failure);
    }
  }

  Future<void> remove(UserSummary user) async {
    final current = state.dataOrNull;
    if (current == null) return;
    emitLoaded(current.where((u) => u.id != user.id).toList(growable: false));
    final failure = (await _repo.remove(user.id)).failureOrNull;
    if (isClosed) return;
    if (failure != null) {
      emitLoaded(current);
      _errors.add(failure);
    }
  }

  @override
  Future<void> close() {
    unawaited(_errors.close());
    return super.close();
  }
}
