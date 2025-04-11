import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/matches/domain/match_repository.dart';
import '../features/matches/infrastructure/api_match_repository.dart';
import '../features/matches/domain/match.dart' as domain; // Import custom Match
import 'dart:async'; // Import for Timer and StreamController
import '../features/favorites/domain/favorites_repository.dart'; // Import Favorites interface
import '../features/favorites/infrastructure/hive_favorites_repository.dart'; // Import Hive implementation
import '../features/favorites/domain/favorite.dart'; // Import Favorite model

// Provider for the Dio instance (HTTP client)
final dioProvider = Provider<Dio>((ref) {
  // Configure Dio instance here if needed (e.g., base options, interceptors)
  // The ApiMatchRepository already adds the base URL, token, and a logger.
  return Dio();
});

// Provider for the MatchRepository implementation
// This depends on the dioProvider
final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiMatchRepository(dio);
  // If we wanted to switch to a mock repository for testing,
  // we could change the implementation returned here.
});

// --- Feature-Specific Providers (Example for Matches) ---

// This provider could fetch the list of upcoming matches using the repository.
// The UI would watch this provider. Using FutureProvider for simplicity here.
// More complex state might use a StateNotifierProvider.
final upcomingMatchesProvider = FutureProvider.autoDispose<List<domain.Match>>((
  ref,
) async {
  final repository = ref.watch(matchRepositoryProvider);
  // TODO: Add actual filtering parameters if needed
  return repository.getUpcomingMatches();
});

// Provider for previous matches
final previousMatchesProvider = FutureProvider.autoDispose<List<domain.Match>>((
  ref,
) async {
  final repository = ref.watch(matchRepositoryProvider);
  // TODO: Add actual filtering parameters if needed
  return repository.getPreviousMatches();
});

// Provider for match details (takes matchId as parameter)
// Using .family modifier to pass the ID
// Keep details provider non-autoDispose unless needed, or use .autoDispose.family
// Changed from FutureProvider to StreamProvider to match repository method
final matchDetailsProvider = StreamProvider.family<domain.Match?, String>((
  ref,
  matchId,
) {
  final repository = ref.watch(matchRepositoryProvider);
  // Directly return the stream from the repository
  return repository.getMatchDetails(matchId);
}); // End of matchDetailsProvider

// Provider that streams match details, polling if the match is live
final liveMatchStreamProvider = StreamProvider.autoDispose.family<
  domain.Match?,
  String
>((ref, matchId) {
  // Simplified: Directly return the stream from the repository.
  // The repository's getMatchDetails now handles emitting cached data
  // followed by fetched data. The complex polling logic here is removed.
  final repository = ref.watch(matchRepositoryProvider);
  return repository.getMatchDetails(matchId);

  // Note: If continuous background polling IS required even after the initial
  // fetch, this provider would need to be redesigned, perhaps using a
  // StateNotifierProvider that listens to the initial stream and then
  // separately triggers periodic fetches via the repository.
  // For now, we rely on the repository's stream behavior.
});

// --- Favorites Providers ---

// Provider for the FavoritesRepository implementation
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  // Return the Hive implementation
  return HiveFavoritesRepository();
  // If we had an old SharedPreferences one, we'd replace it here.
});

// Provider that streams the list of current favorites
final favoritesStreamProvider = StreamProvider.autoDispose<List<Favorite>>((
  ref,
) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.watchFavorites();
});

// Provider to check if a specific team is a favorite (useful for UI toggles)
final isFavoriteProvider = FutureProvider.autoDispose.family<bool, int>((
  ref,
  teamId,
) async {
  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.isFavorite(teamId);
});
// Add other providers as needed (e.g., for state notifiers, other services)
