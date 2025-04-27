# Error Handling Guide with FPDart

## Overview

This guide explains the error handling approach used in the Flutter MVVM Base project using [fpdart](https://pub.dev/packages/fpdart). The project adopts functional programming principles for error handling, making error cases explicit and ensuring they are properly handled throughout the application.

## Why Functional Error Handling?

Traditional error handling in Dart often relies on try-catch blocks and exceptions, which can lead to several issues:

1. **Implicit Errors**: Exceptions are not part of a function's type signature, making error cases implicit
2. **Uncaught Exceptions**: It's easy to forget to catch exceptions, leading to app crashes
3. **Error Propagation**: Propagating errors up the call stack can be verbose and error-prone
4. **Type Safety**: Exception types are not checked at compile time

Functional error handling with fpdart addresses these issues by:

1. **Explicit Errors**: Error cases are explicitly represented in return types
2. **Compile-time Checking**: The compiler ensures that error cases are handled
3. **Composable Error Handling**: Error handling can be composed with other operations
4. **Type Safety**: Error types are checked at compile time

## Core Concepts

### Either Type

The `Either` type from fpdart is the foundation of the error handling approach. It represents a value of one of two possible types:

- **Left**: Represents an error or failure case
- **Right**: Represents a success case

```dart
// A function that returns Either
Future<Either<AuthFailure, UserEntity>> login({
  required String email,
  required String password,
}) async {
  try {
    // Success case
    final user = await _authService.login(email, password);
    return right(user);
  } catch (e) {
    // Error case
    return left(AuthFailure.serverError(e.toString()));
  }
}
```

### Failure Classes

The project uses dedicated failure classes for different types of errors:

```dart
@freezed
class AuthFailure with _$AuthFailure {
  // Authentication-specific failures
  const factory AuthFailure.invalidCredentials() = _InvalidCredentials;
  const factory AuthFailure.emailAlreadyInUse() = _EmailAlreadyInUse;
  const factory AuthFailure.weakPassword() = _WeakPassword;
  const factory AuthFailure.userNotFound() = _UserNotFound;
  const factory AuthFailure.userDisabled() = _UserDisabled;
  const factory AuthFailure.serverError(String message) = _ServerError;
  const factory AuthFailure.networkError() = _NetworkError;
  const factory AuthFailure.unexpectedError() = _UnexpectedError;
}
```

### Option Type

The `Option` type represents a value that may or may not be present:

- **Some**: Contains a value
- **None**: Represents the absence of a value

```dart
// A function that returns Option
Option<UserEntity> getCurrentUser() {
  final user = _authService.currentUser;
  return user != null ? some(user) : none();
}
```

## Implementation Layers

### Domain Layer

In the domain layer, repository interfaces define methods that return `Either` types:

```dart
abstract class AuthRepository {
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  });
  
  Future<Either<AuthFailure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  });
  
  Future<Either<AuthFailure, Unit>> resetPassword({
    required String email,
  });
  
  Future<Either<AuthFailure, UserEntity>> getCurrentUser();
  
  Future<Either<AuthFailure, Unit>> logout();
}
```

### Data Layer

In the data layer, repository implementations convert exceptions to domain-specific failures:

```dart
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
      return left(_mapServerExceptionToFailure(e));
    } on NetworkException {
      return left(const AuthFailure.networkError());
    } catch (e) {
      return left(AuthFailure.unexpectedError());
    }
  }
  
  AuthFailure _mapServerExceptionToFailure(ServerException e) {
    switch (e.code) {
      case 'invalid-credentials':
        return const AuthFailure.invalidCredentials();
      case 'user-not-found':
        return const AuthFailure.userNotFound();
      case 'user-disabled':
        return const AuthFailure.userDisabled();
      default:
        return AuthFailure.serverError(e.message);
    }
  }
  
  // Other methods...
}
```

### Use Case Layer

Use cases in the domain layer pass through the `Either` values from repositories:

```dart
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

### Presentation Layer

In the presentation layer, ViewModels handle the `Either` values and update the UI state accordingly:

```dart
@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    
    final result = await ref.read(loginUseCaseProvider).call(
      email: email,
      password: password,
    );
    
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}
```

### UI Layer

In the UI layer, widgets handle the AsyncValue states:

```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    
    return Scaffold(
      body: loginState.when(
        data: (_) => LoginForm(
          onSubmit: (email, password) {
            ref.read(loginViewModelProvider.notifier).login(email, password);
          },
        ),
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorDisplay(
          error: error as AuthFailure,
          onRetry: () => ref.refresh(loginViewModelProvider),
        ),
      ),
    );
  }
}
```

## Error Handling Patterns

### Pattern Matching with freezed

The project uses freezed for pattern matching on failure types:

```dart
Widget buildErrorMessage(AuthFailure failure) {
  return failure.map(
    invalidCredentials: (_) => const Text('Invalid email or password'),
    emailAlreadyInUse: (_) => const Text('Email is already in use'),
    weakPassword: (_) => const Text('Password is too weak'),
    userNotFound: (_) => const Text('User not found'),
    userDisabled: (_) => const Text('User account has been disabled'),
    serverError: (failure) => Text('Server error: ${failure.message}'),
    networkError: (_) => const Text('Network error. Please check your connection'),
    unexpectedError: (_) => const Text('An unexpected error occurred'),
  );
}
```

### Chaining Operations

FPDart allows for chaining operations with error handling:

```dart
Future<Either<Failure, UserProfile>> getUserProfileWithPreferences(String userId) async {
  return await getUserProfile(userId).flatMap(
    (profile) => getUserPreferences(userId).map(
      (preferences) => profile.copyWith(preferences: preferences),
    ),
  );
}
```

### Transforming Errors

Errors can be transformed to different types:

```dart
Future<Either<UIError, UserEntity>> login(String email, String password) async {
  return await _authRepository
    .login(email: email, password: password)
    .mapLeft((authFailure) => _mapAuthFailureToUIError(authFailure));
}

