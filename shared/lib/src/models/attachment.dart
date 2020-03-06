import 'models.dart';

//all dates in task are in utc timezone and should be converted to local time in ui
class Attachment {
  Attachment({this.id, this.filename, this.base64string, this.task, this.project, this.comment, this.size});

  int id;
  int size;
  String filename; //original filename
  String base64string;
  String url;
  Task task;
  Project project;
  Comment comment;

  Attachment.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    filename = map["filename"];
    size = map["size"];
    base64string = map["base64string"];
    url = map["url"];
    task = (map["task"] != null) ? Task.fromMap(map["task"]) : null;
    project = (map["project"] != null) ? Project.fromMap(map["project"]) : null;
    comment = (map["comment"] != null) ? Comment.fromMap(map["comment"]) : null;
  }
  Map<String, dynamic> asMap() {
    var result = {
      "size": size,
      "filename": filename,
      "base64string": base64string,
      "url": url,
      "task": task?.asMap(),
      "project": project?.asMap(),
      "comment": comment?.asMap(),
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  String toString() {
    return "Attachment " + this.asMap().toString();
  }
}