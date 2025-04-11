import 'package:json_annotation/json_annotation.dart';

part 'match.g.dart'; // Required for json_serializable generation

// Represents the nested 'match' object from the API response
@JsonSerializable(createToJson: false) // We primarily need fromJson
class Match {
  final int id;
  @JsonKey(name: 'competition')
  final CompetitionRef competitionRef;
  final DateTime utcDate;
  final String status; // e.g., SCHEDULED, IN_PLAY, FINISHED
  final String? stage; // e.g., GROUP_STAGE, FINAL
  final String? group;
  final TeamRef homeTeam;
  final TeamRef awayTeam;
  final Score score;
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
@JsonSerializable(createToJson: false)
class CompetitionRef {
  final int id;
  final String name;

  CompetitionRef({required this.id, required this.name});

  factory CompetitionRef.fromJson(Map<String, dynamic> json) =>
      _$CompetitionRefFromJson(json);
}

// Represents the nested 'homeTeam' or 'awayTeam' object within a Match
@JsonSerializable(createToJson: false)
class TeamRef {
  final int id;
  final String name;

  TeamRef({required this.id, required this.name});

  factory TeamRef.fromJson(Map<String, dynamic> json) =>
      _$TeamRefFromJson(json);
}

// Represents the nested 'score' object within a Match
@JsonSerializable(createToJson: false)
class Score {
  final String? winner; // HOME_TEAM, AWAY_TEAM, DRAW
  final ScoreTime fullTime;
  final ScoreTime halfTime;
  // Note: extraTime and penalties might be needed later if handling those durations

  Score({this.winner, required this.fullTime, required this.halfTime});

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
}

// Represents the nested score objects (fullTime, halfTime, etc.)
@JsonSerializable(createToJson: false)
class ScoreTime {
  // API uses homeTeam/awayTeam keys here too
  @JsonKey(name: 'homeTeam')
  final int? homeScore;
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
