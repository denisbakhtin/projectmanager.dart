import '../todo.dart';
import 'models.dart';

class Activity extends ManagedObject<_Activity> implements _Activity {
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

class _Activity {
  @primaryKey
  int id;

  //time spent in minutes;
  int spent;

  //if this activity has been commited to project owner aka paid
  bool commited;
  @Column(indexed: true)
  DateTime lastRunAt;
  DateTime createdAt;
  DateTime updatedAt;

  @Relate(#activities, onDelete: DeleteRule.cascade, isRequired: true)
  Task task;
  @Relate(#activities, onDelete: DeleteRule.cascade, isRequired: true)
  User owner;
  @Relate(#activities, onDelete: DeleteRule.restrict, isRequired: false)
  Session session;
}
