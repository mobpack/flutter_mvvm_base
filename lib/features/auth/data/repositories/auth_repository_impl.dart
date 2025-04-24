import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

/// Implementation of [IAuthRepository] using Supabase
class SupabaseAuthRepositoryImpl implements IAuthRepository {
  final SupabaseClient _client;
  late final GoTrueClient _auth;

  SupabaseAuthRepositoryImpl({required SupabaseClient client})
      : _client = client {
    _auth = _client.auth;
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  TaskEither<Failure, AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) => TaskEither.tryCatch(
    () => _auth.signInWithPassword(
      email: email,
      password: password,
    ),
    (error, _) => Failure.network(error.toString()),
  );

  @override
  TaskEither<Failure, AuthResponse> signUpWithPassword({
    required String email,
    required String password,
  }) => TaskEither.tryCatch(
    () => _auth.signUp(
      email: email,
      password: password,
    ),
    (error, _) => Failure.network(error.toString()),
  );

  @override
  TaskEither<Failure, void> signOut() => TaskEither.tryCatch(
    () => _auth.signOut(),
    (error, _) => Failure.unknown(error.toString()),
  );

  @override
  TaskEither<Failure, void> resetPassword(String email) => TaskEither.tryCatch(
    () => _auth.resetPasswordForEmail(email),
    (error, _) => Failure.network(error.toString()),
  );

  @override
  TaskEither<Failure, UserResponse> updatePassword(String newPassword) => TaskEither.tryCatch(
    () => _auth.updateUser(UserAttributes(password: newPassword)),
    (error, _) => Failure.network(error.toString()),
  );

  @override
  Session? get currentSession => _auth.currentSession;

  @override
  TaskEither<Failure, AuthResponse?> refreshSession() => TaskEither.tryCatch(
    () => _auth.refreshSession(),
    (error, _) => Failure.unknown(error.toString()),
  );

  @override
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
}
