class User {
  int id;
  String email;
  String name;
  Level level;
  String username;

  User({this.id, this.email, this.name, this.level, this.username});

  bool hasLevel(Level reqLevel) {
    if (reqLevel == level) return true;
    final allLevels = [
      Level.guest,
      Level.member,
      Level.moderator,
      Level.admin,
      Level.owner
    ];
    for (var l in allLevels) {
      if (l == level) break;
      if (l == reqLevel) return true;
    }
    return false;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    level = Level.values
        .firstWhere((l) => l.toString().substring(6) == json['level']);
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['level'] = this.level.toString().substring(6);
    data['username'] = this.username;
    return data;
  }

}

enum Level { owner, admin, moderator, member, guest }
