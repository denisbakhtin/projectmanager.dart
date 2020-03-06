import '../todo.dart';
import '../model/models.dart';

class ActivityController extends ResourceController {
  ActivityController(this.context, this.authServer);

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get("task_id")
  Future<Response> getAll(@Bind.path("task_id") int taskId) async {
    var query =  Query<Activity>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID);

    return Response.ok(await query.fetch());
  }

  @Operation.get("task_id", "id")
  Future<Response> get(@Bind.path("task_id") int taskId, @Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Activity>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    var u = await query.fetchOne();
    if (u == null) return Response.notFound();

    return Response.ok(u);
  }

  @Operation.post("task_id")
  Future<Response> create(@Bind.path("task_id") int taskId, @Bind.body() Activity activity) async {
    var owner = User()..id = request.authorization.ownerID;
    //check task belongs to the same user
    var query = Query<Task>(context)
      ..where((n) => n.id).equalTo(taskId)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID);
    var task = await query.fetchOne();
    if (task == null) return Response.notFound();

    activity.owner = owner;
    activity.task?.id = taskId;
    var result = await Query.insertObject(context, activity);
    result.task = task;

    return Response.ok(result);
  }

  @Operation.put("task_id", "id")
  Future<Response> update(@Bind.path("task_id") int taskId, @Bind.path("id") int id, @Bind.body() Activity activity) async {
    var owner = User()..id = request.authorization.ownerID;
    //check task belongs to the same user
    var tQuery = Query<Task>(context)
      ..where((n) => n.id).equalTo(taskId)
      ..where((n) => n.owner).identifiedBy(owner.id);
    var task = await tQuery.fetchOne();
    if (task == null) return Response.notFound();

    activity.task?.id = taskId;
    var query = Query<Activity>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..values = activity
      ..values.removePropertyFromBackingMap("id");
    
    var u = await query.updateOne();
    if (u == null) return Response.notFound();

    u.task = task;
    return Response.ok(u);
  }

  @Operation.delete("task_id", "id")
  Future<Response> delete(@Bind.path("task_id") int taskId, @Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Activity>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    if (await query.delete() > 0) {
      return Response.ok(null);
    }

    return Response.notFound();
  }
}
