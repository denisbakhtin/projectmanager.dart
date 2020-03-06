import '../todo.dart';
import 'models.dart';

class Plan extends ManagedObject<_Plan> implements _Plan {
  
  @override
  void willUpdate() {
    updatedAt = new DateTime.now().toUtc();
  }

  @override
  void willInsert() {
    createdAt = new DateTime.now().toUtc();
    updatedAt = new DateTime.now().toUtc();
  }
}

class _Plan {
  @primaryKey
  int id;

  @Validate.length(lessThan: 1000)
  String title;

  bool closed;

  PlanType type;

  DateTime createdAt;
  DateTime updatedAt;

  @Relate(#plans, onDelete: DeleteRule.restrict, isRequired: true)
  User owner;

  ManagedSet<PlanDate> dates;
}
