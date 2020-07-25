import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/models/event.dart';
import 'package:shared/models/group.dart';
import 'package:shared/models/server.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddEventPage extends StatefulWidget {


  AddEventPage({Key key, this.server, this.group}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final Server server;
  final Group group;

  @override
  AddEventPageState createState() => AddEventPageState();
}

class AddEventPageState extends State<AddEventPage> {

  final api = GetIt.I.get<ApiService>();

  bool editModeEnabled = false;

  TextEditingController nameController = TextEditingController();

  Server serverDropdownValue;
  Group groupDropdownValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add event"),
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Name"),
              ),
              (widget.server == null)
                  ? DropdownButtonFormField<Server>(
                value: serverDropdownValue,
                onChanged: (Server newValue) {
                  setState(() {
                    serverDropdownValue = newValue;
                  });
                },
                items: api.servers
                    .map<DropdownMenuItem<Server>>((Server server) {
                  return new DropdownMenuItem(
                    value: server,
                    child: Text(server.address),
                  );
                }).toList(),
                decoration: InputDecoration(
                    hintText: "Please select a server...",
                    labelText: "Server"
                ),
              )
              
                  : null,
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration:
                InputDecoration(labelText: "Description", hintText: "Test"),
                maxLines: null,
                controller: nameController,
                keyboardType: TextInputType.multiline,
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Create event",
        child: Icon(MdiIcons.check),
        onPressed: () {
          api.createEvent(serverDropdownValue, Event(
              creatorId: api.user.id,
              group: widget.group.id
          ));
        },
      ),
    );
  }
}
