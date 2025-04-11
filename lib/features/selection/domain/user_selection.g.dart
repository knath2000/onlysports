// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_selection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSelectionAdapter extends TypeAdapter<UserSelection> {
  @override
  final int typeId = 6;

  @override
  UserSelection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSelection(
      selectedLeagueId: fields[0] as String?,
      selectedLeagueName: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSelection obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.selectedLeagueId)
      ..writeByte(1)
      ..write(obj.selectedLeagueName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSelectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
