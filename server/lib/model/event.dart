import 'package:jakeson_server/model/comment.dart';
import 'package:jakeson_server/model/user.dart';
import 'package:jakeson_server/jakeson_server.dart';

import 'appointment.dart';
import 'group.dart';
import 'location.dart';

class Event extends ManagedObject<_Event> implements _Event {}

class _Event {
  @primaryKey
  int id;

  String name;

  @Column(defaultValue: "''")
  String description;

  @Relate(#events)
  Location location;

  @Relate(#events)
  Group group;

  ManagedSet<Comment> comments;

  ManagedSet<Appointment> appointments;

  int creatorId;

  @Column(defaultValue: "'draft'")
  EventState state;
}

enum EventState { draft, planned, canceled }
