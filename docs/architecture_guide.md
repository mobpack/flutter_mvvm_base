# Flutter MVVM Architecture Guide

## Overview

This document provides a comprehensive guide to the MVVM (Model-View-ViewModel) architecture pattern as implemented in the Flutter MVVM Base project. The architecture follows clean architecture principles and is designed to be scalable, maintainable, and testable.

## Architecture Layers

The application is structured into four main layers:

### 1. Domain Layer

The domain layer contains the core business logic and rules of the application, independent of any UI or external frameworks.

**Key Components:**
- **Entities**: Business objects that represent the core data structures
- **Repositories (Interfaces)**: Contracts that define how data is accessed
- **Use Cases**: Business logic that orchestrates the flow of data
- **Value Objects**: Immutable objects that represent specific concepts

**Example:**
```dart
// Domain Entity
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    String? name,
    // Additional fields...
  }) = _UserEntity;
  
  // Factory methods...
}

// Repository Interface
abstract class AuthRepository {
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  });
  
  // Additional methods...
}

// Use Case
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<Either<AuthFailure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
```

### 2. Data Layer

The data layer implements the repositories defined in the domain layer and handles data sources.

**Key Components:**
- **Repositories (Implementations)**: Concrete implementations of domain repositories
- **Data Sources**: Remote (API) and local (database) data sources
- **Models (DTOs)**: Data Transfer Objects for serialization/deserialization

**Example:**
```dart
// Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  
  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);
  
  @override
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userDto = await _remoteDataSource.login(email, password);
      await _localDataSource.cacheUser(userDto);
      return right(userDto.toDomain());
    } on ServerException catch (e) {
      return left(AuthFailure.serverError(e.message));
    }
  }
  
  // Additional methods...
}
```

### 3. Presentation Layer

The presentation layer contains UI components and ViewModels that connect the UI with the domain layer.

**Key Components:**
- **Screens**: UI components that display data and handle user input
- **ViewModels**: Manage UI state and business logic
- **Widgets**: Reusable UI components

**Example:**
```dart
// ViewModel (using Riverpod)
@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  FutureOr<void> build() {}
  
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    
    final result = await ref.read(loginUseCaseProvider).call(
      email: email,
      password: password,
    );
    
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) => const AsyncData(null),
    );
  }
}

// Screen
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    
    return Scaffold(
      // UI implementation...
      
      // Example of handling login
      onPressed: () {
        ref.read(loginViewModelProvider.notifier).login(email, password);
      },
    );
  }
}
```

### 4. Infrastructure Layer

The infrastructure layer provides supporting functionality like authentication, navigation, and storage.

**Key Components:**
- **Services**: Technical services used across features
- **Configuration**: Application configuration
- **Utilities**: Helper functions and extensions

## State Management with Riverpod

The project uses Riverpod for state management and dependency injection, with code generation for better type safety and maintainability.

### Provider Types

1. **Provider**: For simple values that don't change
2. **StateProvider**: For simple state that can be modified
3. **StateNotifierProvider**: For complex state with multiple methods
4. **FutureProvider**: For asynchronous data
5. **StreamProvider**: For reactive data streams

### Code Generation

The project uses `riverpod_annotation` for code generation:

```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() async {
    // Initialize state
    return const AuthState.initial();
  }
  
  Future<void> login(String email, String password) async {
    // Implementation...
  }
}
```

### Best Practices

1. **Provider Organization**: Group related providers in a single file
2. **Scoped Providers**: Use `ProviderScope` to limit provider visibility
3. **Provider Overrides**: Use overrides for testing and feature flags
4. **Error Handling**: Handle errors gracefully in providers
5. **Caching**: Use `keepAlive` for providers that should persist

## Navigation with GoRouter

The application uses GoRouter for declarative routing:

```dart
@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Additional routes...
    ],
    redirect: (context, state) {
      // Navigation logic based on auth state
    },
  );
}
```

## Error Handling

The project uses the Either type from fpdart for functional error handling:

```dart
Future<Either<AuthFailure, UserEntity>> login({
  required String email,
  required String password,
}) async {
  try {
    // Implementation...
    return right(user);
  } catch (e) {
    return left(AuthFailure.serverError(e.toString()));
  }
}
```

## Testing

The project follows a comprehensive testing strategy:

### Unit Tests

Test individual components in isolation:

```dart
void main() {
  group('LoginUseCase', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase useCase;
    
    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });
    
    test('should return UserEntity when login is successful', () async {
      // Arrange
      when(mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => right(tUser));
      
      // Act
      final result = await useCase(email: 'test@example.com', password: 'password');
      
      // Assert
      expect(result, right(tUser));
      verify(mockRepository.login(
        email: 'test@example.com',
        password: 'password',
      ));
    });
    
    // Additional tests...
  });
}
```

### Widget Tests

Test UI components:

```dart
void main() {
  group('LoginScreen', () {
    testWidgets('should show error when login fails', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loginViewModelProvider.overrideWith((ref) => MockLoginViewModel()),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      
      // Act
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Assert
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
    
    // Additional tests...
  });
}
```

### Integration Tests

Test multiple components working together:

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('End-to-End Test', () {
    testWidgets('login flow test', (tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login
      await tester.tap(find.byType(LoginButton));
      await tester.pumpAndSettle();
      
      // Enter credentials
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Verify navigation to home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
```

## Conclusion

The MVVM architecture with clean architecture principles provides a solid foundation for building scalable, maintainable, and testable Flutter applications. By following the guidelines in this document, you can ensure that your code remains organized, testable, and easy to understand.

## References

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [FPDart Documentation](https://pub.dev/packages/fpdart)
