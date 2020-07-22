import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:evervent/main.dart';
import 'package:evervent/pages/events.dart';
import 'package:evervent/pages/info.dart';
import 'package:evervent/pages/places.dart';
import 'package:evervent/pages/servers.dart';
import 'package:evervent/pages/settings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'pages/groups.dart';
import 'service/api_service.dart';

enum DrawerPage { dashboard, groups, events, places, info, server, settings }

class EverventDrawer extends StatelessWidget {
  final DrawerPage page;
  EverventDrawer(this.page);

  final api = GetIt.I.get<ApiService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 250,
            child: (DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    "assets/icon.png",
                    height: 70,
                  ),
                  Text("Evervent",
                      style: Theme.of(context).textTheme.headline5),
                  Text("github.com/codedoctorde/evervent",
                      style: Theme.of(context).textTheme.subtitle1),
                  /*    ListTile(
                    trailing: Icon(MdiIcons.swapHorizontal),
                    title: Text(api.server.address),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServerPage()),
                      );
                    },
                  ), */
                ],
              ),
            )),
          ),
          ListTile(
            title: Text('Dashboard'),
            leading: Icon(MdiIcons.viewDashboard),
            selected: page == DrawerPage.dashboard,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            title: Text('Events'),
            leading: Icon(MdiIcons.timeline),
            selected: page == DrawerPage.events,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            },
          ),
          ListTile(
            title: Text('Groups'),
            leading: Icon(MdiIcons.accountGroup),
            selected: page == DrawerPage.groups,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GroupPage()),
              );
            },
          ),
          ListTile(
            title: Text('Places'),
            leading: Icon(MdiIcons.grid),
            selected: page == DrawerPage.places,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PlacesPage()),
              );
            },
          ),
          Divider(),
/*           ListTile(
            title: Text('Servers'),
            leading: Icon(MdiIcons.server),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ServersPage()),
              );
            },
          ), */
          ListTile(
            title: Text('Server'),
            leading: Icon(MdiIcons.server),
            selected: page == DrawerPage.server,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ServerPage()),
              );
            },
          ),
          ListTile(
            title: Text('Info'),
            leading: Icon(MdiIcons.informationOutline),
            selected: page == DrawerPage.info,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InfoPage()),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            selected: page == DrawerPage.settings,
            leading: Icon(MdiIcons.settingsOutline),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
