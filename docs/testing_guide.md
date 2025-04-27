# Testing Guide for Flutter MVVM Base

## Overview

This guide outlines the testing strategy for the Flutter MVVM Base project, following best practices for testing Flutter applications with the MVVM architecture pattern. The project aims for high test coverage across all layers of the application.

## Testing Layers

The testing strategy follows the same layered approach as the application architecture:

1. **Domain Layer Tests**: Test business logic and use cases
2. **Data Layer Tests**: Test repository implementations and data sources
3. **Presentation Layer Tests**: Test ViewModels and UI components
4. **Infrastructure Layer Tests**: Test services and utilities

## Types of Tests

### Unit Tests

Unit tests focus on testing individual components in isolation, typically with mocked dependencies.

**What to Test:**
- Use cases
- Repository implementations
- ViewModels
- Utility functions
- Service implementations

**Example: Testing a Use Case**

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
      verify(mockRepository.login(
        email: 'test@example.com',
        password: 'password',
      )).called(1);
    });
    
    test('should return AuthFailure when login fails', () async {
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
  });
}
```

**Example: Testing a ViewModel**

```dart
void main() {
  group('LoginViewModel', () {
    late MockLoginUseCase mockUseCase;
    
    setUp(() {
      mockUseCase = MockLoginUseCase();
    });
    
    test('initial state is AsyncData with null value', () {
      final container = ProviderContainer(
        overrides: [
          loginUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
      
      final viewModel = container.read(loginViewModelProvider);
      expect(viewModel, equals(const AsyncData<void>(null)));
    });
    
    test('login success updates state to AsyncData', () async {
      // Arrange
      final tUser = UserEntity(id: '1', email: 'test@example.com');
      when(mockUseCase.call(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => right(tUser));
      
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
        equals(const AsyncData<void>(null)),
      );
      verify(mockUseCase.call(
        email: 'test@example.com',
        password: 'password',
      )).called(1);
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
        predicate<AsyncValue<void>>((value) => value is AsyncError),
      );
    });
  });
}
```

### Widget Tests

Widget tests focus on testing UI components and their interaction with ViewModels.

**What to Test:**
- Screens
- Custom widgets
- Form validation
- UI state handling
- User interactions

**Example: Testing a Login Screen**

```dart
void main() {
  group('LoginScreen', () {
    late MockLoginViewModel mockViewModel;
    
    setUp(() {
      mockViewModel = MockLoginViewModel();
    });
    
    testWidgets('should display login form', (tester) async {
      // Arrange
      when(mockViewModel.state).thenReturn(const AsyncData<void>(null));
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loginViewModelProvider.overrideWithValue(mockViewModel),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      
      // Assert
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    
    testWidgets('should call login when form is submitted', (tester) async {
      // Arrange
      when(mockViewModel.state).thenReturn(const AsyncData<void>(null));
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loginViewModelProvider.overrideWithValue(mockViewModel),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password',
      );
      await tester.tap(find.byType(ElevatedButton));
      
      // Assert
      verify(mockViewModel.login('test@example.com', 'password')).called(1);
    });
    
    testWidgets('should display loading indicator when state is loading',
        (tester) async {
      // Arrange
      when(mockViewModel.state).thenReturn(const AsyncLoading<void>());
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loginViewModelProvider.overrideWithValue(mockViewModel),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('should display error message when state is error',
        (tester) async {
      // Arrange
      when(mockViewModel.state).thenReturn(
        AsyncError<void>(
          AuthFailure.invalidCredentials(),
          StackTrace.current,
        ),
      );
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loginViewModelProvider.overrideWithValue(mockViewModel),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      
      // Assert
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
```

### Integration Tests

Integration tests focus on testing multiple components working together, often involving real dependencies.

**What to Test:**
- Feature flows (e.g., authentication flow)
- Navigation between screens
- Data persistence
- API integration

**Example: Testing the Authentication Flow**

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Authentication Flow', () {
    testWidgets('login and navigate to home screen', (tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login screen
      await tester.tap(find.byType(LoginButton));
      await tester.pumpAndSettle();
      
      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password',
      );
      
      // Submit form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Verify navigation to home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
```

## Mocking Dependencies

The project uses [Mockito](https://pub.dev/packages/mockito) for mocking dependencies in tests.

**Example: Creating a Mock Repository**

```dart
// Generate mocks
@GenerateMocks([AuthRepository])
void main() {
  // Tests using MockAuthRepository
}
```

## Testing with Riverpod

Testing Riverpod providers requires special consideration:

1. Use `ProviderContainer` for unit testing providers
2. Use `ProviderScope` with overrides for widget testing
3. Use `UncontrolledProviderScope` for integration testing

**Example: Testing a Provider**

```dart
void main() {
  group('AuthNotifier', () {
    test('initial state is AuthState.initial', () {
      final container = ProviderContainer();
      final authState = container.read(authNotifierProvider);
      
      expect(authState, equals(const AuthState.initial()));
    });
    
    test('checkAuthState updates state to authenticated when user exists', () async {
      final mockAuthRepository = MockAuthRepository();
      final tUser = UserEntity(id: '1', email: 'test@example.com');
      
      when(mockAuthRepository.getCurrentUser()).thenAnswer(
        (_) async => right(tUser),
      );
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      
      await container.read(authNotifierProvider.notifier).checkAuthState();
      
      expect(
        container.read(authNotifierProvider),
        equals(AuthState.authenticated(tUser)),
      );
    });
  });
}
```

## Test Coverage

The project aims for high test coverage across all layers:

- **Domain Layer**: 90%+ coverage
- **Data Layer**: 80%+ coverage
- **Presentation Layer**: 70%+ coverage
- **Infrastructure Layer**: 70%+ coverage

To generate test coverage reports:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Best Practices

1. **Test Isolation**: Each test should be independent and not rely on the state from previous tests
2. **Arrange-Act-Assert**: Structure tests with clear arrangement, action, and assertion phases
3. **Descriptive Test Names**: Use descriptive test names that explain what is being tested
4. **Test Edge Cases**: Test both happy paths and error scenarios
5. **Mock External Dependencies**: Mock external dependencies like APIs and databases
6. **Test One Thing at a Time**: Each test should focus on testing one specific behavior
7. **Keep Tests Fast**: Tests should run quickly to encourage frequent testing
8. **Test Public APIs**: Focus on testing public APIs rather than implementation details
9. **Refactor Tests**: Refactor tests as the codebase evolves
10. **CI Integration**: Run tests automatically in CI/CD pipelines

## Test Directory Structure

The test directory structure mirrors the lib directory structure:

```
test/
├── features/               # Feature-specific tests
│   ├── auth/               # Authentication feature tests
│   │   ├── data/           # Data layer tests
│   │   ├── domain/         # Domain layer tests
│   │   └── presentation/   # Presentation layer tests
│   └── ...                 # Other feature tests
├── shared/                 # Shared component tests
│   ├── core/               # Core utility tests
│   ├── data/               # Shared data layer tests
│   ├── domain/             # Shared domain layer tests
│   └── presentation/       # Shared presentation layer tests
├── integration_test/       # Integration tests
└── mocks/                  # Mock implementations for testing
```

## Conclusion

Following this testing strategy ensures that the Flutter MVVM Base project remains robust, maintainable, and reliable. By testing all layers of the application, we can catch issues early and ensure that the application behaves as expected.
