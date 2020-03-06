import '../todo.dart';
import '../model/models.dart';

class SessionController extends ResourceController {
  SessionController(this.context, this.authServer);

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAll() async {
    var query =  Query<Session>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID)
      ..sortBy((n) => n.createdAt, QuerySortOrder.ascending);

    query.join(set: (t) => t.activities)
      ..where((a) => a.spent).greaterThan(0);

    return Response.ok(await query.fetch());
  }

  @Operation.get("id")
  Future<Response> get(@Bind.path("id") int id) async {
    var requestingUserID = request.authorization.ownerID;
    var query = new Query<Session>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestingUserID);

    //join tasks -> projects to activities
    var querya = query.join(set: (t) => t.activities)
      ..where((a) => a.spent).greaterThan(0);
    querya.join(object: (a) => a.task)..join(object: (t) => t.project);

    var u = await query.fetchOne();
    if (u == null) {
      return new Response.notFound();
    }

    return new Response.ok(u);
  }

  @Operation.post()
  Future<Response> create(@Bind.body() Session session) async {
    var owner = User()..id = request.authorization.ownerID;
    session.owner = owner; 
    
    var result = await context.transaction((transaction) async {
      // note that 'transaction' is the context for each of these queries.
      var result = await Query.insertObject(transaction, session);
    
      if (session.activities != null) {
        for (var act in session.activities) {
          var aQuery = Query<Activity>(transaction)
            ..where((n) => n.id).equalTo(act.id)
            ..where((n) => n.owner).identifiedBy(owner.id)
            ..values.commited = true
            ..values.session = result;
            
          await aQuery.updateOne();
        }
      }
      return result;
    });

    return Response.ok(result);
  }

  //No update or delete method. No way back! ) atm atleast
}