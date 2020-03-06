import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'tasks-item',
  templateUrl: 'tasks_item.html',
  directives: [coreDirectives, routerDirectives, EditCommentModalComponent, EditTaskModalComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class TasksItemComponent{
  @Input()
  Task task;
  @Input()
  Function refreshList;

  bool showEditModal = false;
  bool showCreateCommentModal = false;
  bool showCreateSolutionModal = false;
  final Store store;
  String error;
  final Router router;
  final TasksService tasksService;
  final CommentsService commentsService;
  final ActivityService activityService;
  final HelpersService helpers;

  TasksItemComponent(this.store, this.router, this.activityService, this.helpers): 
    tasksService = TasksService(store), commentsService = CommentsService(store);

  String taskUrl() => RoutePaths.task.toUrl(parameters: {idParam: '${task.id}'});
  String categoryUrl(Category category) => RoutePaths.category.toUrl(parameters: {idParam: '${category.id}'});

  void view() async => await router.navigate(taskUrl());

  void startEdit() async => showEditModal = true;
  void submitEdit() async {
    showEditModal = false;
    if (refreshList != null) refreshList();
  }
  void cancelEdit() => showEditModal = false;

  void startCreateComment() async => showCreateCommentModal = true;
  void submitCreateComment() async {
    showCreateCommentModal = false;
    if (refreshList != null) refreshList();
  }
  void cancelCreateComment() => showCreateCommentModal = false;

  void startSolutionComment() async => showCreateSolutionModal = true;
  void submitSolutionComment() async {
    showCreateSolutionModal = false;
    task.completed = true;
    try {
      await tasksService.update(task);
      if (refreshList != null) refreshList();
    } catch (err) {
      error = err.toString();
    }
  }
  void cancelSolutionComment() => showCreateSolutionModal = false;

  void delete() async {
    await tasksService.delete(task);
    if (refreshList != null) refreshList();
  }

  void run() async {
    try {
      activityService.run(task, onStop: refreshList);
    } catch (err) {
      error = err.toString();
    }
  }
}