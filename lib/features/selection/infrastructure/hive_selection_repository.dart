import 'package:hive/hive.dart';
import '../domain/selection_repository.dart';
import '../domain/user_selection.dart';

/// Hive-based implementation of the [SelectionRepository].
/// Stores a single [UserSelection] object in the 'userSelectionBox'
/// using a fixed key.
class HiveSelectionRepository implements SelectionRepository {
  late final Box<UserSelection> _selectionBox;
  static const String _selectionKey = 'user_selection'; // Fixed key

  HiveSelectionRepository() {
    _selectionBox = Hive.box<UserSelection>('userSelectionBox');
  }

  @override
  Future<void> saveSelection(UserSelection selection) async {
    // Store the single selection object using the fixed key
    await _selectionBox.put(_selectionKey, selection);
  }

  @override
  Future<UserSelection?> getSelection() async {
    // Retrieve the selection object using the fixed key
    return _selectionBox.get(_selectionKey);
  }

  // Optional: Implement watch method if needed
  // @override
  // Stream<UserSelection?> watchSelection() {
  //   // Watch the specific key
  //   return _selectionBox.watch(key: _selectionKey).map((event) {
  //     return event.value as UserSelection?;
  //   });
  // }
}
