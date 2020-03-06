import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'edit-project-modal',
  templateUrl: 'edit_project_modal.html',
  directives: [coreDirectives, formDirectives, AttachmentsComponent, routerDirectives, MaterialDropdownSelectComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class EditProjectModalComponent implements OnInit, OnDestroy {
  @Input()
  int id;
  @Input()
  Function onSubmitCallback;
  @Input()
  Function onCancelCallback;

  Project project;
  List<Category> categories = [];
  final Store store;
  String error;
  bool isNew = true;
  final Router router;
  String get dropdownText => project?.category?.title ?? "Select category...";
  List<StreamSubscription> subscriptions;
  final ProjectsService projectsService;
  final CategoriesService categoriesService;

  EditProjectModalComponent(this.store, this.router): projectsService = ProjectsService(store), categoriesService = CategoriesService(store);

  @override
  void ngOnInit() {
    subscriptions = [
      projectsService.listen((p) {
        if (p != null) {
          project = p;
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
      project = Project();
    } else {
      projectsService.get(id: id);
    }
    categoriesService.getList();
  }

  @override
  void ngOnDestroy() => subscriptions?.forEach((s) => s.cancel());

  void onSubmit() async {
    try {
      if (isNew)
        await projectsService.create(project);
      else
        await projectsService.update(project);
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