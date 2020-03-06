import '../todo.dart';
import '../model/models.dart';
import 'controllers.dart';

class ProjectController extends ResourceController {
  ProjectController(this.context, this.authServer);

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAll() async {
    var query =  Query<Project>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID);
    query
      ..join(set: (p) => p.tasks)
      ..join(object: (p) => p.category);

    return Response.ok(await query.fetch());
  }

  @Operation.get("id")
  Future<Response> get(@Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Project>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);
    query
      ..join(set: (p) => p.attachments)
      ..join(object: (p) => p.category);

    var u = await query.fetchOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }

  @Operation.post()
  Future<Response> create(@Bind.body() Project project) async {
    var owner = User()..id = request.authorization.ownerID;
    if (!await _validateAssociations(project, owner)) return Response.notFound();
    project.owner = owner;
    project.archived = false;

    var result = await Query.insertObject(context, project);

    if (project.attachments != null) {
      for (var att in project.attachments) {
        await _saveAttachment(att, result, owner);
      }
    }
    
    return Response.ok(result);
  }

  @Operation.put("id")
  Future<Response> update(@Bind.path("id") int id, @Bind.body() Project project) async {
    var owner = User()..id = request.authorization.ownerID;
    if (!await _validateAssociations(project, owner)) return Response.notFound();
    var query = Query<Project>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..values = project
      ..values.removePropertyFromBackingMap("id");

    var result = await query.updateOne();
    if (result == null) {
      return Response.notFound();
    }

    //update attachments: delete removed ones, save added
    _deleteAttachments(project, owner);
    //save attachments
    var newAttachments = project.attachments.where((a) => a.base64string != null).toList();
    for (var att in newAttachments) {
      await _saveAttachment(att, result, owner);
    }

    return Response.ok(result);
  }

  @Operation.delete("id")
  Future<Response> delete(@Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Project>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    if (await query.delete() > 0) {
      return Response.ok(null);
    }

    return Response.notFound();
  }

  Future<Attachment> _saveAttachment(Attachment att, Project project, User owner) async {
    var url = await saveEncodedFile(att.base64string, att.filename, userId: owner.id);
    var aQuery = Query<Attachment>(context)
      ..values = att
      ..values.owner = owner
      ..values.project = project
      ..values.url = url;
    return await aQuery.insert();
  }

  void _deleteAttachments(Project project, User owner) async {
    var aQuery = Query<Attachment>(context)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..where((n) => n.project).identifiedBy(project.id);
    var removeAttachments = await aQuery.fetch();
    var keepAttachments = project.attachments?.where((a) => a.id != null)?.toList();
    List<int> keepIds = keepAttachments?.map((a) => a.id)?.toList() ?? [];
    removeAttachments.removeWhere((a) => keepIds.contains(a.id));
    if ((removeAttachments?.length ?? 0) > 0) {
      var remQuery = Query<Attachment>(context)
      ..where((a) => a.id).oneOf(removeAttachments?.map((d) => d.id)?.toList());
      await remQuery.delete();
    }
  }

  Future<bool> _validateAssociations(Project project, User owner) async {
    //manually check the category belongs to the same user... and do so for every association it belongs to
    if (project.category?.id != null) {
      var category = await Query<Category>(context)
        ..where((c) => c.owner).identifiedBy(owner.id)
        ..where((c) => c.id).equalTo(project.category.id)
        ..fetchOne();
      if (category == null) return false;
    }
    return true;
  }
}
