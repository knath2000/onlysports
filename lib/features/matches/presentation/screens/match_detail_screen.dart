import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/providers.dart'; // Import providers
import '../../../../app/theme/app_theme.dart'; // Import AppTheme
// Import custom Match with prefix
import '../../../../shared/widgets/shared_loading_indicator.dart'; // Import shared loading
import '../../../../shared/widgets/shared_error_message.dart'; // Import shared error

// Displays detailed information for a single match
class MatchDetailScreen extends ConsumerWidget {
  final String matchId;

  const MatchDetailScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the STREAM provider for live updates
    final matchDetailsAsync = ref.watch(liveMatchStreamProvider(matchId));

    final theme = Theme.of(context); // Get theme

    return Scaffold(
      // Remove standard AppBar
      backgroundColor: theme.scaffoldBackgroundColor, // Apply theme background
      body: Container(
        // Add Container for gradient
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient, // Apply gradient
        ),
        child: SafeArea(
          // Original SafeArea is now child of Container
          // Ensure content doesn't overlap status bar/notches
          child: matchDetailsAsync.when(
            data: (match) {
              if (match == null) {
                return const Center(child: Text('Match details not found.'));
              }

              // Basic date and time formatting
              final localDate = match.utcDate.toLocal();
              final timeFormat = DateFormat.jm(); // e.g., 5:08 PM
              final dateFormat = DateFormat.yMMMd(); // e.g., Apr 11, 2025

              // Build the details view
              // TODO: Replace with custom layout based on Step 5 design
              // TODO: Apply custom theme colors/fonts
              // TODO: Integrate Rive animations
              // Use ListView for potentially scrollable content
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // --- Custom Header Placeholder ---
                  Row(
                    children: [
                      // Large Back Button Placeholder
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                        ), // Example icon
                        iconSize: 28, // Larger icon
                        color: theme.primaryColor,
                        tooltip: 'Back',
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(), // Pushes button to the left
                      // Optional: Add other header elements like title or actions here
                    ],
                  ),
                  const SizedBox(height: 20), // Spacing after header
                  // --- Match Details Placeholders ---
                  // TODO: Replace with custom widgets (e.g., ScoreCard, TeamInfoWidget)

                  // Example: Basic Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Center content
                        children: [
                          Text(
                            '${match.homeTeam.name} vs ${match.awayTeam.name}',
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            match.competitionRef.name,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${dateFormat.format(localDate)} at ${timeFormat.format(localDate)}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${match.status}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          if (match.venue != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Venue: ${match.venue}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Example: Score Card Placeholder
                  if (match.status == 'FINISHED')
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Result', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 12),
                            Text(
                              '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'}',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '(Half Time: ${match.score.halfTime.homeScore ?? '-'} : ${match.score.halfTime.awayScore ?? '-'})',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // TODO: Add placeholders/widgets for other details (scorers, etc.)
                ],
              );
            },
            // Use shared loading indicator
            loading: () => const SharedLoadingIndicator(),
            // Use shared error message widget with retry callback
            error:
                (error, stackTrace) => SharedErrorMessage(
                  error: 'Failed to load match details: $error',
                  // Retry by refreshing the specific family member of the provider
                  onRetry: () => ref.refresh(liveMatchStreamProvider(matchId)),
                ),
          ), // Close matchDetailsAsync.when
        ), // Close SafeArea
      ), // Close Container
    ); // Close Scaffold
  }
}
