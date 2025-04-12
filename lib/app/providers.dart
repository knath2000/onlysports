import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/matches/domain/match_repository.dart';
import '../features/matches/infrastructure/api_match_repository.dart';
import '../features/matches/domain/match.dart' as domain; // Import custom Match
// Import for Timer and StreamController
import '../features/favorites/domain/favorites_repository.dart'; // Import Favorites interface
import '../features/favorites/infrastructure/hive_favorites_repository.dart'; // Import Hive implementation
import '../features/selection/domain/selection_repository.dart';
import '../features/selection/infrastructure/hive_selection_repository.dart';
import '../features/selection/domain/user_selection.dart';
import '../features/favorites/domain/favorite.dart'; // Import Favorite model
import 'dart:convert'; // Import for jsonEncode

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
// Updated to watch user selection and pass leagueId
final upcomingMatchesProvider = FutureProvider.autoDispose<List<domain.Match>>((
  ref,
) async {
  final repository = ref.watch(matchRepositoryProvider);
  // Watch the user's selection
  final userSelection = ref.watch(userSelectionProvider).asData?.value;
  final leagueId = userSelection?.selectedLeagueId;

  // TODO: Decide what to do if leagueId is null (e.g., return empty list, show error, fetch default?)
  // For now, we pass null or the selected ID to the repository, which defaults to 'PL'.
  print('Fetching upcoming matches for league: $leagueId'); // Debug print
  return repository.getUpcomingMatches(leagueId: leagueId);
});

// Provider for previous matches
// Updated to watch user selection and pass leagueId
final previousMatchesProvider = FutureProvider.autoDispose<List<domain.Match>>((
  ref,
) async {
  final repository = ref.watch(matchRepositoryProvider);
  // Watch the user's selection
  final userSelection = ref.watch(userSelectionProvider).asData?.value;
  final leagueId = userSelection?.selectedLeagueId;

  // Pass null or the selected ID to the repository
  print('Fetching previous matches for league: $leagueId'); // Debug print
  return repository.getPreviousMatches(leagueId: leagueId);
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
  teamId, // Parameter for the family
) async {
  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.isFavorite(teamId);
});

// --- User Selection Providers ---

// Provider for the SelectionRepository implementation
final selectionRepositoryProvider = Provider<SelectionRepository>((ref) {
  return HiveSelectionRepository();
});

// Provider to fetch the currently saved UserSelection (if any)
// This is watched by the initial routing logic.
final userSelectionProvider = FutureProvider.autoDispose<UserSelection?>((ref) {
  final repository = ref.watch(selectionRepositoryProvider);
  return repository.getSelection();
});
// Add other providers as needed (e.g., for state notifiers, other services)

// Provider to fetch available leagues for the selection screen
final availableLeaguesProvider =
    FutureProvider.autoDispose<List<domain.CompetitionRef>>((ref) {
      final repository = ref.watch(matchRepositoryProvider);
      return repository.getAvailableLeagues();
    });

// --- Gemini Prediction Provider ---

// Provider to fetch match prediction from the Gemini API via our proxy
final geminiPredictionProvider = FutureProvider.autoDispose
    .family<String, Map<String, String>>((ref, matchDetails) async {
      final dio = ref.watch(dioProvider);
      final apiUrl = '/api/geminiPrediction'; // Relative path for Vercel proxy

      // Ensure required details are present
      if (!matchDetails.containsKey('homeTeamName') ||
          !matchDetails.containsKey('awayTeamName') ||
          !matchDetails.containsKey('competitionName')) {
        throw ArgumentError('Missing required match details for prediction.');
      }

      try {
        final response = await dio.post(
          apiUrl,
          data: jsonEncode({
            'homeTeamName': matchDetails['homeTeamName'],
            'awayTeamName': matchDetails['awayTeamName'],
            'competitionName': matchDetails['competitionName'],
          }),
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        if (response.statusCode == 200 && response.data is Map) {
          final prediction = response.data['prediction'] as String?;
          if (prediction != null && prediction.isNotEmpty) {
            return prediction;
          } else {
            throw Exception('Prediction not found or empty in API response.');
          }
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error:
                'Failed to get prediction: Status code ${response.statusCode}',
          );
        }
      } on DioException catch (e) {
        // Log or handle Dio-specific errors
        print('DioError fetching prediction: ${e.message}');
        print('Response data: ${e.response?.data}');
        throw Exception('Failed to fetch prediction: ${e.message}');
      } catch (e) {
        // Catch other potential errors
        print('Error fetching prediction: $e');
        throw Exception(
          'An unexpected error occurred while fetching the prediction.',
        );
      }
    });
