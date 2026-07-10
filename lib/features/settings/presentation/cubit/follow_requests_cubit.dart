import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/data/social/follow_requests_repository.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';

/// The follow-request approval inbox (#014, US2). Loads pending requests and
/// applies **optimistic** Approve/Decline (remove the row immediately; roll back
/// + toast on failure). Accept/reject are idempotent (the API client attaches an
/// Idempotency-Key). On a confirmed accept the canonical `RelationshipStore` is
/// updated by the repository.
@injectable
class FollowRequestsCubit extends AppCubit<List<FollowRequest>> {
  FollowRequestsCubit(this._repo);

  final FollowRequestsRepository _repo;
  final StreamController<AppFailure> _errors =
      StreamController<AppFailure>.broadcast();

  /// Transient failures from a rolled-back Approve/Decline (page → toast).
  Stream<AppFailure> get errors => _errors.stream;

  Future<void> load() async {
    emitLoading();
    final result = await _repo.list();
    if (isClosed) return;
    result.fold((page) => emitLoaded(page.items), emitError);
  }

  Future<void> approve(FollowRequest request) => _resolve(
    request,
    () async => (await _repo.accept(request.requester.id)).failureOrNull,
  );

  Future<void> decline(FollowRequest request) => _resolve(
    request,
    () async => (await _repo.reject(request.requester.id)).failureOrNull,
  );

  Future<void> _resolve(
    FollowRequest request,
    Future<AppFailure?> Function() action,
  ) async {
    final current = state.dataOrNull;
    if (current == null) return;
    final next = current
        .where((r) => r.requester.id != request.requester.id)
        .toList(growable: false);
    emitLoaded(next);

    final failure = await action();
    if (isClosed) return;
    if (failure != null) {
      emitLoaded(current); // rollback
      _errors.add(failure);
    }
  }

  @override
  Future<void> close() {
    unawaited(_errors.close());
    return super.close();
  }
}
