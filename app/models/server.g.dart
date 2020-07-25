// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerAdapter extends TypeAdapter<Server> {
  @override
  final typeId = 3;

  @override
  Server read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Server()
      ..address = fields[0] as String
      ..accessToken = fields[1] as String
      ..username = fields[2] as String
      ..created = fields[3] as DateTime
      ..refreshToken = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Server obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.created)
      ..writeByte(4)
      ..write(obj.refreshToken);
  }
}
