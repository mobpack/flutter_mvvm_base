import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/widgets/logout_button.dart';
import 'package:flutter_mvvm_base/features/settings/presentation/view_model/settings_viewmodel.dart';
import 'package:flutter_mvvm_base/shared/presentation/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: Text(
              themeMode.when(
                data: (mode) => mode == ThemeMode.system
                    ? 'System'
                    : mode == ThemeMode.dark
                        ? 'On'
                        : 'Off',
                loading: () => 'Loading...',
                error: (error, stackTrace) => 'Error: $error',
              ),
            ),
            onTap: () => _showThemePicker(context, ref),
          ),
          const Divider(),
          const _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: packageInfo.when(
              data: (info) => Text('${info.version} (${info.buildNumber})'),
              loading: () => const Text('Loading...'),
              error: (_, __) => const Text('Error loading version'),
            ),
          ),
          const Divider(),
          const _SectionHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Sign out of your account'),
            trailing: const LogoutButton(
              text: 'Logout',
              style: ButtonStyle(),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(themeModeProvider.notifier);

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('System'),
                leading: const Icon(Icons.brightness_auto),
                onTap: () {
                  notifier.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light'),
                leading: const Icon(Icons.light_mode),
                onTap: () {
                  notifier.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                leading: const Icon(Icons.dark_mode),
                onTap: () {
                  notifier.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
