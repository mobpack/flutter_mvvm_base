# State Management Guide with Riverpod

## Overview

This guide outlines the state management approach for the Flutter MVVM Base project using Riverpod. The project leverages Riverpod's capabilities for dependency injection, state management, and code generation to create a maintainable and testable codebase.

## Why Riverpod?

Riverpod was chosen as the state management solution for several key reasons:

1. **Type Safety**: Provides compile-time safety with strong typing
2. **Testability**: Makes testing straightforward with easy dependency overrides
3. **Composability**: Allows for composition of providers
4. **Code Generation**: Reduces boilerplate with `riverpod_annotation`
5. **Reactivity**: Efficiently rebuilds only what's needed when state changes
6. **Scoping**: Provides fine-grained control over provider lifetimes
7. **Dependency Tracking**: Automatically handles dependencies between providers

## Provider Types

Riverpod offers several provider types, each suited for different use cases:

### Provider

Used for values that don't change and depend on other providers.

```dart
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final authDataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(authDataSource);
}
```

### StateProvider

Used for simple state that can be modified directly.

```dart
@riverpod
class ThemeMode extends _$ThemeMode {
  @override
  ThemeMode build() => ThemeMode.system;
  
  void setLightMode() => state = ThemeMode.light;
  void setDarkMode() => state = ThemeMode.dark;
  void setSystemMode() => state = ThemeMode.system;
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
```

### NotifierProvider

Used for complex state with multiple methods.

```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();
  
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    
    final result = await ref.read(authRepositoryProvider).login(
      email: email,
      password: password,
    );
    
    state = result.fold(
      (failure) => AuthState.error(failure),
      (user) => AuthState.authenticated(user),
    );
  }
  
  Future<void> logout() async {
    state = const AuthState.loading();
    
    final result = await ref.read(authRepositoryProvider).logout();
    
    state = result.fold(
      (failure) => AuthState.error(failure),
      (_) => const AuthState.unauthenticated(),
    );
  }
  
  Future<void> checkAuthState() async {
    state = const AuthState.loading();
    
    final result = await ref.read(authRepositoryProvider).getCurrentUser();
    
    state = result.fold(
      (failure) => const AuthState.unauthenticated(),
      (user) => AuthState.authenticated(user),
    );
  }
}
```

### AsyncNotifierProvider

Used for state that depends on asynchronous operations.

```dart
@riverpod
class UserProfile extends _$UserProfile {
  @override
  FutureOr<UserEntity> build() {
    return _fetchUserProfile();
  }
  
  Future<UserEntity> _fetchUserProfile() async {
    final userId = ref.read(currentUserIdProvider);
    final result = await ref.read(userRepositoryProvider).getUserById(userId);
    
    return result.fold(
      (failure) => throw failure,
      (user) => user,
    );
  }
  
  Future<void> updateProfile({
    String? name,
    String? avatar,
    String? language,
  }) async {
    state = const AsyncLoading();
    
    final currentUser = await future;
    final updatedUser = currentUser.copyWith(
      name: name ?? currentUser.name,
      avatar: avatar ?? currentUser.avatar,
      language: language ?? currentUser.language,
    );
    
    final result = await ref.read(userRepositoryProvider).updateUser(updatedUser);
    
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) => AsyncData(user),
    );
  }
}
```

### FutureProvider

Used for asynchronous data that doesn't need to be modified.

```dart
@riverpod
Future<List<SettingOption>> settingsOptions(SettingsOptionsRef ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  final result = await repository.getSettingsOptions();
  
  return result.fold(
    (failure) => throw failure,
    (options) => options,
  );
}
```

### StreamProvider

Used for reactive data streams.

```dart
@riverpod
Stream<List<Notification>> notifications(NotificationsRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  return repository.getNotificationsStream(userId);
}
```

## Code Organization

### Provider Files

Providers are organized by feature and layer:

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── providers.dart        # Data layer providers
│   │   ├── presentation/
│   │   │   └── providers/
│   │   │       └── auth_provider.dart # Presentation layer providers
│   │   └── usecases/
│   │       └── login_use_case.dart   # Use case providers
│   └── ...
└── shared/
    ├── infrastructure/
    │   └── providers/
    │       └── shared_providers.dart # Shared providers
    └── ...
```

### Provider Naming Conventions

- **Repository Providers**: `{name}RepositoryProvider`
- **Data Source Providers**: `{name}DataSourceProvider`
- **Use Case Providers**: `{name}UseCaseProvider`
- **Notifier Providers**: `{name}NotifierProvider`
- **State Providers**: `{name}Provider`

## State Classes

State classes are defined using freezed for immutability and pattern matching:

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(AuthFailure failure) = _Error;
}
```

## Consuming Providers

### In Widgets

Use `ConsumerWidget` or `ConsumerStatefulWidget` to access providers:

```dart
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    
    return userProfileAsync.when(
      data: (user) => ProfileContent(user: user),
      loading: () => const LoadingIndicator(),
      error: (error, stackTrace) => ErrorDisplay(error: error),
    );
  }
}
```

