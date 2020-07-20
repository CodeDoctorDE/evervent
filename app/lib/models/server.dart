import 'dart:convert';

import 'package:hive/hive.dart';

part 'server.g.dart';

@HiveType(typeId: 3)
class Server {
  // We use the negative time as key in Hive to sort in descending order.
  String get id => username + '@' + address;

  String get id64 => base64.encode(utf8.encode(id));

  String get aid64 => base64.encode(utf8.encode(address));

  String get baseUrl => address + '/api/v0';

  @HiveField(0)
  String address;

  @HiveField(1)
  String accessToken;

  @HiveField(2)
  String username;

  @HiveField(3)
  DateTime created;

  @HiveField(4)
  String refreshToken;

  /*  Server copyWith({bool done}) {
    return Todo()
      ..name = name
      ..created = created
      ..done = done;
  } */
}
