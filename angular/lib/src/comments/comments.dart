import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'comments',
  templateUrl: 'comments.html',
  directives: [coreDirectives, routerDirectives, AttachmentsComponent, EditCommentModalComponent, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class CommentsComponent implements OnInit, OnDestroy {
  @Input()
  Task task;

  List<Comment> comments = [];
  Comment comment;
  final Store store;
  String error;
  final Router router;
  List<StreamSubscription> subscriptions = [];
  final CommentsService commentsService;
  final HelpersService helpers;
  bool showCreateModal = false;
  bool showEditModal = false;

  CommentsComponent(this.store, this.router, this.helpers): commentsService = CommentsService(store);
  
  void startCreate() => showCreateModal = true;
  void submitCreate() {
    showCreateModal = false;
    commentsService
      ..setTaskId(task.id)
      ..getList();
  }
  void cancelCreate() => showCreateModal = false;

  void startEdit(Comment c) {
    comment = c;
    showEditModal = true;
  }
  void submitEdit() {
    showEditModal = false;
    commentsService
      ..setTaskId(task.id)
      ..getList();
  }
  void cancelEdit() => showEditModal = false;

  void delete(Comment c) async {
    try {
      await commentsService.delete(c);
      commentsService.get(id: task.id);
    } catch (err) {
      error = err.toString();
    }
  }

  @override
  void ngOnInit() async {
    subscriptions = [
      commentsService.listenList((list) {
        if (list != null) {
          comments = list;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];
    commentsService.setTaskId(task.id); //important
    commentsService.getList();
  }

  @override
  void ngOnDestroy() => subscriptions?.forEach((s) => s.cancel());
}