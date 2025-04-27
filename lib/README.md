# Project Structure and Architecture

This project follows a feature-first, layered architecture inspired by Clean Architecture principles and MVVM (Model-View-ViewModel) pattern. The codebase is organized to promote separation of concerns, testability, and maintainability.

## Directory Structure

```
lib/
├── app.dart                # Main application widget
├── main.dart               # Entry point
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   ├── forms/              # Forms feature
│   ├── home/               # Home feature
│   ├── profile/            # Profile feature
│   ├── settings/           # Settings feature
│   └── splash/             # Splash screen feature
└── shared/                 # Shared code across features
    ├── core/               # Core utilities and constants
    ├── data/               # Shared data layer components
    ├── domain/             # Shared domain layer components
    ├── infrastructure/     # Shared infrastructure components
    └── presentation/       # Shared UI components
```

## Architecture Layers

### Domain Layer
- Contains business entities, repository interfaces, and use cases
- Independent of external frameworks and UI
- Defines the core business logic and rules

### Data Layer
- Implements repository interfaces defined in the domain layer
- Manages data sources (remote and local)
- Handles data transformations and caching

### Presentation Layer
- Contains UI components (screens, widgets)
- Implements ViewModels using Riverpod providers
- Connects UI with domain layer through ViewModels

### Infrastructure Layer
- Provides cross-cutting concerns like authentication, navigation, and storage
- Implements technical services used across features

## Key Entities

### UserEntity

The application uses a unified `UserEntity` class located in `shared/domain/entities/user/user_entity.dart`. This entity is used across all features including authentication and user management, ensuring consistency throughout the application.

Key fields include:
- `id`: Unique identifier for the user
- `email`: User's email address
- `name`: User's display name
- `role`: User's role (defaults to 'user')
- `avatar`: URL to user's avatar image
- `language`: User's preferred language
- `onboardingCompleted`: Whether the user has completed onboarding
- `emailConfirmed`: Whether the user's email is confirmed
- `lastSignInAt`: Timestamp when the user last signed in
- `createdAt`: Timestamp when the user was created
- `updatedAt`: Timestamp when the user was last updated

## Adding a New Feature

1. Create a folder in `features/` (e.g., `features/notifications/`)
2. Inside, add the following structure:
   ```
   notifications/
   ├── data/                  # Data layer
   │   ├── models/            # Data models (DTOs)
   │   ├── providers/         # Riverpod providers
   │   └── repositories/      # Repository implementations
   ├── domain/                # Domain layer
   │   ├── entities/          # Business entities
   │   └── repositories/      # Repository interfaces
   ├── presentation/          # Presentation layer
   │   ├── screens/           # UI screens
   │   ├── viewmodels/        # ViewModels
   │   └── widgets/           # UI components
   └── usecases/              # Use cases/interactors
   ```
3. Add tests in `test/features/notifications/`

## State Management

This project uses Riverpod for state management and dependency injection:

- Use `riverpod_annotation` for code generation
- Create providers in the appropriate layer
- Use `ConsumerWidget` for widgets that need to access state
- Follow the MVVM pattern for connecting UI with business logic

## Navigation

The application uses GoRouter for navigation:

- Route definitions are in `shared/infrastructure/navigation/routes/`
- Navigation service is in `shared/infrastructure/navigation/services/`

## Coding Standards

1. Follow Dart and Flutter best practices
2. Use meaningful naming conventions
3. Document all public APIs with DartDoc comments
4. Write tests for all components
5. Use null safety and avoid nullable types unless necessary
6. Prefer stateless widgets unless state is required
7. Use const constructors for better performance
8. Break code into small, reusable components
