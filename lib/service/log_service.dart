import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized logging utility for consistent app-wide logs.
///
/// This service provides:
/// - Log levels (info, warning, error, debug)
/// - Optional [tag] for source identification
/// - Stack trace printing for errors
/// - Works in both debug and release modes (can be silenced in release)
class LogService {
  LogService._();
  static final LogService instance = LogService._();

  /// Whether logs should be printed in release mode.
  /// Default: false
  bool enableInRelease = false;

  void info(String message, {String tag = 'APP'}) {
    _printLog('ℹ️ INFO', message, tag: tag, color: '\x1B[32m'); // Green
  }

  void debug(String message, {String tag = 'APP'}) {
    if (kReleaseMode && !enableInRelease) return;
    _printLog('🐛 DEBUG', message, tag: tag, color: '\x1B[36m'); // Cyan
  }

  void warning(String message, {String tag = 'APP'}) {
    _printLog('⚠️ WARNING', message, tag: tag, color: '\x1B[33m'); // Yellow
  }

  void error(String message, {String tag = 'APP', StackTrace? stackTrace}) {
    _printLog('❌ ERROR', message, tag: tag, color: '\x1B[31m'); // Red
    if (stackTrace != null) {
      developer.log('STACK TRACE:\n$stackTrace', name: tag);
    }
  }

  void _printLog(
    String level,
    String message, {
    required String tag,
    String? color,
  }) {
    final reset = '\x1B[0m';
    final log = '[$tag] $level → $message';
    if (kDebugMode || enableInRelease) {
      // Print with color in console
      print('${color ?? ''}$log$reset');
    }
  }
}
