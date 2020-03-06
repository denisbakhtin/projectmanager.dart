import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';
import 'package:meta/meta.dart';

class CommentsService extends ServiceController<Comment> {
  CommentsService(Store store): super(store);

  int taskId;
  void setTaskId(int id) => taskId = id;

  Future<List<Comment>> getList({String url}) async {
    if (taskId == null) throw ArgumentError.notNull("taskId");
    return await super.getList(url: '/tasks/${taskId}/comments');
  }

  Future<Comment> get({@required int id, String url}) async {
    return await super.get(url: '/tasks/${0}/comments/${id}');
  }

  Future<Comment> create(Comment comment, {String url}) async {
    return await super.create(comment, url: '/tasks/${comment.task.id}/comments');
  }

  Future<Comment> update(Comment comment, {String url}) async {
    return await super.update(comment, url: '/tasks/${comment.task.id}/comments/${comment.id}');
  }

  delete(Comment comment, {String url}) async {
    return await super.delete(comment, url: '/tasks/${comment.task.id}/comments/${comment.id}');
  }
}