import 'package:evervent_server/model/user.dart';
import 'package:evervent_server/evervent_server.dart';

import 'event.dart';

class Comment extends ManagedObject<_Comment> implements _Comment {}

class _Comment {
  @primaryKey
  int id;

  String content;

  DateTime timestamp;

  @Relate(#comments)
  Event event;

  @Relate(#comments)
  User user;
}
