// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ConnectionSettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConnectionSettingsAdapter extends TypeAdapter<ConnectionSettings> {
  @override
  final int typeId = 0;

  @override
  ConnectionSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConnectionSettings(
      name: fields[0] as String,
      host: fields[1] as String,
      port: fields[2] as String,
      password: fields[3] as String,
      isDefault: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ConnectionSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.host)
      ..writeByte(2)
      ..write(obj.port)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
