import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/providers.dart'; // Import providers
import '../../domain/match.dart' as domain; // Import custom Match with prefix

// Displays detailed information for a single match
class MatchDetailScreen extends ConsumerWidget {
  final String matchId;

  const MatchDetailScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the STREAM provider for live updates
    final matchDetailsAsync = ref.watch(liveMatchStreamProvider(matchId));

    return Scaffold(
      appBar: AppBar(
        // Set title based on the async state
        title: matchDetailsAsync.maybeWhen(
          data:
              (match) => Text(
                match != null
                    ? '${match.homeTeam.name} vs ${match.awayTeam.name}'
                    : 'Match Details', // Fallback title
                overflow:
                    TextOverflow.ellipsis, // Prevent long titles overflowing
              ),
          orElse:
              () => const Text('Match Details'), // Title during loading/error
        ),
        // TODO: Apply custom theme
      ),
      body: matchDetailsAsync.when(
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Removed problematic addPostFrameCallback block
                Text(
                  '${match.homeTeam.name} vs ${match.awayTeam.name}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(match.competitionRef.name),
                const SizedBox(height: 8),
                Text(
                  '${dateFormat.format(localDate)} at ${timeFormat.format(localDate)}',
                ),
                const SizedBox(height: 8),
                Text('Status: ${match.status}'),
                if (match.venue != null) ...[
                  const SizedBox(height: 8),
                  Text('Venue: ${match.venue}'),
                ],
                if (match.status == 'FINISHED') ...[
                  const SizedBox(height: 16),
                  Text(
                    'Full Time: ${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '(Half Time: ${match.score.halfTime.homeScore ?? '-'} : ${match.score.halfTime.awayScore ?? '-'})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                // TODO: Display other details like stage, group, scorers, etc. if available
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          // TODO: Improve error display
          print('Error loading match details for $matchId: $error');
          print(stackTrace);
          return Center(child: Text('Error loading details: $error'));
        },
      ),
    );
  }
}
