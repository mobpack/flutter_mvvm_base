import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/core/theme/theme_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Change app theme'),
            trailing: Switch(
              value: themeManager.isDarkMode,
              onChanged: (_) => themeManager.toggleTheme(),
            ),
          ),
          // Add more settings here
        ],
      ),
    );
  }
}
