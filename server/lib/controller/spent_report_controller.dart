import '../todo.dart';
import '../model/models.dart';

class SpentReportController extends ResourceController {
  SpentReportController(this.context, this.authServer);

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAll() async {
    var query =  Query<Project>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID)
      ..sortBy((t) => t.id, QuerySortOrder.ascending);
    var tasksq = query.join(set: (p) => p.tasks)
      ..sortBy((t) => t.id, QuerySortOrder.ascending);
    tasksq.join(set: (t) => t.activities)
      ..where((a) => a.commited).equalTo(false)
      ..where((a) => a.spent).greaterThan(0);

    var result = await query.fetch();
    result = result.where((p) => p.spent > 0).toList();
    for (var p in result) {
      p.tasks.removeWhere((t) => t.spent == 0);
    }
    return Response.ok(result);
  }
}
