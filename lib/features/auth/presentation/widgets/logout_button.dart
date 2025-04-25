import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/viewmodels/logout_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A reusable logout button widget that handles the logout process
class LogoutButton extends ConsumerWidget {
  final String? text;
  final IconData? icon;
  final ButtonStyle? style;
  
  const LogoutButton({
    super.key,
    this.text,
    this.icon,
    this.style,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(logoutViewModelProvider);
    
    return logoutState.when(
      data: (_) => _buildButton(context, ref),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorButton(context, error, ref),
    );
  }
  
  Widget _buildButton(BuildContext context, WidgetRef ref) {
    if (text != null && icon != null) {
      return ElevatedButton.icon(
        onPressed: () => _handleLogout(ref),
        icon: Icon(icon),
        label: Text(text!),
        style: style,
      );
    } else if (icon != null) {
      return IconButton(
        onPressed: () => _handleLogout(ref),
        icon: Icon(icon!),
        tooltip: 'Logout',
      );
    } else {
      return ElevatedButton(
        onPressed: () => _handleLogout(ref),
        style: style,
        child: Text(text ?? 'Logout'),
      );
    }
  }
  
  Widget _buildErrorButton(BuildContext context, Object error, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _handleLogout(ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Text('Retry Logout'),
    );
  }
  
  void _handleLogout(WidgetRef ref) {
    ref.read(logoutViewModelProvider.notifier).logout();
  }
}
