import 'dart:async';
import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';
import 'package:meta/meta.dart';

class SessionsService extends ServiceController<Session> {
  SessionsService(Store store): super(store);

  Future<List<Session>> getList({String url}) async {
    return await super.getList(url: "/sessions");
  }

  Future<Session> get({@required int id, String url}) async {
    return await super.get(id: id, url: '/sessions/${id}');
  }

  Future<Session> create(Session session, {String url}) async {
    return await super.create(session, url: "/sessions");
  }

  //Not needed atm
  Future<Session> update(Session session, {String url}) async {
    throw UnimplementedError();
    //return await super.update(session, url: "/sessions/${session.id}");
  }

  delete(Session session, {String url}) async {
    throw UnimplementedError();
    //return await super.delete(session, url: '/sessions/${session.id}');
  }
}