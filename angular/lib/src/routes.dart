import 'package:angular_router/angular_router.dart';

import 'auth/login.template.dart' as login_template;
import 'auth/logout.template.dart' as logout_template;
import 'auth/register.template.dart' as register_template;
import 'tasks/tasks.template.dart' as tasks_template;
import 'tasks/task.template.dart' as task_template;
import 'projects/projects.template.dart' as projects_template;
import 'projects/project.template.dart' as project_template;
import 'reports/spent.template.dart' as spent_report_template;
import 'not_found_component.template.dart' as not_found_template;
import 'sessions/sessions.template.dart' as sessions_template;
import 'sessions/session.template.dart' as session_template;
import 'sessions/new_session.template.dart' as new_session_template;
import 'categories/categories.template.dart' as categories_template;
import 'categories/category.template.dart' as category_template;
import 'route_paths.dart';

export 'route_paths.dart'; 

class Routes {
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.LoginComponentNgFactory,
  );
  static final register = RouteDefinition(
    routePath: RoutePaths.register,
    component: register_template.RegisterComponentNgFactory,
  );
  static final logout = RouteDefinition(
    routePath: RoutePaths.logout,
    component: logout_template.LogoutComponentNgFactory,
  );

  static final tasks = RouteDefinition(
    routePath: RoutePaths.tasks,
    component: tasks_template.TasksComponentNgFactory,
  );

  static final task = RouteDefinition(
    routePath: RoutePaths.task,
    component: task_template.TaskComponentNgFactory,
  );

  static final projects = RouteDefinition(
    routePath: RoutePaths.projects,
    component: projects_template.ProjectsComponentNgFactory,
  );

  static final project = RouteDefinition(
    routePath: RoutePaths.project,
    component: project_template.ProjectComponentNgFactory,
  );

  static final spentReport = RouteDefinition(
    routePath: RoutePaths.spentReport,
    component: spent_report_template.SpentComponentNgFactory,
  );

  static final sessions = RouteDefinition(
    routePath: RoutePaths.sessions,
    component: sessions_template.SessionsComponentNgFactory,
  );

  static final session = RouteDefinition(
    routePath: RoutePaths.session,
    component: session_template.SessionComponentNgFactory,
  );

  static final newSession = RouteDefinition(
    routePath: RoutePaths.newSession,
    component: new_session_template.NewSessionComponentNgFactory,
  );

  static final categories = RouteDefinition(
    routePath: RoutePaths.categories,
    component: categories_template.CategoriesComponentNgFactory,
  );

  static final category = RouteDefinition(
    routePath: RoutePaths.category,
    component: category_template.CategoryComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    login,
    register,
    logout,
    tasks,
    task,
    spentReport,
    projects,
    project,
    sessions,
    session,
    newSession,
    categories,
    category,
    RouteDefinition(
      path: '.*',
      component: not_found_template.NotFoundComponentNgFactory,
    ),
  ];
}
