import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';

/// Log severity.
enum LogLevel { debug, info, warn, error }

/// The single logging entry point for the whole app (Constitution I/IV):
/// raw `print`/`debugPrint` are forbidden, and secrets are redacted before
/// anything is written.
@lazySingleton
class AppLogger {
  const AppLogger();

  /// Minimum level emitted (everything, by default).
  LogLevel get minLevel => LogLevel.debug;

  /// Substrings that, when they appear as a key, cause the value to be redacted.
  static const _secretKeys = <String>[
    'password',
    'token',
    'authorization',
    'secret',
    'email',
    'phone',
    'otp',
    'refresh',
    'access_token',
  ];

  void debug(String message, {Map<String, Object?>? data}) =>
      _log(LogLevel.debug, message, data: data);

  void info(String message, {Map<String, Object?>? data}) =>
      _log(LogLevel.info, message, data: data);

  void warn(String message, {Map<String, Object?>? data}) =>
      _log(LogLevel.warn, message, data: data);

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? data,
  }) => _log(
    LogLevel.error,
    message,
    data: data,
    error: error,
    stackTrace: stackTrace,
  );

  void _log(
    LogLevel level,
    String message, {
    Map<String, Object?>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) return;
    final safeMessage = redact(message);
    final safeData = data == null ? null : _redactMap(data);
    final suffix = safeData == null || safeData.isEmpty ? '' : ' $safeData';
    developer.log(
      '$safeMessage$suffix',
      name: 'we36.${level.name}',
      level: _levelValue(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  int _levelValue(LogLevel level) => switch (level) {
    LogLevel.debug => 500,
    LogLevel.info => 800,
    LogLevel.warn => 900,
    LogLevel.error => 1000,
  };

  /// Redact obvious secrets in a free-form string (emails, bearer tokens).
  static String redact(String input) {
    return input
        .replaceAll(
          RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'),
          '[redacted-email]',
        )
        .replaceAll(
          RegExp(r'[Bb]earer\s+[A-Za-z0-9._-]+'),
          'Bearer [redacted]',
        );
  }

  static Map<String, Object?> _redactMap(Map<String, Object?> data) {
    return data.map((key, value) {
      final lower = key.toLowerCase();
      final isSecret = _secretKeys.any(lower.contains);
      return MapEntry(key, isSecret ? '[redacted]' : value);
    });
  }
}
