import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import '../store.dart';
import '../routes.dart';

@Component(
  selector: 'logout-form',
  templateUrl: 'logout.html',
  directives: [coreDirectives],
  providers: [],
  exports: [RoutePaths],
)

class LogoutComponent implements OnActivate {
  final Store store;
  final Router router;
  final UserService userService;

  LogoutComponent(this.store, this.router): userService = UserService(store);

  @override
  void onActivate(_, RouterState current) async {
    await userService.logout();
    await router.navigate(RoutePaths.login.toUrl());
  }
}