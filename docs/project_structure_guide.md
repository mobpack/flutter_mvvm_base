# Project Structure Guide

## Overview

This guide explains the folder structure and organization of the Flutter MVVM Base project. The project follows a feature-first, layered architecture inspired by Clean Architecture principles and the MVVM (Model-View-ViewModel) pattern.

## Root Directory Structure

```
flutter_mvvm_base/
├── .dart_tool/              # Dart tool configuration
├── .fvm/                    # Flutter Version Management
├── .github/                 # GitHub workflows and templates
├── .vscode/                 # VS Code configuration
├── android/                 # Android-specific code
├── build/                   # Build outputs
├── docs/                    # Project documentation
├── ios/                     # iOS-specific code
├── lib/                     # Dart source code (main application)
├── linux/                   # Linux-specific code
├── macos/                   # macOS-specific code
├── test/                    # Test files
├── web/                     # Web-specific code
├── widgetbook/              # Widgetbook component library
├── windows/                 # Windows-specific code
├── .env                     # Environment variables
├── .fvmrc                   # FVM configuration
├── .gitignore               # Git ignore rules
├── analysis_options.yaml    # Dart analysis options
├── pubspec.lock             # Locked dependencies
├── pubspec.yaml             # Project dependencies
└── README.md                # Project overview
```

## Main Source Code Structure (`lib/`)

The `lib/` directory follows a feature-first organization with a layered architecture:

```
lib/
├── app.dart                 # Main application widget
├── main.dart                # Entry point
├── features/                # Feature modules
│   ├── auth/                # Authentication feature
│   ├── forms/               # Forms feature
│   ├── home/                # Home feature
│   ├── profile/             # Profile feature
│   ├── settings/            # Settings feature
│   └── splash/              # Splash screen feature
└── shared/                  # Shared code across features
    ├── core/                # Core utilities and constants
    ├── data/                # Shared data layer components
    ├── domain/              # Shared domain layer components
    ├── infrastructure/      # Shared infrastructure components
    └── presentation/        # Shared UI components
```

## Feature Module Structure

Each feature module follows a consistent structure based on the layered architecture:

```
features/feature_name/
├── data/                    # Data layer
│   ├── datasources/         # Data sources (remote/local)
│   ├── models/              # Data models (DTOs)
│   ├── providers/           # Data providers
│   └── repositories/        # Repository implementations
├── domain/                  # Domain layer
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── value_objects/       # Value objects
├── presentation/            # Presentation layer
│   ├── screens/             # UI screens
│   ├── viewmodels/          # ViewModels
│   └── widgets/             # Feature-specific UI components
└── usecases/                # Use cases/interactors
```

## Shared Module Structure

The shared module contains code that is used across multiple features:

```
shared/
├── core/                    # Core functionality and utilities
│   ├── constants/           # App-wide constants
│   ├── extensions/          # Dart/Flutter extensions
│   ├── logging/             # Logging functionality
│   └── utils/               # Utility functions
├── data/                    # Shared data layer
│   ├── datasources/         # Shared data sources
│   │   ├── local/           # Local storage implementations
│   │   └── remote/          # API clients and remote data sources
│   ├── models/              # Shared data models
│   └── repositories/        # Shared repository implementations
├── domain/                  # Shared domain layer
│   ├── entities/            # Shared business entities
│   │   └── user/            # User-related entities
│   ├── repositories/        # Shared repository interfaces
│   ├── services/            # Domain services
│   ├── usecases/            # Shared use cases
│   └── value_objects/       # Shared value objects
├── infrastructure/          # Infrastructure concerns
│   ├── auth/                # Authentication infrastructure
│   │   ├── domain/          # Auth domain models and interfaces
│   │   └── providers/       # Auth providers and notifiers
│   ├── navigation/          # Navigation infrastructure
│   │   ├── routes/          # Route definitions
│   │   └── services/        # Navigation services
│   └── storage/             # Storage infrastructure
└── presentation/            # Shared presentation layer
    ├── state/               # Shared state management
    │   └── providers/       # Shared providers
    ├── theme/               # Theme definitions
    └── widgets/             # Reusable widgets
        ├── buttons/         # Button components
        ├── dialogs/         # Dialog components
        ├── feedback/        # Error and feedback components
        ├── forms/           # Form components
        │   └── dynamic_form/ # Dynamic form components
        ├── layouts/         # Layout components
        └── screens/         # Common screen templates
```

## Test Directory Structure

The test directory mirrors the structure of the lib directory:

```
test/
├── features/               # Feature-specific tests
│   ├── auth/               # Authentication feature tests
│   │   ├── data/           # Data layer tests
│   │   ├── domain/         # Domain layer tests
│   │   ├── presentation/   # Presentation layer tests
│   │   └── usecases/       # Use case tests
│   └── ...                 # Other feature tests
├── shared/                 # Shared component tests
│   ├── core/               # Core utility tests
│   ├── data/               # Shared data layer tests
│   ├── domain/             # Shared domain layer tests
│   └── presentation/       # Shared presentation layer tests
├── mocks/                  # Mock implementations for testing
└── helpers/                # Test helpers and utilities
```

## Widgetbook Directory Structure

The Widgetbook is a separate application for showcasing UI components:

```
widgetbook/
├── lib/                    # Widgetbook source code
│   ├── main.dart           # Entry point for the Widgetbook app
│   ├── main.directories.g.dart # Generated directory structure
│   ├── widgets/            # Widget showcases
│   └── use_cases/          # Component use cases
├── pubspec.yaml            # Widgetbook dependencies
└── analysis_options.yaml   # Widgetbook analysis options
```

## Documentation Directory Structure

The docs directory contains comprehensive documentation for the project:

