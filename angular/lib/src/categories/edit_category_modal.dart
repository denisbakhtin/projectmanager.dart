import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'edit-category-modal',
  templateUrl: 'edit_category_modal.html',
  directives: [coreDirectives, formDirectives, AttachmentsComponent, routerDirectives, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class EditCategoryModalComponent implements OnInit, OnDestroy {
  @Input()
  int id;
  @Input()
  Function onSubmitCallback;
  @Input()
  Function onCancelCallback;

  Category category;
  final Store store;
  String error;
  bool isNew = true;
  final Router router;
  List<StreamSubscription> subscriptions;
  final CategoriesService categoriesService;

  EditCategoryModalComponent(this.store, this.router): categoriesService = CategoriesService(store);

  @override
  void ngOnInit() {
    subscriptions = [
      categoriesService.listen((p) {
        if (p != null) {
          category = p;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];

    isNew = (id == null);
    if (isNew) {
      category = Category();
    } else {
      categoriesService.get(id: id);
    }
  }

  @override
  void ngOnDestroy() => subscriptions?.forEach((s) => s.cancel());

  void onSubmit() async {
    try {
      if (isNew)
        await categoriesService.create(category);
      else
        await categoriesService.update(category);
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