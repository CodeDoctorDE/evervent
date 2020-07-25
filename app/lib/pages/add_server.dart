import 'dart:convert';

import 'package:evervent/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:evervent/colors.dart' as colors;
import 'package:evervent/main.dart';
import 'package:evervent/models/server.dart';
import 'package:evervent/pages/servers.dart';
import 'package:evervent/service/api_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:email_validator/email_validator.dart';

class AddServerPage extends StatefulWidget {
  @override
  _AddServerPageState createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage>
    with SingleTickerProviderStateMixin {
  /*  String serverAddress = '';

  String username = '';
  String password = ''; */


  final serverAddressCtrl = TextEditingController();
  String error;

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Server'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (error != null) ...[
                Container(
                  /* 
                    color: Colors.redAccent, */
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    error,
                    style: TextStyle(
                        color: colors.danger, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
              if (loading)
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'https://example.com',
                  labelText: 'Server address',
                ),
                /* 
                  onChanged: (_) => serverAddress = _, */
                controller: serverAddressCtrl,
                onSubmitted: (text) {
                  connectToServer(text);
                },
              ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton.icon(
                  icon: Icon(MdiIcons.plus),
                  label: Text('Connect to server'),
                  onPressed: () async {
                    connectToServer(serverAddressCtrl.text);
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> connectToServer(String text) async {
    try {
      setState(() {
        error = null;
        loading = true;
      });
      var res = await http.get(text + '/api/v0/info');

      if (res.statusCode != 200) {
        setState(() {
          error = 'Status Code ${res.statusCode}';
        });
        return;
      }
      var data = json.decode(res.body);
      if (data['version'] == null) {
        setState(() {
          error = 'Not a evervent server';
        });
        return;
      }

      setState(() {
        error = null;
        loading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthPage(address: serverAddressCtrl.text,)));
    } catch (error) {
      setState(() {
        this.error = error.toString();
        loading = false;
      });
    }
  }
}
