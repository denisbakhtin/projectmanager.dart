import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import '../store.dart';
import '../routes.dart';

@Component(
  selector: 'active-task',
  templateUrl: 'active_task.html',
  directives: [coreDirectives, MaterialIconComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error :)
  exports: [RoutePaths, Routes],
)

class ActiveTaskComponent implements OnInit, OnDestroy {
  Activity activity;
  final Store store;
  final Router router;
  String error;
  List<StreamSubscription> subscriptions;
  final ActivityService activityService;

  ActiveTaskComponent(this.store, this.router, this.activityService);

  void view() async => await router.navigate(_taskUrl(activity.task.id));
  String _taskUrl(int id) => RoutePaths.task.toUrl(parameters: {idParam: '$id'});

  void stop() async {
    try {
      activityService.stop();
    } catch (err) {
      error = err.toString();
    }
  }

  @override
  void ngOnInit() async {
    subscriptions = [
      activityService.listen((a) {
        activity = a;
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
  }

  @override
  void ngOnDestroy() => subscriptions?.forEach((s) => s.cancel());
}