import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/forgot_password/forgot_password_screen.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/login/login_screen.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/register/register_screen.dart';
import 'package:flutter_mvvm_base/features/home/presentation/my_home_page.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/screens/profile_screen.dart';
import 'package:flutter_mvvm_base/features/settings/presentation/settings_screen.dart';
import 'package:flutter_mvvm_base/features/splash/presentation/splash_screen.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/auth_state.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:flutter_mvvm_base/shared/router/route_paths.dart';
import 'package:flutter_mvvm_base/shared/widgets/app_shell.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/example_form_screen.dart';
import 'package:flutter_mvvm_base/shared/widgets/error_screen.dart';
import 'package:flutter_mvvm_base/shared/widgets/not_found_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Router notifier that handles redirects based on authentication state
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  
  RouterNotifier(this._ref) {
    _ref.listen(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }
  
  /// Redirect logic based on authentication state
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
  
  /// Define all routes in the application
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
        // Example of nested routes with parameters
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

/// Placeholder for the NestedFeatureScreen
class NestedFeatureScreen extends StatelessWidget {
  const NestedFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nested Feature')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nested Feature Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('${RoutePaths.nestedFeatureDetail}/123'),
              child: const Text('Go to Detail'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the NestedFeatureDetailScreen
class NestedFeatureDetailScreen extends StatelessWidget {
  final String id;
  
  const NestedFeatureDetailScreen({
    required this.id, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Text('Detail Screen for ID: $id'),
      ),
    );
  }
}
