import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      noBoxingByDefault: true,
      excludeBox: const {
        Level.trace: true,
        Level.debug: true,
        Level.info: true,
      },
    ),
    level: kDebugMode ? Level.trace : Level.off,
  );

  static void trace(dynamic message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.t('$prefix$message');
  }

  static void debug(dynamic message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.d('$prefix$message');
  }

  static void info(dynamic message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.i('$prefix$message');
  }

  static void warning(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.w('$prefix$message', error: error, stackTrace: stackTrace);
  }

  static void error(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.e(
      '$prefix$message',
      error: error,
      stackTrace: stackTrace ?? (error != null ? StackTrace.current : null),
    );
  }

  static void fatal(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.f(
      '$prefix$message',
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  static void json(dynamic data, {String? tag}) {
    if (!kDebugMode) return;
    try {
      final object = data is String ? jsonDecode(data) : data;
      final prettyString = const JsonEncoder.withIndent('  ').convert(object);
      _logger.d('${tag != null ? '[$tag]\n' : ''}$prettyString');
    } catch (_) {
      _logger.d('${tag != null ? '[$tag] ' : ''}$data');
    }
  }

  static void network(
    String method,
    String url, {
    int? statusCode,
    dynamic data,
    Duration? duration,
  }) {
    if (!kDebugMode) return;
    final statusStr = statusCode != null ? ' [$statusCode]' : '';
    final durationStr = duration != null
        ? ' (${duration.inMilliseconds}ms)'
        : '';
    final icon = (statusCode != null && statusCode >= 200 && statusCode < 300)
        ? '🌐'
        : '⚠️';
    _logger.i('$icon $method $url$statusStr$durationStr');
    if (data != null) {
      json(data, tag: '$method Response');
    }
  }
}

typedef AppLoggerHelper = AppLogger;


/// ============================================================================
/// 🚀 AppLogger Usage Guide 
/// ============================================================================

/// AppLogger.debug('Button clicked');
/// AppLogger.info('User profile loaded: $userName');


/// AppLogger.debug('Token refreshed', tag: 'Auth');
/// AppLogger.info('Push notification received', tag: 'FCM');

