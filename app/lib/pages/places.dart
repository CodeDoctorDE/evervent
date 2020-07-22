import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:evervent/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlacesPage extends StatefulWidget {
  PlacesPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  PlacesPageState createState() => PlacesPageState();
}

class PlacesPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: EverventDrawer(Page.places),
      appBar: AppBar(title: Text("Places"),
        leading: IconButton(
          icon: Icon(MdiIcons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Coming soon...")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Create place",
        child: Icon(MdiIcons.plus),
        onPressed: () {},
      ),
    );
  }
}
