import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/favorites_repository.dart'; // Import domain interface
import '../domain/favorite.dart'; // Import Favorite model
import '../../../app/providers.dart'; // Import global providers (Corrected path)

// State Notifier for managing favorite add/remove ACTIONS
// The actual list state is handled by favoritesStreamProvider
class FavoritesNotifier extends StateNotifier<AsyncValue<void>> {
  final FavoritesRepository _repository;

  // Constructor now takes the repository directly
  FavoritesNotifier(this._repository)
    : super(const AsyncValue.data(null)); // Initial state is idle/success

  // _loadFavorites is no longer needed, UI will watch favoritesStreamProvider

  // Add a team to favorites - takes the full Favorite object now
  Future<void> addFavorite(Favorite favorite) async {
    state = const AsyncValue.loading(); // Set state to loading
    try {
      await _repository.addFavorite(favorite);
      state = const AsyncValue.data(null); // Set state to success
    } catch (e, s) {
      print('Error adding favorite: $e');
      state = AsyncValue.error(e, s); // Set state to error
    }
  }

  // Remove a team from favorites - takes the integer teamId
  Future<void> removeFavorite(int teamId) async {
    state = const AsyncValue.loading(); // Set state to loading
    try {
      await _repository.removeFavorite(teamId);
      state = const AsyncValue.data(null); // Set state to success
    } catch (e, s) {
      print('Error removing favorite: $e');
      state = AsyncValue.error(e, s); // Set state to error
    }
  }

  // isFavorite method removed - UI should use isFavoriteProvider from app/providers.dart
}

// Local repository provider removed - use the one from app/providers.dart

// Provider for the FavoritesNotifier - updated state type and repository source
final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<void>>((ref) {
      // Watch the global repository provider
      final repository = ref.watch(favoritesRepositoryProvider);
      return FavoritesNotifier(repository);
    });
