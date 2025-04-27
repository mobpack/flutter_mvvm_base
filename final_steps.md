## Step 7: Add Logging and Analytics

1. **Create a logging service**:
   ```dart
   // lib/shared/logging/log_service.dart
   import 'package:flutter/foundation.dart';
   import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
   
   enum LogLevel {
     debug,
     info,
     warning,
     error,
   }
   
   class Logger {
     void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
       if (kDebugMode) {
         print('[$level] $message');
         if (error != null) {
           print('Error: $error');
         }
         if (stackTrace != null) {
           print('StackTrace: $stackTrace');
         }
       }
       
       // In a real app, you would send this to a logging service like Firebase Crashlytics
     }
     
     void debug(String message, [Object? error, StackTrace? stackTrace]) {
       log(LogLevel.debug, message, error, stackTrace);
     }
     
     void info(String message, [Object? error, StackTrace? stackTrace]) {
       log(LogLevel.info, message, error, stackTrace);
     }
     
     void warning(String message, [Object? error, StackTrace? stackTrace]) {
       log(LogLevel.warning, message, error, stackTrace);
     }
     
     void error(String message, [Object? error, StackTrace? stackTrace]) {
       log(LogLevel.error, message, error, stackTrace);
     }
     
     void logError(AppError appError) {
       switch(appError) {
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
   
   final logger = Logger();
   ```

2. **Add error logging to ViewModels**:
   ```dart
   // Update the login method in LoginViewModel
   Future<void> login(BuildContext context) async {
     // ... existing code ...
     
     switch (result) {
       case Left(value: final error):
         // Log the error
         logger.logError(error);
         
         // ... rest of the error handling ...
       
       case Right(value: final user):
         // ... existing success handling ...
     }
   }
   ```

## Step 8: Testing Your Error Handling

1. **Create unit tests for error mapping**:
   ```dart
   // test/shared/domain/mappers/error_mapper_test.dart
   import 'dart:io';
   
   import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
   import 'package:flutter_mvvm_base/shared/domain/mappers/error_mapper.dart';
   import 'package:flutter_test/flutter_test.dart';
   import 'package:supabase_flutter/supabase_flutter.dart';
   
   void main() {
     group('ErrorMapper', () {
       test('maps SocketException to NetworkError', () {
         final exception = SocketException('Failed to connect');
         final error = ErrorMapper.mapException(exception);
         
         expect(error, isA<NetworkError>());
         expect(error.userMessage, contains('Unable to connect'));
       });
       
       test('maps AuthException to AuthError', () {
         final exception = AuthException('Invalid credentials', 'invalid-login-credentials');
         final error = ErrorMapper.mapException(exception);
         
         expect(error, isA<AuthError>());
         expect((error as AuthError).code, equals('invalid-login-credentials'));
       });
       
       // Add more tests for other error types
     });
   }
   ```

## Step 9: Documentation and Maintenance

1. **Document your error handling approach**:
   ```markdown
   // lib/shared/domain/common/README.md
   # Error Handling Strategy
   
   This document outlines our approach to error handling in the application.
   
   ## Error Types
   
   We use a sealed class `AppError` with the following variants:
   
   - `NetworkError`: For connectivity and API issues
   - `AuthError`: For authentication and authorization issues
   - `ValidationError`: For input validation errors
   - `ServerError`: For backend server errors
   - `UnexpectedError`: For unexpected errors
   
   ## Error Flow
   
   1. Exceptions are caught at the repository layer using `TaskEither.tryCatch`
   2. Exceptions are mapped to domain-specific `AppError` types
   3. Use cases may add additional validation or business logic errors
   4. ViewModels handle errors and update the UI state
   5. UI components display appropriate error messages
   
   ## Adding New Error Types
   
   To add a new error type:
   
   1. Add a new factory constructor to `AppError`
   2. Update the `userMessage` and `isRecoverable` getters
   3. Update the `ErrorMapper` to handle the new error type
   4. Add UI components to display the new error type
   ```

2. **Regularly review and update error handling**:
   - Schedule regular reviews of error logs
   - Update error messages based on user feedback
   - Add new error types as needed
   - Keep dependencies up to date

## Conclusion

By following these steps, you'll have implemented a comprehensive, type-safe error handling strategy that provides a great user experience while making your code more maintainable and testable. This approach leverages the latest features of Dart 3, Freezed, and FPDart to create a robust error handling system that is easy to extend and maintain.
