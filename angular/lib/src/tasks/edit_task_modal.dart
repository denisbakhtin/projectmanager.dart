import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:async';
import '../store.dart';
import '../components.dart';

@Component(
  selector: 'edit-task-modal',
  templateUrl: 'edit_task_modal.html',
  directives: [coreDirectives, formDirectives, AutoFocusDirective, AttachmentsComponent, MaterialRadioComponent,
    MaterialRadioGroupComponent, MaterialDropdownSelectComponent, MaterialButtonComponent, NgIf, NgModel],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [Priority],
)

class EditTaskModalComponent implements OnInit, OnDestroy {
  @Input()
  int id;
  //predefined project id, when task is created via project page
  @Input()
  int projectId;
  @Input()
  Function onSubmitCallback;
  @Input()
  Function onCancelCallback;
  
  Task task;
  bool isNew = true;
  List<Project> projects = [];
  List<Category> categories = [];
  final Store store;
  String error;
  String get dropdownText => task?.project?.title ?? "Select project...";
  String get categoryDropdownText => task?.category?.title ?? "Select category...";
  List<StreamSubscription> subscriptions;
  final ProjectsService projectsService;
  final TasksService tasksService;
  final CategoriesService categoriesService;
  final HelpersService helpers;

  EditTaskModalComponent(this.store, this.helpers): projectsService = ProjectsService(store), tasksService = TasksService(store), categoriesService = CategoriesService(store);

  void ngOnInit() {
    subscriptions = [
      projectsService.listenList((list) {
        if (list != null) {
          projects = list;
          if (projectId != null && isNew)
            task.project = projects.firstWhere((p) => p.id == projectId);
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
      tasksService.listen((t) {
        if (t != null) {
          task = t;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
      categoriesService.listenList((list) {
        if (list != null) {
          categories = list;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];

    isNew = (id == null);
    if (isNew) {
      task = Task();
    } else {
      tasksService.get(id: id);
    }
    projectsService.getList();
    categoriesService.getList();
  }

  @override
  void ngOnDestroy() => subscriptions?.forEach((s) => s.cancel());

  void onSubmit() async {
    try {
      if (isNew)
        await tasksService.create(task);
      else
        await tasksService.update(task);
      if (onSubmitCallback != null)
        onSubmitCallback();
    } catch (err) {
      error = err.toString();
    }
  }

  void onCancel() async {
    if (onCancelCallback != null)
      onCancelCallback();
  }

  @HostListener('keydown.escape', ['\$event'])
  void onEscape(event) => onCancel();

  @HostListener('keydown.shift.enter', ['\$event'])
  void onShiftEnter(event) => onSubmit();
}