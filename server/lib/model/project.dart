import '../todo.dart';
import 'models.dart';

class Project extends ManagedObject<_Project> implements _Project {
  int get spent {
    int sum = 0;
    tasks?.forEach((t) => sum += t.spent);
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

class _Project {
  @primaryKey
  int id;

  @Validate.length(lessThan: 1000)
  String title;

  @Column(nullable: true)
  String contents;

  bool archived;

  DateTime createdAt;
  DateTime updatedAt;
  @Column(nullable: true)
  DateTime expiresdAt;

  @Relate(#projects, onDelete: DeleteRule.restrict, isRequired: true)
  User owner;

  @Relate(#projects, onDelete: DeleteRule.restrict, isRequired: false)
  Category category;

  ManagedSet<Task> tasks;
  ManagedSet<Attachment> attachments;
}