```
docs/
├── architecture_guide.md   # Architecture overview
├── dependency_injection_guide.md # Dependency injection guide
├── error_handling_guide.md # Error handling guide
├── forms_guide.md          # Forms implementation guide
├── navigation_guide.md     # Navigation guide
├── project_structure_guide.md # This guide
├── responsive_ui_guide.md  # Responsive UI guide
├── state_management_guide.md # State management guide
├── testing_guide.md        # Testing guide
├── user_entity.md          # UserEntity documentation
└── widgetbook_guide.md     # Widgetbook guide
```

## Key Files

### Entry Point

`lib/main.dart` is the entry point of the application:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  logger.init();
  logger.info('Starting app...');
  
  // Load environment variables
  await dotenv.load();
  logger.debug('Environment variables loaded');
  
  usePathUrlStrategy();
  
  runApp(
    ProviderScope(
      overrides: [
        // Provider overrides
      ],
      child: const App(),
    ),
  );
}
```

### Main Application Widget

`lib/app.dart` defines the main application widget:

```dart
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Check authentication state when app starts
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return themeModeAsync.when(
      data: (themeMode) => ScreenUtilInit(
        // App configuration
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Theme error: $e')),
        ),
      ),
    );
  }
}
```

### Dependency Configuration

`pubspec.yaml` defines the project dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  go_router: ^14.8.1
  freezed_annotation: ^3.0.0
  fpdart: ^1.1.0
  flutter_screenutil: ^5.9.3
  responsive_framework: ^1.5.1
  supabase_flutter: ^2.8.4
  # Additional dependencies...

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  riverpod_generator: ^2.6.5
  freezed: ^3.0.6
  # Additional dev dependencies...
```

## Naming Conventions

The project follows consistent naming conventions:

### Files and Directories

- **Feature Directories**: `snake_case` (e.g., `user_profile`)
- **Dart Files**: `snake_case` (e.g., `user_entity.dart`)
- **Test Files**: `snake_case` with `_test` suffix (e.g., `user_entity_test.dart`)

### Classes

- **Entities**: `PascalCase` with `Entity` suffix (e.g., `UserEntity`)
- **Models**: `PascalCase` with `Model` or `Dto` suffix (e.g., `UserDto`)
- **Repositories**: `PascalCase` with `Repository` suffix (e.g., `AuthRepository`)
- **Use Cases**: `PascalCase` with `UseCase` suffix (e.g., `LoginUseCase`)
- **ViewModels**: `PascalCase` with `ViewModel` suffix (e.g., `LoginViewModel`)
- **Widgets**: `PascalCase` (e.g., `LoginScreen`, `PrimaryButton`)

### Variables and Methods

- **Variables**: `camelCase` (e.g., `userName`)
- **Methods**: `camelCase` (e.g., `getUserProfile()`)
- **Constants**: `camelCase` for local constants, `SCREAMING_SNAKE_CASE` for top-level constants

### Providers

- **Repository Providers**: `camelCase` with `RepositoryProvider` suffix (e.g., `authRepositoryProvider`)
- **Use Case Providers**: `camelCase` with `UseCaseProvider` suffix (e.g., `loginUseCaseProvider`)
- **ViewModel Providers**: `camelCase` with `Provider` suffix (e.g., `loginViewModelProvider`)

## Layer Responsibilities

### Domain Layer

The domain layer contains the core business logic and entities:

- **Entities**: Business objects that represent the core data structures
- **Repositories (Interfaces)**: Contracts that define how data is accessed
- **Value Objects**: Immutable objects that represent specific concepts
- **Use Cases**: Business logic that orchestrates the flow of data

### Data Layer

The data layer implements the repositories defined in the domain layer:

- **Models (DTOs)**: Data Transfer Objects for serialization/deserialization
- **Repositories (Implementations)**: Concrete implementations of domain repositories
- **Data Sources**: Remote (API) and local (database) data sources

### Presentation Layer

The presentation layer contains UI components and ViewModels:

- **Screens**: UI components that display data and handle user input
- **ViewModels**: Manage UI state and business logic
- **Widgets**: Reusable UI components

### Infrastructure Layer

The infrastructure layer provides supporting functionality:

- **Services**: Technical services used across features
- **Configuration**: Application configuration
- **Utilities**: Helper functions and extensions

## Adding New Features

When adding a new feature to the project:

1. Create a new directory in `lib/features/` with the feature name (e.g., `notifications`)
2. Follow the standard feature structure (data, domain, presentation, usecases)
3. Implement the required components for each layer
4. Add tests for the new feature in `test/features/`
5. Update documentation as needed

## Best Practices

### 1. Follow the Directory Structure

Maintain the established directory structure to ensure consistency and maintainability.

### 2. Respect Layer Boundaries

Ensure that each layer only depends on the layers it should:
- Presentation depends on Domain
- Domain does not depend on Presentation or Data
- Data depends on Domain (for interfaces)

### 3. Feature-First Organization

Organize code by feature first, then by layer, to keep related code together.

### 4. Shared Code Management

Place code in the shared directory only if it's used by multiple features.

### 5. Consistent Naming

Follow the established naming conventions for files, directories, classes, and variables.

### 6. Documentation

Document the purpose and structure of new components and features.

### 7. Testing

Write tests for all components, following the established test structure.

### 8. Code Generation

Use code generation for repetitive code (e.g., freezed for data classes, riverpod_generator for providers).

### 9. Dependency Injection

Use Riverpod for dependency injection, following the established patterns.

### 10. Error Handling

Use fpdart's Either type for error handling, following the established patterns.

## Conclusion

The Flutter MVVM Base project follows a well-organized, feature-first structure with a clean separation of concerns. By understanding and following this structure, developers can maintain consistency and improve the maintainability of the codebase.
