import '../todo.dart';
import 'models.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {
  @Column(unique: true)
  String email;

  ManagedSet<Task> tasks;
  ManagedSet<Comment> comments;
  ManagedSet<Activity> activities;
  ManagedSet<Project> projects;
  ManagedSet<Attachment> attachments;
  ManagedSet<Session> sessions;
  ManagedSet<Category> categories;
  ManagedSet<Plan> plans;

/* This class inherits the following from ManagedAuthenticatable:

  @managedPrimaryKey
  int id;

  @ManagedColumnAttributes(unique: true, indexed: true)
  String username;

  @ManagedColumnAttributes(omitByDefault: true)
  String hashedPassword;

  @ManagedColumnAttributes(omitByDefault: true)
  String salt;

  ManagedSet<ManagedToken> tokens;
 */
}
