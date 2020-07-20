import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';

import 'comment.dart';
import 'group_user.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;

  bool hasLevel(Level reqLevel) {
    if (reqLevel == level) return true;
    final allLevels = [
      Level.guest,
      Level.member,
      Level.moderator,
      Level.admin,
      Level.owner
    ];
    for (var l in allLevels) {
      if (l == level) break;
      if (l == reqLevel) return true;
    }
    return false;
  }
}

class _User extends ResourceOwnerTableDefinition {
  @Column(unique: true)
  String email;

  String name;
  @Column(defaultValue: "''")
  String biography;

  @Column(defaultValue: "'guest'")
  Level level;

  ManagedSet<GroupUser> groupUsers;

  ManagedSet<Comment> comments;
}

enum Level { owner, admin, moderator, member, guest }
