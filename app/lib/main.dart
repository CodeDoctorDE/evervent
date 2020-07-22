import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:evervent/colors.dart' as colors;
import 'package:evervent/drawer.dart';
import 'package:evervent/pages/servers.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/event.dart';
import 'models/group.dart';
import 'models/server.dart';
import 'pages/add_server.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  WidgetsFlutterBinding.ensureInitialized();

  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(
    ServerAdapter(),
  );
  Hive.registerAdapter(
    GroupAdapter(),
  );
  Hive.registerAdapter(
    EventAdapter(),
  );

  await Hive.openBox('pref');
  var box = await Hive.openBox('servers');
/* 
  if (Hive.box('pref').get('currentServer') != null) {
    var server = box.get(Hive.box('pref').get('currentServer')) as Server; */

  await Hive.openBox('groups');
  await Hive.openBox('users');
  await Hive.openBox('events');
  /*  } */

  //for (var server in box.values.toList().cast<Server>()) {}

  print(Hive.box('servers').values);
  print(Hive.box('pref').values);

  GetIt.I.registerSingleton<ApiService>(ApiService());

  runApp(Evervent());
}

class Evervent extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Evervent',
        theme: ThemeData(
          primaryColor: colors.primary,
          accentColor: colors.secondary,
        ),
        home: _buildHome());
  }

  Widget _buildHome() {
    if (Hive.box('servers').isEmpty) {
      // Nutzer öffnet die App zum ersten Mal, hat noch keine Server hinzugefügt
      // TODO Intro hier einfügen
      return AddServerPage();
    } else {
      if (Hive.box('pref').get('currentServer') == null) {
        // Nutzer hat bereits einen oder mehrere Server hinzugefügt, aber keinen ausgewählt
        return ServerPage();
      } else {
        // Nutzer hat einen Server ausgewählt
        return HomePage();
      }
    }
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: EverventDrawer(Page.dashboard),
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Evervent"),
        leading: IconButton(
          icon: Icon(MdiIcons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(MdiIcons.plus),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
