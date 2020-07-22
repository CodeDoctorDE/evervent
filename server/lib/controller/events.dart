import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:evervent_server/model/event.dart';
import 'package:evervent_server/model/group.dart';
import 'package:evervent_server/model/user.dart';

class EventsController extends ResourceController {
  EventsController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> listEvents() async {
    var query = Query<Event>(context);

    return Response.ok(await query.fetch());
  }

  @Operation.get('id')
  Future<Response> getEvent(@Bind.path('id') int id) async {
    var query = Query<Event>(context)..where((e) => e.id).equalTo(id);

    return Response.ok(await query.fetch());
  }

  @Operation.post()
  Future<Response> createEvent(@Bind.body() Event event) async {
    var forUserID = request.authorization.ownerID;
    User user = await (Query<User>(context)
          ..where((u) => u.id).equalTo(forUserID)
          ..returningProperties((u) => [u.id, u.level]))
        .fetchOne();

    if (!user.hasLevel(Level.member)) return Response.unauthorized();

    event.creatorId = forUserID;

    var newEvent=await context.insertObject(event);

    return Response.ok(newEvent);
  }

  @Operation.delete('id')
  Future<Response> deleteEvent(@Bind.path('id') int id) async {
    var forUserID = request.authorization.ownerID;
    User user = await (Query<User>(context)
          ..where((u) => u.id).equalTo(forUserID)
          ..returningProperties((u) => [u.id, u.level]))
        .fetchOne();

    var query = Query<Event>(context)..where((e) => e.id).equalTo(id);

    if (!user.hasLevel(Level.moderator)) {
      Event event = await query.fetchOne();
      if (event.creatorId != forUserID) {
        return Response.unauthorized();
      }
    }

    int eventsDeleted = await query.delete();

    return Response.ok(eventsDeleted);
  }
}
