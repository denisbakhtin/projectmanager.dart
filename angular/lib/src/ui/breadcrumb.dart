import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import '../store.dart';
import '../routes.dart';

@Component(
  selector: 'breadcrumb',
  templateUrl: 'breadcrumb.html',
  directives: [coreDirectives, routerDirectives, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class BreadcrumbComponent implements OnInit {
  @Input()
  Task task;
  @Input()
  Project project;
  @Input()
  Session session;
  @Input()
  Category category;
  @Input()
  String section; //Top level section, e.g. Tasks, Reports, Projects. Only Home is the parent.

  List<Breadcrumb> breadcrumbs;

  BreadcrumbComponent();

  @override
  void ngOnInit() {
    if (task != null) {
      breadcrumbs = [
        Breadcrumb("Home", "//"),
        Breadcrumb("Projects", RoutePaths.projects.toUrl()),
        if (task.project != null) Breadcrumb(task.project.title, RoutePaths.project.toUrl(parameters: {idParam: '${task.project.id}'})),
        Breadcrumb(task.contents, ""),
      ];
    }
    if (project != null) {
      breadcrumbs = [
        Breadcrumb("Home", "//"),
        Breadcrumb("Projects", RoutePaths.projects.toUrl()),
        Breadcrumb(project.title, ""),
      ];
    }
    if (session != null) {
      breadcrumbs = [
        Breadcrumb("Home", "//"),
        Breadcrumb("Sessions", RoutePaths.sessions.toUrl()),
        Breadcrumb("Session #${session.id}", ""),
      ];
    }
    if (category != null) {
      breadcrumbs = [
        Breadcrumb("Home", "//"),
        Breadcrumb("Categories", RoutePaths.categories.toUrl()),
        Breadcrumb(category.title, ""),
      ];
    }
    if (section != null) {
      breadcrumbs = [
        Breadcrumb("Home", "//"),
        Breadcrumb(section, ""),
      ];
    }
  }
}

class Breadcrumb {
  final String title;
  final String url;
  Breadcrumb(this.title, this.url);
}