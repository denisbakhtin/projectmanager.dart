import 'dart:async';
import 'package:http/http.dart' as http;
import 'models/models.dart';
import 'dart:convert';
import 'store.dart';

const contentTypeHeader = "Content-Type";
const authorizationHeader = "Authorization";
const jsonContentType = "application/json";
const xwwwContentType = "application/x-www-form-urlencoded";
const baseURL = "http://localhost:8082";

class Request {
  Request.get(this.path) {
    method = "GET";
  }
  Request.post(this.path, this.body, {String contentType}) {
    this.contentType = contentType ?? jsonContentType;
    method = "POST";
  }
  Request.put(this.path, this.body, {String contentType}) {
    this.contentType = contentType ?? jsonContentType;
    method = "PUT";
  }
  Request.delete(this.path) {
    this.contentType = jsonContentType;
    method = "DELETE";
  }

  String get clientAuthorization => "Basic ${new Base64Encoder().convert("com.projectmanager.client:Pr0JektMan@ggEr".codeUnits)}";
  String method;
  String path;
  dynamic body;
  String get contentType => _contentType;
  set contentType(String t) {
    _contentType = t;
    if (_contentType != null) {
      headers[contentTypeHeader] = _contentType;
    }
  }
  String _contentType;
  Map<String, String> headers = {};

  Future<Response> executeClientRequest(Store store) async {
    headers[authorizationHeader] = clientAuthorization;
    return executeRequest(store);
  }

  Future<Response> executeUserRequest(Store store, {AuthorizationToken token}) async {
    AuthorizationToken t = token ?? store.authenticatedUser?.token;

    if (t?.isExpired ?? true) {
      throw new UnauthenticatedException();
    }

    headers[authorizationHeader] = t.authorizationHeaderValue;
    var response = await executeRequest(store);

    if (response.statusCode == 401) {
      // Refresh the token, try again
    }

    return response;
  }

  Future<Response> executeRequest(Store store) async {
    try {
      if (body != null) {
        if (contentType.contains(jsonContentType)) {
          body = json.encode(body);
        } else if (contentType.contains(xwwwContentType)) {
          body = (body as Map<String, String>).keys.map((k) => "$k=${Uri.encodeQueryComponent(body[k])}").join("&");
        }
      }
      if (method == "GET")
        return new Response.fromHTTPResponse(
            await http.get(baseURL + path, headers: headers));
      else if (method == "POST")
        return new Response.fromHTTPResponse(
          await http.post(baseURL + path, headers: headers, body: body));
      else if (method == "PUT")
        return new Response.fromHTTPResponse(
          await http.put(baseURL + path, headers: headers, body: body));
      else if (method == "DELETE")
        return new Response.fromHTTPResponse(
          await http.delete(baseURL + path, headers: headers));
      else
        throw 'Unsupported HTTP method';
    } catch (e) {
      return new Response.failed(e);
    }
  }
}

class Response {
  Response.fromHTTPResponse(http.Response response) {
    statusCode = response.statusCode;

    var contentType = response.headers["content-type"];
    if (contentType?.contains(jsonContentType) ?? false) {
      body = json.decode(response.body);
    }
  }

  Response.failed(this.error);

  int statusCode;
  dynamic body;
  Object error;
}

class UnauthenticatedException implements Exception {}

class APIError {
  APIError(this.reason) {
    reason ??= "Unknown failure";
  }

  String reason;

  @override
  String toString() => reason;
}