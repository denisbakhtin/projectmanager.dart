import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';
import 'package:meta/meta.dart';

class ProjectsService extends ServiceController<Project> {
  ProjectsService(Store store): super(store);

  Future<List<Project>> getList({String url}) async {
    return await super.getList(url: '/projects');
  }

  Future<Project> get({@required int id, String url}) async {
    return await super.get(id: id, url: '/projects/${id}');
  }

  Future<Project> create(Project project, {String url}) async {
    return await super.create(project, url: "/projects");
  }

  Future<Project> update(Project project, {String url}) async {
    return await super.update(project, url: "/projects/${project.id}");
  }

  delete(Project project, {String url}) async {
    return await super.delete(project, url: '/projects/${project.id}');
  }
}