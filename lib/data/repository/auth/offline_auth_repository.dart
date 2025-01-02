import 'dart:async';

import 'package:flutter_mvvm_base/core/services/storage_service.dart';
import 'package:flutter_mvvm_base/data/repository/auth/auth_repository_interface.dart';
import 'package:safe_result/safe_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfflineAuthRepository implements AuthRepository {
  final StorageService _storageService;
  final _authStateController = StreamController<AuthState>.broadcast();

  static const _keyEmail = 'offline_auth_email';
  static const _keyIsAuthenticated = 'offline_auth_is_authenticated';

  OfflineAuthRepository({required StorageService storageService})
      : _storageService = storageService;

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final email = _storageService.getString(_keyEmail);
      if (email == null) return const Result.ok(null);

      // Create a minimal User object for offline mode
      return Result.ok(
        User(
          id: 'offline',
          email: email,
          createdAt: DateTime.now().toIso8601String(),
          appMetadata: {},
          userMetadata: {},
          aud: '',
        ),
      );
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      final isAuthenticated =
          _storageService.getBool(_keyIsAuthenticated) ?? false;
      return Result.ok(isAuthenticated);
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
      // Simulate offline authentication
      await _storageService.setString(_keyEmail, email);
      await _storageService.setBool(_keyIsAuthenticated, value: true);

      final user = User(
        id: 'offline',
        email: email,
        createdAt: DateTime.now().toIso8601String(),
        appMetadata: {},
        userMetadata: {},
        aud: '',
      );

      _authStateController.add(
        AuthState(
          AuthChangeEvent.signedIn,
          Session(
            accessToken: 'offline_token',
            tokenType: '',
            user: user,
          ),
        ),
      );

      return Result.ok(
        AuthResponse(
          user: user,
        ),
      );
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthResponse>> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    // In offline mode, sign up is same as sign in
    return signInWithPassword(email: email, password: password);
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _storageService.remove(_keyEmail);
      await _storageService.setBool(_keyIsAuthenticated, value: false);

      _authStateController.add(
        const AuthState(
          AuthChangeEvent.signedOut,
          null,
        ),
      );

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> resetPassword(String email) async {
    // Not supported in offline mode
    return Result.error(
        Exception('Password reset not available in offline mode'));
  }

  @override
  Future<Result<UserResponse>> updatePassword(String newPassword) async {
    // Not supported in offline mode
    return Result.error(
      Exception('Password update not available in offline mode'),
    );
  }

  @override
  Future<Result<AuthResponse?>> refreshSession() async {
    // Not supported in offline mode
    return Result.error(
      Exception('Session refresh not available in offline mode'),
    );
  }

  @override
  Stream<AuthState> get onAuthStateChange => _authStateController.stream;

  void dispose() {
    _authStateController.close();
  }
}
