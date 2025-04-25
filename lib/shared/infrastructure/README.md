# Infrastructure

This directory contains infrastructure concerns that support the application's functionality.

## Structure

- **auth/**: Authentication infrastructure
  - **domain/**: Auth domain models and interfaces
  - **providers/**: Auth providers and notifiers
- **navigation/**: Navigation infrastructure
  - **routes/**: Route definitions
  - **services/**: Navigation services
- **storage/**: Storage infrastructure

## Best Practices

1. Follow the MVVM architecture pattern
2. Use dependency injection for all services
3. Keep infrastructure concerns separate from business logic
4. Use Riverpod for state management and dependency injection
5. Write unit tests for all infrastructure components
6. Document all public APIs with DartDoc comments
7. Use freezed for data classes and value objects
8. Prefer const constructors for better performance
