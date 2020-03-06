export 'identity_controller.dart';
export 'register_controller.dart';
export 'task_controller.dart';
export 'comment_controller.dart';
export 'activity_controller.dart';
export 'spent_report_controller.dart';
export 'project_controller.dart';
export 'session_controller.dart';
export 'category_controller.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as path;

//returns file uri
Future<String> saveEncodedFile(String base64string, String name, {int userId}) async {
  var bytes = base64Decode(base64string);
  return await saveFile(bytes, name, userId: userId);
}

//returns file uri
Future<String> saveFile(List<int> bytes, String name, {int userId}) async {
  var dir = await _createUploadSubdir(userId: userId);
  await dir.create(recursive: true);
  var file = File("${dir.path}/$name");
  await file.writeAsBytes(bytes);
  return '/${path.toUri(path.relative(file.path)).path}';
}

Future<Directory> _createUploadSubdir({int userId}) async {
  var dir = Directory.current;
  var uploads = path.join(dir.path, "public", "uploads");
  if (userId != null) uploads = "$uploads/$userId";
  var timestamp = DateTime.now().millisecondsSinceEpoch;
  var d = Directory('$uploads/$timestamp');
  var exists = await d.exists();
  if (exists) {
    //pick a new subdirectory :)
    for (var i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 10));
      timestamp = DateTime.now().millisecondsSinceEpoch;
      d = Directory('$uploads/$timestamp');
      exists = await d.exists();
      if (!exists) break;
    }
  }
  if (exists) throw FileSystemException("Can't create a subdirectory for file upload");
  return d;
}