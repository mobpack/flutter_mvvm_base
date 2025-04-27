# Domain

This directory contains the domain layer of the application, following the MVVM architecture pattern.

## Structure

- **common/**: Common domain models and utilities
- **entities/**: Business entities (domain models)
- **mappers/**: Mappers for converting between domain and data models
- **repositories/**: Repository interfaces
- **services/**: Domain services
- **usecases/**: Use cases/interactors
- **value_objects/**: Value objects

## Best Practices

1. Keep domain layer independent of UI and data sources
2. Use fpdart for functional programming concepts
3. Use freezed for immutable domain models
4. Define clear interfaces for repositories
5. Implement use cases for each business operation
6. Document all public APIs with DartDoc comments
7. Write unit tests for all domain logic
8. Use meaningful naming that reflects the business domain
9. Avoid nullable types unless necessary
10. Use value objects for validated domain values
