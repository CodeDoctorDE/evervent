import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jakeson/main.dart';
import 'package:jakeson/pages/events.dart';
import 'package:jakeson/pages/info.dart';
import 'package:jakeson/pages/places.dart';
import 'package:jakeson/pages/servers.dart';
import 'package:jakeson/pages/settings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'pages/groups.dart';
import 'service/api_service.dart';

enum Page { dashboard, groups, events, places, info, server, settings }

class JakesonDrawer extends StatelessWidget {
  final Page page;
  JakesonDrawer(this.page);

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
                  Text("Jakeson",
                      style: Theme.of(context).textTheme.headline5),
                  Text("gitlab.com/jakeson",
                      style: Theme.of(context).textTheme.subtitle1),
                  Text("jakeson.gitlab.io",
                      style: Theme.of(context).textTheme.subtitle2),
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
            selected: page == Page.dashboard,
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
            selected: page == Page.events,
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
            selected: page == Page.groups,
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
            selected: page == Page.places,
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
            selected: page == Page.server,
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
            selected: page == Page.info,
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
            selected: page == Page.settings,
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
