import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_mvvm_base/shared/domain/common/failure.dart';

abstract class IAuthRepository {
  // User management
  User? get currentUser;
  bool get isAuthenticated;

  // Authentication
  TaskEither<Failure, AuthResponse> signInWithPassword({
    required String email,
    required String password,
  });

  TaskEither<Failure, AuthResponse> signUpWithPassword({
    required String email,
    required String password,
  });

  TaskEither<Failure, void> signOut();

  // Password management
  TaskEither<Failure, void> resetPassword(String email);
  TaskEither<Failure, UserResponse> updatePassword(String newPassword);

  // Session management
  Session? get currentSession;
  TaskEither<Failure, AuthResponse?> refreshSession();

  // Auth state
  Stream<AuthState> get onAuthStateChange;
}
