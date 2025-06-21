// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GovernorateAdapter extends TypeAdapter<Governorate> {
  @override
  final int typeId = 0;

  @override
  Governorate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Governorate(
      id: fields[0] as int,
      enName: fields[1] as String,
      arName: fields[2] as String,
      countryId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Governorate obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.enName)
      ..writeByte(2)
      ..write(obj.arName)
      ..writeByte(3)
      ..write(obj.countryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GovernorateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StateModelAdapter extends TypeAdapter<StateModel> {
  @override
  final int typeId = 1;

  @override
  StateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StateModel(
      id: fields[0] as int,
      enName: fields[1] as String,
      arName: fields[2] as String,
      governorateId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StateModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.enName)
      ..writeByte(2)
      ..write(obj.arName)
      ..writeByte(3)
      ..write(obj.governorateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final int typeId = 2;

  @override
  Place read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Place(
      id: fields[0] as int,
      enName: fields[1] as String,
      arName: fields[2] as String,
      stateId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.enName)
      ..writeByte(2)
      ..write(obj.arName)
      ..writeByte(3)
      ..write(obj.stateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
