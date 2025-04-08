import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// UserEntity represents a user in the application, matching the Supabase PostgreSQL schema
///
/// The class uses freezed for immutability and JSON serialization/deserialization
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    /// Unique identifier for the user (UUID in PostgreSQL)
    required String id,

    /// User's email address (required in DB)
    required String email,

    /// User's role (defaults to 'user' in DB)
    @Default('user') String role,

    /// URL to user's avatar image
    String? avatar,

    /// User's preferred language (defaults to 'en' in DB)
    @Default('en') String language,

    /// Whether the user has completed onboarding
    @Default(false) bool onboardingCompleted,

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
      role: userData['role']?.toString() ?? user.role,
      avatar: userData['avatar']?.toString(),
      language: userData['language']?.toString() ?? user.language,
      onboardingCompleted:
          userData['onboarding_completed'] as bool? ?? user.onboardingCompleted,
      createdAt: userData['created_at'] != null
          ? DateTime.parse(userData['created_at'].toString())
          : user.createdAt,
      updatedAt: userData['updated_at'] != null
          ? DateTime.parse(userData['updated_at'].toString())
          : user.updatedAt,
    );
  }
}
