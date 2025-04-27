# UserEntity Documentation

## Overview

The `UserEntity` class is a unified entity used across all features in the application. It serves as the single source of truth for user data, ensuring consistency throughout the application.

## Location

The `UserEntity` is located at:
```
lib/shared/domain/entities/user/user_entity.dart
```

## Implementation

The `UserEntity` is implemented using [freezed](https://pub.dev/packages/freezed) for immutability and code generation:

```dart
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
  
  // Factory methods...
}
```

## Key Features

1. **Immutability**: The entity is immutable, ensuring data integrity.
2. **Default Values**: Provides sensible defaults for optional fields.
3. **Comprehensive Fields**: Includes all user-related fields needed across different features.
4. **Supabase Integration**: Includes factory methods for Supabase integration.

## Factory Methods

### Empty User

Creates an empty `UserEntity` with default values:

```dart
factory UserEntity.empty() => const UserEntity(id: '', email: '');
```

### From JSON

Creates a `UserEntity` from a JSON map:

```dart
factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
```

### From Supabase User

Creates a `UserEntity` from a Supabase User object:

```dart
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
```

### Merge with Supabase Data

Updates a `UserEntity` with fresh data from the database:

```dart
factory UserEntity.mergeWithSupabaseData(
  UserEntity user,
  Map<String, dynamic> userData,
) {
  return user.copyWith(
    // Field mappings...
  );
}
```

## Usage Across Features

The `UserEntity` is used across multiple features:

1. **Authentication**: For user login, registration, and session management
2. **Profile**: For displaying and editing user profile information
3. **Settings**: For user preferences and settings
4. **Home**: For personalized content and user-specific functionality

## Best Practices

1. **Single Source of Truth**: Always use this entity for user data across all features
2. **Immutability**: Never modify the entity directly; use `copyWith` for changes
3. **Factory Methods**: Use the provided factory methods for creating and updating entities
4. **Validation**: Validate user data before creating or updating entities
5. **Documentation**: Document any changes to the entity structure

## Migration from Multiple UserEntity Classes

Previously, the application had two separate UserEntity classes:
1. `/features/auth/domain/entity/user_entity.dart` - focused on authentication
2. `/features/user/domain/user_entity.dart` - more comprehensive

These have been consolidated into a single `UserEntity` class that serves all features, ensuring consistency and reducing duplication.
