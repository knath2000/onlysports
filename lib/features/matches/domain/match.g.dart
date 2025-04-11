// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchAdapter extends TypeAdapter<Match> {
  @override
  final int typeId = 1;

  @override
  Match read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Match(
      id: fields[0] as int,
      competitionRef: fields[1] as CompetitionRef,
      utcDate: fields[2] as DateTime,
      status: fields[3] as String,
      stage: fields[4] as String?,
      group: fields[5] as String?,
      homeTeam: fields[6] as TeamRef,
      awayTeam: fields[7] as TeamRef,
      score: fields[8] as Score,
      venue: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Match obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.competitionRef)
      ..writeByte(2)
      ..write(obj.utcDate)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.stage)
      ..writeByte(5)
      ..write(obj.group)
      ..writeByte(6)
      ..write(obj.homeTeam)
      ..writeByte(7)
      ..write(obj.awayTeam)
      ..writeByte(8)
      ..write(obj.score)
      ..writeByte(9)
      ..write(obj.venue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetitionRefAdapter extends TypeAdapter<CompetitionRef> {
  @override
  final int typeId = 2;

  @override
  CompetitionRef read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompetitionRef(
      id: fields[0] as int,
      name: fields[1] as String,
      emblem: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CompetitionRef obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.emblem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetitionRefAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamRefAdapter extends TypeAdapter<TeamRef> {
  @override
  final int typeId = 3;

  @override
  TeamRef read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamRef(
      id: fields[0] as int,
      name: fields[1] as String,
      crest: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeamRef obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.crest);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamRefAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreAdapter extends TypeAdapter<Score> {
  @override
  final int typeId = 4;

  @override
  Score read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Score(
      winner: fields[0] as String?,
      fullTime: fields[1] as ScoreTime,
      halfTime: fields[2] as ScoreTime,
    );
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.winner)
      ..writeByte(1)
      ..write(obj.fullTime)
      ..writeByte(2)
      ..write(obj.halfTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreTimeAdapter extends TypeAdapter<ScoreTime> {
  @override
  final int typeId = 5;

  @override
  ScoreTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreTime(
      homeScore: fields[0] as int?,
      awayScore: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ScoreTime obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.homeScore)
      ..writeByte(1)
      ..write(obj.awayScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      id: (json['id'] as num).toInt(),
      competitionRef:
          CompetitionRef.fromJson(json['competition'] as Map<String, dynamic>),
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
      emblem: json['emblem'] as String?,
    );

TeamRef _$TeamRefFromJson(Map<String, dynamic> json) => TeamRef(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      crest: json['crest'] as String?,
    );

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      winner: json['winner'] as String?,
      fullTime: ScoreTime.fromJson(json['fullTime'] as Map<String, dynamic>),
      halfTime: ScoreTime.fromJson(json['halfTime'] as Map<String, dynamic>),
    );

ScoreTime _$ScoreTimeFromJson(Map<String, dynamic> json) => ScoreTime(
      homeScore: (json['home'] as num?)?.toInt(),
      awayScore: (json['away'] as num?)?.toInt(),
    );
