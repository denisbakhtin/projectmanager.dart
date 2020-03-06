import 'models.dart';

//all dates in task are in utc timezone and should be converted to local time in ui
class Category {
  Category();

  int id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  User owner;
  List<Task> tasks;
  List<Project> projects;

  Category.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    createdAt = (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]): null;
    updatedAt = (map["updatedAt"] != null) ? DateTime.parse(map["updatedAt"]): null;
    owner = (map["owner"] != null) ? User.fromMap(map["owner"]) : null;
    //this is the correct way to cast List<dynamic> to List<Type>, in case you face that kind of error
    tasks = List<Task>.from(map["tasks"]?.map((c) => Task.fromMap(c))?.toList() ?? []);
    projects = List<Project>.from(map["projects"]?.map((c) => Project.fromMap(c))?.toList() ?? []);
  }
  Map<String, dynamic> asMap() {
    Map<String, dynamic> result = {
      "title": title,
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  @override
  String toString() => title;

  @override
  bool operator ==(t) => t is Category && id == t.id && title == t.title && createdAt == t.createdAt && updatedAt == t.updatedAt;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
}