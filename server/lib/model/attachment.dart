import '../todo.dart';
import 'models.dart';

class Attachment extends ManagedObject<_Attachment> implements _Attachment {
  @override
  void willUpdate() {
    base64string = null;
  }

  @override
  void willInsert() {
    base64string = null;
  }
}

class _Attachment {
  @primaryKey
  int id;

  String filename; //original filename
  String url;
  int size;
  @Column(nullable: true)
  String base64string; //not stored in db

  @Relate(#attachments, onDelete: DeleteRule.cascade, isRequired: false)
  Task task;
  @Relate(#attachments, onDelete: DeleteRule.cascade, isRequired: false)
  Project project;
  @Relate(#attachments, onDelete: DeleteRule.cascade, isRequired: false)
  Comment comment;
  @Relate(#attachments, onDelete: DeleteRule.cascade, isRequired: true)
  User owner;
}
