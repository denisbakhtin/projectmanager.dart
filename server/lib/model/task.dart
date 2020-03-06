import '../todo.dart';
import 'models.dart';

class Task extends ManagedObject<_Task> implements _Task {
  int get spent {
    int sum = 0;
    activities?.forEach((a) => sum += a.spent);
    return sum;
  }

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

class _Task {
  @primaryKey
  int id;

  @Validate.length(lessThan: 1000)
  String contents;

  bool completed;

  Priority priority;

  @Column(indexed: true, nullable: true)
  DateTime dueTo;

  DateTime createdAt;
  DateTime updatedAt;

  @Relate(#tasks, onDelete: DeleteRule.restrict, isRequired: true)
  User owner;

  @Relate(#tasks, onDelete: DeleteRule.restrict, isRequired: true)
  Project project;

  @Relate(#tasks, onDelete: DeleteRule.restrict, isRequired: false)
  Category category;

  ManagedSet<Comment> comments;
  ManagedSet<Activity> activities;
  ManagedSet<Attachment> attachments;
}
