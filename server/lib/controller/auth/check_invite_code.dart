import 'package:aqueduct/aqueduct.dart' hide Level;
import 'package:aqueduct/aqueduct.dart';
import 'package:evervent_server/model/invite_code.dart';

class CheckInviteCodeController extends ResourceController {
  CheckInviteCodeController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> checkInviteCode(@Bind.query('code') String code) async {
    final inviteCodeQuery = Query<InviteCode>(context)
      ..where((_) => _.code).equalTo(code);
    final inviteCode = await inviteCodeQuery.fetchOne();

    print(inviteCode);

    return Response.ok(
        {'valid': inviteCode != null && inviteCode.isValid()});
  }
}
