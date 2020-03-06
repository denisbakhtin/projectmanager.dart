import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';
import 'package:meta/meta.dart';

class CategoriesService extends ServiceController<Category> {
  CategoriesService(Store store): super(store);

  bool associations;
  void setAssociations(bool a) => associations = a;

  Future<List<Category>> getList({String url}) async {
    return await super.getList(url: "/categories");
  }

  Future<Category> get({@required int id, String url}) async {
    return await super.get(id: id, url: '/categories/${id}${(associations == true) ? "?associations=true" : ""}');
  }

  Future<Category> create(Category category, {String url}) async {
    return await super.create(category, url: "/categories");
  }

  Future<Category> update(Category category, {String url}) async {
    return await super.update(category, url: "/categories/${category.id}");
  }

  delete(Category category, {String url}) async {
    return await super.delete(category, url: '/categories/${category.id}');
  }
}