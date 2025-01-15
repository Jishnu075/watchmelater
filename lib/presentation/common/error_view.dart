import 'package:flutter/material.dart';
import 'package:watchmelater/core/errors/error_types.dart';

class ErrorView extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onRetry;
  final String message;

  const ErrorView({
    super.key,
    required this.onRetry,
    required this.icon,
    required this.iconColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
