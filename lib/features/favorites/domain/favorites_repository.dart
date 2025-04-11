import 'favorite.dart'; // Import the Favorite model

/// Abstract interface for managing favorite teams.
/// Defines the contract for data operations related to favorites,
/// independent of the underlying storage mechanism (e.g., Hive, SharedPreferences).
abstract class FavoritesRepository {
  /// Adds a favorite team to the persistent storage.
  Future<void> addFavorite(Favorite favorite);

  /// Removes a favorite team from storage using its unique ID.
  Future<void> removeFavorite(int teamId);

  /// Retrieves a list of all currently favorited teams.
  Future<List<Favorite>> getFavorites();

  /// Checks if a team with the given ID is currently favorited.
  Future<bool> isFavorite(int teamId);

  /// Provides a stream that emits the updated list of favorites
  /// whenever a change occurs (add/remove).
  Stream<List<Favorite>> watchFavorites();
}
