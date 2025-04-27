# Navigation Guide with GoRouter

## Overview

This guide explains the navigation and routing system implemented in the Flutter MVVM Base project using [GoRouter](https://pub.dev/packages/go_router). GoRouter provides a declarative, URL-based routing approach that integrates well with the MVVM architecture and supports deep linking, nested navigation, and route guards.

## Why GoRouter?

GoRouter was chosen as the navigation solution for several key reasons:

1. **Declarative API**: Provides a clean, declarative way to define routes
2. **Deep Linking Support**: Handles deep links and web URLs seamlessly
3. **Nested Navigation**: Supports nested navigation with tabs and navigation stacks
4. **Type Safety**: Offers type-safe route parameters and arguments
5. **Integration with Riverpod**: Works well with Riverpod for dependency injection and state management
6. **Redirection**: Supports route guards and redirects based on application state
7. **URL Path Parameters**: Handles path parameters and query parameters

## Router Configuration

The router is configured using Riverpod to integrate with the application's state management system:

```dart
@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Main redirection logic based on auth state
      final isLoggedIn = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      
      final isGoingToLogin = state.location == '/login';
      final isGoingToRegister = state.location == '/register';
      final isGoingToAuth = isGoingToLogin || isGoingToRegister;
      
      // If not logged in and not going to auth pages, redirect to login
      if (!isLoggedIn && !isGoingToAuth) {
        return '/login';
      }
      
      // If logged in and going to auth pages, redirect to home
      if (isLoggedIn && isGoingToAuth) {
        return '/home';
      }
      
      // No redirection needed
      return null;
    },
    routes: [
      // Define application routes here
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Additional routes...
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}
```

## Route Structure

Routes are organized in a hierarchical structure that reflects the application's navigation flow:

```
/                   # Splash screen (entry point)
/login              # Login screen
/register           # Registration screen
/forgot-password    # Password recovery screen
/home               # Home screen (authenticated)
/profile            # User profile screen
/profile/edit       # Edit profile screen
/settings           # Settings screen
/settings/:section  # Specific settings section
```

## Nested Navigation

GoRouter supports nested navigation for more complex UI structures like bottom navigation bars or tabs:

```dart
GoRoute(
  path: '/home',
  builder: (context, state) => const HomeScreen(),
  routes: [
    // Nested routes under /home
    GoRoute(
      path: 'feed',
      builder: (context, state) => const FeedScreen(),
    ),
    GoRoute(
      path: 'explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
),
```

## Route Parameters

Routes can include parameters to pass data between screens:

```dart
GoRoute(
  path: '/user/:userId',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserDetailScreen(userId: userId);
  },
),
```

## Query Parameters

Query parameters can be used for optional parameters:

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.queryParameters['q'] ?? '';
    final filter = state.queryParameters['filter'] ?? 'all';
    return SearchScreen(query: query, filter: filter);
  },
),
```

## Extra Parameters

For complex objects that can't be serialized to strings, use extra parameters:

```dart
// Navigate with extra data
context.go('/product-details', extra: product);

// In the route definition
GoRoute(
  path: '/product-details',
  builder: (context, state) {
    final product = state.extra as Product;
    return ProductDetailScreen(product: product);
  },
),
```

## Navigation Service

The application uses a navigation service to abstract the navigation logic and make it testable:

```dart
@riverpod
class NavigationService extends _$NavigationService {
  @override
  void build() {}
  
  void navigateTo(String path, {Map<String, String>? queryParams, Object? extra}) {
    final context = _getContext();
    if (context != null) {
      final uri = Uri(path: path, queryParameters: queryParams);
      context.go(uri.toString(), extra: extra);
    }
  }
  
  void pushTo(String path, {Map<String, String>? queryParams, Object? extra}) {
    final context = _getContext();
    if (context != null) {
      final uri = Uri(path: path, queryParameters: queryParams);
      context.push(uri.toString(), extra: extra);
    }
  }
  
  void pop<T>([T? result]) {
    final context = _getContext();
    if (context != null && context.canPop()) {
      context.pop(result);
    }
  }
  
  void replace(String path, {Map<String, String>? queryParams, Object? extra}) {
    final context = _getContext();
    if (context != null) {
      final uri = Uri(path: path, queryParameters: queryParams);
      context.replace(uri.toString(), extra: extra);
    }
  }
  
