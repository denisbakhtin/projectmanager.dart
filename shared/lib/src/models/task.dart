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
  Priority priority;
  Project project;
  Category category;
  List<Comment> comments;
  List<Activity> activities;
  List<Attachment> attachments;
  TaskDuration spentTotal;

  Task.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    contents = map["contents"];
    createdAt = (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]): null;
    updatedAt = (map["updatedAt"] != null) ? DateTime.parse(map["updatedAt"]): null;
    priority = enumFromString(Priority.values, map["priority"]) ?? Priority.DoLast;
    owner = (map["owner"] != null) ? User.fromMap(map["owner"]) : null;
    project = (map["project"] != null) ? Project.fromMap(map["project"]) : null;
    category = (map["category"] != null) ? Category.fromMap(map["category"]) : null;
    completed = map["completed"];
    //this is the correct way to cast List<dynamic> to List<Type>, in case you face that kind of error
    comments = List<Comment>.from(map["comments"]?.map((c) => Comment.fromMap(c))?.toList() ?? []);
    activities = List<Activity>.from(map["activities"]?.map((a) => Activity.fromMap(a))?.toList() ?? []);
    attachments = List<Attachment>.from(map["attachments"]?.map((a) => Attachment.fromMap(a))?.toList() ?? []);
    calcSpentTotal();
  }
  Task.fromTask(Task t) {
    id = t.id;
    contents = t.contents;
    createdAt = t.createdAt;
    updatedAt = t.updatedAt;
    priority = t.priority;
    owner = t.owner;
    project = t.project;
    category = t.category;
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
      "priority": enumToString(priority),
      "project": project?.asMap(),
      "category": category?.asMap(),
      "attachments": attachments?.map((a) => a.asMap())?.toList(),
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  void calcSpentTotal() {
    spentTotal = TaskDuration(minutes: 0);
    activities.forEach((a) => spentTotal += a.spent);
  }

  @override
  String toString() {
    return "Task " + this.asMap().toString();
  }

  @override
  bool operator ==(t) => t is Task && id == t.id && contents == t.contents && completed == t.completed && dueTo == t.dueTo && priority == t.priority
    && createdAt == t.createdAt && updatedAt == t.updatedAt;

  @override
  int get hashCode => id.hashCode ^ contents.hashCode ^ completed.hashCode ^ dueTo.hashCode ^ priority.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
}