import 'package:flutter/foundation.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
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

  /// Logs an AppError with appropriate level based on error type
  void logError(AppError appError) {
    switch (appError) {
      case NetworkError(message: final msg, originalError: final err):
        warning('Network error: $msg', err);
      case AuthError(message: final msg, code: final code, originalError: final err):
        warning('Auth error: $msg (code: $code)', err);
      case ValidationError(errors: final errors):
        info('Validation error: $errors');
      case ServerError(message: final msg, code: final code, originalError: final err):
        error('Server error: $msg (code: $code)', err);
      case UnexpectedError(message: final msg, stackTrace: final stack, originalError: final err):
        error('Unexpected error: $msg', err, stack);
    }
  }
}

/// Global instance for easy access
final logger = LogService();
