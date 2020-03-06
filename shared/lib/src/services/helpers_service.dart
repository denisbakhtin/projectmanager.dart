import 'package:intl/intl.dart';
import 'package:projectmanager_shared/src/models/models.dart';
import '../http.dart';

class HelpersService {
  String dateString(DateTime d) {
    var formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(d);
  }

  String absoluteFileUri(String uri) {
    return baseURL + uri;
  }

  String splitCamelCase(String src) {
    // Single character look-ahead for capital letter.
    final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
    var parts = src.split(beforeCapitalLetter);
    return parts.join(" ");
  }

  String humanPriority(Priority value) => splitCamelCase(enumToString(value));
  
  String classPriority(Priority value) => enumToString(value);
}