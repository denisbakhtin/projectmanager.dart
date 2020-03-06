import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'package:filesize/filesize.dart';
import '../store.dart';
import '../routes.dart';

@Component(
  selector: 'attachments',
  templateUrl: 'attachments.html',
  directives: [coreDirectives, routerDirectives, MaterialButtonComponent, NgIf],
  providers: [ materialProviders ], //fixes required DomService error
  exports: [RoutePaths, Routes, filesize],
)

class AttachmentsComponent {
  List<Attachment> _attachments;
  List<Attachment> get attachments => _attachments;
  final _attachmentsChange = StreamController<List<Attachment>>();
  @Input()
  void set attachments(List<Attachment> value) => _attachments = value;
  @Output()
  Stream<List<Attachment>> get attachmentsChange => _attachmentsChange.stream;
  @Input()
  Task task;
  @Input()
  bool canEdit = false;
  
  final Store store;
  String error;
  List<StreamSubscription> subscriptions;
  final HelpersService helpers;

  AttachmentsComponent(this.store, this.helpers);

  Future<void> handleUpload(Event e) async {
    var blob = (e.target as FileUploadInputElement).files[0];
    var reader = FileReader()..readAsArrayBuffer(blob);
    await reader.onLoadEnd.first;
    List<int> bytes = reader.result;
    var base64str = base64Encode(bytes);
    if (_attachments == null) _attachments = [];
    _attachments.add(Attachment(filename: blob.name, base64string: base64str, size: blob.size));
    _attachmentsChange.add(_attachments);
    (e.target as FileUploadInputElement).value = ""; //reset input value
  }

  void delete(Attachment att) async {
    _attachments?.removeWhere((a) => a == att);
    _attachmentsChange.add(_attachments);
  } 
}