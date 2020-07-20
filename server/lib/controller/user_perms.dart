import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:jakeson_server/model/group.dart';
import 'package:jakeson_server/model/user.dart';

class UserPermsController extends ResourceController {
  UserPermsController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getPerms() async {
    var forUserID = request.authorization.ownerID;
    User user = await (Query<User>(context)
          ..where((u) => u.id).equalTo(
              forUserID) /* 
          ..returningProperties((u) => [u.id, u.level]) */
        )
        .fetchOne();

    return Response.ok(user);
  }
}
