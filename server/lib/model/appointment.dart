import 'package:evervent_server/model/user.dart';
import 'package:evervent_server/evervent_server.dart';

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