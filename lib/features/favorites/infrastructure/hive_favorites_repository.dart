import 'dart:async';
import 'package:hive/hive.dart';
import '../domain/favorite.dart';
import '../domain/favorites_repository.dart';

/// Hive-based implementation of the [FavoritesRepository].
/// Interacts with the 'favoritesBox' to store and retrieve favorite teams.
class HiveFavoritesRepository implements FavoritesRepository {
  late final Box<Favorite> _favoritesBox;

  HiveFavoritesRepository() {
    // Get the box opened during app initialization
    _favoritesBox = Hive.box<Favorite>('favoritesBox');
  }

  @override
  Future<void> addFavorite(Favorite favorite) async {
    // Use teamId as the key for easy lookup and removal
    await _favoritesBox.put(favorite.teamId, favorite);
  }

  @override
  Future<void> removeFavorite(int teamId) async {
    await _favoritesBox.delete(teamId);
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    // Return all values currently in the box
    return _favoritesBox.values.toList();
  }

  @override
  Future<bool> isFavorite(int teamId) async {
    // Check if a key (teamId) exists in the box
    return _favoritesBox.containsKey(teamId);
  }

  @override
  Stream<List<Favorite>> watchFavorites() {
    // Listen to changes in the box
    final stream = _favoritesBox.watch();

    // Map the BoxEvent stream to a stream of List<Favorite>
    // Emit the current list immediately, then emit updates on changes.
    final controller = StreamController<List<Favorite>>.broadcast();

    // Emit initial value
    controller.add(_favoritesBox.values.toList());

    // Listen for changes and emit updated list
    final listener = stream.listen((event) {
      if (!controller.isClosed) {
        controller.add(_favoritesBox.values.toList());
      }
    });

    // Close the listener when the stream subscription is cancelled
    controller.onCancel = () {
      listener.cancel();
    };

    return controller.stream;
  }
}
