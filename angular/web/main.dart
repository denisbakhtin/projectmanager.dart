import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:projectmanager/app_component.template.dart' as ng;
import 'package:projectmanager/src/store.dart';

import 'main.template.dart' as self;

const useHashLS = false;


@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  FactoryProvider(Store, storeFactory),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}

