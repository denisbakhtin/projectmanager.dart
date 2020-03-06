import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:html';
import 'dart:async';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'categories',
  templateUrl: 'categories.html',
  directives: [coreDirectives, routerDirectives, BreadcrumbComponent, EditCategoryModalComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class CategoriesComponent implements OnActivate, OnDeactivate {
  List<Category> categories = [];
  final Store store;
  String error;
  final Router router;
  Category category;
  bool showCreateModal = false;
  bool showEditModal = false;
  List<StreamSubscription> subscriptions = [];
  final CategoriesService categoriesService;
  final HelpersService helpers;

  CategoriesComponent(this.store, this.router, this.helpers): categoriesService = CategoriesService(store);

  void startCreate() => showCreateModal = true;
  void submitCreate() {
    showCreateModal = false;
    categoriesService.getList();
  }
  void cancelCreate() => showCreateModal = false;

  void startEdit(Category c) {
    category = c;
    showEditModal = true;
  }

  void submitEdit() {
    showEditModal = false;
    categoriesService.getList();
  }

  void cancelEdit() => showEditModal = false;

  @override
  void onActivate(_, RouterState current) async {
    if (!store.isAuthenticated) {
      window.sessionStorage["returnUrl"] = current.path;
      await router.navigate(RoutePaths.login.toUrl());
      return null;
    }
    subscriptions = [
      categoriesService.listenList((list) {
        if (list != null) {
          categories = list;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),

      categoriesService.listen((cat) {
        //category has been deleted
        if (cat == null) {
          categoriesService.getList(); //refresh the list
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    categoriesService.getList();
  }

  @override
  void onDeactivate(RouterState current, _) => subscriptions?.forEach((s) => s.cancel());

  void view(Category cat) async => await router.navigate(categoryUrl(cat));
  void delete(Category cat) async => await categoriesService.delete(cat);
  String categoryUrl(Category cat) => RoutePaths.category.toUrl(parameters: {idParam: '${cat.id}'});
}