import 'models.dart';

//all dates in task are in utc timezone and should be converted to local time in ui
class Project {
  Project();

  int id;
  String title;
  String contents;
  bool archived = false;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime expiresAt;
  User owner;
  Category category;
  List<Task> tasks;
  List<Attachment> attachments;
  TaskDuration spentTotal;

  Project.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    contents = map["contents"];
    createdAt = (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]): null;
    updatedAt = (map["updatedAt"] != null) ? DateTime.parse(map["updatedAt"]): null;
    expiresAt = (map["expiresAt"] != null) ? DateTime.parse(map["expiresAt"]): null;
    owner = (map["owner"] != null) ? User.fromMap(map["owner"]) : null;
    category = (map["category"] != null) ? Category.fromMap(map["category"]) : null;
    archived = map["archived"] ?? false;
    attachments = List<Attachment>.from(map["attachments"]?.map((a) => Attachment.fromMap(a))?.toList() ?? []);
    //this is the correct way to cast List<dynamic> to List<Type>, in case you face that kind of error
    tasks = List<Task>.from(map["tasks"]?.map((a) => Task.fromMap(a))?.toList() ?? []);
    calcSpentTotal();
  }
  Map<String, dynamic> asMap() {
    var result = {
      "archived": archived,
      "title": title,
      "contents": contents,
      "attachments": attachments?.map((a) => a.asMap())?.toList(),
      "category": category?.asMap(),
      //"expiresAt": expiresAt,
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  void calcSpentTotal() {
    spentTotal = TaskDuration(minutes: 0);
    tasks.forEach((t) => spentTotal += t.spentTotal);
  }

  @override
  String toString() => title;

  @override
  bool operator ==(p) => p is Project && id == p.id && title == p.title && contents == p.contents && archived == p.archived && createdAt == p.createdAt
    && updatedAt == p.updatedAt && expiresAt == p.expiresAt;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ contents.hashCode ^ archived.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ expiresAt.hashCode;
}