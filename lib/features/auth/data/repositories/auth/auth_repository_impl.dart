import 'package:flutter_mvvm_base/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:flutter_mvvm_base/services/supabase/auth/auth_interface.dart';
import 'package:safe_result/safe_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({required AuthService authService})
      : _authService = authService;

  @override
  Future<Result<User?, AuthException>> getCurrentUser() async {
    try {
      final user = _authService.currentUser;
      return Result.ok(user);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Future<Result<AuthResponse, AuthException>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signInWithPassword(
        email: email,
        password: password,
      );
      return Result.ok(response);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Future<Result<AuthResponse, AuthException>> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signUpWithPassword(
        email: email,
        password: password,
      );
      return Result.ok(response);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Future<Result<void, AuthException>> signOut() async {
    try {
      await _authService.signOut();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Future<Result<void, AuthException>> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Future<Result<UserResponse, AuthException>> updatePassword(
    String newPassword,
  ) async {
    try {
      final response = await _authService.updatePassword(newPassword);
      return Result.ok(response);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Future<Result<AuthResponse?, AuthException>> refreshSession() async {
    try {
      final response = await _authService.refreshSession();
      return Result.ok(response);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Future<Result<bool, AuthException>> isAuthenticated() async {
    try {
      return Result.ok(_authService.currentUser != null);
    } catch (e) {
      return Result.error(e as AuthException);
    }
  }

  @override
  Stream<AuthState> get onAuthStateChange => _authService.onAuthStateChange;
}