UIError _mapAuthFailureToUIError(AuthFailure failure) {
  return failure.map(
    invalidCredentials: (_) => const UIError.form(
      field: 'password',
      message: 'Invalid email or password',
    ),
    // Other mappings...
  );
}
```

### Combining Multiple Results

Multiple results can be combined:

```dart
Future<Either<Failure, UserSettings>> getUserSettings(String userId) async {
  final profileResult = await getUserProfile(userId);
  final preferencesResult = await getUserPreferences(userId);
  final themeResult = await getUserTheme(userId);
  
  return profileResult.flatMap(
    (profile) => preferencesResult.flatMap(
      (preferences) => themeResult.map(
        (theme) => UserSettings(
          profile: profile,
          preferences: preferences,
          theme: theme,
        ),
      ),
    ),
  );
}
```

## Error Reporting

The project includes error reporting to track and analyze errors:

```dart
Future<Either<AuthFailure, UserEntity>> login({
  required String email,
  required String password,
}) async {
  try {
    final user = await _authService.login(email, password);
    return right(user);
  } catch (e, stackTrace) {
    // Log the error
    _logger.error('Login error', e, stackTrace);
    
    // Report the error to an error tracking service
    _errorReporter.reportError(e, stackTrace);
    
    // Return the appropriate failure
    return left(_mapExceptionToFailure(e));
  }
}
```

## Testing Error Handling

### Testing Repositories

```dart
void main() {
  group('AuthRepositoryImpl', () {
    late MockAuthRemoteDataSource mockRemoteDataSource;
    late MockAuthLocalDataSource mockLocalDataSource;
    late AuthRepositoryImpl repository;
    
    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockLocalDataSource = MockAuthLocalDataSource();
      repository = AuthRepositoryImpl(
        mockRemoteDataSource,
        mockLocalDataSource,
      );
    });
    
    test('should return AuthFailure.invalidCredentials when credentials are invalid',
        () async {
      // Arrange
      when(mockRemoteDataSource.login(any, any))
          .thenThrow(const ServerException(code: 'invalid-credentials'));
      
      // Act
      final result = await repository.login(
        email: 'test@example.com',
        password: 'password',
      );
      
      // Assert
      expect(result, equals(left(const AuthFailure.invalidCredentials())));
    });
    
    test('should return UserEntity when login is successful', () async {
      // Arrange
      final tUserDto = UserDto(id: '1', email: 'test@example.com');
      when(mockRemoteDataSource.login(any, any))
          .thenAnswer((_) async => tUserDto);
      
      // Act
      final result = await repository.login(
        email: 'test@example.com',
        password: 'password',
      );
      
      // Assert
      expect(result, equals(right(tUserDto.toDomain())));
    });
  });
}
```

### Testing Use Cases

```dart
void main() {
  group('LoginUseCase', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase useCase;
    
    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });
    
    test('should return AuthFailure when repository returns failure', () async {
      // Arrange
      final tFailure = AuthFailure.invalidCredentials();
      when(mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => left(tFailure));
      
      // Act
      final result = await useCase.call(
        email: 'test@example.com',
        password: 'password',
      );
      
      // Assert
      expect(result, equals(left(tFailure)));
    });
    
    test('should return UserEntity when repository returns success', () async {
      // Arrange
      final tUser = UserEntity(id: '1', email: 'test@example.com');
      when(mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => right(tUser));
      
      // Act
      final result = await useCase.call(
        email: 'test@example.com',
        password: 'password',
      );
      
      // Assert
      expect(result, equals(right(tUser)));
    });
  });
}
```

### Testing ViewModels

```dart
void main() {
  group('LoginViewModel', () {
    late MockLoginUseCase mockUseCase;
    
    setUp(() {
      mockUseCase = MockLoginUseCase();
    });
    
    test('login failure updates state to AsyncError', () async {
      // Arrange
      final tFailure = AuthFailure.invalidCredentials();
      when(mockUseCase.call(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => left(tFailure));
      
      final container = ProviderContainer(
        overrides: [
          loginUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
      
      // Act
      await container.read(loginViewModelProvider.notifier).login(
        'test@example.com',
        'password',
      );
      
      // Assert
      expect(
        container.read(loginViewModelProvider),
        isA<AsyncError>(),
      );
      expect(
        (container.read(loginViewModelProvider) as AsyncError).error,
        equals(tFailure),
      );
    });
  });
}
```

## Best Practices

### 1. Use Domain-Specific Failures

Create domain-specific failure classes that represent the different types of errors that can occur in your application.

### 2. Map Exceptions to Failures

Map exceptions to domain-specific failures in the data layer to isolate the rest of the application from implementation details.

### 3. Use Pattern Matching

Use pattern matching with freezed to handle different failure types in a type-safe way.

### 4. Be Explicit About Error Types

Be explicit about the error types that can be returned from each function.

### 5. Handle All Error Cases

Ensure that all error cases are handled appropriately in the UI.

### 6. Log Errors

Log errors with appropriate context to help with debugging.

### 7. Report Critical Errors

Report critical errors to an error tracking service to help identify and fix issues in production.

### 8. Test Error Handling

Write tests for error handling to ensure that errors are handled correctly.

### 9. Use Meaningful Error Messages

Provide meaningful error messages to users to help them understand what went wrong.

### 10. Graceful Degradation

Design the application to gracefully degrade when errors occur, providing alternative functionality when possible.

## Conclusion

Functional error handling with fpdart provides a robust and type-safe approach to error handling in Flutter applications. By following the patterns and best practices outlined in this guide, you can create a more reliable and maintainable application that handles errors gracefully.
