import 'models.dart';

//all dates in task are in utc timezone and should be converted to local time in ui
class Plan {
  Plan();

  int id;
  String title;
  bool closed = false;
  PlanType type;
  DateTime createdAt;
  DateTime updatedAt;
  User owner;
  List<PlanDate> dates;

  Plan.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    type = map["type"];
    createdAt = (map["createdAt"] != null) ? DateTime.parse(map["createdAt"]): null;
    updatedAt = (map["updatedAt"] != null) ? DateTime.parse(map["updatedAt"]): null;
    owner = (map["owner"] != null) ? User.fromMap(map["owner"]) : null;
    closed = map["closed"];
    //this is the correct way to cast List<dynamic> to List<Type>, in case you face that kind of error
    dates = List<PlanDate>.from(map["dates"]?.map((d) => PlanDate.fromMap(d))?.toList() ?? []);
  }
  Plan.fromPlan(Plan p) {
    id = p.id;
    title = p.title;
    type = p.type;
    createdAt = p.createdAt;
    updatedAt = p.updatedAt;
    owner = p.owner;
    dates = p.dates;
    closed = p.closed;
  }
  Map<String, dynamic> asMap() {
    var result = {
      "closed": closed,
      "title": title,
      "type": type,
      "dates": dates?.map((d) => d.asMap())?.toList(),
    };
    //need to have this work around for aqueduct backend serializer
    if (id != null) result["id"] = id;
    return result;
  }

  @override
  String toString() {
    return "Plan " + this.asMap().toString();
  }

  @override
  bool operator ==(t) => t is Plan && id == t.id && title == t.title && type == t.type && closed == t.closed && createdAt == t.createdAt && updatedAt == t.updatedAt;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ type.hashCode ^ closed.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
}