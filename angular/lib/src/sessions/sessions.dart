import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'sessions',
  templateUrl: 'sessions.html',
  directives: [coreDirectives, routerDirectives, BreadcrumbComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class SessionsComponent implements OnActivate, OnDeactivate {
  List<Session> sessions = [];
  final Store store;
  String error;
  final Router router;
  List<StreamSubscription> subscriptions = [];
  final SessionsService sessionsService;
  final HelpersService helpers;

  SessionsComponent(this.store, this.router, this.helpers): sessionsService = SessionsService(store);

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return null;
    }
    subscriptions = [
      sessionsService.listenList((list) {
        if (list != null) {
          sessions = list;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    sessionsService.getList();
  }

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());

  void gotoCreate() async => await router.navigate(RoutePaths.newSession.toUrl());
  String sessionUrl(Session session) => RoutePaths.session.toUrl(parameters: {idParam: '${session.id}'});
}