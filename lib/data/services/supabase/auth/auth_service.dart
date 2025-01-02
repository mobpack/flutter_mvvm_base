import 'package:flutter_mvvm_base/data/services/supabase/auth/auth_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService implements AuthService {
  final SupabaseClient _client;
  late final GoTrueClient _auth;

  SupabaseAuthService({required SupabaseClient client}) : _client = client {
    _auth = _client.auth;
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  @override
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }

  @override
  Session? get currentSession => _auth.currentSession;

  @override
  Future<AuthResponse?> refreshSession() async {
    return await _auth.refreshSession();
  }

  @override
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
}
