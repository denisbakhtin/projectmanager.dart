import 'models.dart';

//all dates in task comment are in utc timezone and should be converted to local time in ui
class Comment {
  Comment();

  int id;
  String contents;
  bool isSolution;
  DateTime createdAt;
  DateTime updatedAt;
  User owner;
  Task task;
  List<Attachment> attachments;

  Comment.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    contents = map["contents"];
    createdAt = (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]) : null;
    updatedAt = (map["updatedAt"] != null) ? DateTime.parse(map["updatedAt"]) : null;
    isSolution = map["isSolution"] ?? false;
    owner = (map["owner"] != null) ? User.fromMap(map["owner"]) : null;
    task = (map["task"] != null) ? Task.fromMap(map["task"]) : null;
    attachments = List<Attachment>.from(map["attachments"]?.map((a) => Attachment.fromMap(a))?.toList() ?? []);
  }
  Comment.fromTask(Task task) {
    this.task = task;
  }
  Comment.fromComment(Comment c) {
    id = c.id;
    contents = c.contents;
    createdAt = c.createdAt;
    updatedAt = c.updatedAt;
    owner = c.owner;
    task = c.task;
    isSolution = c.isSolution;
    attachments = c.attachments;
  }
  Map<String, dynamic> asMap() {
    var result = {
      "contents": contents,
      "task": task?.asMap(),
      "isSolution": isSolution ?? false,
      "attachments": attachments?.map((a) => a.asMap())?.toList(),
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }
}