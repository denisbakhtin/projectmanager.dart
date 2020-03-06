import '../todo.dart';
import 'models.dart';

class Comment extends ManagedObject<_Comment> implements _Comment {
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

class _Comment {
  @primaryKey
  int id;

  @Validate.length(lessThan: 10000)
  String contents;

  @Column(indexed: true)
  DateTime createdAt;

  @Column(indexed: true)
  DateTime updatedAt;

  @Column(defaultValue: "false")
  bool isSolution;

  @Relate(#comments, onDelete: DeleteRule.restrict, isRequired: true)
  User owner;

  @Relate(#comments, onDelete: DeleteRule.cascade, isRequired: true)
  Task task;

  ManagedSet<Attachment> attachments;
}
