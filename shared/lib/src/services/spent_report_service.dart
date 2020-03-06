import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';

class SpentReportService extends ServiceController<Project> {
  SpentReportService(Store store): super(store);

  Future<List<Project>> getList({String url}) async {
    return await super.getList(url: "/reports/spent");
  }
}