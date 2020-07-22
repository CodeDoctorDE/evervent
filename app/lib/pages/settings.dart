import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:evervent/drawer.dart';
import 'package:evervent/models/event.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final api = GetIt.I.get<ApiService>();

  @override
  void initState() {
    super.initState();
    api.listEvents();
  }

/*   List<Group> groups = Hive.box('groups'); */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(MdiIcons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: api.eventsBox.listenable(),
          builder: (context, box, _widget) {
            print('rebuild hive box');

            var events = box.values.toList().cast<Event>();
            return RefreshIndicator(
                onRefresh: api.listEvents,
                child: Container(
                    child: Column(children: <Widget>[Text("Coming soon...")])
                )
            );
          }),
      drawer: EverventDrawer(Page.settings),
    );
  }
}
