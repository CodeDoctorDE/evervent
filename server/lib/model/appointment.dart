import 'package:jakeson_server/model/user.dart';
import 'package:jakeson_server/jakeson_server.dart';

import 'event.dart';

class Appointment extends ManagedObject<_Appointment> implements _Appointment {}

class _Appointment {
  @primaryKey
  int id;
  
  DateTime start;

  DateTime finish;

  @Relate(#appointments)
  Event event;


  @Column(defaultValue: "'draft'")
  AppointmentState state;
}

enum AppointmentState { draft, planned, canceled }