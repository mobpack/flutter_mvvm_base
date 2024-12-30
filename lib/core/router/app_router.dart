import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/ui/auth/login_screen.dart';
import 'package:flutter_mvvm_base/ui/home/my_home_page.dart';
import 'package:flutter_mvvm_base/ui/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
