import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';


@Component(
  selector: 'login-form',
  templateUrl: 'login.html',
  directives: [coreDirectives, formDirectives, routerDirectives, MaterialButtonComponent, NgIf],
  providers: [ ],
  exports: [RoutePaths],
)

class LoginComponent implements OnInit, OnDestroy {
  @Input()
  Login login = Login("admin@admin.com", "admin");
  final Store store;
  String error;
  final Router router;
  final UserService userService;
  StreamSubscription userSubscription;
  User user;

  LoginComponent(this.store, this.router) : userService = UserService(store);

  void onSubmit() async {
    try {
      await userService.login(login.email, login.password);
    } catch (err) {
      error = err.toString();
    }
  }

  @override
  void ngOnInit() {
    //as well checks if key is not expired
    if (store.isAuthenticated)
      user = store.authenticatedUser;

    userSubscription = userService.listen((u) {
      if (u != null) {
        var returnUrl = window.sessionStorage["returnUrl"];
        window.sessionStorage.remove("returnUrl");
        if (returnUrl != null)
          router.navigateByUrl(returnUrl);
        else
          router.navigate(RoutePaths.tasks.toUrl());
        user = u;
      }
    }, onError: (Object err) {
      error = err.toString();
    });
  }

  @override
  void ngOnDestroy() => userSubscription.cancel();
}

class Login {
  String email, password;

  Login([this.email, this.password]);
}