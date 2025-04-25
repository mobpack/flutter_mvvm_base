import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/navigation/routes/route_paths.dart';
import 'package:go_router/go_router.dart';

/// App shell that provides a common layout for all authenticated screens
/// including bottom navigation bar for main app sections
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    required this.child,
    super.key,
  });

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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Calculate the selected index based on the current route
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

  /// Handle navigation when a bottom navigation item is tapped
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
