// ignore_for_file: avoid_print
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A production-ready logger utility for the WALLR Admin Panel.
/// Automatically handles release-mode suppression and formats logs
/// with emojis, timestamps, tags, and stack traces.
class AppLogger {
  AppLogger._();

  /// Log debug messages (e.g. state changes, minor events)
  static void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log('DEBUG', message, error: error, stackTrace: stackTrace, tag: tag);
  }

  /// Log informational messages (e.g. API responses, successful DB writes)
  static void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log('INFO', message, error: error, stackTrace: stackTrace, tag: tag);
  }

  /// Log warnings (e.g. non-fatal failures, caching issues)
  static void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log('WARNING', message, error: error, stackTrace: stackTrace, tag: tag);
  }

  /// Log errors (e.g. crash reports, failed network calls, uncaught exceptions)
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log('ERROR', message, error: error, stackTrace: stackTrace, tag: tag);
  }

  static void _log(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    // Suppress logs entirely in Release Mode for security & performance
    if (kReleaseMode) return;

    final emoji = _getEmoji(level);
    final tagStr = tag != null ? '[$tag]' : '';
    final formattedMessage = '$emoji $level $tagStr: $message';

    // Log to Dart developer tools (useful in VS Code / Android Studio loggers)
    developer.log(
      formattedMessage,
      name: 'WALLR_ADMIN',
      level: _getLevelValue(level),
      error: error,
      stackTrace: stackTrace,
    );

    // Also output formatted text blocks to the terminal console
    // Using standard print() to guarantee it is sent to both the browser console and the IDE debugger in Flutter Web.
    final time = DateTime.now().toIso8601String().substring(
      11,
      19,
    ); // HH:MM:ss
    final header = '$emoji [$level] [$time]${tag != null ? ' [$tag]' : ''}';

    print(
      '================================================================',
    );
    print(header);
    print('Message: $message');
    if (error != null) {
      print('Error: $error');
      if (error is DioException) {
        final response = error.response;
        if (response != null && response.data != null) {
          print('Dio Response Data: ${response.data}');
        }
      }
    }
    if (stackTrace != null) {
      print('StackTrace:\n$stackTrace');
    }
    print(
      '================================================================',
    );
  }

  static String _getEmoji(String level) {
    switch (level) {
      case 'DEBUG':
        return '🐛';
      case 'INFO':
        return '💡';
      case 'WARNING':
        return '⚠️';
      case 'ERROR':
        return '🚨';
      default:
        return '📝';
    }
  }

  static int _getLevelValue(String level) {
    switch (level) {
      case 'DEBUG':
        return 500;
      case 'INFO':
        return 800;
      case 'WARNING':
        return 900;
      case 'ERROR':
        return 1000;
      default:
        return 0;
    }
  }
}
