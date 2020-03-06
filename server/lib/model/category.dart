import '../todo.dart';
import 'models.dart';

class Category extends ManagedObject<_Category> implements _Category {
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

class _Category {
  @primaryKey
  int id;

  @Validate.length(lessThan: 1000)
  String title;

  DateTime createdAt;
  DateTime updatedAt;

  @Relate(#categories, onDelete: DeleteRule.restrict, isRequired: true)
  User owner;

  ManagedSet<Task> tasks;
  ManagedSet<Project> projects;
}