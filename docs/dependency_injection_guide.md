# Dependency Injection Guide with Riverpod

## Overview

This guide explains the dependency injection (DI) approach used in the Flutter MVVM Base project using Riverpod. Dependency injection is a key architectural pattern that promotes testability, maintainability, and separation of concerns by providing dependencies to classes rather than having them create their own dependencies.

## Why Riverpod for Dependency Injection?

Riverpod serves as both a state management solution and a dependency injection framework, offering several advantages:

1. **Type Safety**: Provides compile-time safety with strong typing
2. **Testability**: Makes testing straightforward with easy dependency overrides
3. **Lazy Initialization**: Dependencies are created only when needed
4. **Scoped Dependencies**: Provides fine-grained control over dependency lifetimes
5. **Hierarchical DI**: Supports hierarchical dependency injection
6. **Code Generation**: Reduces boilerplate with `riverpod_annotation`
7. **Automatic Disposal**: Handles resource cleanup automatically

## Dependency Injection Structure

The project follows a layered approach to dependency injection, mirroring the clean architecture layers:

### 1. Data Layer Dependencies

- **Data Sources**: Remote and local data sources
- **Repositories**: Repository implementations
- **API Clients**: HTTP clients and API services

### 2. Domain Layer Dependencies

- **Use Cases**: Business logic interactors
- **Domain Services**: Domain-specific services

### 3. Infrastructure Layer Dependencies

- **Services**: Technical services (logging, analytics, etc.)
- **Utilities**: Helper classes and utilities

### 4. Presentation Layer Dependencies

- **ViewModels**: UI state management
- **Navigation**: Navigation services

## Provider Organization

Providers are organized by feature and layer to maintain a clean separation of concerns:

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── providers.dart        # Data layer providers
│   │   ├── domain/
│   │   │   └── providers.dart        # Domain layer providers
│   │   └── presentation/
│   │       └── providers/            # Presentation layer providers
│   │           └── auth_provider.dart
│   └── ...
└── shared/
    ├── infrastructure/
    │   └── providers/
    │       └── shared_providers.dart # Shared infrastructure providers
    └── ...
```

## Provider Implementation

### Data Layer Providers

```dart
// Remote data source provider
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(supabase);
}

// Local data source provider
@riverpod
AuthLocalDataSource authLocalDataSource(AuthLocalDataSourceRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDataSourceImpl(secureStorage);
}

// Repository provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource, localDataSource);
}
```

### Domain Layer Providers

```dart
// Use case provider
@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

// Domain service provider
@riverpod
UserService userService(UserServiceRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final preferencesRepository = ref.watch(preferencesRepositoryProvider);
  return UserServiceImpl(userRepository, preferencesRepository);
}
```

### Infrastructure Layer Providers

```dart
// Logger provider
@Riverpod(keepAlive: true)
Logger logger(LoggerRef ref) {
  return Logger();
}

// Secure storage provider
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

// Supabase client provider
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}
```

### Presentation Layer Providers

```dart
// ViewModel provider
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

## Provider Modifiers

### Keep Alive

Use `keepAlive: true` for providers that should persist throughout the application lifecycle:

```dart
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  // This will be initialized once and kept alive
  throw UnimplementedError('Initialize in the main() function');
}
```

### Auto-Dispose

By default, providers created with `riverpod_annotation` are auto-disposed when no longer used:

```dart
@riverpod
Future<UserProfile> userProfile(UserProfileRef ref, String userId) async {
  // This will be disposed when no longer listened to
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserProfile(userId);
}
```

### Family Providers

Use family providers for parameterized dependencies:

```dart
@riverpod
Future<ProductDetails> productDetails(
  ProductDetailsRef ref,
  String productId,
) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductDetails(productId);
}
```

## Provider Overrides

### Overriding for Testing

```dart
void main() {
  group('LoginViewModel', () {
    late MockLoginUseCase mockLoginUseCase;
    
    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
    });
    
    test('login success updates state to AsyncData', () async {
      // Arrange
      when(mockLoginUseCase.call(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => right(null));
      
      final container = ProviderContainer(
        overrides: [
          loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
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
        isA<AsyncData<void>>(),
      );
    });
  });
}
```

### Overriding for Feature Flags

```dart
ProviderScope(
  overrides: [
    // Override for feature flags
    featureFlagsProvider.overrideWith((ref) => FeatureFlags(
      enableNewUI: true,
      enableAnalytics: false,
    )),
  ],
  child: const MyApp(),
)
```

