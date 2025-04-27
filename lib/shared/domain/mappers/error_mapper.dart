import 'dart:io';

import 'package:flutter_mvvm_base/shared/core/logging/log_service.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorMapper {
  /// Maps exceptions to domain-specific AppError types
  static AppError mapException(dynamic error, [StackTrace? stackTrace]) {
    logger.debug('Error: $error', error, stackTrace);
    logger.debug('Error type: ${error.runtimeType}');

    if (error is AuthException) {
      return _mapAuthError(error, stackTrace);
    }

    if (error is PostgrestException) {
      return _mapDatabaseError(error, stackTrace);
    }

    if (error is SocketException || error is HttpException) {
      return AppError.network(
        message: 'Connection error: ${error.message}',
        originalError: error,
      );
    }

    return AppError.unexpected(
      message: error.toString(),
      stackTrace: stackTrace,
      originalError: error,
    );
  }

  static AppError _mapAuthError(AuthException error, [StackTrace? stackTrace]) {
    switch (error.code) {
      case 'invalid-login-credentials':
        return AppError.auth(
          message: 'Invalid email or password',
          code: error.code,
          originalError: error,
        );
      default:
        return AppError.auth(
          message: error.message,
          code: error.code,
          originalError: error,
        );
    }
  }

  static AppError _mapDatabaseError(
    PostgrestException error, [
    StackTrace? stackTrace,
  ]) {
    if (error.code == '23505') {
      // Unique violation
      return AppError.validation(
        errors: {
          'general': ['This record already exists'],
        },
      );
    }

    if (error.code?.startsWith('23') ?? false) {
      // All integrity constraint violations
      return AppError.validation(
        errors: {
          'general': [error.message],
        },
      );
    }

    return AppError.server(
      message: error.message,
      code: int.tryParse(error.code ?? ''),
      originalError: error,
    );
  }
}
