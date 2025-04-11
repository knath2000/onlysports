import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart'; // Import Hive

part 'match.g.dart'; // Required for json_serializable and hive_generator

// Represents the nested 'match' object from the API response
@HiveType(typeId: 1) // Unique Hive typeId
@JsonSerializable(createToJson: false) // We primarily need fromJson
class Match extends HiveObject {
  // Extend HiveObject for top-level caching
  @HiveField(0)
  final int id;

  @HiveField(1)
  @JsonKey(name: 'competition')
  final CompetitionRef competitionRef;

  @HiveField(2)
  final DateTime utcDate;

  @HiveField(3)
  final String status; // e.g., SCHEDULED, IN_PLAY, FINISHED

  @HiveField(4)
  final String? stage; // e.g., GROUP_STAGE, FINAL

  @HiveField(5)
  final String? group;

  @HiveField(6)
  final TeamRef homeTeam;

  @HiveField(7)
  final TeamRef awayTeam;

  @HiveField(8)
  final Score score;

  @HiveField(9)
  final String? venue; // Added as per requirements, might be null in API

  Match({
    required this.id,
    required this.competitionRef,
    required this.utcDate,
    required this.status,
    this.stage,
    this.group,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    this.venue,
  });

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

// Represents the nested 'competition' object within a Match
@HiveType(typeId: 2) // Unique Hive typeId
@JsonSerializable(createToJson: false)
class CompetitionRef {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  CompetitionRef({required this.id, required this.name});

  factory CompetitionRef.fromJson(Map<String, dynamic> json) =>
      _$CompetitionRefFromJson(json);
}

// Represents the nested 'homeTeam' or 'awayTeam' object within a Match
@HiveType(typeId: 3) // Unique Hive typeId
@JsonSerializable(createToJson: false)
class TeamRef {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  TeamRef({required this.id, required this.name});

  factory TeamRef.fromJson(Map<String, dynamic> json) =>
      _$TeamRefFromJson(json);
}

// Represents the nested 'score' object within a Match
@HiveType(typeId: 4) // Unique Hive typeId
@JsonSerializable(createToJson: false)
class Score {
  @HiveField(0)
  final String? winner; // HOME_TEAM, AWAY_TEAM, DRAW

  @HiveField(1)
  final ScoreTime fullTime;

  @HiveField(2)
  final ScoreTime halfTime;
  // Note: extraTime and penalties might be needed later if handling those durations

  Score({this.winner, required this.fullTime, required this.halfTime});

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
}

// Represents the nested score objects (fullTime, halfTime, etc.)
@HiveType(typeId: 5) // Unique Hive typeId
@JsonSerializable(createToJson: false)
class ScoreTime {
  // API uses homeTeam/awayTeam keys here too
  @HiveField(0)
  @JsonKey(name: 'homeTeam')
  final int? homeScore;

  @HiveField(1)
  @JsonKey(name: 'awayTeam')
  final int? awayScore;

  ScoreTime({this.homeScore, this.awayScore});

  factory ScoreTime.fromJson(Map<String, dynamic> json) =>
      _$ScoreTimeFromJson(json);
}

// --- Potentially needed later based on API structure ---
// class Season { ... }
// class Head2Head { ... }
// class Goal { ... }
// class Booking { ... }
// class Substitution { ... }
// class Referee { ... }
