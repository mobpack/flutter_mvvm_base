import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthService {
  // User management
  User? get currentUser;
  bool get isAuthenticated;

  // Authentication
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> signUpWithPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  // Password management
  Future<void> resetPassword(String email);
  Future<UserResponse> updatePassword(String newPassword);

  // Session management
  Session? get currentSession;
  Future<AuthResponse?> refreshSession();

  // Auth state
  Stream<AuthState> get onAuthStateChange;
}
