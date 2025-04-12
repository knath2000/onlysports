// import 'package:shared_preferences/shared_preferences.dart'; // Removed - Migrated to Hive
// Handles persistence of favorite team IDs
class FavoritesRepository {
  static const _favoritesKey = 'favoriteTeamIds';

  // Get the shared preferences instance
  Future<SharedPreferences> _getPrefs() async {
    return SharedPreferences.getInstance();
  }

  // Load the list of favorite team IDs
  Future<List<String>> loadFavoriteTeamIds() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Save the list of favorite team IDs
  Future<bool> saveFavoriteTeamIds(List<String> ids) async {
    final prefs = await _getPrefs();
    return prefs.setStringList(_favoritesKey, ids);
  }

  // Add a team ID to favorites
  Future<bool> addFavorite(String teamId) async {
    final currentFavorites = await loadFavoriteTeamIds();
    if (!currentFavorites.contains(teamId)) {
      final updatedFavorites = [...currentFavorites, teamId];
      return saveFavoriteTeamIds(updatedFavorites);
    }
    return true; // Already exists, success
  }

  // Remove a team ID from favorites
  Future<bool> removeFavorite(String teamId) async {
    final currentFavorites = await loadFavoriteTeamIds();
    if (currentFavorites.contains(teamId)) {
      final updatedFavorites =
          currentFavorites.where((id) => id != teamId).toList();
      return saveFavoriteTeamIds(updatedFavorites);
    }
    return true; // Doesn't exist, success
  }
}
