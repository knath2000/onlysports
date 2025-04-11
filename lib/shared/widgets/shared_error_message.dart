import 'package:flutter/material.dart';

/// A reusable widget to display error messages, optionally with a retry button.
class SharedErrorMessage extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry; // Optional callback for a retry button

  const SharedErrorMessage({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    // TODO: Improve error formatting/parsing for user-friendliness
    final errorMessage = 'An error occurred: $error';
    print('Displaying error: $errorMessage'); // Log the error for debugging

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
