import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:jakeson_server/model/group.dart';
import 'package:jakeson_server/model/user.dart';

class GroupsController extends ResourceController {
  GroupsController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> listGroups() async {
    /*    if (!request.authorization.isAuthorizedForScope("user:feed")) {
      return Response.unauthorized();
    } */

    var query = Query<Group>(
            context) /* 
      ..where((p) => p.user).identifiedBy(forUserID)
      ..sortBy((u) => u.date, QuerySortOrder.descending) */
        ;

    return Response.ok(await query.fetch());
  }

  @Operation.get('id')
  Future<Response> getGroup() async {
/*     User user=await query.
 */ /*    if (!request.authorization.isAuthorizedForScope("user:feed")) {
      return Response.unauthorized();
    } */

    var query = Query<Group>(
            context) /* 
      ..where((p) => p.user).identifiedBy(forUserID)
      ..sortBy((u) => u.date, QuerySortOrder.descending) */
        ;

    return Response.ok(await query.fetch());
  }

  @Operation.post()
  Future<Response> createGroup(@Bind.body() Group group) async {
    final forUserID = request.authorization.ownerID;
    final User user = await (Query<User>(context)
          ..where((u) => u.id).equalTo(forUserID)
          ..returningProperties((u) => [u.id, u.level]))
        .fetchOne();

    if (!user.hasLevel(Level.admin)) {
      return Response.unauthorized();
    }

    await context.insertObject(group);

    return Response.ok(group);
  }

  @Operation.delete('id')
  Future<Response> deleteGroup(@Bind.path('id') int groupId) async {
    var forUserID = request.authorization.ownerID;
    User user = await (Query<User>(context)
          ..where((u) => u.id).equalTo(forUserID)
          ..returningProperties((u) => [u.id, u.level]))
        .fetchOne();

    if (!user.hasLevel(Level.admin)) {
      return Response.unauthorized();
    }

    final query = Query<Group>(context)..where((g) => g.id).equalTo(groupId);

    final int groupsDeleted = await query.delete();

    return Response.ok(groupsDeleted);
  }
}
