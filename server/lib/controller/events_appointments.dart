import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:jakeson_server/model/appointment.dart';
import 'package:jakeson_server/model/event.dart';
class EventsAppointmentsController extends ResourceController {
  EventsAppointmentsController(this.context);

  ManagedContext context;

  @Operation.post('id')
  Future<Response> addAppointmentToEvent(@Bind.path('id') int eventId,
      @Bind.body() Appointment appointment) async {
    var forUserID = request.authorization.ownerID;
    final event = Event()..id = eventId;

    final query = Query<Appointment>(context)
      ..values = appointment
      ..values.event = event;

    return Response.ok(await query.insert());
  }

  @Operation.get('id')
  Future<Response> listAppointments(
    @Bind.path('id') int eventId,
  ) async {
    final query = Query<Appointment>(context)
      ..where((_) => _.event.id).equalTo(eventId);

    return Response.ok(await query.fetch());
  }

  /* @Operation.delete('id', 'commentId')
  Future<Response> deleteComment(@Bind.path('id') int eventId,
      @Bind.path('commentId') int commentId) async {
    var forUserID = request.authorization.ownerID;
    User user = await (Query<User>(context)
          ..where((u) => u.id).equalTo(forUserID)
          ..returningProperties((u) => [u.id, u.level]))
        .fetchOne();

    var query = Query<Comment>(context)..where((_) => _.id).equalTo(commentId);

    if (!user.hasLevel(Level.moderator)) {
      Comment comment = await query.fetchOne();
      if (comment.user.id != forUserID) {
        return Response.unauthorized();
      }
    }

    int commentsDeleted = await query.delete();

    return Response.ok(commentsDeleted);
  } */
}
