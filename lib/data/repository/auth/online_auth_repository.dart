import 'package:flutter_mvvm_base/data/repository/auth/auth_repository_interface.dart';
import 'package:flutter_mvvm_base/data/services/supabase/auth/auth_interface.dart';
import 'package:safe_result/safe_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlineAuthRepository implements AuthRepository {
  final AuthService _authService;

  OnlineAuthRepository({required AuthService authService})
      : _authService = authService;

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final user = _authService.currentUser;
      return Result.ok(user);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      return Result.ok(_authService.isAuthenticated);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthResponse>> signInWithPassword({
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
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthResponse>> signUpWithPassword({
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
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _authService.signOut();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserResponse>> updatePassword(String newPassword) async {
    try {
      final response = await _authService.updatePassword(newPassword);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthResponse?>> refreshSession() async {
    try {
      final response = await _authService.refreshSession();
      return Result.ok(response);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Stream<AuthState> get onAuthStateChange => _authService.onAuthStateChange;
}