### Overriding for Environment Configuration

```dart
ProviderScope(
  overrides: [
    // Override for different environments
    environmentConfigProvider.overrideWith((ref) => EnvironmentConfig(
      apiUrl: 'https://api.dev.example.com',
      enableLogging: true,
    )),
  ],
  child: const MyApp(),
)
```

## Initialization

Some providers require initialization before they can be used. This is typically done in the `main()` function:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  runApp(
    ProviderScope(
      overrides: [
        // Override providers with initialized instances
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}
```

## Dependency Injection in Widgets

### Using ConsumerWidget

```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access dependencies
    final loginViewModel = ref.watch(loginViewModelProvider);
    
    return Scaffold(
      // UI implementation
      
      // Use dependencies
      onPressed: () {
        ref.read(loginViewModelProvider.notifier).login(email, password);
      },
    );
  }
}
```

### Using ConsumerStatefulWidget

```dart
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Access dependencies in initState
    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).loadData();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Access dependencies in build
    final homeState = ref.watch(homeViewModelProvider);
    
    return Scaffold(
      // UI implementation using homeState
    );
  }
}
```

## Dependency Injection in Use Cases

```dart
class GetUserProfileUseCase {
  final UserRepository _userRepository;
  final AnalyticsService _analyticsService;
  
  // Dependencies are injected through the constructor
  GetUserProfileUseCase(this._userRepository, this._analyticsService);
  
  Future<Either<Failure, UserProfile>> call(String userId) async {
    // Track analytics event
    _analyticsService.trackEvent('get_user_profile', {'user_id': userId});
    
    // Use repository
    return _userRepository.getUserProfile(userId);
  }
}

// Provider for the use case
@riverpod
GetUserProfileUseCase getUserProfileUseCase(GetUserProfileUseCaseRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final analyticsService = ref.watch(analyticsServiceProvider);
  
  return GetUserProfileUseCase(userRepository, analyticsService);
}
```

## Dependency Injection in Repositories

```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  // Dependencies are injected through the constructor
  UserRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );
  
  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteProfile = await _remoteDataSource.getUserProfile(userId);
        await _localDataSource.cacheUserProfile(remoteProfile);
        return right(remoteProfile.toDomain());
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    } else {
      try {
        final localProfile = await _localDataSource.getUserProfile(userId);
        return right(localProfile.toDomain());
      } on CacheException {
        return left(const CacheFailure('No cached data available'));
      }
    }
  }
}

// Provider for the repository
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  final localDataSource = ref.watch(userLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  
  return UserRepositoryImpl(
    remoteDataSource,
    localDataSource,
    networkInfo,
  );
}
```

## Best Practices

### 1. Single Responsibility

Each provider should have a single responsibility and provide a single dependency.

### 2. Dependency Direction

Dependencies should flow from the outer layers to the inner layers:
- Presentation depends on Domain
- Domain does not depend on Presentation or Data
- Data depends on Domain (for interfaces)

### 3. Interface Segregation

Create focused interfaces for dependencies to make them easier to mock and test.

### 4. Provider Organization

Organize providers by feature and layer to maintain a clean separation of concerns.

### 5. Testability

Design dependencies with testability in mind, making them easy to mock and override.

### 6. Documentation

Document complex dependencies and their relationships to make the codebase more maintainable.

### 7. Lazy Initialization

Take advantage of Riverpod's lazy initialization to improve performance.

### 8. Proper Scoping

Use the appropriate scope for each dependency:
- `keepAlive: true` for application-wide singletons
- Auto-dispose for feature-specific dependencies

### 9. Error Handling

Handle initialization errors gracefully:

```dart
@riverpod
Future<Database> database(DatabaseRef ref) async {
  try {
    return await openDatabase('app_database.db');
  } catch (e, stackTrace) {
    ref.read(loggerProvider).error(
      'Failed to open database',
      e,
      stackTrace,
    );
    rethrow;
  }
}
```

### 10. Avoid Circular Dependencies

Avoid circular dependencies between providers, as they can lead to initialization issues.

## Conclusion

Riverpod provides a powerful and flexible dependency injection solution for Flutter applications. By following the patterns and best practices outlined in this guide, you can create a maintainable, testable, and scalable codebase for your Flutter MVVM Base project.
