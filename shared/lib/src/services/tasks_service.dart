import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';
import 'package:meta/meta.dart';

class TasksService extends ServiceController<Task> {
  TasksService(Store store): super(store);

  int projectId;
  void setProjectId(int id) => projectId = id;

  Future<List<Task>> getList({String url}) async {
    return await super.getList(url: (projectId != null) ? '/tasks?project_id=${projectId}' : "/tasks");
  }

  Future<Task> get({@required int id, String url}) async {
    return await super.get(id: id, url: '/tasks/${id}');
  }

  Future<Task> create(Task task, {String url}) async {
    return await super.create(task, url: "/tasks");
  }

  Future<Task> update(Task task, {String url}) async {
    return await super.update(task, url: "/tasks/${task.id}");
  }

  delete(Task task, {String url}) async {
    return await super.delete(task, url: '/tasks/${task.id}');
  }
}