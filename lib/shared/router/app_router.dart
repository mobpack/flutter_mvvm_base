import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/login/login_screen.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/register/register_screen.dart';
import 'package:flutter_mvvm_base/features/home/presentation/my_home_page.dart';
import 'package:flutter_mvvm_base/features/settings/presentation/settings_screen.dart';
import 'package:flutter_mvvm_base/features/splash/presentation/splash_screen.dart';
import 'package:flutter_mvvm_base/features/user/presentation/user_profile_screen.dart';
import 'package:flutter_mvvm_base/shared/router/providers.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/example_form_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
    initialLocation: '/',
    debugLogDiagnostics: true,
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final user = _ref.read(authStateProvider).maybeWhen(
          data: (u) => u,
          orElse: () => null,
        );
    final isAuth = user != null;

    final isSplash = state.matchedLocation == '/splash';
    final isLoggingIn = state.matchedLocation == '/login';
    final isRegistering = state.matchedLocation == '/register';

    if (isSplash) {
      return isAuth ? '/' : '/login';
    }

    if (!isAuth && !isLoggingIn && !isRegistering) {
      return '/login';
    }

    if (isAuth && (isLoggingIn || isRegistering)) {
      return '/';
    }

    return null;
  }

  List<RouteBase> get _routes => [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const MyHomePage(title: 'Home'),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/dynamic-form',
          name: 'dynamic-form',
          builder: (context, state) => const ExampleFormScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const UserProfileScreen(),
        ),
      ];
}
