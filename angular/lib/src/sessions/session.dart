import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import 'dart:collection';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'session',
  templateUrl: 'session.html',
  directives: [coreDirectives, routerDirectives, BreadcrumbComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class SessionComponent implements OnActivate, OnDeactivate {
  Session session;
  List<Project> projects = []; //session activities grouped by projects->tasks->activities
  final Store store;
  String error;
  final Router router;
  int id;
  List<StreamSubscription> subscriptions = [];
  final SessionsService sessionsService;
  final HelpersService helpers;

  SessionComponent(this.store, this.router, this.helpers): sessionsService = SessionsService(store);

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return null;
    }
    id = getId(current.parameters);
    if (id == null) return null;
    subscriptions = [
      sessionsService.listen((c) {
        if (c != null) {
          session = c;
          var tasks = groupByTasks(session.activities);
          tasks.forEach((t) => t.calcSpentTotal());
          projects = groupByProjects(tasks);
          projects.forEach((p) => p.calcSpentTotal());
          print("projects.length = ${projects.length}");
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];

    sessionsService.get(id: id);
  }

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());

  String taskUrl(Task t) => RoutePaths.task.toUrl(parameters: {idParam: '${t.id}'});
  String projectUrl(Project p) => RoutePaths.project.toUrl(parameters: {idParam: '${p.id}'});

  List<Task> groupByTasks(List<Activity> activities) {
    //HashSet uses overriden equality operator & hashCode
    HashSet<Task> tasks = HashSet();
    for (var a in activities) {
      if (tasks.contains(a.task)) {
        var task = tasks.lookup(a.task);
        task.activities.add(a);
        tasks.add(task);
      } else {
        a.task.activities.add(a);
        tasks.add(a.task);
      }
    }
    return tasks.toList();
  }

  List<Project> groupByProjects(List<Task> tasks) {
    //HashSet uses overriden equality operator & hashCode
    HashSet<Project> projects = HashSet();
    for (var t in tasks) {
      if (projects.contains(t.project)) {
        var project = projects.lookup(t.project);
        project.tasks.add(t);
        projects.add(project);
      } else {
        t.project.tasks.add(t);
        projects.add(t.project);
      }
    }
    return projects.toList();
  }
}