import 'dart:async';
import '../models/models.dart';

import 'event_entity_sink.dart';
import '../store.dart';
import '../http.dart';
import 'package:meta/meta.dart';

class ServiceController<T> implements EventEntitySink<T> {
  final Store store;
  T _element;
  List<T> _list = [];

  ServiceController(this.store) {
     _controller = StreamController<T>.broadcast();
     _listController = StreamController<List<T>>.broadcast();
  }

  //Stream methods
  StreamController<T> _controller;
  StreamController<List<T>> _listController;

  StreamSubscription<T> listen(void onData(T event), {
    Function onError,
    void onDone(),
    bool cancelOnError: false
  }) {
    return _controller.stream.listen(
        onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  StreamSubscription<List<T>> listenList(void onData(List<T> event), {
    Function onError,
    void onDone(),
    bool cancelOnError: false
  }) {
    return _listController.stream.listen(
        onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  void add(T event) {
    _controller.add(event);
  }
  @override
  void addList(List<T> listEvent) {
    _listController.add(listEvent);
  }

  @override
  void addError(Object errorEvent, [StackTrace trace]) {
    _controller.addError(errorEvent, trace);
  }
  @override
  void addListError(Object errorEvent, [StackTrace trace]) {
    _listController.addError(errorEvent, trace);
  }

  @override
  void close() {
    _controller.close();
    _listController.close();
  }

  //not used at all, candidate for removal
  void clearCache() {
    _element = null;
    _list = [];
  }

  //request methods
  @protected
  Future<List<T>> getList({@required String url}) async {
    var req = Request.get(url);
    var response = await req.executeUserRequest(store);

    if (response.error != null) {
      addListError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: {
        _list = (response.body as List<dynamic>)
            .map((o) => _fromMap(o))
            .toList();

        addList(_list);
        return _list;
      } break;

      default: addListError(APIError(response.body["error"]));
    }

    return null;
  }

  @protected
  Future<T> get({int id, @required String url}) async {
    var req = Request.get(url);
    var response = await req.executeUserRequest(store);

    if (response.error != null) {
      addError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: {
        _element = _fromMap(response.body);

        add(_element);
        return _element;
      } break;

      default: addError(APIError(response.body["error"]));
    }

    return null;
  }

  @protected
  Future<T> create(T element, {@required String url}) async {
    var req = Request.post(url, _asMap(element));
    var response = await req.executeUserRequest(store);

    if (response.error != null) {
      addListError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: {
        _element = _fromMap(response.body);
        _list.insert(0, _element);
        addList(List.from(_list));

        return _element;
      } break;

      default: addListError(APIError(response.body["error"]));
    }

    return null;
  }

  @protected
  Future<T> update(T element, {@required String url}) async {
    var req = Request.put(url, _asMap(element));
    var response = await req.executeUserRequest(store);

    if (response.error != null) {
      addError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: {
        _element = _fromMap(response.body);
        add(_element);
        //big question here, if comparison would work. Need to implement == operator here? Or call getList in component's listen method
        var index = _list.indexWhere((e) => e == element);
        if (index > -1) {
          _list[index] = _element;
        } else {
          _list.insert(0, _element);
        }
        addList(List.from(_list));

        return _element;
      } break;

      default: addError(APIError(response.body["error"]));
    }

    return null;
  }

  @protected
  delete(T element, {@required String url}) async {
    var req = Request.delete(url);
    var response = await req.executeUserRequest(store);

    if (response.error != null) {
      addListError(response.error);
      return;
    }

    switch (response.statusCode) {
      case 200: {
        //same question as in update method, check if it works as expected
        _list.removeWhere((e) => e == element);
        addList(List.from(_list));
        return;
      } break;

      default: addListError(APIError(response.body["error"]));
    }

    return;
  }

  T _fromMap(dynamic m) {
    //TODO: Restrict T to <T extends Serializable> ??
    if (T == Task) return (Task.fromMap(m) as T);
    if (T == Comment) return (Comment.fromMap(m) as T);
    if (T == Project) return (Project.fromMap(m) as T);
    if (T == Category) return (Category.fromMap(m) as T);
    if (T == User) return (User.fromMap(m) as T);
    if (T == Session) return (Session.fromMap(m) as T);
    if (T == Attachment) return (Attachment.fromMap(m) as T);
    if (T == Activity) return (Activity.fromMap(m) as T);
    if (T == AuthorizationToken) return (AuthorizationToken.fromMap(m) as T);
    //add other classes accordingly, otherwise meet this error :P

    throw UnsupportedError("fromMap on $T");
  }

  Map<String, dynamic> _asMap(T element) {
    //TODO: Restrict T to <T extends Serializable> ??
    if (T == Task) return (element as Task).asMap();
    if (T == Comment) return (element as Comment).asMap();
    if (T == Project) return (element as Project).asMap();
    if (T == Category) return (element as Category).asMap();
    if (T == User) return (element as User).asMap();
    if (T == Session) return (element as Session).asMap();
    if (T == Attachment) return (element as Attachment).asMap();
    if (T == Activity) return (element as Activity).asMap();
    if (T == AuthorizationToken) return (element as AuthorizationToken).asMap();
    //add other classes accordingly, otherwise meet this error :P

    throw UnsupportedError("asMap on $T");
  }
}