import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:evervent/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  InfoPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: EverventDrawer(Page.info),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Information"),
        leading: IconButton(
          icon: Icon(MdiIcons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Groups",
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline6,
                    ),
                    Text(
                        "Groups are a useful feature in this smart calendar. You can easily find a date where everybody can come and add this date to everybody's calendar!"),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Places",
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline6,
                    ),
                    Text(
                        "Places helps you to find a group and has the security that the room is free. You can create a place, can add member which can have different permission and see in the plan, if the room is free!"),
                  ],
                ),
              ),
            ),
            InkWell(
              child:
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Open Source Project",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
                        ),
                        Text(
                            "GitLab: https://github.com/evervent \r\n"
                                "Version: Alpha 0.0.1 \r\n"
                                "Contributors: CodeDoctorDE, redsolver \r\n"

                        ),
                      ]),
                ),
              ),
              onTap: () {
                launch("https://github.com/evervent");
              },
            ),
          ],
        ),
      ),
    );
  }
}
