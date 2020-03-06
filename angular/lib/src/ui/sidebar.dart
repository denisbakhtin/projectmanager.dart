import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import '../routes.dart';

@Component(
  selector: 'sidebar',
  templateUrl: 'sidebar.html',
  directives: [coreDirectives, routerDirectives, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class SidebarComponent {
  SidebarComponent();
}