import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:evervent/colors.dart' as colors;
import 'package:shared/models/event.dart';
import 'package:shared/models/user.dart';
import 'package:evervent/pages/add_event.dart';
import 'package:evervent/pages/appointment.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventPage extends StatefulWidget {
  EventPage({this.id, Key key}) : super(key: key);

  final int id;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final api = GetIt.I.get<ApiService>();

  bool editModeEnabled = false;
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
        title: Text('Event'),
        actions: <Widget>[
          (api.user.hasLevel(Level.moderator))
              ? IconButton(
                  icon: Icon(MdiIcons.pencil),
                  color: editModeEnabled ? colors.secondary : null,
                  onPressed: () {
                    setState(() {
                      if (editModeEnabled) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("Update event"),
                                content: new Text(
                                    "Did you want to update the event?"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        editModeEnabled = false;
                                      });
                                      final snackBar = SnackBar(
                                          content: Text(
                                              'Successfully updated the event!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                                      _scaffoldKey.currentState
                                          .showSnackBar(snackBar);
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text("No"),
                                    onPressed: () {
                                      setState(() {
                                        editModeEnabled = false;
                                      });
                                      Navigator.of(context).pop();
                                      final snackBar = SnackBar(
                                          content: Text(
                                              'Successfully discard the changes!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                                      _scaffoldKey.currentState
                                          .showSnackBar(snackBar);
                                    },
                                  ),
                                ],
                              );
                            });
                      } else
                        editModeEnabled = !editModeEnabled;
                    });
                  },
                )
              : null,
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: api.eventsBox.listenable(),
          builder: (context, box, currentWidget) {
            print('rebuild hive box');

            Event event = box.get('${api.server.aid64}|${widget.id}');
            final nameController = TextEditingController(text: event.name);
            final creatorController =
            TextEditingController(text: event.creatorId.toString());

            return RefreshIndicator(
                onRefresh: api.listEvents,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
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
                          enabled: api.user.hasLevel(Level.moderator) &&
                              editModeEnabled,
                          onSubmitted: (String text) {
                            event.name = text;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: "Description"),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          enabled: api.user.hasLevel(Level.moderator) &&
                              editModeEnabled,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Creator',
                            labelText: 'Creator name',
                          ),
                          /*
                  onChanged: (_) => serverAddress = _, */
                          controller: creatorController,
                          enabled: api.user.hasLevel(Level.moderator) &&
                              editModeEnabled,
                          onSubmitted: (String text) {
                            event.id = text as int;
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Appointments",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
                        ),
                        ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            ListTile(
                              title: Text("10th October 2019"),
                              subtitle: Text(
                                  "There are 5 people who can on this date too!"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AppointmentPage()),
                                );
                              },
                              trailing: api.user.hasLevel(Level.member) &&
                                  editModeEnabled
                                  ? IconButton(
                                  icon: Icon(MdiIcons.trashCanOutline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title:
                                          new Text("Delete appointment"),
                                          content: new Text(
                                            // TODO: Show the date of the appointment
                                              "Do you really want to delete the appointment?"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new FlatButton(
                                              child: new Text("Yes"),
                                              onPressed: () {
                                                final snackBar = SnackBar(
                                                    content: Text(
                                                        'Successfully deleted the appointment!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                                                _scaffoldKey
                                                    .currentState
                                                    .showSnackBar(
                                                    snackBar);
                                              },
                                            ),
                                            new FlatButton(
                                              child: new Text("No"),
                                              onPressed: () {
                                                setState(() {
                                                  editModeEnabled =
                                                  false;
                                                });
                                                Navigator.of(context)
                                                    .pop();
                                                final snackBar = SnackBar(
                                                    content: Text(
                                                        'Successfully discard the changes!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                                                _scaffoldKey
                                                    .currentState
                                                    .showSnackBar(
                                                    snackBar);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  })
                                  : null,
                            ),
                          ],
                        ),
                        (api.user.hasLevel(Level.moderator)) ?
                        FlatButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEventPage()),
                            );
                          },
                          color: Colors.white,
                          highlightColor: colors.secondary,
                          label: Text("Create appointment"),
                          icon: Icon(MdiIcons.plus),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side:
                              BorderSide(color: colors.primary, width: 2)),
                        ) : null
                      ],
                    )
                  ],
                ));
          }),
      floatingActionButton: (api.user.hasLevel(Level.moderator) &&
          editModeEnabled)
          ? FloatingActionButton(
          child: Icon(MdiIcons.check),
          onPressed: () {
            setState(() {
              editModeEnabled = false;
            });
            final snackBar =
            SnackBar(content: Text('Successfully updated the event!'));
            _scaffoldKey.currentState.showSnackBar(snackBar);
          })
          : null,
    );
  }
}
