import 'dart:async';
import '../todo.dart';

class FileDisposition extends Controller {
  Future<RequestOrResponse> handle(Request request) async {
    request.addResponseModifier((response) {
      //this instructs the browser to save the file instead of just viewing it in a tab
      response.headers["Content-Disposition"] = "attachment;filename=" + request.path.segments.last;
    });

    return request;
  }
}