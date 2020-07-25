import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:evervent/drawer.dart';
import 'package:shared/models/group.dart';
import 'package:shared/models/user.dart';
import 'package:evervent/pages/add_group.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final api = GetIt.I.get<ApiService>();

  @override
  void initState() {
    super.initState();
    _listGroups();
  }

  Future _listGroups() async {
    await api.listGroups();
    //setState(() {});
  }

/*   List<Group> groups = Hive.box('groups'); */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Groups'),
        leading: IconButton(
          icon: Icon(MdiIcons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: api.groupsBox.listenable(),
          builder: (context, box, widget) {
            print('rebuild hive box');

            var groups = box.values.toList().cast<Group>();
            return RefreshIndicator(
                onRefresh: _listGroups,
                child: ListView(
                  children: <Widget>[
                    for (var group in groups)
                      ListTile(
                        title: Text(group.name),
                        subtitle: Text(group.id.toString()),
                      )
                  ],
                ));
          }),
      floatingActionButton: api.user.hasLevel(Level.admin)
          ? FloatingActionButton(
        child: Icon(MdiIcons.plus), onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              AddGroupPage()),
        );
        },
            )
          : null,
      drawer: EverventDrawer(DrawerPage.groups),
    );
  }
}
