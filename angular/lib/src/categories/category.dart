import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'category',
  templateUrl: 'category.html',
  directives: [coreDirectives, routerDirectives, AttachmentsComponent, ProjectsItemComponent, TasksItemComponent, BreadcrumbComponent, EditTaskModalComponent, EditCategoryModalComponent, TasksItemComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class CategoryComponent implements OnActivate, OnDeactivate {
  Category category;
  final Store store;
  String error;
  final Router router;
  List<StreamSubscription> subscriptions;
  bool showEditModal = false;
  int id;
  final CategoriesService categoriesService;

  CategoryComponent(this.store, this.router): categoriesService = CategoriesService(store);

  void startEdit() => showEditModal = true;
  void submitEdit() {
    showEditModal = false;
    categoriesService.get(id: id);
  }
  void cancelEdit() => showEditModal = false;

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return null;
    }
    id = getId(current.parameters);
    if (id == null) return null;

    subscriptions = [
      categoriesService.listen((p) {
        if (p != null) {
          category = p;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    getCategory();
  }

  void getCategory() => categoriesService..setAssociations(true)..get(id: id);

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());
}