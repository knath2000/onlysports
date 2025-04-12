import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart'; // Import global providers
import '../features/selection/presentation/selection_screen.dart'
    deferred as selection_screen;
import '../features/matches/presentation/screens/match_list_screen.dart';
import '../shared/widgets/shared_loading_indicator.dart'; // Import shared loading
import '../shared/widgets/shared_error_message.dart'; // Import shared error

/// Determines the initial screen based on whether the user
/// has already made a league selection.
class InitialRouteDispatcher extends ConsumerWidget {
  const InitialRouteDispatcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider that checks for saved selection
    final asyncSelection = ref.watch(userSelectionProvider);

    return asyncSelection.when(
      data: (selection) {
        // If a selection exists and has a league ID, go to main screen
        if (selection != null && selection.hasSelection) {
          return const MatchListScreen(); // Or your main navigator/shell
        } else {
          // Otherwise, load and go to the selection screen
          return FutureBuilder<void>(
            future: selection_screen.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // Handle library loading error
                  return Scaffold(
                    body: SharedErrorMessage(
                      error:
                          'Failed to load selection screen: ${snapshot.error}',
                    ),
                  );
                }
                // Library loaded, show the screen (remove const)
                return selection_screen.SelectionScreen();
              }
              // Show loading indicator while the library is loading
              return const Scaffold(body: SharedLoadingIndicator());
            },
          );
        }
      },
      // Show a loading indicator while checking persistence
      // Use shared loading indicator
      loading: () => const Scaffold(body: SharedLoadingIndicator()),
      // Show an error screen if persistence fails to load
      // Use shared error message widget
      error:
          (err, stack) => Scaffold(
            body: SharedErrorMessage(
              error: 'Failed to load user preferences: $err',
              // No retry action defined here, as it's a critical startup error
            ),
          ),
    );
  }
}
