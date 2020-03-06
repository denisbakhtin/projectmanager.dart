import 'package:angular/angular.dart';
import 'src/store.dart';
import 'package:angular_router/angular_router.dart';
import 'src/routes.dart';
import 'src/tasks/active_task.dart';
import 'src/ui/sidebar.dart';

@Component(
  selector: 'pm-app',
  templateUrl: 'app_component.html',
  directives: [routerDirectives, SidebarComponent, ActiveTaskComponent, NgIf],
  providers: [
    ClassProvider(ActivityService), ClassProvider(HelpersService)
  ],
  exports: [RoutePaths, Routes],
)

@Injectable()
class AppComponent {
  final Router router;
  final Store store;

  AppComponent(this.store, this.router);
}