  BuildContext? _getContext() {
    // Implementation to get the current BuildContext
    // This could use a GlobalKey or other mechanism
  }
}
```

## Route Guards

Route guards are implemented using the `redirect` callback to protect routes based on authentication state or other conditions:

```dart
redirect: (context, state) {
  // Check if the user is authenticated
  final isAuthenticated = ref.read(authNotifierProvider).maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
  
  // Check if the user has completed onboarding
  final hasCompletedOnboarding = ref.read(onboardingCompletedProvider);
  
  // If not authenticated, redirect to login
  if (!isAuthenticated && !state.location.startsWith('/auth')) {
    return '/auth/login';
  }
  
  // If authenticated but hasn't completed onboarding, redirect to onboarding
  if (isAuthenticated && !hasCompletedOnboarding && 
      !state.location.startsWith('/onboarding')) {
    return '/onboarding';
  }
  
  // No redirection needed
  return null;
},
```

## Deep Linking

GoRouter supports deep linking for both web and mobile platforms:

### Android Configuration

In `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
  <application ...>
    <activity ...>
      <!-- Deep linking -->
      <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Accepts URIs that begin with "https://yourdomain.com" -->
        <data android:scheme="https" android:host="yourdomain.com" />
      </intent-filter>
      <!-- App Links -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Accepts URIs that begin with "app://yourdomain.com" -->
        <data android:scheme="app" android:host="yourdomain.com" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

### iOS Configuration

In `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>yourdomain.com</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>app</string>
    </array>
  </dict>
</array>
```

## Navigation Patterns

### Push Navigation

Use `push` to navigate to a new screen while keeping the current screen in the navigation stack:

```dart
// Using GoRouter directly
context.push('/profile');

// Using NavigationService
ref.read(navigationServiceProvider.notifier).pushTo('/profile');
```

### Replace Navigation

Use `replace` to replace the current screen with a new one:

```dart
// Using GoRouter directly
context.replace('/home');

// Using NavigationService
ref.read(navigationServiceProvider.notifier).replace('/home');
```

### Pop Navigation

Use `pop` to navigate back to the previous screen:

```dart
// Using GoRouter directly
context.pop();

// Using NavigationService
ref.read(navigationServiceProvider.notifier).pop();
```

### Pop with Result

Use `pop` with a result to pass data back to the previous screen:

```dart
// Return a result when popping
context.pop(selectedItem);

// In the previous screen, use pushTo and await the result
final result = await ref.read(navigationServiceProvider.notifier).pushTo('/select-item');
if (result != null) {
  // Handle the result
}
```

## Error Handling

GoRouter provides an `errorBuilder` to handle navigation errors:

```dart
errorBuilder: (context, state) {
  return ErrorScreen(
    error: state.error,
    onRetry: () => context.go('/home'),
  );
},
```

## Testing Navigation

### Unit Testing

```dart
void main() {
  group('NavigationService', () {
    late MockBuildContext mockContext;
    late ProviderContainer container;
    
    setUp(() {
      mockContext = MockBuildContext();
      container = ProviderContainer(
        overrides: [
          // Override dependencies
        ],
      );
    });
    
    test('navigateTo calls context.go with correct path', () {
      // Arrange
      final service = container.read(navigationServiceProvider.notifier);
      
      // Mock the _getContext method to return mockContext
      // This requires some setup with your testing framework
      
      // Act
      service.navigateTo('/profile');
      
      // Assert
      verify(mockContext.go('/profile')).called(1);
    });
  });
}
```

### Widget Testing

```dart
void main() {
  group('Navigation Flow', () {
    testWidgets('tapping login button navigates to home on success',
        (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override providers for testing
          ],
          child: const MyApp(),
        ),
      );
      
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
      await tester.tap(find.byType(SubmitButton));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
```

## Best Practices

### 1. Centralize Route Definitions

Keep all route definitions in a single place for better maintainability:

```dart
// lib/shared/infrastructure/navigation/routes/app_routes.dart
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
  
  // Nested routes
  static String settingsSection(String section) => '/settings/$section';
  static String userProfile(String userId) => '/user/$userId';
}
```

### 2. Use a Navigation Service

Abstract navigation logic in a service for better testability and reusability.

### 3. Type-Safe Route Parameters

Use helper methods to create type-safe route parameters:

```dart
// Navigate with type-safe parameters
context.go(AppRoutes.userProfile('123'));

// Define routes with type-safe parameters
GoRoute(
  path: '/user/:userId',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserDetailScreen(userId: userId);
  },
),
```

### 4. Handle Loading States

Show loading indicators during navigation when needed:

```dart
FutureBuilder<void>(
  future: _navigateAndLoadData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingIndicator();
    }
    return const ScreenContent();
  },
);
```

### 5. Use Named Routes

Use named constants for routes to avoid string literals throughout the codebase.

### 6. Handle Deep Links

Configure deep links properly and test them on both Android and iOS.

### 7. Implement Error Handling

Always provide an error handler for navigation errors.

### 8. Use Redirects Sparingly

Use redirects only when necessary, as they can make the navigation flow harder to understand.

### 9. Test Navigation Flows

Write tests for navigation flows to ensure they work as expected.

### 10. Document Navigation Logic

Document complex navigation logic, especially redirects and guards.

## Conclusion

GoRouter provides a powerful and flexible navigation solution for Flutter applications. By following the patterns and best practices outlined in this guide, you can create a maintainable, testable, and user-friendly navigation system for your Flutter MVVM Base project.
