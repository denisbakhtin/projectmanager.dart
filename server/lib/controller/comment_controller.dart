import '../todo.dart';
import '../model/models.dart';
import 'controllers.dart';

class CommentController extends ResourceController {
  CommentController(this.context, this.authServer);

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get("task_id")
  Future<Response> getAll(@Bind.path("task_id") int taskId) async {
    var query =  Query<Comment>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID)
      ..where((n) => n.task).identifiedBy(taskId)
      ..sortBy((n) => n.createdAt, QuerySortOrder.ascending);
    query..join(set: (t) => t.attachments);

    return Response.ok(await query.fetch());
  }

  @Operation.get("task_id", "id")
  Future<Response> get(@Bind.path("task_id") int taskId, @Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Comment>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    query..join(set: (t) => t.attachments);

    var u = await query.fetchOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }

  @Operation.post("task_id")
  Future<Response> create(@Bind.path("task_id") int taskId, @Bind.body() Comment comment) async {
    var owner = User()..id = request.authorization.ownerID;

    var query = Query<Task>(context)
      ..where((n) => n.id).equalTo(taskId)
      ..where((n) => n.owner).identifiedBy(owner.id);
    var task = await query.fetchOne();
    if (task == null) return Response.notFound();

    comment.owner = owner;
    comment.task?.id = taskId;
    var result = await Query.insertObject(context, comment);
    result.task = task;

    if (comment.attachments != null) {
      for (var att in comment?.attachments) {
        await _saveAttachment(att, result, owner);
      }
    }
    
    return Response.ok(result);
  }

  @Operation.put("task_id", "id")
  Future<Response> update(@Bind.path("task_id") int taskId, @Bind.path("id") int id, @Bind.body() Comment comment) async {
    var owner = User()..id = request.authorization.ownerID;
    var tQuery = Query<Task>(context)
      ..where((n) => n.id).equalTo(taskId)
      ..where((n) => n.owner).identifiedBy(owner.id);
    var task = await tQuery.fetchOne();
    if (task == null) return Response.notFound();

    comment.task?.id = taskId;
    var query = Query<Comment>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..values = comment
      ..values.removePropertyFromBackingMap("id");

    var result = await query.updateOne();
    if (result == null) {
      return Response.notFound();
    }

    result.task = task;

    //update attachments: delete removed ones, save added
    _deleteAttachments(comment, owner);
    //save attachments
    var newAttachments = comment.attachments.where((a) => a.base64string != null).toList();
    for (var att in newAttachments) {
      await _saveAttachment(att, result, owner);
    }

    return Response.ok(result);
  }

  @Operation.delete("task_id", "id")
  Future<Response> delete(@Bind.path("task_id") int taskId, @Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Comment>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    if (await query.delete() > 0) {
      return Response.ok(null);
    }

    return Response.notFound();
  }

  Future<Attachment> _saveAttachment(Attachment att, Comment comment, User owner) async {
    var url = await saveEncodedFile(att.base64string, att.filename, userId: owner.id);
    var aQuery = Query<Attachment>(context)
      ..values = att
      ..values.owner = owner
      ..values.comment = comment
      ..values.url = url;
    return await aQuery.insert();
  }

  void _deleteAttachments(Comment comment, User owner) async {
    var aQuery = Query<Attachment>(context)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..where((n) => n.comment).identifiedBy(comment.id);
    var removeAttachments = await aQuery.fetch();
    var keepAttachments = comment.attachments?.where((a) => a.id != null)?.toList();
    List<int> keepIds = keepAttachments?.map((a) => a.id)?.toList() ?? [];
    removeAttachments.removeWhere((a) => keepIds.contains(a.id));
    if ((removeAttachments?.length ?? 0) > 0) {
      var remQuery = Query<Attachment>(context)
      ..where((a) => a.id).oneOf(removeAttachments?.map((d) => d.id)?.toList());
      await remQuery.delete();
    }
  }
}
