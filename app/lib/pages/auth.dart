import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:evervent/main.dart';
import 'package:shared/models/server.dart';
import 'package:evervent/pages/servers.dart';
import 'package:evervent/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  String address;
  AuthPage({Key key, this.address}) : super(key: key);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final inviteCodeCtrl = TextEditingController();

  final regEmailCtrl = TextEditingController();
  final regUsernameCtrl = TextEditingController();
  final regPasswordCtrl = TextEditingController();

  TabController _tabCtrl;

  String error;

  bool registerPage = false;

  bool loading = false;

  bool inviteCodeValid = false;
  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(
      vsync: this,
      initialIndex: 0,
      length: 2,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
        bottom: TabBar(controller: _tabCtrl, tabs: [
          Tab(icon: Icon(Icons.directions_car)),
          Tab(icon: Icon(Icons.directions_transit)),
          Tab(icon: Icon(Icons.directions_bike)),
        ]),
      ),
      body: TabBarView(
        children: [
          Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              TextField(
                enabled: !inviteCodeValid,
                decoration: InputDecoration(
                  hintText: '',
                  labelText: 'Invite Code',
                ),
                controller:
                    inviteCodeCtrl, /*
                    onChanged: (_) => username = _, */
              ),
              SizedBox(
                height: 16,
              ),
              if (inviteCodeValid) ...[
                TextField(
                  decoration: InputDecoration(
                    hintText: '',
                    labelText: 'E-Mail',
                  ),
                  controller: regEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: '',
                    labelText: 'Username',
                  ),
                  controller: regUsernameCtrl,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: '',
                    labelText: 'Password',
                  ),
                  controller: regPasswordCtrl,
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton.icon(
                  icon: Icon(MdiIcons.accountPlus),
                  label: Text('Register'),
                  onPressed: () async {
                    try {
                      setState(() {
                        error = null;
                        loading = true;
                      });
                      if (!EmailValidator.validate(regEmailCtrl.text)) {
                        setState(() {
                          error = 'Invalid E-Mail';
                          loading = false;
                        });
                        return;
                      }
                      var body = json.encode({
                        "inviteCode": inviteCodeCtrl.text,
                        "password": regPasswordCtrl.text,
                        "email": regEmailCtrl.text,
                        "username": regUsernameCtrl.text,
                        "name": regUsernameCtrl.text,
                      });

                      var res = await http.post(
                          widget.address + '/api/v0/auth/register',
                          body: body,
                          headers: {
                            'Authorization':
                                'Basic ${base64.encode('app_dev:secret'.codeUnits)}',
                            'Content-Type': 'application/json'
                          });

                      if (res.statusCode != 200) {
                        setState(() {
                          loading = false;
                          error = 'Status Code ${res.statusCode} - ${res.body}';
                        });
                        return;
                      }

                      setState(() {
                        loading = false;
                        error = null;
                        usernameCtrl.text = regUsernameCtrl.text;
                        passwordCtrl.text = regPasswordCtrl.text;
                        registerPage = false;
                      });
                      return;

                      var data = json.decode(res.body);
                      var box = Hive.box('servers');

                      var server = Server()
                        ..address = widget.address
                        ..username = usernameCtrl.text
                        ..accessToken = data['access_token']
                        ..refreshToken = data['refresh_token']
                        ..created = DateTime.now();

                      box.put(server.id, server);

                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => ServerPage()));
                    } catch (e, st) {
                      setState(() {
                        error = e.toString();
                        loading = false;
                      });
                      print(st);
                    }
                  },
                ),
              ],
              if (!inviteCodeValid)
                RaisedButton.icon(
                    icon: Icon(MdiIcons.cloudCheck),
                    label: Text('Check'),
                    onPressed: () async {
                      setState(() {
                        error = null;
                        loading = true;
                      });
                      var res = await http.get(
                          widget.address+
                              '/api/v0/auth/checkInviteCode?code=${inviteCodeCtrl.text}',
                          headers: {
                            'Authorization':
                                'Basic ${base64.encode('app_dev:secret'.codeUnits)}',
                          });
                      if (res.statusCode != 200) {
                        setState(() {
                          loading = false;

                          error = 'Status Code ${res.statusCode}';
                        });
                        return;
                      }
                      if (json.decode(res.body)['valid']) {
                        setState(() {
                          loading = false;
                          inviteCodeValid = true;
                        });
                      } else {
                        setState(() {
                          loading = false;

                          error = 'Invite Code invalid or expired';
                        });
                      }
                    }),
            ],
          ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '',
                          labelText: 'Username',
                        ),
                        controller:
                            usernameCtrl, /*
                    onChanged: (_) => username = _, */
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '',
                          labelText: 'Password',
                        ),
                        controller: passwordCtrl,
                        obscureText: true,

                        /*
                    onChanged: (_) => password = _, */
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      RaisedButton.icon(
                        icon: Icon(MdiIcons.loginVariant),
                        label: Text('Login'),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                        onPressed: () async {
                          try {
                            setState(() {
                              error = null;
                              loading = true;
                            });
                            var body =
                                "username=${Uri.encodeFull(usernameCtrl.text)}&password=${Uri.encodeFull(passwordCtrl.text)}&grant_type=password";

                            var res = await http.post(
                                widget.address + '/api/v0/auth/token',
                                body: body,
                                headers: {
                                  'Authorization':
                                      'Basic ${base64.encode('app_dev:secret'.codeUnits)}',
                                  'Content-Type':
                                      'application/x-www-form-urlencoded'
                                });

                            if (res.statusCode != 200) {
                              setState(() {
                                loading = false;
                                if (res.statusCode == 400) {
                                  error = 'Invalid login';
                                } else {
                                  error = 'Status Code ${res.statusCode}';
                                }
                              });
                              return;
                            }

                            var data = json.decode(res.body);
                            var box = Hive.box('servers');

                            var server = Server()
                              ..address = widget.address
                              ..username = usernameCtrl.text
                              ..accessToken = data['access_token']
                              ..refreshToken = data['refresh_token']
                              ..created = DateTime.now();

                            box.put(server.id, server);
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
                            await GetIt.I
                                .get<ApiService>()
                                .refreshPermissions();
                            Navigator.of(context).pop();

                            /*   setState(() {
                          error = null;
                        }); */
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => HomePage()));

                            /*

                        var data = json.decode(res.body);
                        if (data['evervent'] == null) {
                          setState(() {
                            error = 'Not a evervent server';
                          });
                          return;
                        }

                        setState(() {
                          error = null;
                          serverAddressVerified = true;
                        }); */
                          } catch (e, st) {
                            setState(() {
                              error = e.toString();
                              loading = false;
                            });
                            print(st);
                          }
                        },
                      ),
                    ],
                  ),
        ],
      ),
    );
  }
}
