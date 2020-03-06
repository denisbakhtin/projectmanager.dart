import '../todo.dart';
import 'models.dart';

class PlanDate extends ManagedObject<_PlanDate> implements _PlanDate {
  
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

class _PlanDate {
  @primaryKey
  int id;

  @Column(indexed: true, nullable: true)
  DateTime date;

  DateType type;

  DateTime createdAt;
  DateTime updatedAt;

  @Relate(#dates, onDelete: DeleteRule.cascade, isRequired: true)
  Plan plan;
}
