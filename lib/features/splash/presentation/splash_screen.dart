import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/auth/domain/auth_state.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/auth/providers/auth_notifier.dart';
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
