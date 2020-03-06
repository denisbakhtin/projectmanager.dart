import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'task',
  templateUrl: 'task.html',
  directives: [coreDirectives, routerDirectives, AttachmentsComponent, BreadcrumbComponent, EditTaskModalComponent, CommentsComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class TaskComponent implements OnActivate, OnDeactivate {
  Task task;
  final Store store;
  String error;
  bool showEditModal = false;
  int id;
  final Router router;
  List<StreamSubscription> subscriptions = [];
  final TasksService tasksService;
  final ActivityService activityService;

  TaskComponent(this.store, this.router, this.activityService): tasksService = TasksService(store);

  void startEdit() async => showEditModal = true;
  void submitEdit() async {
    showEditModal = false;
    tasksService.get(id: id);
  }
  void cancelEdit() => showEditModal = false;

  void delete() async {
    await tasksService.delete(task);
    window.history.back();
  }

  void run() async {
    try {
      activityService.run(task, onStop: () => tasksService.get(id: task.id));
    } catch (err) {
      error = err.toString();
    }
  }

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
      tasksService.listen((t) {
        if (t != null) {
          task = t;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    tasksService.get(id: id);
  }

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());
  String categoryUrl(Category category) => RoutePaths.category.toUrl(parameters: {idParam: '${category.id}'});
}