import 'models.dart';

class Session {
  Session();

  int id;
  //if this activity has been commited to project owner aka paid
  String comment;
  DateTime createdAt;
  DateTime updatedAt;
  List<Activity> activities;
  TaskDuration spentTotal;

  Session.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    comment = map['comment'];
    createdAt = DateTime.parse(map["createdAt"]);
    updatedAt = DateTime.parse(map["updatedAt"]);
    //this is the correct way to cast List<dynamic> to List<Type>, in case you face that kind of error
    activities = List<Activity>.from(map["activities"]?.map((a) => Activity.fromMap(a))?.toList() ?? []);
    calcSpentTotal();
  }
  Map<String, dynamic> asMap() {
    var result = {
      "comment": comment ?? "",
      "activities": activities?.map((a) => a.asMap())?.toList(),
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  TaskDuration spentCalculated() {
    TaskDuration spent = TaskDuration();
    activities.forEach((a) => spent += a.spent);
    return spent;
  }

  void calcSpentTotal() {
    spentTotal = TaskDuration(minutes: 0);
    activities.forEach((a) => spentTotal += a.spent);
  }

  String toString() {
    return "Session " + this.asMap().toString();
  }
}