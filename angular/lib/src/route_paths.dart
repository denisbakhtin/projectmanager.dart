import 'package:angular_router/angular_router.dart';

const idParam = 'id';

class RoutePaths {
  static final login = RoutePath(path: 'login');
  static final logout = RoutePath(path: 'logout');
  static final register = RoutePath(path: 'register');
  static final tasks = RoutePath(path: 'tasks');
  static final task = RoutePath(path: '${tasks.path}/:$idParam');
  static final taskComments = RoutePath(path: 'task_comments');
  static final spentReport = RoutePath(path: 'reports/spent');
  static final projects = RoutePath(path: 'projects');
  static final project = RoutePath(path: '${projects.path}/:$idParam');
  static final sessions = RoutePath(path: 'sessions');
  static final session = RoutePath(path: '${sessions.path}/:$idParam');
  static final newSession = RoutePath(path: 'new_session');
  static final categories = RoutePath(path: 'categories');
  static final category = RoutePath(path: '${categories.path}/:$idParam');
}

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}