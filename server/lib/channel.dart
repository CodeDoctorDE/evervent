import 'package:jakeson_server/model/user.dart';
import 'package:yaml/yaml.dart';

import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';

import 'controller/auth/check_invite_code.dart';
import 'controller/auth/register.dart';
import 'controller/events.dart';
import 'controller/events_appointments.dart';
import 'controller/events_comments.dart';
import 'controller/groups.dart';
import 'controller/groups_users.dart';
import 'controller/user_perms.dart';
import 'controller/users.dart';
import 'jakeson_server.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class JakesonServerChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    final database = loadYaml(File('database.yaml').readAsStringSync());
    final psc = PostgreSQLPersistentStore(
        database['username'] as String,
        database['password'] as String,
        database['host'] as String,
        database['port'] as int,
        database['databaseName'] as String);

    context = ManagedContext(dataModel, psc);

    final delegate = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(delegate);
    return;
/* 
    if (!File('.solver-server-lock').existsSync()) {
      File('.solver-server-lock').createSync();
      print('Starting services...');
      ImapService(context).start();
    } */
    /*  final mQuery = Query<InviteCode>(context)
      ..values.code = 'thisisaninvitecode'
      ..values.description = 'An invite code'
      ..values.remainingCount = 100
      ..values.invalidAfter = DateTime(2020, 10, 9);
    await mQuery.insert(); */
    /*    final salt = AuthUtility.generateRandomSalt();
    final hashedPassword = authServer.hashPassword("PASSWORD_HERE", salt);

    final query = Query<User>(context)
      ..values.email = "info@redsolver.net"
      ..values.username = 'redsolver'
      ..values.name = 'Red Solver'
      ..values.level = prefix0.Level.admin
      ..values.hashedPassword = hashedPassword
      ..values.salt = salt;

    final user = await query.insert(); */
    /*   return; */

    /* */

    // Generate User
    /*  final salt = AuthUtility.generateRandomSalt();
    final hashedPassword = authServer.hashPassword(
        "PW_HERE", salt);

    final query = Query<User>(context)
      ..values.email = "info@redsolver.net"
      ..values.username = 'redsolver'
      ..values.name = 'Redsolver'
      ..values.hashedPassword = hashedPassword
      ..values.salt = salt;

    final user = await query.insert(); */
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router(basePath: '/api/v0');

    router
        .route("/info")
        .linkFunction((res) => Response.ok({'version': 'Alpha 0.0.1'}));

    // Set up auth token route- this grants and refresh tokens
    router.route("/auth/token").link(() => AuthController(authServer));

    // Set up auth code route- this grants temporary access codes that can be exchanged for token
    router.route("/auth/code").link(() => AuthRedirectController(authServer));

    router
        .route("/auth/register")
        .link(() => Authorizer.basic(authServer))
        .link(() => AuthRegisterController(context, authServer));

    router
        .route("/auth/checkInviteCode")
        .link(() => Authorizer.basic(authServer))
        .link(() => CheckInviteCodeController(context));

    router
        .route("/user/perms")
        .link(() => Authorizer.bearer(authServer))
        .link(() => UserPermsController(context));

    router
        .route('/users/[:id]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => UsersController(context));

    router
        .route('/groups/[:id]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => GroupsController(context));

    router
        .route('/groups/:id/users/[:userId]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => GroupsUsersController(context));

    router
        .route('/events/[:id]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => EventsController(context));

    router
        .route('/events/:id/comments/[:commentId]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => EventsCommentsController(context));

    router
        .route('/events/:id/appointments/[:appointmentId]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => EventsAppointmentsController(context));

    return router;
  }
}
