import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'result.freezed.dart';

/// The return type of every fallible operation (Constitution V): success
/// carries a [T]; failure carries a typed [AppFailure]. No throwing for
/// expected failures.
@freezed
sealed class Result<T> with _$Result<T> {
  const Result._();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(AppFailure failure) = Err<T>;

  /// Collapse to a single value by handling both branches.
  R fold<R>(R Function(T value) onOk, R Function(AppFailure failure) onErr) =>
      switch (this) {
        Ok<T>(:final value) => onOk(value),
        Err<T>(:final failure) => onErr(failure),
      };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  AppFailure? get failureOrNull => switch (this) {
    Ok<T>() => null,
    Err<T>(:final failure) => failure,
  };

  /// Map the success value, preserving a failure.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T>(:final value) => Result<R>.ok(transform(value)),
    Err<T>(:final failure) => Result<R>.err(failure),
  };
}
