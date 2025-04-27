import 'package:flutter_mvvm_base/shared/infrastructure/auth/providers/auth_notifier.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/navigation/services/router_notifier.dart';
import 'package:flutter_mvvm_base/shared/presentation/widgets/screens/not_found_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Provider that creates and configures the GoRouter instance for the app
final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  final router = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: authNotifier,
    redirect: router.redirect,
    routes: router.routes,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

// The RouterNotifier class has been moved to router_notifier.dart
