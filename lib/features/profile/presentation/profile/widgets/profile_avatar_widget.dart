import 'package:flutter/material.dart';

/// Widget that displays a user's avatar with fallback to initials
class ProfileAvatarWidget extends StatelessWidget {
  /// URL to the user's avatar image
  final String? avatarUrl;

  /// User's name or display text
  final String userName;

  /// Size of the avatar in pixels
  final double size;

  /// Creates a new [ProfileAvatarWidget]
  const ProfileAvatarWidget({
    required this.userName,
    super.key,
    this.avatarUrl,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (avatarUrl != null && avatarUrl!.isNotEmpty)
          CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(avatarUrl!),
          )
        else
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              _getInitials(userName),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: size / 3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Extracts initials from a name (e.g., "John Doe" -> "JD")
  String _getInitials(String name) {
    if (name.isEmpty) return '';

    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }
}
