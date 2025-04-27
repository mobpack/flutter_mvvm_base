import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository interface for authentication operations
abstract class IAuthRepository {
  // User management
  TaskEither<AppError, UserEntity?> getCurrentUser();
  bool get isAuthenticated;

  // Authentication
  /// Sign in with email and password
  TaskEither<AppError, UserEntity> signInWithPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  TaskEither<AppError, UserEntity> signUpWithPassword({
    required String email,
    required String password,
  });

  /// Sign out the current user
  TaskEither<AppError, Unit> signOut();

  // Password management
  /// Reset password for a given email
  TaskEither<AppError, Unit> resetPassword({required String email});

  /// Update password for the current user
  TaskEither<AppError, UserEntity> updatePassword({
    required String newPassword,
  });

  // Session management
  TaskEither<AppError, Unit> refreshSession();

  // Auth state
  Stream<AuthState> get onAuthStateChange;
}
