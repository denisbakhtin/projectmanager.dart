class AuthorizationToken {
  String accessToken;
  String refreshToken;
  DateTime expiresAt;
  String get authorizationHeaderValue => "Bearer $accessToken";
  bool get isExpired =>
    expiresAt.difference(DateTime.now()).inSeconds < 0;

  AuthorizationToken.fromMap(Map<String, dynamic> map) {
    accessToken = map["access_token"];
    refreshToken = map["refresh_token"];

    if (map.containsKey("expires_in")) {
      expiresAt = DateTime.now().add(Duration(seconds: map["expires_in"]));
    } else if (map.containsKey("expiresAt")) {
      expiresAt = DateTime.parse(map["expiresAt"]);
    }
  }
  Map<String, dynamic> asMap() =>
      {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "expiresAt": expiresAt.toIso8601String()
      };
}