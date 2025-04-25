# Shared

This directory contains shared code and components used across multiple features in the application, following the Flutter MVVM architecture pattern.

## Directory Structure

```
lib/shared/
├── core/                        # Core functionality and utilities
│   ├── constants/               # App-wide constants
│   ├── extensions/              # Dart/Flutter extensions
│   ├── logging/                 # Logging functionality
│   └── utils/                   # Utility functions
│
├── data/                        # Data layer
│   ├── datasources/             # Remote and local data sources
│   │   ├── local/               # Local storage implementations
│   │   └── remote/              # API clients and remote data sources
│   ├── models/                  # Data models (DTOs)
│   └── repositories/            # Repository implementations
│
├── domain/                      # Domain layer
│   ├── entities/                # Business entities
│   ├── repositories/            # Repository interfaces
│   ├── services/                # Domain services
│   ├── usecases/                # Use cases/interactors
│   └── value_objects/           # Value objects
│
├── infrastructure/              # Infrastructure concerns
│   ├── auth/                    # Authentication infrastructure
│   │   ├── domain/              # Auth domain models and interfaces
│   │   └── providers/           # Auth providers and notifiers
│   ├── navigation/              # Navigation infrastructure
│   │   ├── routes/              # Route definitions
│   │   └── services/            # Navigation services
│   └── storage/                 # Storage infrastructure
│
└── presentation/                # Presentation layer
    ├── state/                   # Shared state management
    │   └── providers/           # Shared providers
    ├── theme/                   # Theme definitions
    └── widgets/                 # Reusable widgets
        ├── buttons/             # Button components
        ├── dialogs/             # Dialog components
        ├── feedback/            # Error and feedback components
        ├── forms/               # Form components
        │   └── dynamic_form/    # Dynamic form components
        ├── layouts/             # Layout components
        └── screens/             # Common screen templates
```

## Architecture Guidelines

This project follows the MVVM (Model-View-ViewModel) architecture pattern with a clean architecture approach:

1. **Domain Layer**: Contains business logic and rules, independent of any UI or external frameworks
2. **Data Layer**: Implements repositories defined in the domain layer and handles data sources
3. **Presentation Layer**: Contains UI components and ViewModels that connect the UI with the domain layer
4. **Infrastructure Layer**: Provides supporting functionality like authentication, navigation, and storage

## Best Practices

1. **Dependency Injection**: Use Riverpod for dependency injection and state management
2. **Immutable State**: Use freezed for data classes and value objects
3. **Functional Programming**: Use fpdart for functional programming concepts like Either for error handling
4. **Stateless Widgets**: Prefer stateless widgets unless state is required
5. **ConsumerWidget**: Use ConsumerWidget for screens and widgets that require state management
6. **GoRouter**: Use GoRouter for navigation and routing
7. **Documentation**: Add DartDoc comments to all public APIs, classes, and complex logic
8. **Testing**: Write unit, widget, and integration tests for all components
9. **Null Safety**: Leverage Dart's null safety features and avoid nullable types unless necessary
10. **Const Constructors**: Use const constructors for better performance
11. **Small Components**: Break code into small, reusable widgets and functions
12. **Meaningful Names**: Use clear, descriptive names for files, classes, methods, and variables

## Adding New Shared Components

When adding new shared components:

1. Place them in the appropriate directory based on their responsibility
2. Follow the existing naming conventions and code style
3. Document the component with DartDoc comments
4. Write tests for the component
5. Update the relevant README.md file if necessary

## Feature-Specific vs. Shared Code

- Place code in the `shared` directory only if it's used by multiple features
- Feature-specific code should remain in the feature directory
- If a component starts as feature-specific but later needs to be shared, refactor it to the shared directory
