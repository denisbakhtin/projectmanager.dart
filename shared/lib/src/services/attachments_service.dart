import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';

class AttachmentService extends ServiceController<Attachment> {
  AttachmentService(Store store): super(store);

  Future<Attachment> create(Attachment attachment, {String url}) async {
    return await super.create(attachment, url: "/attachments");
  }

  delete(Attachment attachment, {String url}) async {
    return await super.delete(attachment, url: '/attachments/${attachment.id}');
  }
}