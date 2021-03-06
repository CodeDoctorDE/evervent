import 'package:evervent_server/model/user.dart';
import 'package:evervent_server/evervent_server.dart';

import 'event.dart';

class Location extends ManagedObject<_Location> implements _Location {}

class _Location {
  @primaryKey
  int id;

  @Column(defaultValue: "'place'")
  LocationType type;

  String address;

  ManagedSet<Event> events;
}

enum LocationType { place, digital }
