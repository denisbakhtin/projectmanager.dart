import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import '../store.dart';
import '../routes.dart';

@Component(
  selector: 'register-form',
  templateUrl: 'register.html',
  directives: [coreDirectives, formDirectives, routerDirectives, MaterialButtonComponent, NgIf],
  providers: [  ],
  exports: [RoutePaths],
)

class RegisterComponent implements OnInit, OnDestroy {
  @Input()
  Register register = Register();
  final Store store;
  String error;
  final Router router;
  StreamSubscription userSubscription;
  final UserService userService;

  RegisterComponent(this.store, this.router): userService = UserService(store);

  void onSubmit() async {
    //todo: find a better place for validation
    if (register.password != register.repeatPassword) {
      error = "Passwords don't match.";
      return;
    }
    try {
      await userService.register(register.email, register.password);
    } catch (err) {
      error = err.toString();
    }
  }

  @override
  void ngOnInit() {
    userSubscription = userService.listen((user) {
      if (user != null) {
        //navigate
        router.navigate(RoutePaths.tasks.toUrl());
      }
    }, onError: (Object err) {
      error = err.toString();
    });
  }

  @override
  void ngOnDestroy() => userSubscription.cancel();
}

class Register {
  String email, password, repeatPassword;

  Register([this.email, this.password, this.repeatPassword]);
}