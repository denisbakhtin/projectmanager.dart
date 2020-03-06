import '../todo.dart';
import '../model/models.dart';

class RegisterController extends QueryController<User> {
  RegisterController(ManagedContext context, this.authServer) : super(context);

  final AuthServer authServer;

  @Operation.post()
  Future<Response> create() async {
    if (query.values.email == null || query.values.password == null) {
      return Response.badRequest(body: {"error": "email and password required."});
    }

    query.values.email = query.values.email.toLowerCase();
    query.values.username = query.values.email;
    
    final salt = AuthUtility.generateRandomSalt();
    final hashedPassword = AuthUtility.generatePasswordHash(query.values.password, salt);

    query.values.hashedPassword = hashedPassword;
    query.values.salt = salt;

    final u = await query.insert();
    final token = await authServer.authenticate(u.email, query.values.password,
        request.authorization.credentials.username, request.authorization.credentials.password);

    return AuthController.tokenResponse(token);
  }
}
