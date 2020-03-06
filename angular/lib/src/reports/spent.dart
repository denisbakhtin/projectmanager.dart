import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'spent-report',
  templateUrl: 'spent.html',
  directives: [coreDirectives, routerDirectives, BreadcrumbComponent, MaterialIconComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error :)
  exports: [RoutePaths, Routes],
)

class SpentComponent implements OnActivate, OnDeactivate {
  List<Project> projects = [];
  final Store store;
  String error;
  List<StreamSubscription> subscriptions = [];
  final SpentReportService spentReportService;
  final Router router;
  TaskDuration spentTotal = TaskDuration(minutes: 0);

  SpentComponent(this.store, this.router): spentReportService = SpentReportService(store);

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
}