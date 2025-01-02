import 'package:safe_result/safe_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<Result<User?>> getCurrentUser();
  
  Future<Result<AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  });

  Future<Result<AuthResponse>> signUpWithPassword({
    required String email,
    required String password,
  });

  Future<Result<void>> signOut();

  Future<Result<void>> resetPassword(String email);

  Future<Result<UserResponse>> updatePassword(String newPassword);

  Future<Result<AuthResponse?>> refreshSession();

  Future<Result<bool>> isAuthenticated();

  Stream<AuthState> get onAuthStateChange;
}
