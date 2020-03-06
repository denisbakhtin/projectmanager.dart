import 'models.dart';

class Activity {
  Activity();

  int id;
  //time spent in minutes;
  TaskDuration spent;
  //if this activity has been commited to project owner aka paid
  bool commited = false;
  DateTime lastRunAt;
  Task task;
  TaskDuration get activeFor => TaskDuration.fromDuration(DateTime.now().toUtc().difference(lastRunAt));

  Activity.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    task = (map["task"] != null) ? Task.fromMap(map["task"]) : null;
    spent = TaskDuration(minutes: map["spent"]); //parse from int in minutes
    commited = map["commited"];
    lastRunAt = DateTime.parse(map["lastRunAt"]);
  }
  Map<String, dynamic> asMap() {
    var result = {
      "spent": TaskDuration(minutes: (activeFor.inSeconds % 60 > activityThreshold) ? activeFor.inMinutes + 1 : activeFor.inMinutes).inMinutes, //convert to int in minutes
      "task": task.asMap(),
      "lastRunAt": lastRunAt.toIso8601String(),
      "commited": commited,
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  String toString() {
    return "Activity " + this.asMap().toString();
  }
}