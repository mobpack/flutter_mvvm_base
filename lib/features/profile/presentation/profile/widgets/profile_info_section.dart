import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';

/// Widget that displays user profile information in a structured format
class ProfileInfoSection extends StatelessWidget {
  /// The user entity containing profile data
  final UserEntity user;

  /// Creates a new [ProfileInfoSection]
  const ProfileInfoSection({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildInfoItem(context, 'Email', user.email),
        if (user.name != null) _buildInfoItem(context, 'Name', user.name!),
        _buildInfoItem(context, 'Role', user.role),
        _buildInfoItem(
          context, 
          'Onboarding Completed', 
          user.onboardingCompleted ? 'Yes' : 'No',
        ),
        _buildInfoItem(
          context, 
          'Email Confirmed', 
          user.emailConfirmed ? 'Yes' : 'No',
        ),
        if (user.createdAt != null)
          _buildInfoItem(
            context, 
            'Member Since', 
            _formatDate(user.createdAt!),
          ),
      ],
    );
  }

  /// Builds a single information item with label and value
  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Formats a DateTime into a readable date string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
