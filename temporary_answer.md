# Fixing Splash Screen Navigation with Authentication Handling

## Issue Analysis

The app is getting stuck at the splash screen because:

1. The splash screen is currently a static widget with no navigation logic
2. The router's redirect logic should handle navigation based on auth state, but there might be timing issues
3. The authentication state might not be properly checked or updated when the app starts
4. There's a disconnect between the splash screen, router, and authentication state

## Solution

I've implemented a solution that properly handles navigation from the splash screen to either the login screen (if unauthenticated) or the home screen (if authenticated). The key changes are:

1. Convert the splash screen from a StatelessWidget to a ConsumerStatefulWidget to manage state
2. Add explicit authentication check and navigation logic in the splash screen
3. Ensure the auth state is properly checked and updated when the app starts

## Implementation

### 1. Updated Splash Screen

The splash screen now actively checks authentication status and navigates accordingly:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/auth_state.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash screen that displays while checking authentication status
/// and automatically navigates to the appropriate screen
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check authentication state after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  /// Checks authentication state and navigates to the appropriate screen
  Future<void> _checkAuthAndNavigate() async {
    // Explicitly check auth state to ensure it's up to date
    await ref.read(authNotifierProvider.notifier).checkAuthState();
    
    // Get the current auth state
    final authState = ref.read(authNotifierProvider);
    
    // Navigate based on auth state
    if (mounted) {
      if (authState is AuthStateAuthenticated) {
        context.go('/');
      } else if (authState is AuthStateUnauthenticated) {
        context.go('/login');
      }
      // If still in initial or authenticating state, stay on splash screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flutter_dash,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Flutter MVVM Base',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

### 2. How It Works

1. When the app starts, the splash screen is displayed
2. In the `initState` method, we schedule a check of the authentication state after the widget is built
3. The `_checkAuthAndNavigate` method explicitly checks the auth state and navigates to the appropriate screen:
   - If authenticated, navigate to the home screen ('/')
   - If unauthenticated, navigate to the login screen ('/login')
   - If still in initial or authenticating state, stay on the splash screen

### 3. Benefits of This Approach

1. **Explicit Navigation**: The splash screen now actively checks auth state and navigates, rather than relying solely on the router's redirect logic
2. **Proper Timing**: By using `addPostFrameCallback`, we ensure the navigation happens after the widget is built
3. **State Management**: By converting to a StatefulWidget, we can properly manage the state and navigation
4. **Graceful Handling**: We check if the widget is still mounted before navigating to avoid potential issues

## Additional Considerations

1. The app's router is still configured to handle redirects based on authentication state, providing a fallback mechanism
2. The auth notifier is initialized in the App class, ensuring authentication state is checked when the app starts
3. The solution follows the MVVM architecture pattern and uses Riverpod for state management as required

This implementation ensures that users are properly redirected to either the login screen or home screen based on their authentication status, fixing the issue where the app was stuck at the splash screen.

### Step 1: Create Auth State Classes

Create a sealed class hierarchy for authentication states:

```dart
// lib/shared/auth/domain/auth_state.dart
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.authenticating() = AuthStateAuthenticating;
  const factory AuthState.authenticated(UserEntity user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
}
```

### Step 2: Create Auth Notifier

Create an auth notifier that implements `Listenable` to notify go_router of auth state changes:

```dart
// lib/shared/auth/domain/notifiers/auth_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> implements Listenable {
  VoidCallback? _routerListener;

  @override
  AuthState build() {
    ref.listen(authStateProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            state = AuthState.authenticated(UserEntity.fromSupabaseUser(user));
          } else {
            state = const AuthState.unauthenticated();
          }
          _routerListener?.call();
        },
        error: (_, __) {
          state = const AuthState.unauthenticated();
          _routerListener?.call();
        },
      );
    });

    return const AuthState.initial();
  }

  Future<void> checkAuthState() async {
    state = const AuthState.authenticating();
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.getCurrentUser().run();

    result.fold(
      (error) {
        state = const AuthState.unauthenticated();
        _routerListener?.call();
      },
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
        _routerListener?.call();
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthState.authenticating();
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signOut().run();

    result.fold(
      (error) {
        // Even if there's an error, we should consider the user logged out
        state = const AuthState.unauthenticated();
        _routerListener?.call();
      },
      (_) {
        state = const AuthState.unauthenticated();
        _routerListener?.call();
      },
    );
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}
```

### Step 3: Create Route Configuration

Define route paths and configurations:

```dart
// lib/shared/router/route_paths.dart
class RoutePaths {
  // Auth routes
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Main app routes
  static const home = '/';
  static const profile = '/profile';
  static const settings = '/settings';
  static const dynamicForm = '/dynamic-form';

  // Nested routes example
  static const nestedFeature = '/nested-feature';
  static const nestedFeatureDetail = '/nested-feature/detail';

  // Error routes
  static const notFound = '/404';
  static const error = '/error';

  // Public routes that don't require authentication
  static const List<String> publicRoutes = [
    splash,
    login,
    register,
    forgotPassword,
    notFound,
    error,
  ];

  // Check if a route is public
  static bool isPublicRoute(String route) {
    return publicRoutes.any((path) => route.startsWith(path));
  }
}
```

### Step 4: Create Router Notifier

Create a router notifier that handles redirects based on authentication state:

```dart
// lib/shared/router/router_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/auth_state.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:flutter_mvvm_base/shared/router/route_paths.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authNotifierProvider);

    // Handle initial or authenticating states
    if (authState is AuthStateInitial || authState is AuthStateAuthenticating) {
      // During initial load or authentication, show splash screen
      return RoutePaths.splash;
    }

    final isLoggedIn = authState is AuthStateAuthenticated;
    final isGoingToPublicRoute = RoutePaths.isPublicRoute(state.matchedLocation);

    // If user is not logged in and trying to access a protected route
    if (!isLoggedIn && !isGoingToPublicRoute) {
      return RoutePaths.login;
    }

    // If user is logged in and trying to access an auth route
    if (isLoggedIn && isGoingToPublicRoute) {
      // Special case for splash screen
      if (state.matchedLocation == RoutePaths.splash) {
        return RoutePaths.home;
      }

      // Don't redirect for error routes even when logged in
      if (state.matchedLocation == RoutePaths.notFound ||
          state.matchedLocation == RoutePaths.error) {
        return null;
      }

      // Redirect to home for other auth routes
      return RoutePaths.home;
    }

    // No redirection needed
    return null;
  }

  List<RouteBase> get routes => [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RoutePaths.notFound,
      builder: (context, state) => const NotFoundScreen(),
    ),
    GoRoute(
      path: RoutePaths.error,
      builder: (context, state) => ErrorScreen(
        error: state.extra as Exception?,
      ),
    ),
    // Main app shell with nested navigation
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const MyHomePage(title: 'Home'),
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: RoutePaths.dynamicForm,
          builder: (context, state) => const ExampleFormScreen(),
        ),
        // Example of nested routes
        GoRoute(
          path: RoutePaths.nestedFeature,
          builder: (context, state) => const NestedFeatureScreen(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) => NestedFeatureDetailScreen(
                id: state.pathParameters['id'] ?? '',
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}
```

### Step 5: Create Router Provider

Create a go_router provider that uses the router notifier:

```dart
// lib/shared/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:flutter_mvvm_base/shared/router/router_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  final router = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: authNotifier,
    redirect: router.redirect,
    routes: router.routes,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => NotFoundScreen(),
  );
});
```

### Step 6: Create App Shell for Nested Navigation

Create an app shell widget for nested navigation:

```dart
// lib/shared/widgets/app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/router/route_paths.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RoutePaths.home)) {
      return 0;
    } else if (location.startsWith(RoutePaths.profile)) {
      return 1;
    } else if (location.startsWith(RoutePaths.settings)) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RoutePaths.home);
        break;
      case 1:
        context.go(RoutePaths.profile);
        break;
      case 2:
        context.go(RoutePaths.settings);
        break;
    }
  }
}
```

### Step 7: Update Logout Use Case

Update the logout use case to properly handle navigation after logout:

```dart
// lib/features/auth/presentation/viewmodels/logout_viewmodel.dart
import 'package:flutter_mvvm_base/features/auth/usecases/logout_usecase.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_viewmodel.g.dart';

@riverpod
class LogoutViewModel extends _$LogoutViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      // Execute the logout use case
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      final result = await logoutUseCase.execute().run();

      result.fold(
        (error) {
          state = AsyncValue.error(error, StackTrace.current);
        },
        (_) {
          // Explicitly notify the auth notifier about the logout
          final authNotifier = ref.read(authNotifierProvider.notifier);
          authNotifier.signOut();

          state = const AsyncValue.data(null);
        },
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

### Step 8: Update Main.dart

Update the main.dart file to initialize the auth notifier:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mvvm_base/app.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart' as auth_providers;
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:flutter_mvvm_base/shared/logging/log_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  logger.init();
  logger.info('Starting app...');

  // Load environment variables
  await dotenv.load();
  logger.debug('Environment variables loaded');

  // Configure URL strategy for web
  usePathUrlStrategy();

  runApp(
    ProviderScope(
      overrides: [
        // Override the generated authRepository provider with the actual implementation
        authRepositoryProvider.overrideWith(
          (ref) => ref.read(auth_providers.authRepositoryProvider),
        ),
      ],
      child: const App(),
    ),
  );
}
```

### Step 9: Update App.dart

Update the App widget to initialize the auth state:

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:flutter_mvvm_base/shared/router/app_router.dart';
import 'package:flutter_mvvm_base/shared/theme/app_theme.dart';
import 'package:flutter_mvvm_base/shared/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Check authentication state when app starts
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return themeModeAsync.when(
      data: (themeMode) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Flutter MVVM Base',
            builder: (context, child) {
              // First wrap with ResponsiveBreakpoints
              final Widget responsiveChild = ResponsiveBreakpoints.builder(
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  const Breakpoint(
                    start: 1921,
                    end: double.infinity,
                    name: '4K',
                  ),
                ],
                child: Builder(
                  builder: (context) {
                    // Apply theme after ResponsiveBreakpoints is available
                    if (child != null) {
                      return Theme(
                        data: themeMode == ThemeMode.dark
                            ? AppTheme.getDarkTheme(context)
                            : AppTheme.getLightTheme(context),
                        child: child,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              );

              // Apply MediaQuery to ensure proper scaling
              final mediaQuery = MediaQuery.of(context);
              final scale = mediaQuery.textScaler;

              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaler: scale.clamp(
                    minScaleFactor: 0.8,
                    maxScaleFactor: 1.0,
                  ),
                ),
                child: responsiveChild,
              );
            },
            themeMode: themeMode,
            routerConfig: router,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Theme error: $e')),
        ),
      ),
    );
  }
}
```

### Step 10: Create Error and Not Found Screens

Create screens for error handling:

```dart
// lib/shared/widgets/error_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({
    Key? key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'An error occurred',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/shared/widgets/not_found_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              color: Colors.grey,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

This implementation provides a robust routing solution with proper authentication handling, nested navigation, deep linking support, and error handling. The key improvement is the creation of a dedicated `AuthNotifier` that implements `Listenable` to properly notify go_router of authentication state changes, ensuring users are redirected to the login screen immediately after logout.
