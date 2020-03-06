import 'models.dart';

//all dates in task are in utc timezone and should be converted to local time in ui
class PlanDate {
  PlanDate();

  int id;
  DateTime date;
  DateType type;
  DateTime createdAt;
  DateTime updatedAt;
  Plan plan;

  PlanDate.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    date = map["date"];
    type = map["type"];
    createdAt = (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]): null;
    updatedAt = (map["updatedAt"] != null) ? DateTime.parse(map["updatedAt"]): null;
    plan = (map["plan"] != null) ? Plan.fromMap(map["plan"]) : null;
  }
  Map<String, dynamic> asMap() {
    var result = {
      "type": type,
      "date": date?.toIso8601String(),
      "plan": plan.asMap(),
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  @override
  String toString() {
    return "PlanDate " + this.asMap().toString();
  }

  @override
  bool operator ==(t) => t is PlanDate && id == t.id && type == t.type && date == t.date && createdAt == t.createdAt && updatedAt == t.updatedAt;

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ date.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
}