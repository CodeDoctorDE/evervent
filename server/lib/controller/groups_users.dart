import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:evervent_server/model/group.dart';
import 'package:evervent_server/model/group_user.dart';
import 'package:evervent_server/model/user.dart';

class GroupsUsersController extends ResourceController {
  GroupsUsersController(this.context);

  ManagedContext context;
  @Operation.post('id')
  Future<Response> addUserToGroup(
      @Bind.path('id') int groupId, @Bind.body() User user) async {
    var forUserID = request.authorization.ownerID;
    User runUser = await (Query<User>(context)
          ..where((u) => u.id).equalTo(forUserID)
          ..returningProperties((u) => [u.id, u.level]))
        .fetchOne();

    if (!runUser.hasLevel(Level.moderator)) return Response.unauthorized();

    final group = Group()..id = groupId;

    final query = Query<GroupUser>(context)
      ..values.user = user
      ..values.group = group;

    var checkQuery = Query<GroupUser>(context)
      ..where((gu) => gu.user.id).equalTo(user.id)
      ..where((gu) => gu.group.id).equalTo(groupId);
    /* if (!request.authorization.isAuthorizedForScope("group:create")) {
      return Response.unauthorized();
    } */
    // await context.insertObject(group);

/*     var query = Query<Group>(
            context) */ /* 
      ..where((p) => p.user).identifiedBy(forUserID)
      ..sortBy((u) => u.date, QuerySortOrder.descending) */

    var gu = await checkQuery.fetchOne();
    /*  print(gu.asMap()); */
    if (gu == null) {
      return Response.ok(await query.insert());
    } else {
      return Response.conflict();
    }
  }

  @Operation.get('id')
  Future<Response> listUsers(@Bind.path('id') int groupId) async {
    /*    if (!request.authorization.isAuthorizedForScope("user:feed")) {
      return Response.unauthorized();
    } */

    final query = Query<Group>(context)
      ..where((t) => t.id).equalTo(groupId)
      ..join(set: (t) => t.groupUsers).join(object: (tp) => tp.user);

    Group group = await query.fetchOne();
    group.users = group.groupUsers.map((t) => t.user.asMap()).toList();

    group.backing.removeProperty("groupUsers");
/*     final user = await query.fetchOne(); */

    return Response.ok(group.users);
  }

  @Operation.delete('id', 'userId')
  Future<Response> removeUserFromGroup(
      @Bind.path('id') int groupId, @Bind.path('userId') int userId) async {
    var forUserID = request.authorization.ownerID;
    User user = await (Query<User>(context)
          ..where((u) => u.id).equalTo(forUserID)
          ..returningProperties((u) => [u.id, u.level]))
        .fetchOne();

    if (!user.hasLevel(Level.moderator)) return Response.unauthorized();
    /*    if (!request.authorization.isAuthorizedForScope("user:feed")) {
      return Response.unauthorized();
    } */

    var query = Query<GroupUser>(context)
      ..where((gu) => gu.user.id).equalTo(userId)
      ..where((gu) => gu.group.id).equalTo(groupId);

    int usersDeleted = await query.delete();
/*     final user = await query.fetchOne(); */

    return Response.ok(usersDeleted);
  }
}
