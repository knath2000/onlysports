import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart'; // Import global providers
import '../features/selection/presentation/selection_screen.dart';
import '../features/matches/presentation/screens/match_list_screen.dart';

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
          // Otherwise, go to the selection screen
          return const SelectionScreen();
        }
      },
      // Show a loading indicator while checking persistence
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      // Show an error screen if persistence fails to load
      error: (err, stack) {
        print('Error loading user selection: $err\n$stack');
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error loading preferences: $err'),
            ),
          ),
        );
      },
    );
  }
}
