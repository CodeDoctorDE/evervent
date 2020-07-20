import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jakeson/models/group.dart';
import 'package:jakeson/models/server.dart';
import 'package:jakeson/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddGroupPage extends StatefulWidget {
  AddGroupPage({Key key, this.server, this.group}) : super(key: key);

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
  AddGroupPageState createState() => AddGroupPageState();
}

class AddGroupPageState extends State<AddGroupPage> {
  final api = GetIt.I.get<ApiService>();

  bool editModeEnabled = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
        title: Text("Add group"),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Name"),
              controller: nameController,
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
                        labelText: "Server"),
                  )
                : null,
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: "Description", hintText: "Test"),
              maxLines: null,
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Create event",
        child: Icon(MdiIcons.check),
        onPressed: () {
          print(nameController.text);
          api.createGroup(
              serverDropdownValue,
              Group(
                  name: nameController.text,
                  description: descriptionController.text));
        },
      ),
    );
  }
}
