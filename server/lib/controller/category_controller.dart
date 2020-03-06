import '../todo.dart';
import '../model/models.dart';

class CategoryController extends ResourceController {
  CategoryController(this.context, this.authServer);

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAll() async {
    var query = Query<Category>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID)
      ..sortBy((n) => n.createdAt, QuerySortOrder.ascending);

    return Response.ok(await query.fetch());
  }

  @Operation.get("id")
  Future<Response> get(@Bind.path("id") int id, {@Bind.query("associations") bool associations}) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Category>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    if (associations == true) {
      query.join(set: (c) => c.tasks)
        ..join(set: (t) => t.comments);
      query.join(set: (c) => c.projects)
        ..join(set: (p) => p.tasks);
    }

    var u = await query.fetchOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }

  @Operation.post()
  Future<Response> create(@Bind.body() Category category) async {
    var owner = User()..id = request.authorization.ownerID;
    category.owner = owner; 

    var result = await Query.insertObject(context, category);
    
    return Response.ok(result);
  }

  @Operation.put("id")
  Future<Response> update(@Bind.path("id") int id, @Bind.body() Category category) async {
    var owner = User()..id = request.authorization.ownerID;
    var query = Query<Category>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(owner.id)
      ..values = category
      ..values.removePropertyFromBackingMap("id");

    var result = await query.updateOne();
    if (result == null) return Response.notFound();

    return Response.ok(result);
  }

  @Operation.delete("id")
  Future<Response> delete(@Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = Query<Category>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    if (await query.delete() > 0) return Response.ok(null);

    return Response.notFound();
  }

}
