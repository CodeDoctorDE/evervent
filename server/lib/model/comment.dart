import 'package:jakeson_server/model/user.dart';
import 'package:jakeson_server/jakeson_server.dart';

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
