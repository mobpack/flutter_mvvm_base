import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// UserEntity represents a user in the application, matching the Supabase PostgreSQL schema
///
/// The class uses freezed for immutability and JSON serialization/deserialization
@freezed
abstract class UserEntity implements _$UserEntity {
  const UserEntity._(); // Private constructor for adding methods to the class

  /// Default constructor with named parameters
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

  /// Merges this UserEntity with data from Supabase
  ///
  /// This method is used to update the UserEntity with fresh data from the database
  /// while preserving any local-only fields that might not be in the database
  UserEntity mergeWithSupabaseData(Map<String, dynamic> userData) {
    return copyWith(
      id: userData['id']?.toString() ?? id,
      email: userData['email']?.toString() ?? email,
      role: userData['role']?.toString() ?? role,
      avatar: userData['avatar']?.toString(),
      language: userData['language']?.toString() ?? language,
      onboardingCompleted:
          userData['onboarding_completed'] as bool? ?? onboardingCompleted,
      createdAt: userData['created_at'] != null
          ? DateTime.parse(userData['created_at'].toString())
          : createdAt,
      updatedAt: userData['updated_at'] != null
          ? DateTime.parse(userData['updated_at'].toString())
          : updatedAt,
    );
  }
}
