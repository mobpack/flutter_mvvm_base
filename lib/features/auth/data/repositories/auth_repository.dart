import 'package:safe_result/safe_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepository {
  Future<Result<User?, AuthException>> getCurrentUser();

  Future<Result<AuthResponse, AuthException>> signInWithPassword({
    required String email,
    required String password,
  });

  Future<Result<AuthResponse, AuthException>> signUpWithPassword({
    required String email,
    required String password,
  });

  Future<Result<void, AuthException>> signOut();

  Future<Result<void, AuthException>> resetPassword(String email);

  Future<Result<UserResponse, AuthException>> updatePassword(
    String newPassword,
  );

  Future<Result<AuthResponse?, AuthException>> refreshSession();

  Future<Result<bool, AuthException>> isAuthenticated();

  Stream<AuthState> get onAuthStateChange;
}
