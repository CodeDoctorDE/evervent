import 'package:evervent_server/model/user.dart';
import 'package:evervent_server/evervent_server.dart';

import 'event.dart';
import 'group_user.dart';

class Group extends ManagedObject<_Group> implements _Group {}

class _Group {
  @primaryKey
  int id;

  @Column(unique: true)
  String name;

  @Column(defaultValue: "''")
  String description;

  ManagedSet<GroupUser> groupUsers;

  ManagedSet<Event> events;

  @Serialize(input: false, output: true)
  List<Map<String, dynamic>> users;


}
