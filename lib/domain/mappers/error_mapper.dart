import 'dart:io';

import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/service/logging/log_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorMapper {
  static AppError mapError(dynamic error, [StackTrace? stackTrace]) {
    logger.debug('Error: $error', error, stackTrace);
    logger.debug('Error type: ${error.runtimeType}');

    if (error is AuthException) {
      return _mapAuthError(error, stackTrace);
    }

    if (error is PostgrestException) {
      return _mapDatabaseError(error, stackTrace);
    }

    if (error is SocketException || error is HttpException) {
      return AppError.network(error.toString());
    }

    return AppError.unknown(error, stackTrace);
  }

  static AppError _mapAuthError(AuthException error, [StackTrace? stackTrace]) {
    switch (error.code) {
      case 'invalid-login-credentials':
        return AppError.authentication('Invalid email or password', error.code);
      default:
        return AppError.authentication(error.message, error.code);
    }
  }

  static AppError _mapDatabaseError(
    PostgrestException error, [
    StackTrace? stackTrace,
  ]) {
    if (error.code == '23505') {
      // Unique violation
      return AppError.validation('This record already exists');
    }

    if (error.code?.startsWith('23') ?? false) {
      // All integrity constraint violations
      return AppError.validation(error.message);
    }

    return AppError.server(error.message);
  }
}
