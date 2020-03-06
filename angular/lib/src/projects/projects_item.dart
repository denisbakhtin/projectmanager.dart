import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'projects-item',
  templateUrl: 'projects_item.html',
  directives: [coreDirectives, routerDirectives, EditProjectModalComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class ProjectsItemComponent{
  @Input()
  Project project;
  @Input()
  Function refreshList;

  bool showEditModal = false;
  final Store store;
  String error;
  final Router router;
  final ProjectsService projectsService;
  final HelpersService helpers;

  ProjectsItemComponent(this.store, this.router, this.helpers): projectsService = ProjectsService(store);

  String projectUrl() => RoutePaths.project.toUrl(parameters: {idParam: '${project.id}'});
  String categoryUrl(Category category) => RoutePaths.category.toUrl(parameters: {idParam: '${category.id}'});

  void view() async => await router.navigate(projectUrl());

  void startEdit() async => showEditModal = true;
  void submitEdit() async {
    showEditModal = false;
    if (refreshList != null) refreshList();
  }
  void cancelEdit() => showEditModal = false;

  void delete() async {
    await projectsService.delete(project);
    if (refreshList != null) refreshList();
  }
}