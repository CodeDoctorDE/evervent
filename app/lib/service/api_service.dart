import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:jakeson/models/event.dart';
import 'package:jakeson/models/group.dart';
import 'package:jakeson/models/server.dart';
import 'package:http/http.dart' as http;
import 'package:jakeson/models/user.dart';

class ApiService {
  Server server;

  Box get groupsBox => Hive.box(
        'groups',
      );
  Box get usersBox => Hive.box('users');
  Box get eventsBox => Hive.box('events');

  List<Server> get servers =>
      Hive.box('servers').values.toList().cast<Server>();

  int get serverCount => Hive.box('servers').length;

  String get baseUrl => server.address + '/api/v0';

  var client = new http.Client();

  User user;

  ApiService() {
    print('ApiService init');
    print(Hive.box('pref').get('user'));

    if (Hive.box('pref').get('user') != null) {
      var userMap = Hive.box('pref').get('user').cast<String, dynamic>();
      if (userMap != null) user = User.fromJson(userMap);
      print('Logged in as user ${user.name}');
    }
    updateServer(true);
  }
  Map<String, String> get headers => {
        'Authorization': 'Bearer ${server.accessToken}',
      };

  var cTypeHeaders = {'Content-Type': 'application/json'};

  Future listGroups() async {
    await _checkRefresh();
    int count = 0;
    for (var server in servers) {
      client.get('${server.baseUrl}/groups', headers: headers).then((res) {
        List<Group> groups =
            data(res).map<Group>((m) => Group.fromJson(m)).toList();

        List ids = [];
        var serverId = server.aid64;

        groups.forEach((g) {
          var id = '$serverId|${g.id}';
          groupsBox.put(id, g);
          ids.add(id);
        });
        ids = groupsBox.keys
            .where((k) => k.startsWith(serverId + '|') && !ids.contains(k))
            .toList();

        groupsBox.deleteAll(ids);
        count++;
      });
    }
    while (count < serverCount) {
      /*  print(count);
      print(serverCount); */
      await Future.delayed(Duration(milliseconds: 5));
    }
    return;
  }

  Future listEvents() async {
    await _checkRefresh();
    int count = 0;
    for (var server in servers) {
      client.get('${server.baseUrl}/events', headers: headers).then((res) {
        List<Event> events =
            data(res).map<Event>((m) => Event.fromJson(m)).toList();

        List ids = [];
        var serverId = server.aid64;

        events.forEach((e) {
          var id = '$serverId|${e.id}';
          eventsBox.put(id, e);
          ids.add(id);
        });
        ids = eventsBox.keys
            .where((k) => k.startsWith(serverId + '|') && !ids.contains(k))
            .toList();

        eventsBox.deleteAll(ids);
        count++;
      });
    }
    while (count < serverCount) {
      /*  print(count);
      print(serverCount); */
      await Future.delayed(Duration(milliseconds: 5));
    }
    return;
  }

  Future<Group> createGroup(Server server, Group group) async {
    await _checkRefresh();
    var res = await client.post('${server.baseUrl}/groups',
        headers: headers..addAll(cTypeHeaders),
        body: json.encode(group.toJson()));

    return Group.fromJson(data(res));
  }

  Future<Event> createEvent(Server server, Event event) async {
    await _checkRefresh();
    var res = await client.post('${server.baseUrl}/events',
        headers: headers..addAll(cTypeHeaders), body: json.encode(event.toJson()));

    return Event.fromJson(data(res));
  }

/* 
  Future<List<Event>> listEvents() async {
    await _checkRefresh();

    var res = await client.get('$baseUrl/events', headers: headers);

    List<Event> events =
        data(res).map<Event>((m) => Event.fromJson(m)).toList();

    List ids = [];

    events.forEach((e) {
      eventsBox.put(e.id, e);
      ids.add(e.id);
    });
    ids = eventsBox.keys.where((k) => !ids.contains(k)).toList();

    eventsBox.deleteAll(ids);

    return events;
  }
 */
  updateServer(bool refresh) {
    String serverId = Hive.box('pref').get('currentServer');

    if (serverId != null) {
      server = Hive.box('servers').get(serverId);
      print('Server selected');
      print(server.accessToken);
      print(server.refreshToken);
      if (refresh) {
        if (server.refreshToken != null) refreshToken();
        refreshPermissions();
      }
    }
  }

/*   openDatabases() async {
    // TODO Close DBs, when not in use
    /*  if (groupsBox != null) groupsBox.close();
    if (usersBox.isOpen) usersBox.close();
    if (eventsBox.isOpen) eventsBox.close(); */
    await Hive.openBox('${server.id64}-groups');
    await Hive.openBox('${server.id64}-users');
    await Hive.openBox('${server.id64}-events');
  } */

  bool refreshingToken = false;

  refreshToken() async {
    refreshingToken = true;

    print('Refreshing token...');
    var res = await client.post('$baseUrl/auth/token',
        body: 'grant_type=refresh_token&refresh_token=${server.refreshToken}',
        headers: {
          'Authorization': 'Basic ${base64.encode('app_dev:secret'.codeUnits)}',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    if (res.statusCode == 200) {
      server.accessToken = data(res)['access_token'];
      print('New token: ${server.accessToken}');
      Hive.box('servers').put(server.id, server);
    } else {
      // TODO Raise error
    }
    refreshingToken = false;
  }

  Future _checkRefresh() async {
    while (refreshingToken) {
      await Future.delayed(Duration(milliseconds: 5));
    }
  }

  Future refreshPermissions() async {
    print('Refreshing permissions...');
    var res = await client.get('$baseUrl/user/perms', headers: headers);
    if (res.statusCode == 200) {
      print('Got user data');
      user = User.fromJson(data(res));
      Hive.box('pref').put('user', user.toJson());
    } else {
      // TODO Raise error
    }
  }

  dispose() {
    client.close();
  }

  dynamic data(http.Response res) {
    if (res.statusCode != 200) {
      print('+-------------------------------+');
      print('| ERROR ERROR ERROR ERROR ERROR |');
      print('+-------------------------------+');
      return [];
    } else {
      print(res.statusCode);
      print(res.body);
      return json.decode(res.body);
    }
  }
}
