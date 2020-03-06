import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'tasks',
  templateUrl: 'tasks.html',
  directives: [coreDirectives, routerDirectives, BreadcrumbComponent, EditTaskModalComponent, TasksItemComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class TasksComponent implements OnActivate, OnDeactivate {
  List<Task> tasks = [];
  final Store store;
  String error;
  List<StreamSubscription> subscriptions = [];
  final TasksService tasksService;
  bool showCreateModal = false;
  final Router router;

  TasksComponent(this.store, this.router): tasksService = TasksService(store);

  void startCreate() => showCreateModal = true;
  void submitCreate() {
    showCreateModal = false;
    tasksService.getList();
  }
  void cancelCreate() => showCreateModal = false;

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return;
    }
    subscriptions = [
      tasksService.listenList((list) {
        if (list != null) {
          tasks = list;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    tasksService.getList();
  }

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());
}