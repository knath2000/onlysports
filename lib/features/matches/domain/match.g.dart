// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
  id: (json['id'] as num).toInt(),
  competitionRef: CompetitionRef.fromJson(
    json['competition'] as Map<String, dynamic>,
  ),
  utcDate: DateTime.parse(json['utcDate'] as String),
  status: json['status'] as String,
  stage: json['stage'] as String?,
  group: json['group'] as String?,
  homeTeam: TeamRef.fromJson(json['homeTeam'] as Map<String, dynamic>),
  awayTeam: TeamRef.fromJson(json['awayTeam'] as Map<String, dynamic>),
  score: Score.fromJson(json['score'] as Map<String, dynamic>),
  venue: json['venue'] as String?,
);

CompetitionRef _$CompetitionRefFromJson(Map<String, dynamic> json) =>
    CompetitionRef(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

TeamRef _$TeamRefFromJson(Map<String, dynamic> json) =>
    TeamRef(id: (json['id'] as num).toInt(), name: json['name'] as String);

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
  winner: json['winner'] as String?,
  fullTime: ScoreTime.fromJson(json['fullTime'] as Map<String, dynamic>),
  halfTime: ScoreTime.fromJson(json['halfTime'] as Map<String, dynamic>),
);

ScoreTime _$ScoreTimeFromJson(Map<String, dynamic> json) => ScoreTime(
  homeScore: (json['homeTeam'] as num?)?.toInt(),
  awayScore: (json['awayTeam'] as num?)?.toInt(),
);
