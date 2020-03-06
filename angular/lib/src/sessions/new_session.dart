import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'new-session',
  templateUrl: 'new_session.html',
  directives: [coreDirectives, routerDirectives, BreadcrumbComponent, MaterialToggleComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class NewSessionComponent implements OnActivate, OnDeactivate {
  List<Project> projects = [];
  Session session = Session()..activities = [];
  List<Task> commitedTasks = [];
  final Store store;
  String error;
  final Router router;
  int id;
  List<StreamSubscription> subscriptions = [];
  final SessionsService sessionsService;
  final SpentReportService spentReportService;
  final HelpersService helpers;
  TaskDuration spentTotal = TaskDuration(minutes: 0);

  NewSessionComponent(this.store, this.router, this.helpers): sessionsService = SessionsService(store), spentReportService = SpentReportService(store);

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return null;
    }
    subscriptions = [
      spentReportService.listenList((list) {
        if (list != null) {
          projects = list;
          projects.forEach((p) => spentTotal += p.spentTotal);
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];

    spentReportService.getList();
  }

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());

  String taskUrl(Task t) => RoutePaths.task.toUrl(parameters: {idParam: '${t.id}'});
  String projectUrl(Project p) => RoutePaths.project.toUrl(parameters: {idParam: '${p.id}'});

  //toggle commit on task
  void commitTask(Task t) {
    commitedTasks.add(t);
    session.activities.addAll(t.activities);
  }
  void uncommitTask(Task t) {
    commitedTasks.removeWhere((r) => r == t);
    session.activities.removeWhere((r) => r.task.id == t.id);
  }

  //toggle commit on whole project
  void commitProject(Project p) {
    //firsly uncommit all manually commited tasks
    uncommitProject(p);
    commitedTasks.addAll(p.tasks);
    session.activities.addAll(p.tasks.map((t) => t.activities).expand((a) => a).toList());
  }
  void uncommitProject(Project p) {
    commitedTasks.removeWhere((r) => p.tasks.contains(r));
    session.activities.removeWhere((r) => p.tasks.firstWhere((t) => t.id == r.task.id, orElse: () => null) != null); //refuses to check with p.tasks.contains(r.task)...
  }

  void onTaskToggle(Task t, bool checked) => (checked) ? commitTask(t) : uncommitTask(t);
  void onProjectToggle(Project p, bool checked) => (checked) ? commitProject(p) : uncommitProject(p);

  TaskDuration commitedByProject(Project p) {
    TaskDuration spent = TaskDuration();
    session.activities
      .where((a) => p.tasks.firstWhere((t) => t.id == a.task.id, orElse: () => null) != null)
      ?.forEach((a) => spent += a.spent);
    return spent;
  }

  bool taskIsCommited(Task t) => session.activities.firstWhere((a) => a.task.id == t.id, orElse: () => null) != null;
  bool projectIsCommited(Project p) => !p.tasks.any((t) => session.activities.firstWhere((a) => a.task.id == t.id, orElse: () => null) == null);

  void submit() async {
    try {
      await sessionsService.create(session);
      await router.navigate(RoutePaths.sessions.toUrl());
    } catch (err) {
      error = err.toString();
    }
  }
}
