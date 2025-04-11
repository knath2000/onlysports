import 'user_selection.dart';

/// Abstract interface for managing the user's league/team selection.
abstract class SelectionRepository {
  /// Saves the user's current selection.
  /// This typically overwrites any previous selection.
  Future<void> saveSelection(UserSelection selection);

  /// Retrieves the user's saved selection, if any.
  /// Returns null if no selection has been saved yet.
  Future<UserSelection?> getSelection();

  // Optional: Add a watch method if needed later
  // Stream<UserSelection?> watchSelection();
}
