import 'models.dart';

//all dates in task are in utc timezone and should be converted to local time in ui
class Task {
  Task();

  int id;
  String contents;
  bool completed = false;
  //todo: priority
  DateTime dueTo;
  DateTime createdAt;
  DateTime updatedAt;
  User owner;
  Project project;
  List<Comment> comments;
  List<Activity> activities;
  List<Attachment> attachments;
  TaskDuration spentTotal;

  Task.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    contents = map["contents"];
    createdAt = (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]): null;
    updatedAt = (map["updatedAt"] != null) ? DateTime.parse(map["updatedAt"]): null;
    owner = (map["owner"] != null) ? User.fromMap(map["owner"]) : null;
    project = (map["project"] != null) ? Project.fromMap(map["project"]) : null;
    completed = map["completed"];
    //this is the correct way to cast List<dynamic> to List<Type>, in case you face that kind of error
    comments = List<Comment>.from(map["comments"]?.map((c) => Comment.fromMap(c))?.toList() ?? []);
    activities = List<Activity>.from(map["activities"]?.map((a) => Activity.fromMap(a))?.toList() ?? []);
    attachments = List<Attachment>.from(map["attachments"]?.map((a) => Attachment.fromMap(a))?.toList() ?? []);
    spentTotal = TaskDuration(minutes: 0);
    activities.forEach((a) => spentTotal += a.spent);
  }
  Task.fromTask(Task t) {
    id = t.id;
    contents = t.contents;
    createdAt = t.createdAt;
    updatedAt = t.updatedAt;
    owner = t.owner;
    project = t.project;
    comments = t.comments;
    completed = t.completed;
    activities = t.activities;
    attachments = t.attachments;
    spentTotal = t.spentTotal;
  }
  Map<String, dynamic> asMap() {
    var result = {
      "dueTo": dueTo?.toIso8601String(),
      "completed": completed,
      "contents": contents,
      "project": project?.asMap(),
      "attachments": attachments?.map((a) => a.asMap())?.toList(),
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  String toString() {
    return "Task " + this.asMap().toString();
  }
}