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
      dateTimeFormat: DateTimeFormat.none,
      noBoxingByDefault: true,
      levelColors: {
        Level.trace: const AnsiColor.fg(8), // Grey
        Level.debug: const AnsiColor.fg(13), // Magenta / Violet
        Level.info: const AnsiColor.fg(10), // Vibrant Green (not blue!)
        Level.warning: const AnsiColor.fg(208), // Orange
        Level.error: const AnsiColor.fg(196), // Red
        Level.fatal: const AnsiColor.fg(199), // Deep Red
      },
      levelEmojis: {
        Level.trace: '🔬',
        Level.debug: '🔍',
        Level.info: '🟢',
        Level.warning: '⚠️',
        Level.error: '❌',
        Level.fatal: '💀',
      },
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

  // ── ANSI Terminal Colors ──────────────────────────────────────────────────
  static const String _cReset = '\x1B[0m';
  static const String _cCyan = '\x1B[36m';
  static const String _cGreen = '\x1B[32m';
  static const String _cRed = '\x1B[31m';
  static const String _cYellow = '\x1B[33m';
  static const String _cMagenta = '\x1B[35m';

  // ── 🚀 Clean Network Box Logger ───────────────────────────────────────────
  static void logRequest(String method, String url, {dynamic body}) {
    if (!kDebugMode) return;
    final buffer = StringBuffer();
    buffer.writeln('\n$_cCyan┌─────────────────────────────────────────────────────────────────$_cReset');
    buffer.writeln('$_cCyan│ 🚀 [$method REQUEST] $url$_cReset');
    if (body != null) {
      buffer.writeln('$_cCyan├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄ [ Request Body ] ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄$_cReset');
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(body);
        for (final line in prettyJson.split('\n')) {
          buffer.writeln('$_cCyan│ $line$_cReset');
        }
      } catch (_) {
        buffer.writeln('$_cCyan│ $body$_cReset');
      }
    }
    buffer.write('$_cCyan└─────────────────────────────────────────────────────────────────$_cReset');
    debugPrint(buffer.toString());
  }

  static void logResponse(
    String method,
    String url,
    int statusCode, {
    dynamic data,
  }) {
    if (!kDebugMode) return;

    final String color;
    final String icon;
    final String tag;

    if (statusCode >= 200 && statusCode < 300) {
      color = _cGreen;
      icon = '✅';
      tag = statusCode == 201 ? 'CREATED' : 'SUCCESS';
    } else if (statusCode >= 300 && statusCode < 400) {
      color = _cCyan;
      icon = '🔀';
      tag = 'REDIRECT';
    } else if (statusCode == 400) {
      color = _cYellow;
      icon = '⚠️';
      tag = 'BAD REQUEST';
    } else if (statusCode == 401) {
      color = _cYellow;
      icon = '🔒';
      tag = 'UNAUTHORIZED';
    } else if (statusCode == 403) {
      color = _cYellow;
      icon = '🚫';
      tag = 'FORBIDDEN';
    } else if (statusCode == 404) {
      color = _cMagenta;
      icon = '🔍';
      tag = 'NOT FOUND';
    } else if (statusCode == 422) {
      color = _cYellow;
      icon = '📝';
      tag = 'VALIDATION ERROR';
    } else if (statusCode >= 400 && statusCode < 500) {
      color = _cYellow;
      icon = '⚠️';
      tag = 'CLIENT ERROR';
    } else if (statusCode >= 500) {
      color = _cRed;
      icon = '💥';
      tag = 'SERVER ERROR';
    } else {
      color = _cRed;
      icon = '❌';
      tag = 'ERROR';
    }

    final buffer = StringBuffer();
    buffer.writeln('\n$color┌─────────────────────────────────────────────────────────────────$_cReset');
    buffer.writeln('$color│ $icon [$statusCode $tag] $method $url$_cReset');
    if (data != null) {
      buffer.writeln('$color├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄ [ Response Body ] ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄$_cReset');
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(data);
        for (final line in prettyJson.split('\n')) {
          buffer.writeln('$color│ $line$_cReset');
        }
      } catch (_) {
        buffer.writeln('$color│ $data$_cReset');
      }
    }
    buffer.write('$color└─────────────────────────────────────────────────────────────────$_cReset');
    debugPrint(buffer.toString());
  }

  static void logNetworkError(
    String method,
    String url, {
    required String error,
    int? statusCode,
  }) {
    if (!kDebugMode) return;
    final buffer = StringBuffer();
    final statusStr = statusCode != null ? ' (Status: $statusCode)' : '';
    buffer.writeln('\n$_cRed┌─────────────────────────────────────────────────────────────────$_cReset');
    buffer.writeln('$_cRed│ ❌ [NETWORK ERROR$statusStr] $method $url$_cReset');
    buffer.writeln('$_cRed├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄ [ Error Details ] ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄$_cReset');
    buffer.writeln('$_cRed│ $error$_cReset');
    buffer.write('$_cRed└─────────────────────────────────────────────────────────────────$_cReset');
    debugPrint(buffer.toString());
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

