import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:evervent_server/model/group.dart';
import 'package:evervent_server/model/user.dart';

class UsersController extends ResourceController {
  UsersController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> listUsers() async {
    var query = Query<User>(context);

    return Response.ok(await query.fetch());
  }

  @Operation.get('id')
  Future<Response> getUser(@Bind.path('id') int id) async {
    var query = Query<User>(context)..where((_) => _.id).equalTo(id);

    return Response.ok(await query.fetch());
  }
}
