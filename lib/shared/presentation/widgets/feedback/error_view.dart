import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';

/// A full-screen error view with optional retry functionality
class ErrorView extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;

  const ErrorView({
    required this.error,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForError(error),
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              error.userMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (error.isRecoverable && onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns an appropriate icon based on the error type
  IconData _getIconForError(AppError error) {
    return switch (error) {
      NetworkError() => Icons.signal_wifi_off,
      AuthError() => Icons.lock_outline,
      ValidationError() => Icons.error_outline,
      ServerError() => Icons.cloud_off,
      UnexpectedError() => Icons.warning_amber,
    };
  }
}
