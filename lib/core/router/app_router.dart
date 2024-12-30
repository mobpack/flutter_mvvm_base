import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mvvm_base/ui/home/my_home_page.dart';
import 'package:flutter_mvvm_base/ui/settings/settings_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
