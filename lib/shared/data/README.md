# Data

This directory contains the data layer of the application, following the MVVM architecture pattern.

## Structure

- **datasources/**: Data sources for retrieving and storing data
  - **local/**: Local data sources (e.g., SharedPreferences, SQLite)
  - **remote/**: Remote data sources (e.g., REST APIs, GraphQL)
- **models/**: Data transfer objects (DTOs)
- **repositories/**: Repository implementations

## Best Practices

1. Implement repository interfaces defined in the domain layer
2. Use dependency injection for all data sources
3. Handle errors properly and convert them to domain errors
4. Use freezed for data models
5. Document all public APIs with DartDoc comments
6. Write unit tests for all repository implementations
7. Use meaningful naming that reflects the data structure
8. Separate concerns between data sources and repositories
9. Use proper error handling with Either from fpdart
10. Avoid exposing implementation details to the domain layer
