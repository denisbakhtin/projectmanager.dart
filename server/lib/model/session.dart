import '../todo.dart';
import 'models.dart';

class Session extends ManagedObject<_Session> implements _Session {
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

class _Session {
  @primaryKey
  int id;

  //Optional comment;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;

  @Relate(#sessions, onDelete: DeleteRule.restrict, isRequired: true)
  User owner;

  ManagedSet<Activity> activities;
}
