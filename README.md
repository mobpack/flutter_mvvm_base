# Flutter MVVM Base

A modern Flutter application template following the MVVM (Model-View-ViewModel) architecture pattern with a clean architecture approach. This project serves as a solid foundation for building scalable, maintainable, and testable Flutter applications.

## Architecture Overview

This project implements a feature-first, layered architecture inspired by Clean Architecture principles:

- **Domain Layer**: Contains business logic and rules, independent of any UI or external frameworks
- **Data Layer**: Implements repositories defined in the domain layer and handles data sources
- **Presentation Layer**: Contains UI components and ViewModels that connect the UI with the domain layer
- **Infrastructure Layer**: Provides supporting functionality like authentication, navigation, and storage

## Project Structure

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

## Key Technologies & Packages

- **State Management**: Flutter Riverpod with riverpod_annotation
- **Navigation**: GoRouter for declarative routing
- **API Integration**: Supabase Flutter for backend services
- **Data Classes**: Freezed for immutable data models
- **Functional Programming**: FPDart for functional programming patterns
- **Forms**: Reactive Forms for form handling
- **Responsive UI**: Responsive Framework & Flutter ScreenUtil
- **Secure Storage**: Flutter Secure Storage
- **Dependency Injection**: Riverpod
- **Logging**: Logger package

## Getting Started

### Prerequisites

- Flutter SDK (^3.6.0)
- Dart SDK (^3.6.0)
- [FVM](https://fvm.app/) (optional but recommended for version management)

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/flutter_mvvm_base.git
   cd flutter_mvvm_base
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the root directory with your environment variables
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. Run the app
   ```bash
   flutter run
   ```

## Development Guidelines

### Architecture Guidelines

1. Follow the MVVM pattern for all features
2. Keep the domain layer independent of external frameworks
3. Use repositories to abstract data sources
4. Implement ViewModels using Riverpod providers

### Coding Standards

1. Follow Dart and Flutter best practices for code style and readability
2. Use meaningful naming conventions for files, classes, methods, and variables
3. Break code into small, reusable widgets and functions
4. Document all public APIs, classes, and complex logic with DartDoc comments
5. Prefer stateless widgets unless state is required
6. Use ConsumerWidget for screens and widgets that require state management
7. Leverage Dart's null safety features and avoid nullable types unless necessary
8. Use const constructors for better performance

### Testing

1. Write unit tests for business logic and ViewModels
2. Write widget tests for UI components
3. Write integration tests for critical user flows
4. Aim for high test coverage

## Contributing

1. Create a feature branch from the main branch
2. Implement your changes following the project's architecture and coding standards
3. Add tests for your changes
4. Run `flutter analyze` and `flutter format` before committing
5. Submit a pull request for review

## License

This project is licensed under the MIT License - see the LICENSE file for details.
