import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/user/domain/user_entity.dart';
import 'package:flutter_mvvm_base/features/user/presentation/provider/users_provider.dart';
import 'package:flutter_mvvm_base/features/user/presentation/state/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Screen that displays and allows editing of user profile information
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _dateFormat = DateFormat('MMM dd, yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    // Load user profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  /// Loads the user profile data from the repository
  Future<void> _loadUserProfile() async {
    final authState = ref.read(authProvider);
    final currentUser = authState.valueOrNull;

    if (currentUser != null) {
      await ref
          .read(usersProviderProvider.notifier)
          .loadUserProfile(currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(usersProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        elevation: 0,
      ),
      body: _buildBody(userState),
    );
  }

  /// Builds the body based on the current user state
  Widget _buildBody(UserState state) {
    if (state is Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is Error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUserProfile,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final user = (state as Success).user;
    return _buildUserProfileContent(user);
  }

  /// Builds the user profile content with all user data
  Widget _buildUserProfileContent(UserEntity user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar and basic info
          Center(
            child: Column(
              children: [
                _buildUserAvatar(user),
                const SizedBox(height: 16),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Role: ${user.role}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // User details
          _buildInfoSection('Account Information', [
            _buildInfoRow('User ID', user.id),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Role', user.role),
            _buildInfoRow('Language', user.language),
            _buildInfoRow(
              'Onboarding Completed',
              user.onboardingCompleted ? 'Yes' : 'No',
            ),
          ]),

          const SizedBox(height: 16),

          // Timestamps
          _buildInfoSection('Timestamps', [
            _buildInfoRow(
              'Created At',
              user.createdAt != null
                  ? _dateFormat.format(user.createdAt!)
                  : 'N/A',
            ),
            _buildInfoRow(
              'Updated At',
              user.updatedAt != null
                  ? _dateFormat.format(user.updatedAt!)
                  : 'N/A',
            ),
          ]),

          const SizedBox(height: 32),

          // Edit profile button
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showEditProfileDialog(user),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the user avatar with fallback to initials
  Widget _buildUserAvatar(UserEntity user) {
    return Hero(
      tag: 'user-avatar-${user.id}',
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Theme.of(context).primaryColor,
        backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
            ? NetworkImage(user.avatar!)
            : null,
        child: user.avatar == null || user.avatar!.isEmpty
            ? Text(
                user.email.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }

  /// Builds a section with a title and list of info rows
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  /// Builds a row with a label and value
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to edit the user profile
  void _showEditProfileDialog(UserEntity user) {
    final languageController = TextEditingController(text: user.language);
    final avatarController = TextEditingController(text: user.avatar ?? '');
    bool onboardingCompleted = user.onboardingCompleted;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: languageController,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  helperText: 'e.g., en, fr, es',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: avatarController,
                decoration: const InputDecoration(
                  labelText: 'Avatar URL',
                  helperText: 'URL to your profile image',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Onboarding Completed'),
                  const Spacer(),
                  Switch(
                    value: onboardingCompleted,
                    onChanged: (value) {
                      setState(() {
                        onboardingCompleted = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Create updated user entity
              final updatedUser = user.copyWith(
                language: languageController.text,
                avatar: avatarController.text.isEmpty
                    ? null
                    : avatarController.text,
                onboardingCompleted: onboardingCompleted,
              );

              // Update the user profile
              ref
                  .read(usersProviderProvider.notifier)
                  .loadUserProfile(updatedUser.id);

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
