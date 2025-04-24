import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// UserEntity represents a user in the application, matching the Supabase PostgreSQL schema
///
/// This entity is used across multiple features including authentication and user management.
/// The class uses freezed for immutability and JSON serialization/deserialization.
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    /// Unique identifier for the user (UUID in PostgreSQL)
    required String id,

    /// User's email address (required in DB)
    required String email,

    /// User's display name
    String? name,

    /// User's role (defaults to 'user' in DB)
    @Default('user') String role,

    /// URL to user's avatar image
    String? avatar,

    /// User's preferred language (defaults to 'en' in DB)
    @Default('en') String language,

    /// Whether the user has completed onboarding
    @Default(false) bool onboardingCompleted,

    /// Whether the user's email is confirmed
    @Default(false) bool emailConfirmed,

    /// Timestamp when the user last signed in
    DateTime? lastSignInAt,

    /// Timestamp when the user was created
    DateTime? createdAt,

    /// Timestamp when the user was last updated
    DateTime? updatedAt,
  }) = _UserEntity;

  /// Creates an empty UserEntity with default values
  factory UserEntity.empty() => const UserEntity(id: '', email: '');

  /// Creates a UserEntity from JSON map
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  /// Factory method to create a UserEntity from a Supabase User object
  factory UserEntity.fromSupabaseUser(supabase.User user) {
    return UserEntity(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String?,
      avatar: user.userMetadata?['avatar_url'] as String?,
      emailConfirmed: user.emailConfirmedAt != null,
      lastSignInAt: DateTime.tryParse(user.lastSignInAt ?? ''),
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  /// Factory method to merge UserEntity with data from Supabase
  ///
  /// This method is used to update the UserEntity with fresh data from the database
  /// while preserving any local-only fields that might not be in the database
  factory UserEntity.mergeWithSupabaseData(
    UserEntity user,
    Map<String, dynamic> userData,
  ) {
    return user.copyWith(
      id: userData['id']?.toString() ?? user.id,
      email: userData['email']?.toString() ?? user.email,
      name: userData['name']?.toString() ?? user.name,
      role: userData['role']?.toString() ?? user.role,
      avatar: userData['avatar']?.toString() ?? user.avatar,
      language: userData['language']?.toString() ?? user.language,
      onboardingCompleted:
          userData['onboarding_completed'] as bool? ?? user.onboardingCompleted,
      emailConfirmed:
          userData['email_confirmed'] as bool? ?? user.emailConfirmed,
      lastSignInAt: userData['last_sign_in_at'] != null
          ? DateTime.parse(userData['last_sign_in_at'].toString())
          : user.lastSignInAt,
      createdAt: userData['created_at'] != null
          ? DateTime.parse(userData['created_at'].toString())
          : user.createdAt,
      updatedAt: userData['updated_at'] != null
          ? DateTime.parse(userData['updated_at'].toString())
          : user.updatedAt,
    );
  }
}
