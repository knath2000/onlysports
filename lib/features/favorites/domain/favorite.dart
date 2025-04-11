import 'package:hive/hive.dart';

part 'favorite.g.dart'; // Generated file

@HiveType(typeId: 0) // Unique typeId for each HiveObject model
class Favorite extends HiveObject {
  @HiveField(0)
  final int teamId;

  @HiveField(1)
  final String teamName; // Example additional data, adjust if needed

  Favorite({required this.teamId, required this.teamName});

  // Optional: Override toString for easier debugging
  @override
  String toString() => 'Favorite(teamId: $teamId, teamName: $teamName)';

  // Optional: Implement equality operators if needed
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Favorite &&
        other.teamId == teamId &&
        other.teamName == teamName;
  }

  @override
  int get hashCode => teamId.hashCode ^ teamName.hashCode;
}
