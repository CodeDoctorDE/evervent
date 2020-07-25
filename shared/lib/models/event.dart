import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 1)
class Event {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int creatorId;
  @HiveField(3)
  String state;
  @HiveField(4)
  int location;
  @HiveField(5)
  int group;

  Event(
      {this.id,
      this.name,
      this.creatorId,
      this.state,
      this.location,
      this.group});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creatorId = json['creatorId'];
    state = json['state'];
    location = json['location'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['creatorId'] = this.creatorId;
    data['state'] = this.state;
    data['location'] = this.location;
    data['group'] = this.group;
    return data;
  }
}

enum EventState { draft, planned, canceled }
