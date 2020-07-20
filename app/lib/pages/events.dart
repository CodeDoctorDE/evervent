import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakeson/drawer.dart';
import 'package:jakeson/models/event.dart';
import 'package:jakeson/models/user.dart';
import 'package:jakeson/pages/add_event.dart';
import 'package:jakeson/pages/event.dart';
import 'package:jakeson/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
        title: Text('Events'),
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
                child: ListView(
                  children: <Widget>[
                    for (var event in events)
                      ListTile(
                        title: Text(event.name),
                        subtitle: Text(event.toJson().toString()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                EventPage(id: event.id)),
                          );
                        },
                      )
                  ],
                ));
          }),
      floatingActionButton: api.user.hasLevel(Level.moderator)
          ? FloatingActionButton(
        child: Icon(MdiIcons.plus), onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              AddEventPage()),
        );
      },
      )
          : null,
      drawer: JakesonDrawer(Page.events),
    );
  }
}
