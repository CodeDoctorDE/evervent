import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:evervent_server/model/comment.dart';
import 'package:evervent_server/model/event.dart';
import 'package:evervent_server/model/group.dart';
import 'package:evervent_server/model/group_user.dart';
import 'package:evervent_server/model/user.dart';

class EventsCommentsController extends ResourceController {
  EventsCommentsController(this.context);

  ManagedContext context;

  @Operation.post('id')
  Future<Response> addCommentToEvent(
      @Bind.path('id') int eventId, @Bind.body() Comment comment) async {
    var forUserID = request.authorization.ownerID;
    final event = Event()..id = eventId;

    final query = Query<Comment>(context)
      ..values.timestamp = DateTime.now()
      ..values.user = (User()..id = forUserID)
      ..values.event = event;
    /* if (!request.authorization.isAuthorizedForScope("group:create")) {
      return Response.unauthorized();
    } */
    // await context.insertObject(group);

/*     var query = Query<Group>(
            context) */ /* 
      ..where((p) => p.user).identifiedBy(forUserID)
      ..sortBy((u) => u.date, QuerySortOrder.descending) */
    ;

    return Response.ok(await query.insert());
  }

  @Operation.get('id')
  Future<Response> listComments(@Bind.path('id') int commentId) async {
    // TODO
    /* var forUserID = request.authorization.ownerID;

    final query = Query<Group>(context)
      ..where((t) => t.id).equalTo(groupId)
      ..join(set: (t) => t.groupUsers).join(object: (tp) => tp.user);

    Group group = await query.fetchOne();
    group.users = group.groupUsers.map((t) => t.user.asMap()).toList();

    group.backing.removeProperty("groupUsers");

    return Response.ok(group.users); */
  }

  @Operation.delete('id', 'commentId')
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
  }
}
