import 'match.dart'; // Placeholder import

// Placeholder for Match Repository Interface (Domain Layer)
abstract class MatchRepository {
  Future<List<Match>> getUpcomingMatches({
    String? leagueId, // Changed parameter name for clarity
    // String? team, // Team filtering not implemented yet
    DateTime? date,
  });
  Future<List<Match>> getPreviousMatches({
    String? leagueId, // Changed parameter name for clarity
    // String? team,
    DateTime? date,
  });
  Stream<Match?> getMatchDetails(
    String matchId,
  ); // Changed to Stream for potential updates/caching

  Future<List<CompetitionRef>>
  getAvailableLeagues(); // Added for selection screen
  // Add methods for favorites if managed here
}
