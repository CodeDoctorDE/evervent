import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:evervent/colors.dart' as colors;
import 'package:evervent/models/user.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({this.id, Key key}) : super(key: key);

  final int id;

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final api = GetIt.I.get<ApiService>();

  bool editModeEnabled = false;

  @override
  void initState() {
    super.initState();
    // api.listAppointments();
  }

  List<User> participants = [
    User(name: "Test", username: "Test Username", level: Level.moderator)
  ];

/*   List<Group> groups = Hive.box('groups'); */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Appointment for TestEvent'),
        actions: <Widget>[
          (api.user.hasLevel(Level.moderator))
              ? IconButton(
                  icon: Icon(MdiIcons.pencil),
                  color: editModeEnabled ? colors.secondary : null,
                  onPressed: () {
                    if (editModeEnabled)
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Update appointemt"),
                              content: new Text(
                                  "Did you want to update the appointemt?"),
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
                                            'Successfully updated the appointemt!'));

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
                    else
                      setState(() {
                        editModeEnabled = !editModeEnabled;
                      });
                  },
                )
              : null,
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: api.eventsBox.listenable(),
          builder: (context, box, widget) {
            print('rebuild hive box');

            // Appointment Appointment = box.get('${api.server.aid64}|${widget.id}');
            final dateController =
            TextEditingController(text: "20th April 2019");

            return RefreshIndicator(
                onRefresh: api.listEvents,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DateTimeField(
                      decoration: InputDecoration(
                          hintText: "Date", labelText: "yyyy/MM/dd"),
                      format: DateFormat("yyyy/MM/dd"),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                    DateTimeField(
                      decoration:
                      InputDecoration(hintText: "Time", labelText: "HH:mm"),
                      format: DateFormat("HH:mm"),
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                    Text("Participants"),
                    Expanded(
                        child: ListView(
                          children: <Widget>[
                            for (var user in participants)
                              ListTile(
                                title: Text(user.username),
                                subtitle: Text(user.level.toString()),
                                trailing: editModeEnabled
                                    ? IconButton(
                                  icon: Icon(MdiIcons.gavel),
                                  color: colors.secondary,
                                  onPressed: () {},
                                )
                                    : null,
                              )
                          ],
                        ))
                  ],
                ));
          }),
      floatingActionButton:
      (api.user.hasLevel(Level.moderator) && editModeEnabled)
          ? FloatingActionButton(
          child: Icon(MdiIcons.check),
          onPressed: () {
            setState(() {
              editModeEnabled = false;
            });
            final snackBar = SnackBar(
                content: Text('Successfully updated the appointment!'));
            _scaffoldKey.currentState.showSnackBar(snackBar);
          })
          : null,
    );
  }
}
