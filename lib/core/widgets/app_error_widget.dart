import 'package:flutter/material.dart';

/// A widget to display error states with retry functionality.
class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Factory constructor for network errors.
  factory AppErrorWidget.network({VoidCallback? onRetry}) {
    return AppErrorWidget(
      message: 'No internet connection',
      details: 'Please check your network and try again.',
      onRetry: onRetry,
      icon: Icons.wifi_off,
    );
  }

  /// Factory constructor for server errors.
  factory AppErrorWidget.server({VoidCallback? onRetry}) {
    return AppErrorWidget(
      message: 'Something went wrong',
      details: 'We\'re having trouble connecting to our servers.',
      onRetry: onRetry,
      icon: Icons.cloud_off,
    );
  }

  /// Factory constructor for empty states.
  factory AppErrorWidget.empty({
    String message = 'Nothing here yet',
    String? details,
    IconData icon = Icons.inbox_outlined,
  }) {
    return AppErrorWidget(message: message, details: details, icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
