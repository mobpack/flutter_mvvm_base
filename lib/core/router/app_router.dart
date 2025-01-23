import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/providers/auth_provider.dart';
import 'package:flutter_mvvm_base/ui/auth/login/login_screen.dart';
import 'package:flutter_mvvm_base/ui/auth/register/register_screen.dart';
import 'package:flutter_mvvm_base/ui/home/my_home_page.dart';
import 'package:flutter_mvvm_base/ui/settings/settings_screen.dart';
import 'package:flutter_mvvm_base/ui/splash/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authProvider);
    final user = authState.valueOrNull;
    final isAuth = user != null;
    final isLoading = authState.isLoading;

    final isSplash = state.matchedLocation == '/splash';
    final isLoggingIn = state.matchedLocation == '/login';
    final isRegistering = state.matchedLocation == '/register';

    if (isLoading) {
      return '/splash';
    }

    if (isSplash && !isLoading) {
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
          builder: (context, state) =>
              const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ];
}
