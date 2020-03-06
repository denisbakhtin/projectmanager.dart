import 'package:todo/todo.dart';
import 'package:aqueduct/aqueduct.dart';

Future main() async {
  var app = new Application<AppChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8082;
  await app.start();
}