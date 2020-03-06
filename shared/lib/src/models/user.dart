import 'models.dart';

class User {
  User();

  int id;
  String email;
  List<Task> tasks = [];
  List<Comment> comments = [];
  AuthorizationToken token;

  bool get isAuthenticated => token != null && !token.isExpired;

  User.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    email = map["email"];

    if (map.containsKey("token")) {
      token = AuthorizationToken.fromMap(map["token"]);
    }
  }
  Map<String, dynamic> asMap() =>
    {
      "id": id,
      "email": email,
      "token": token.asMap()
    };
}