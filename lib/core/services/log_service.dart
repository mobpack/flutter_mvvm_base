import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;

  late Logger _logger;
  bool _initialized = false;

  LogService._internal();

  void init() {
    if (_initialized) return;

    _logger = Logger(
      printer: PrettyPrinter(
        lineLength: 80,
      ),
      level: kDebugMode ? Level.trace : Level.warning,
    );

    _initialized = true;
  }

  void trace(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      init();
    }
  }

  /// Dispose should be called when the app is shutting down
  void dispose() {
    _logger.close();
    _initialized = false;
  }
}

/// Global instance for easy access
final log = LogService();
