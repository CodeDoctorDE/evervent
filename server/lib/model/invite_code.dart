import 'package:evervent_server/evervent_server.dart';

class InviteCode extends ManagedObject<_InviteCode> implements _InviteCode {
  bool isValid() {
    print("Valid?");
    if (invalidAfter != null && invalidAfter.isBefore(DateTime.now())) {
      return false;
    }
    if (remainingCount != null) {
      if (remainingCount <= 0) {
        return false;
      } else {
        return true;
      }
    } else
      return true;
  }
}

class _InviteCode {
  @primaryKey
  int id;

  @Column(unique: true)
  String code;

  String description;

  @Column(defaultValue: "null", nullable: true)
  int remainingCount;

  @Column(defaultValue: "null", nullable: true)
  DateTime invalidAfter;
}
