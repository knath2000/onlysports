import 'package:hive/hive.dart';

part 'user_selection.g.dart'; // Generated file

@HiveType(typeId: 6) // Unique Hive typeId (Match used 1-5, Favorite used 0)
class UserSelection extends HiveObject {
  @HiveField(0)
  String? selectedLeagueId; // e.g., "PL", "BL1" etc. from API

  @HiveField(1)
  String? selectedLeagueName; // e.g., "Premier League"

  // Team fields are omitted for now as per requirement

  UserSelection({this.selectedLeagueId, this.selectedLeagueName});

  // Helper to check if a valid selection has been made
  bool get hasSelection =>
      selectedLeagueId != null && selectedLeagueId!.isNotEmpty;

  @override
  String toString() =>
      'UserSelection(leagueId: $selectedLeagueId, leagueName: $selectedLeagueName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSelection &&
        other.selectedLeagueId == selectedLeagueId &&
        other.selectedLeagueName == selectedLeagueName;
  }

  @override
  int get hashCode => selectedLeagueId.hashCode ^ selectedLeagueName.hashCode;
}
