import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:evervent/drawer.dart';
import 'package:shared/models/event.dart';
import 'package:shared/models/user.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DatePage extends StatefulWidget {
  DatePage({this.id, Key key}) : super(key: key);

  final int id;

  @override
  _DatePageState createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
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
      appBar: AppBar(title: Text('Event')),
      body: ValueListenableBuilder(
          valueListenable: api.eventsBox.listenable(),
          builder: (context, box, _widget) {
            print('rebuild hive box');

            Event event = box.get('${api.server.aid64}|${widget.id}');
            final nameController = TextEditingController(text: event.name);
            final creatorController =
                TextEditingController(text: event.creatorId.toString());

            return RefreshIndicator(
                onRefresh: api.listEvents,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Event name',
                            labelText: 'Name',
                          ),
                          /*
                  onChanged: (_) => serverAddress = _, */
                          controller: nameController,
                          enabled: api.user.hasLevel(Level.moderator),
                          onSubmitted: (String text) {
                            event.name = text;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Creator',
                            labelText: 'Creator name',
                          ),
                          /*
                  onChanged: (_) => serverAddress = _, */
                          controller: creatorController,
                          enabled: api.user.hasLevel(Level.moderator),
                          onSubmitted: (String text) {
                            event.id = text as int;
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            ListTile(
                              title: Text("10th October 2019"),
                              subtitle: Text(
                                  "There are 5 people who can on this date too!"),
                              trailing: api.user.hasLevel(Level.member)
                                  ? IconButton(
                                      icon: Icon(MdiIcons.plusOne),
                                      onPressed: () {},
                                    )
                                  : null,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )));
          }),
      drawer: EverventDrawer(DrawerPage.events),
    );
  }
}
