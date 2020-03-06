import 'todo.dart';

import 'controller/controllers.dart';
import 'middleware/middlewares.dart';
import 'model/models.dart';

class AppChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = TodoConfiguration(options.configurationFilePath);
    context = contextWithConnectionInfo(config.database);

    authServer = AuthServer(ManagedAuthDelegate<User>(context));
  }

  @override
  Controller get entryPoint {
    final router = Router();
    router
      .route("/public/*")
      .link(() => FileDisposition())
      .link(() => FileController("public/"));

    /* OAuth 2.0 Resource Owner Grant Endpoint */
    router.route("/auth/token").link(() => AuthController(authServer));

    /* Create an account */
    router
        .route("/register")
        .link(() => Authorizer.basic(authServer))
        .link(() => RegisterController(context, authServer));

    /* Gets profile for user with bearer token */
    router
        .route("/me")
        .link(() => Authorizer.bearer(authServer))
        .link(() => IdentityController(context));

    /* Creates, updates, deletes and gets tasks */
    router
        .route("/tasks/[:id]")
        .link(() => Authorizer(authServer))
        .link(() => TaskController(context, authServer));
    
    /* Creates, updates, deletes and gets task comments */
    router
        .route("/tasks/:task_id/comments/[:id]")
        .link(() => Authorizer(authServer))
        .link(() => CommentController(context, authServer));

    /* Creates, updates, deletes and gets tasks */
    router
        .route("/tasks/:task_id/activities/[:id]")
        .link(() => Authorizer(authServer))
        .link(() => ActivityController(context, authServer));

    /* Creates, updates, deletes and gets tasks */
    router
        .route("/projects/[:id]")
        .link(() => Authorizer(authServer))
        .link(() => ProjectController(context, authServer));

    /* Creates, updates, deletes and gets categories */
    router
        .route("/categories/[:id]")
        .link(() => Authorizer(authServer))
        .link(() => CategoryController(context, authServer));

    /* Shows spent time report */
    router
        .route("/reports/spent")
        .link(() => Authorizer(authServer))
        .link(() => SpentReportController(context, authServer));

    /* Creates, updates, deletes and gets tasks */
    router
        .route("/sessions/[:id]")
        .link(() => Authorizer(authServer))
        .link(() => SessionController(context, authServer));

    router
      .route("/*")
      .link(() => ReroutingFileController("web"));

    return router;
  }

  /*
   * Helper methods
   */

  ManagedContext contextWithConnectionInfo(
    DatabaseConfiguration connectionInfo) {
    var dataModel = new ManagedDataModel.fromCurrentMirrorSystem();
    var psc = new PostgreSQLPersistentStore.fromConnectionInfo(
        connectionInfo.username,
        connectionInfo.password,
        connectionInfo.host,
        connectionInfo.port,
        connectionInfo.databaseName);

    return new ManagedContext(dataModel, psc);
  }
}

class TodoConfiguration extends Configuration{
  TodoConfiguration(String fileName) : super.fromFile(File(fileName));

  DatabaseConfiguration database;
}


class ReroutingFileController extends FileController {
  ReroutingFileController(String directory) : super(directory);

  @override
  Future<RequestOrResponse> handle(Request req) async {
    Response potentialResponse = await super.handle(req);
    final acceptsHTML = req.raw.headers.value(HttpHeaders.acceptHeader).contains("text/html");

    if (potentialResponse.statusCode == 404 && acceptsHTML)  {
        return new Response(302, {
          HttpHeaders.locationHeader: "/",
          "X-JS-Route": req.path.remainingPath
        }, null);
    }

    return potentialResponse;
  }
}