import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import '../store.dart';
import '../routes.dart';
import '../components.dart';

@Component(
  selector: 'edit-comment-modal',
  templateUrl: 'edit_comment_modal.html',
  directives: [coreDirectives, formDirectives, AttachmentsComponent, routerDirectives, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes],
)

class EditCommentModalComponent implements OnInit, OnDestroy {
  @Input()
  int taskId;
  @Input()
  int id;
  @Input()
  bool isSolution = false;
  @Input()
  Function onSubmitCallback;
  @Input()
  Function onCancelCallback;

  Comment comment;
  final Store store;
  String error;
  bool isNew = true;
  final Router router;
  List<StreamSubscription> subscriptions;
  final CommentsService commentsService;

  EditCommentModalComponent(this.store, this.router): commentsService = CommentsService(store);

  @override
  void ngOnInit() {
    subscriptions = [
      commentsService.listen((c) {
        if (c != null) {
          comment = c;
        }
      }, onError: (Object err) {
        error = err.toString();
      }),
    ];

    isNew = (id == null);
    if (isNew) {
      comment = Comment();
      comment.isSolution = isSolution ?? false;
      comment.task = Task()..id = taskId;
    } else {
      commentsService.get(id: id);
    }
  }

  @override
  void ngOnDestroy() => subscriptions?.forEach((s) => s.cancel());

  void onSubmit() async {
    try {
      if (isNew)
        await commentsService.create(comment);
      else
        await commentsService.update(comment);
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