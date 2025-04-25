enum AppErrorType {
  network,
  authentication,
  validation,
  server,
  unknown,
}

class AppError implements Exception {
  final String message;
  final String? errorCode;
  final AppErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.message,
    required this.type,
    this.errorCode,
    this.originalError,
    this.stackTrace,
  });

  factory AppError.network([String? message]) => AppError(
        message: message ?? 'Network error occurred',
        type: AppErrorType.network,
      );

  factory AppError.authentication([String? message, String? errorCode]) =>
      AppError(
        message: message ?? 'Authentication error occurred',
        type: AppErrorType.authentication,
        errorCode: errorCode,
      );

  factory AppError.validation([String? message]) => AppError(
        message: message ?? 'Validation error occurred',
        type: AppErrorType.validation,
      );

  factory AppError.server([String? message]) => AppError(
        message: message ?? 'Server error occurred',
        type: AppErrorType.server,
      );

  factory AppError.unknown([dynamic error, StackTrace? stackTrace]) => AppError(
        message: 'An unexpected error occurred',
        type: AppErrorType.unknown,
        originalError: error,
        stackTrace: stackTrace,
      );

  @override
  String toString() => 'AppError: $message (Type: $type)';

  AppError copyWith({
    String? message,
    AppErrorType? type,
    dynamic originalError,
    StackTrace? stackTrace,
  }) {
    return AppError(
      message: message ?? this.message,
      type: type ?? this.type,
      originalError: originalError ?? this.originalError,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }
}
