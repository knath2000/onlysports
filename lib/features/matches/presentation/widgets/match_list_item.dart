import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:intl/intl.dart';
import '../../domain/match.dart' as domain;
import '../../../../app/providers.dart'; // Import global providers
import '../../../favorites/application/favorites_notifier.dart'; // Import favorites notifier
import '../../../favorites/domain/favorite.dart'; // Import Favorite model
import '../screens/match_detail_screen.dart';

// Widget for displaying a single match in a list
// Change to ConsumerWidget to access providers
class MatchListItem extends ConsumerWidget {
  final domain.Match match;

  const MatchListItem({super.key, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add WidgetRef
    // Basic date and time formatting
    final localDate = match.utcDate.toLocal();
    final timeFormat = DateFormat.jm(); // e.g., 5:08 PM
    final dateFormat = DateFormat.yMMMd(); // e.g., Apr 11, 2025

    // Determine score display based on status
    String scoreOrTime;
    // Handle different statuses for score/time display
    if (match.status == 'FINISHED') {
      scoreOrTime =
          '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'}';
    } else if (match.status == 'SCHEDULED' || match.status == 'TIMED') {
      // Also handle TIMED
      scoreOrTime = timeFormat.format(localDate);
    } else {
      // Handle IN_PLAY, PAUSED, etc. - potentially show live score if available
      scoreOrTime =
          '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'} (${match.status})';
    }

    return ListTile(
      // TODO: Replace with custom layout based on Step 5 design
      // TODO: Add team logos/crests if available from API/assets
      // TODO: Apply custom theme colors/fonts
      // TODO: Integrate Rive animations for interactions/status changes
      leading: Column(
        // Example layout
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dateFormat.format(localDate),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(scoreOrTime, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      title: Text(
        '${match.homeTeam.name} vs ${match.awayTeam.name}',
        style: Theme.of(context).textTheme.titleMedium, // Use theme style
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        match.competitionRef.name, // Show competition name
        style: Theme.of(context).textTheme.bodySmall, // Use theme style
      ),
      trailing: Consumer(
        // Use Consumer to rebuild only the icon button
        builder: (context, ref, child) {
          // Watch the specific provider for this team's favorite status
          final teamId = match.homeTeam.id; // Use int ID
          final asyncIsFav = ref.watch(isFavoriteProvider(teamId));

          // Handle loading/error states for the favorite check
          final isFav = asyncIsFav.maybeWhen(
            data: (isFavoriteResult) => isFavoriteResult,
            orElse: () => false, // Default to false on loading/error
          );
          // TODO: Allow favoriting away team or league too? Needs design decision.

          return IconButton(
            icon: Icon(
              isFav ? Icons.star : Icons.star_border,
              color:
                  isFav
                      ? Theme.of(context).colorScheme.primary
                      : null, // Use theme color
            ),
            onPressed: () {
              final notifier = ref.read(favoritesNotifierProvider.notifier);
              final teamIdInt = match.homeTeam.id; // Already have int ID
              final teamName = match.homeTeam.name;

              if (isFav) {
                notifier.removeFavorite(teamIdInt);
              } else {
                // Create Favorite object to add
                final favoriteToAdd = Favorite(
                  teamId: teamIdInt,
                  teamName: teamName,
                );
                notifier.addFavorite(favoriteToAdd);
              }
              // Invalidate the isFavoriteProvider for this ID to force a refresh
              // after the action completes, ensuring the icon updates.
              ref.invalidate(isFavoriteProvider(teamIdInt));
            },
          );
        },
      ),
      onTap: () {
        print('Tapped on match: ${match.id}');
        // Navigate to MatchDetailScreen, passing the match ID
        Navigator.push(
          context,
          MaterialPageRoute(
            // TODO: Consider using named routes for better organization
            builder:
                (context) => MatchDetailScreen(matchId: match.id.toString()),
          ),
        );
      },
    );
  }
}
