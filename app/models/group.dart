import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 2)
class Group {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  Group({this.id, this.name, this.description});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
