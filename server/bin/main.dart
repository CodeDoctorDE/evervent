//import 'package:jakeson_server/service/imap_get.dart';
import 'package:jakeson_server/jakeson_server.dart';

Future main() async {
  final app = Application<JakesonServerChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8888;

  // Services

/*   for (var service in [ImapService()]) {
    print("Starting Service $service");
    service.start();
  } */

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
