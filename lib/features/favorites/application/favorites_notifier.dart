import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/favorites_repository.dart';

// State Notifier for managing the list of favorite team IDs
class FavoritesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadFavorites(); // Load initial favorites when notifier is created
  }

  // Load favorites from the repository
  Future<void> _loadFavorites() async {
    try {
      final ids = await _repository.loadFavoriteTeamIds();
      state = AsyncValue.data(ids);
    } catch (e, s) {
      print('Error loading favorites: $e');
      state = AsyncValue.error(e, s);
    }
  }

  // Add a team to favorites
  Future<void> addFavorite(String teamId) async {
    // Optimistically update the state first for faster UI feedback
    state.whenData((currentIds) {
      if (!currentIds.contains(teamId)) {
        state = AsyncValue.data([...currentIds, teamId]);
      }
    });

    try {
      await _repository.addFavorite(teamId);
      // Optionally reload or just trust optimistic update if repository is reliable
      // await _loadFavorites(); // Uncomment to reload after successful save
    } catch (e, s) {
      print('Error adding favorite: $e');
      // Revert optimistic update on error
      await _loadFavorites();
      // Optionally expose error state to UI
    }
  }

  // Remove a team from favorites
  Future<void> removeFavorite(String teamId) async {
    // Optimistic update
    state.whenData((currentIds) {
      if (currentIds.contains(teamId)) {
        state = AsyncValue.data(
          currentIds.where((id) => id != teamId).toList(),
        );
      }
    });

    try {
      await _repository.removeFavorite(teamId);
      // Optionally reload
      // await _loadFavorites();
    } catch (e, s) {
      print('Error removing favorite: $e');
      // Revert optimistic update
      await _loadFavorites();
      // Optionally expose error state
    }
  }

  // Helper to check if a team is favorite (synchronous check on current state)
  bool isFavorite(String teamId) {
    return state.maybeWhen(
      data: (ids) => ids.contains(teamId),
      orElse: () => false, // Default to false if loading/error
    );
  }
}

// Provider for the FavoritesRepository
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

// Provider for the FavoritesNotifier
final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<String>>>((ref) {
      final repository = ref.watch(favoritesRepositoryProvider);
      return FavoritesNotifier(repository);
    });
