# Flutter MVVM Base Documentation

## Overview

This documentation provides comprehensive guides for the Flutter MVVM Base project, a modern Flutter application template following the MVVM (Model-View-ViewModel) architecture pattern with a clean architecture approach. The project serves as a solid foundation for building scalable, maintainable, and testable Flutter applications.

## Documentation Guides

### Architecture and Structure
- [Architecture Guide](architecture_guide.md) - Comprehensive overview of the MVVM architecture implementation
- [Project Structure Guide](project_structure_guide.md) - Detailed explanation of the project's folder structure and organization
- [Dependency Injection Guide](dependency_injection_guide.md) - Guide to using Riverpod for dependency injection

### State Management and Navigation
- [State Management Guide](state_management_guide.md) - Guide to using Riverpod for state management
- [Navigation Guide](navigation_guide.md) - Guide to implementing navigation with GoRouter

### UI and Forms
- [Responsive UI Guide](responsive_ui_guide.md) - Guide to creating responsive and adaptive UIs
- [Forms Guide](forms_guide.md) - Guide to implementing forms with reactive_forms
- [Widgetbook Guide](widgetbook_guide.md) - Guide to using the Widgetbook component library

### Error Handling and Testing
- [Error Handling Guide](error_handling_guide.md) - Guide to functional error handling with fpdart
- [Testing Guide](testing_guide.md) - Guide to testing strategies and implementation

### Entity Documentation
- [UserEntity Documentation](user_entity.md) - Documentation for the unified UserEntity

## Key Features

- **MVVM Architecture**: Clear separation of concerns with Model, View, and ViewModel layers
- **Clean Architecture**: Domain-driven design with independent layers
- **Riverpod State Management**: Type-safe, testable state management
- **GoRouter Navigation**: Declarative routing with deep linking support
- **Responsive UI**: Adaptive layouts for different screen sizes
- **Form Handling**: Reactive forms with validation
- **Error Handling**: Functional error handling with Either type
- **Testing**: Comprehensive testing strategy
- **Widgetbook**: Component library for UI development
- **Dependency Injection**: Riverpod-based dependency injection

## Getting Started

See the [README.md](../README.md) for installation and setup instructions.

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
