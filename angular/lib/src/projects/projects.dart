import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'projects',
  templateUrl: 'projects.html',
  directives: [coreDirectives, routerDirectives, ProjectsItemComponent, BreadcrumbComponent, EditProjectModalComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class ProjectsComponent implements OnActivate, OnDeactivate {
  List<Project> projects = [];
  final Store store;
  String error;
  final Router router;
  Project project;
  bool showCreateModal = false;
  bool showEditModal = false;
  List<StreamSubscription> subscriptions = [];
  final ProjectsService projectsService;
  final HelpersService helpers;

  ProjectsComponent(this.store, this.router, this.helpers): projectsService = ProjectsService(store);

  void startCreate() {
    showCreateModal = true;
  }

  void submitCreate() {
    showCreateModal = false;
    projectsService.getList();
  }

  void cancelCreate() {
    showCreateModal = false;
  }

  void startEdit(Project p) {
    project = p;
    showEditModal = true;
  }

  void submitEdit() {
    showEditModal = false;
    projectsService.getList();
  }

  void cancelEdit() {
    showEditModal = false;
  }

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return null;
    }
    subscriptions = [
      projectsService.listenList((list) {
        if (list != null) {
          projects = list;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),

      projectsService.listen((proj) {
        //project has been deleted
        if (proj == null) {
          projectsService.getList(); //refresh the list
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    projectsService.getList();
  }

  @override
  void onDeactivate(RouterState current, _) {
    subscriptions?.forEach((s) => s.cancel());
  }

  void view(Project proj) async {
    await router.navigate(RoutePaths.project.toUrl(parameters: {idParam: '${proj.id}'}));
  }

  void delete(Project proj) async {
    await projectsService.delete(proj);
  }

  String projectUrl(Project project) => RoutePaths.project.toUrl(parameters: {idParam: '${project.id}'});
  String categoryUrl(Category category) => RoutePaths.category.toUrl(parameters: {idParam: '${category.id}'});
}