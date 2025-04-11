import 'match.dart'; // Placeholder import

// Placeholder for Match Repository Interface (Domain Layer)
abstract class MatchRepository {
  Future<List<Match>> getUpcomingMatches({
    String? league,
    String? team,
    DateTime? date,
  });
  Future<List<Match>> getPreviousMatches({
    String? league,
    String? team,
    DateTime? date,
  });
  Stream<Match?> getMatchDetails(
    String matchId,
  ); // Changed to Stream for potential updates/caching
  // Add methods for favorites if managed here
}
