import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:evervent_server/model/invite_code.dart';
import 'package:evervent_server/model/user.dart';

class AuthRegisterController extends ResourceController {
  AuthRegisterController(this.context, this.authServer);

  ManagedContext context;
  AuthServer authServer;

  @Operation.post()
  Future<Response> register(@Bind.body() Map m) async {
    print("1?");
    String inviteCode = m['inviteCode'] as String;
    if (inviteCode == null) {
      return Response.unauthorized();
    }
    print("2?");

    String email = m['email'] as String;
    String username = m['username'] as String;
    String name = m['name'] as String;
    String password = m['password'] as String;

    final salt = AuthUtility.generateRandomSalt();
    final hashedPassword = authServer.hashPassword(password, salt);
    print("Register?");

    User newUser;
    final bool confirmed = await context.transaction((transaction) async {
      final invite = await (Query<InviteCode>(transaction)
            ..where((_) => _.code).equalTo(inviteCode))
          .fetchOne();

      if (invite == null) {
        return false;
      }
      print(invite.asMap());
      if (invite.isValid()) {
        print("TRUE!");
        final query = Query<User>(transaction)
          ..values.email = email
          ..values.username = username
          ..values.name = name
          ..values.hashedPassword = hashedPassword
          ..values.salt = salt;

        newUser = await query.insert();

        if (invite.remainingCount != null) {
          final countDownQuery = Query<InviteCode>(transaction)
            ..where((_) => _.code).equalTo(invite.code)
            ..values.remainingCount = invite.remainingCount - 1;
          await countDownQuery.update();
        }
        return true;
      } else {
        return false;
      }
    });
    if (!confirmed)
      return Response.unauthorized(body: {"error": "invalid_code"});

    return Response.ok(newUser);
  }
}
