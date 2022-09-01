// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordAdapter extends TypeAdapter<Record> {
  @override
  final int typeId = 1;

  @override
  Record read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Record(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Record obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.playCount)
      ..writeByte(2)
      ..write(obj.correct)
      ..writeByte(3)
      ..write(obj.highScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
