import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';
import '../http.dart';

class UserService extends ServiceController<User> {
  UserService(this.store): super(store);

  Store store;

  void logout() {
    store.authenticatedUser = null;
    add(null);
  }

  Future<User> login(String email, String password) async {
    var req = new Request.post("/auth/token", {
      "username": email, //required by aqueduct, no dedicated email field
      "password": password,
      "grant_type": "password"
    }, contentType: xwwwContentType);

    var response = await req.executeClientRequest(store);
    if (response.error != null) {
      addError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: return getAuthenticatedUser(token: new AuthorizationToken.fromMap(response.body));
      default: addError(new APIError(response.body["error"]));
    }

    return null;
  }

  Future<User> register(String email, String password) async {
    var req = new Request.post(
        "/register", {"email": email, "password": password});

    var response = await req.executeClientRequest(store);
    if (response.error != null) {
      addError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: return getAuthenticatedUser(token: new AuthorizationToken.fromMap(response.body));
      case 409: addError(new APIError("User already exists")); break;
      default: addError(new APIError(response.body["error"]));
    }

    return null;
  }

  Future<User> getAuthenticatedUser({AuthorizationToken token}) async {
    var req = new Request.get("/me");
    var response = await req.executeUserRequest(store, token: token);

    if (response.error != null) {
      addError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: {
        var user = new User.fromMap(response.body)
          ..token = token;
        add(user);
        store.authenticatedUser = user;

        return user;
      } break;

      default: addError(new APIError(response.body["error"]));
    }

    return null;
  }
}