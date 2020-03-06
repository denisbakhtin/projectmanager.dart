import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'project',
  templateUrl: 'project.html',
  directives: [coreDirectives, routerDirectives, AttachmentsComponent, BreadcrumbComponent, EditTaskModalComponent, EditProjectModalComponent, TasksItemComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class ProjectComponent implements OnActivate, OnDeactivate {
  Project project;
  final Store store;
  String error;
  final Router router;
  List<StreamSubscription> subscriptions;
  bool showCreateModal = false;
  bool showEditModal = false;
  int id;
  final ProjectsService projectsService;
  final TasksService tasksService;

  ProjectComponent(this.store, this.router): 
    projectsService = ProjectsService(store), tasksService = TasksService(store);

  void startCreate() => showCreateModal = true;
  void submitCreate() {
    showCreateModal = false;
    tasksService
      ..setProjectId(project.id)
      ..getList();
  }
  void cancelCreate() => showCreateModal = false;

  void startEdit() => showEditModal = true;
  void submitEdit() {
    showEditModal = false;
    projectsService.get(id: id);
  }
  void cancelEdit() => showEditModal = false;

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return null;
    }
    id = getId(current.parameters);
    if (id == null) return null;
    tasksService.setProjectId(id);

    subscriptions = [
      projectsService.listen((p) {
        if (p != null) {
          project = p;
          //project is ready, it's safe to fetch tasks
          tasksService.getList(); 
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
      tasksService.listenList((list) {
        if (list != null) {
          project.tasks = list;
          project.calcSpentTotal();
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    projectsService.get(id: id);
  }

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());
  String categoryUrl(Category category) => RoutePaths.category.toUrl(parameters: {idParam: '${category.id}'});
}