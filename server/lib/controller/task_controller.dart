import 'package:todo/controller/controllers.dart';

import '../todo.dart';
import '../model/models.dart';

class TaskController extends ResourceController {
  TaskController(this.context, this.authServer);

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAll({@Bind.query("project_id") int projectId}) async {
    var query =  Query<Task>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID)
      ..sortBy((n) => n.completed, QuerySortOrder.ascending)
      ..sortBy((n) => n.createdAt, QuerySortOrder.ascending);

    if (projectId != null)
      query.where((n) => n.project).identifiedBy(projectId);

    query
      ..join(object: (t) => t.project)
      ..join(object: (t) => t.category)
      ..join(set: (t) => t.comments);
    query.join(set: (t) => t.activities)
      ..where((a) => a.commited).equalTo(false)
      ..where((a) => a.spent).greaterThan(0);

    return Response.ok(await query.fetch());
  }

  @Operation.get("id")
  Future<Response> get(@Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = new Query<Task>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID)
      ..join(object: (t) => t.project)
      ..join(object: (t) => t.category)
      ..join(set: (t) => t.attachments);

    var u = await query.fetchOne();
    if (u == null) {
      return new Response.notFound();
    }

    return new Response.ok(u);
  }

  @Operation.post()
  Future<Response> create(@Bind.body() Task task) async {
    var owner = User()..id = request.authorization.ownerID;
    if (!await _validateAssociations(task, owner)) return Response.notFound();
    task.owner = owner; 
    task.completed = false;
    task.priority ??= Priority.DoLast;

    var result = await Query.insertObject(context, task);
    
    if (task.attachments != null) {
      for (var att in task.attachments) {
        await _saveAttachment(att, result, owner);
      }
    }
    
    return Response.ok(result);
  }

  @Operation.put("id")
  Future<Response> update(@Bind.path("id") int id, @Bind.body() Task task) async {
    var owner = User()..id = request.authorization.ownerID;
    if (!await _validateAssociations(task, owner)) return Response.notFound();
    var query = Query<Task>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..values = task
      ..values.removePropertyFromBackingMap("id");

    var result = await query.updateOne();
    if (result == null) {
      return Response.notFound();
    }

    //update attachments: delete removed ones, save added
    _deleteAttachments(task, owner);
    //save new attachments
    var newAttachments = task.attachments.where((a) => a.base64string != null).toList();
    for (var att in newAttachments) {
      await _saveAttachment(att, result, owner);
    }

    return Response.ok(result);
  }

  @Operation.delete("id")
  Future<Response> delete(@Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Task>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    if (await query.delete() > 0) {
      return Response.ok(null);
    }

    return Response.notFound();
  }

  Future<Attachment> _saveAttachment(Attachment att, Task task, User owner) async {
    var url = await saveEncodedFile(att.base64string, att.filename, userId: owner.id);
    var aQuery = Query<Attachment>(context)
      ..values = att
      ..values.owner = owner
      ..values.task = task
      ..values.url = url;
    return await aQuery.insert();
  }

  void _deleteAttachments(Task task, User owner) async {
    var aQuery = Query<Attachment>(context)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..where((n) => n.task).identifiedBy(task.id);
    var removeAttachments = await aQuery.fetch();
    var keepAttachments = task.attachments?.where((a) => a.id != null)?.toList();
    List<int> keepIds = keepAttachments?.map((a) => a.id)?.toList() ?? [];
    removeAttachments.removeWhere((a) => keepIds.contains(a.id));
    if ((removeAttachments?.length ?? 0) > 0) {
      var remQuery = Query<Attachment>(context)
      ..where((a) => a.id).oneOf(removeAttachments?.map((d) => d.id)?.toList());
      await remQuery.delete();
    }
  }

  Future<bool> _validateAssociations(Task task, User owner) async {
    //manually check the category belongs to the same user... and do so for every association it belongs to
    if (task.category?.id != null) {
      var category = await Query<Category>(context)
        ..where((c) => c.owner).identifiedBy(owner.id)
        ..where((c) => c.id).equalTo(task.category.id)
        ..fetchOne();
      if (category == null) return false;
    }
    if (task.project?.id != null) {
      var project = await Query<Project>(context)
        ..where((p) => p.owner).identifiedBy(owner.id)
        ..where((p) => p.id).equalTo(task.project.id)
        ..fetchOne();
      if (project == null) false;
    }
    return true;
  }
}
