# Feature Modules

This directory contains feature modules following the MVVM (Model-View-ViewModel) architecture pattern with a clean architecture approach. Each feature is self-contained with its own data, domain, and presentation layers.

## Directory Structure

```
features/
├── auth/                  # Authentication feature
│   ├── data/              # Data layer
│   ├── domain/            # Domain layer
│   ├── presentation/      # Presentation layer
│   └── usecases/          # Use cases/interactors
├── forms/                 # Forms feature
├── home/                  # Home feature
├── profile/               # User profile feature
├── settings/              # App settings feature
└── splash/                # Splash screen feature
```

## Feature Architecture

Each feature follows a layered architecture:

### Data Layer
- **Models**: Data transfer objects (DTOs)
- **Repositories**: Implementations of domain repositories
- **Providers**: Riverpod providers for data sources

### Domain Layer
- **Entities**: Business entities
- **Repositories**: Repository interfaces
- **Value Objects**: Immutable value objects

### Presentation Layer
- **Screens**: UI screens
- **ViewModels**: Manages UI state and business logic
- **Widgets**: Feature-specific UI components

### Use Cases
- **Interactors**: Business logic that orchestrates the flow of data between the presentation and data layers

## Shared Entities

To maintain consistency across features, the application uses a unified `UserEntity` located in `shared/domain/entities/user/user_entity.dart`. This entity is used by all features that need user information, ensuring a single source of truth for user data.

The unified `UserEntity` includes all fields needed across different features:

- Authentication data (id, email, emailConfirmed, lastSignInAt)
- Profile information (name, avatar)
- User preferences (language, role)
- System fields (createdAt, updatedAt)

## Feature Guidelines

### Adding a New Feature

1. Create a new directory in `features/` with a descriptive name
2. Implement the standard layered architecture (data, domain, presentation, usecases)
3. Use the shared `UserEntity` for user-related functionality
4. Follow the MVVM pattern for connecting UI with business logic
5. Use Riverpod for state management and dependency injection
6. Write tests for all components

### Feature Independence

Features should be as independent as possible, with minimal dependencies on other features. Cross-feature communication should be handled through:

1. Shared entities in the domain layer
2. Riverpod providers for state management
3. Navigation service for screen transitions

### Feature-Specific vs. Shared Code

- Code that is used by multiple features should be moved to the `shared/` directory
- Feature-specific code should remain within the feature directory
- If a component starts as feature-specific but later needs to be shared, refactor it to the shared directory

## Current Features

### Authentication (auth)
Handles user authentication, including login, registration, and password reset.

### Forms (forms)
Provides form handling and validation functionality.

### Home (home)
Implements the main home screen and dashboard functionality.

### Profile (profile)
Manages user profile information and editing.

### Settings (settings)
Handles application settings and preferences.

### Splash (splash)
Implements the application splash screen and initial loading.
