import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/matches/domain/match_repository.dart';
import '../features/matches/infrastructure/api_match_repository.dart';
import '../features/matches/domain/match.dart' as domain; // Import custom Match
import 'dart:async'; // Import for Timer and StreamController

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
final matchDetailsProvider = FutureProvider.family<domain.Match?, String>((
  ref,
  matchId,
) async {
  final repository = ref.watch(matchRepositoryProvider);
  return repository.getMatchDetails(matchId);
}); // End of matchDetailsProvider

// Provider that streams match details, polling if the match is live
final liveMatchStreamProvider = StreamProvider.autoDispose.family<
  domain.Match?,
  String
>((ref, matchId) {
  final repository = ref.watch(matchRepositoryProvider);
  Timer? timer; // Timer for polling
  final controller =
      StreamController<
        domain.Match?
      >.broadcast(); // Use broadcast if multiple listeners

  Future<void> fetchAndEmit() async {
    try {
      final match = await repository.getMatchDetails(matchId);
      if (controller.isClosed) return; // Stop if controller is closed
      controller.add(match);

      // If match is finished or cancelled, stop polling
      if (match?.status == 'FINISHED' ||
          match?.status == 'CANCELLED' ||
          match?.status == 'POSTPONED') {
        timer?.cancel();
        await controller.close(); // Close the stream
      }
      // Keep polling only if IN_PLAY or similar live status (adjust as needed)
      else if (match?.status != 'IN_PLAY' && match?.status != 'PAUSED') {
        // If scheduled/timed, emit once and stop (no need to poll)
        timer?.cancel();
        await controller.close();
      }
    } catch (e, s) {
      print('Error polling match details for $matchId: $e');
      if (!controller.isClosed) {
        controller.addError(e, s);
        // Consider stopping polling on error? Or retry? For now, stop.
        timer?.cancel();
        await controller.close();
      }
    }
  }

  // Initial fetch
  fetchAndEmit().then((_) {
    // Start polling only if the stream is still open after initial fetch
    // (i.e., match is potentially live)
    if (!controller.isClosed) {
      // Poll every 10 seconds (adjust as needed, mindful of rate limits)
      timer = Timer.periodic(const Duration(seconds: 10), (t) {
        print('Polling match details for $matchId...');
        fetchAndEmit();
      });
    }
  });

  // Cancel the timer when the provider is disposed
  ref.onDispose(() {
    print('Disposing liveMatchStreamProvider for $matchId, cancelling timer.');
    timer?.cancel();
    controller.close();
  });

  return controller.stream;
});

// Add other providers as needed (e.g., for state notifiers, other services)
