import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// A unified error model for the application.
///
/// This sealed class represents all possible error types in the application.
/// Using Dart 3's sealed classes allows for exhaustive pattern matching.
@freezed
sealed class AppError with _$AppError {
  /// Network-related errors (connectivity issues, timeouts, etc.)
  const factory AppError.network({
    required String message,
    @Default(true) bool isRecoverable,
    Object? originalError,
  }) = NetworkError;

  /// Authentication errors (invalid credentials, expired tokens, etc.)
  const factory AppError.auth({
    required String message,
    String? code,
    @Default(true) bool isRecoverable,
    Object? originalError,
  }) = AuthError;

  /// Validation errors (form validation, input validation, etc.)
  const factory AppError.validation({
    required Map<String, List<String>> errors,
    @Default(false) bool isRecoverable,
  }) = ValidationError;

  /// Server errors (internal server errors, API errors, etc.)
  const factory AppError.server({
    required String message,
    int? code,
    @Default(false) bool isRecoverable,
    Object? originalError,
  }) = ServerError;

  /// Unexpected errors (unhandled exceptions, etc.)
  const factory AppError.unexpected({
    required String message,
    StackTrace? stackTrace,
    @Default(false) bool isRecoverable,
    Object? originalError,
  }) = UnexpectedError;
}

/// Extension methods for AppError
extension AppErrorX on AppError {
  /// Returns a user-friendly message for the error
  String get userMessage {
    return switch (this) {
      NetworkError(message: final msg) =>
        'Unable to connect to the server. $msg',
      AuthError(message: final msg) => 'Authentication error: $msg',
      ValidationError(errors: final errors) =>
        errors.values.expand((e) => e).join(', '),
      ServerError(message: final msg) => 'Server error: $msg',
      UnexpectedError(message: final msg) =>
        'An unexpected error occurred: $msg',
    };
  }

  /// Returns whether the error is recoverable (can be retried)
  bool get isRecoverable {
    return switch (this) {
      NetworkError(isRecoverable: final recoverable) => recoverable,
      AuthError(isRecoverable: final recoverable) => recoverable,
      ValidationError(isRecoverable: final recoverable) => recoverable,
      ServerError(isRecoverable: final recoverable) => recoverable,
      UnexpectedError(isRecoverable: final recoverable) => recoverable,
    };
  }
}
