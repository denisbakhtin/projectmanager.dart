import '../todo.dart';
import '../model/models.dart';

class IdentityController extends ResourceController {
  IdentityController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> get() async {
    var q = Query<User>(context)
      ..where((u) => u.id).equalTo(request.authorization.ownerID);

    var u = await q.fetchOne();
    if (u == null) {
      return  Response.notFound();
    }

    return Response.ok(u);
  }
}
