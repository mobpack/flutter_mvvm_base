import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/widgets/logout_button.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/state/profile_state.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/viewmodels/profile_viewmodel.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/widgets/profile_avatar_widget.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/widgets/profile_info_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen that displays the user's profile information
class ProfileScreen extends ConsumerWidget {
  /// Creates a new [ProfileScreen]
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: _buildBody(context, state, ref),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state, WidgetRef ref) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.error}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Refresh the profile by rebuilding the viewmodel
                ref.invalidate(profileViewModelProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.user == null) {
      return const Center(
        child: Text('User not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ProfileAvatarWidget(
              avatarUrl: state.user!.avatar,
              userName: state.user!.name ?? state.user!.email,
            ),
          ),
          const SizedBox(height: 24),
          ProfileInfoSection(user: state.user!),
          const SizedBox(height: 24),
          // Language selector and other settings
          const Text(
            'Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(state.user!.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to language settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to change password
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {},
            trailing: const LogoutButton(
              icon: Icons.exit_to_app,
              text: 'Logout',
              style: ButtonStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