### In ViewModels

ViewModels can access other providers using `ref`:

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
    
    if (state is! AsyncError) {
      ref.read(authNotifierProvider.notifier).checkAuthState();
    }
  }
}
```

## Provider Lifecycle

### Auto-dispose

By default, providers created with `riverpod_annotation` are auto-disposed when no longer used:

```dart
@riverpod
Future<UserEntity> userDetails(UserDetailsRef ref, String userId) async {
  final repository = ref.watch(userRepositoryProvider);
  final result = await repository.getUserById(userId);
  
  return result.fold(
    (failure) => throw failure,
    (user) => user,
  );
}
```

### Keep Alive

To keep a provider alive even when not being listened to:

```dart
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  // Implementation...
}
```

## Provider Dependencies

Providers can depend on other providers:

```dart
@riverpod
class ThemeManager extends _$ThemeManager {
  @override
  Future<ThemeMode> build() async {
    final preferences = ref.watch(sharedPreferencesProvider);
    final themeString = preferences.getString('theme') ?? 'system';
    
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.setString('theme', mode.toString().split('.').last);
    ref.invalidateSelf();
  }
}
```

## Error Handling

Providers handle errors gracefully using AsyncValue:

```dart
@riverpod
Future<List<Post>> userPosts(UserPostsRef ref, String userId) async {
  try {
    final repository = ref.watch(postRepositoryProvider);
    final result = await repository.getPostsByUserId(userId);
    
    return result.fold(
      (failure) => throw failure,
      (posts) => posts,
    );
  } catch (e, stackTrace) {
    // Log the error
    ref.read(loggerProvider).error('Failed to fetch user posts', e, stackTrace);
    rethrow;
  }
}
```

## Testing Providers

### Unit Testing

```dart
void main() {
  group('AuthNotifier', () {
    late MockAuthRepository mockRepository;
    
    setUp(() {
      mockRepository = MockAuthRepository();
    });
    
    test('initial state is AuthState.initial', () {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      
      expect(
        container.read(authNotifierProvider),
        equals(const AuthState.initial()),
      );
    });
    
    test('login success updates state to authenticated', () async {
      // Arrange
      final tUser = UserEntity(id: '1', email: 'test@example.com');
      when(mockRepository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => right(tUser));
      
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      
      // Act
      await container.read(authNotifierProvider.notifier).login(
        'test@example.com',
        'password',
      );
      
      // Assert
      expect(
        container.read(authNotifierProvider),
        equals(AuthState.authenticated(tUser)),
      );
    });
  });
}
```

### Widget Testing

```dart
void main() {
  group('ProfileScreen', () {
    testWidgets('displays user profile when data is available', (tester) async {
      // Arrange
      final tUser = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileProvider.overrideWith((_) => AsyncData(tUser)),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );
      
      // Assert
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });
  });
}
```

## Best Practices

### 1. Use Code Generation

Use `riverpod_annotation` and code generation to reduce boilerplate:

```dart
// Install dependencies
// flutter pub add riverpod_annotation
// flutter pub add dev:riverpod_generator
// flutter pub add dev:build_runner

// Run code generation
// flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Organize Providers by Feature

Keep providers organized by feature and layer to maintain a clean codebase.

### 3. Use Immutable State

Use freezed for immutable state classes to prevent unintended state mutations.

### 4. Handle Loading and Error States

Always handle loading and error states in the UI:

```dart
ref.watch(userProfileProvider).when(
  data: (user) => ProfileContent(user: user),
  loading: () => const LoadingIndicator(),
  error: (error, stackTrace) => ErrorDisplay(error: error),
);
```

### 5. Keep Providers Focused

Each provider should have a single responsibility:

- Repository providers should only provide repositories
- Use case providers should only provide use cases
- ViewModel providers should only manage UI state

### 6. Use Provider Modifiers

Use provider modifiers to control provider behavior:

- `family`: For parameterized providers
- `autoDispose`: For providers that should be disposed when not in use
- `keepAlive`: For providers that should be kept alive

### 7. Use Ref.listen for Side Effects

Use `ref.listen` to perform side effects when a provider's state changes:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen<AuthState>(authNotifierProvider, (previous, current) {
    current.maybeWhen(
      authenticated: (_) => context.go('/home'),
      unauthenticated: () => context.go('/login'),
      error: (failure) => showErrorSnackBar(context, failure),
      orElse: () {},
    );
  });
  
  // Rest of the build method...
}
```

### 8. Avoid Provider Nesting

Avoid nesting providers to prevent performance issues and make testing easier.

### 9. Use Select for Granular Rebuilds

Use `select` to only rebuild when specific parts of a provider's state change:

```dart
final userName = ref.watch(userProfileProvider.select((user) => user.value?.name));
```

### 10. Document Providers

Document providers with clear comments explaining their purpose and usage.

## Conclusion

Riverpod provides a powerful and flexible state management solution for Flutter applications. By following the patterns and best practices outlined in this guide, you can create a maintainable, testable, and scalable codebase for your Flutter MVVM Base project.
