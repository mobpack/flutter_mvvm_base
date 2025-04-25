import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';

/// A reusable banner for displaying errors in the UI
class ErrorBanner extends StatelessWidget {
  final AppError error;
  final VoidCallback? onDismiss;
  
  const ErrorBanner({
    required this.error,
    this.onDismiss,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            _getIconForError(error),
            size: 24,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error.userMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close),
              color: Theme.of(context).colorScheme.onErrorContainer,
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
  
  /// Returns an appropriate icon based on the error type
  IconData _getIconForError(AppError error) {
    return switch(error) {
      NetworkError() => Icons.signal_wifi_off,
      AuthError() => Icons.lock_outline,
      ValidationError() => Icons.error_outline,
      ServerError() => Icons.cloud_off,
      UnexpectedError() => Icons.warning_amber,
    };
  }
}
