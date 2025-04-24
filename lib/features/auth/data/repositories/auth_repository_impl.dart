import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user_entity.dart';
import 'package:flutter_mvvm_base/shared/domain/mappers/error_mapper.dart';
import 'package:flutter_mvvm_base/shared/logging/log_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of [IAuthRepository] using Supabase
class SupabaseAuthRepositoryImpl implements IAuthRepository {
  final SupabaseClient _client;
  late final GoTrueClient _auth;

  SupabaseAuthRepositoryImpl({required SupabaseClient client})
      : _client = client {
    _auth = _client.auth;
  }

  /// Maps a Supabase User to our domain UserEntity
  UserEntity _mapUserToEntity(User user) {
    return UserEntity.fromSupabaseUser(user);
  }

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  TaskEither<AppError, UserEntity> signInWithPassword({
    required String email,
    required String password,
  }) =>
      TaskEither.tryCatch(
        () async {
          final response = await _auth.signInWithPassword(
            email: email,
            password: password,
          );

          if (response.user == null) {
            throw const AuthException('User not found', code: 'user-not-found');
          }

          return _mapUserToEntity(response.user!);
        },
        (error, stackTrace) {
          logger.debug('Sign in error', error, stackTrace);
          return ErrorMapper.mapException(error, stackTrace);
        },
      );

  @override
  TaskEither<AppError, UserEntity> signUpWithPassword({
    required String email,
    required String password,
  }) =>
      TaskEither.tryCatch(
        () async {
          final response = await _auth.signUp(
            email: email,
            password: password,
          );

          if (response.user == null) {
            throw const AuthException(
              'Failed to create user',
              code: 'signup-failed',
            );
          }

          return _mapUserToEntity(response.user!);
        },
        (error, stackTrace) {
          logger.debug('Sign up error', error, stackTrace);
          return ErrorMapper.mapException(error, stackTrace);
        },
      );

  @override
  TaskEither<AppError, Unit> signOut() => TaskEither.tryCatch(
        () async {
          await _auth.signOut();
          return unit;
        },
        (error, stackTrace) {
          logger.debug('Sign out error', error, stackTrace);
          return ErrorMapper.mapException(error, stackTrace);
        },
      );

  @override
  TaskEither<AppError, Unit> resetPassword({required String email}) =>
      TaskEither.tryCatch(
        () async {
          await _auth.resetPasswordForEmail(email);
          return unit;
        },
        (error, stackTrace) {
          logger.debug('Reset password error', error, stackTrace);
          return ErrorMapper.mapException(error, stackTrace);
        },
      );

  @override
  TaskEither<AppError, UserEntity> updatePassword({
    required String newPassword,
  }) =>
      TaskEither.tryCatch(
        () async {
          final response =
              await _auth.updateUser(UserAttributes(password: newPassword));

          if (response.user == null) {
            throw const AuthException(
              'Failed to update password',
              code: 'update-failed',
            );
          }

          return _mapUserToEntity(response.user!);
        },
        (error, stackTrace) {
          logger.debug('Update password error', error, stackTrace);
          return ErrorMapper.mapException(error, stackTrace);
        },
      );

  @override
  TaskEither<AppError, UserEntity?> getCurrentUser() => TaskEither.tryCatch(
        () async {
          final user = _auth.currentUser;
          return user != null ? _mapUserToEntity(user) : null;
        },
        (error, stackTrace) {
          logger.debug('Get current user error', error, stackTrace);
          return ErrorMapper.mapException(error, stackTrace);
        },
      );

  @override
  TaskEither<AppError, Unit> refreshSession() => TaskEither.tryCatch(
        () async {
          await _auth.refreshSession();
          return unit;
        },
        (error, stackTrace) {
          logger.debug('Refresh session error', error, stackTrace);
          return ErrorMapper.mapException(error, stackTrace);
        },
      );

  @override
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
}
