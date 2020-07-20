import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakeson/colors.dart' as colors;
import 'package:jakeson/drawer.dart';
import 'package:jakeson/main.dart';
import 'package:jakeson/models/server.dart';
import 'package:jakeson/pages/groups.dart';
import 'package:jakeson/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'add_server.dart';

class ServerPage extends StatefulWidget {
  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  bool editModeEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JakesonDrawer(Page.server),
      appBar: AppBar(
        title: Text('Edit Servers (WIP)'),
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.pencil),
            color: editModeEnabled ? colors.secondary : null,
            onPressed: () {
              setState(() {
                editModeEnabled = !editModeEnabled;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: Hive.box('servers').listenable(),
            builder: (context, box, _widget) {
              var servers = box.values.toList().cast<Server>();
              //servers.sort((a, b) => a.id.compareTo(b.id));
              return ListView(
                children: <Widget>[
                  for (var server in servers)
                    ListTile(
                      title: Text(server.address),
                      subtitle: Text(server.username),
                      onTap: () async {
                        Hive.box('pref').put('currentServer', server.id);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: ListTile(
                                leading: CircularProgressIndicator(),
                                title: Text('Loading...'),
                              ),
                            ),
                            barrierDismissible: false);
                        await GetIt.I.get<ApiService>().updateServer(false);
                        await GetIt.I.get<ApiService>().refreshToken();
                        await GetIt.I.get<ApiService>().refreshPermissions();
                        //await GetIt.I.get<ApiService>().openDatabases();
                        Navigator.of(context).pop();

                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomePage()));
                      },
                      trailing: editModeEnabled
                          ? IconButton(
                        icon: Icon(MdiIcons.delete),
                        color: colors.secondary,
                        onPressed: () {
                          Hive.box('servers').delete(server.id);
                        },
                      )
                          : null,
                    ),
                ],
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              child: Icon(MdiIcons.plus),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AddServerPage()));
              },
            ),
            alignment: Alignment.bottomRight,
          ),
        ],
      ),
    );
  }
}
